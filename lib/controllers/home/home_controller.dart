import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../startup/startup_controller.dart';
import '../../models/filter/author_model.dart';
import '../../models/filter/language_model.dart';
import '../../models/home/home_tabs_model.dart';
import 'package:yatharthageeta/models/home_collection/home_collection_listing_model.dart'
    as homecollectionlisting;
import 'package:yatharthageeta/models/startup/startup_model.dart';
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:yatharthageeta/services/filter_service/filter_service.dart';
import 'package:yatharthageeta/services/home/home_service.dart';

class HomeController extends GetxController {
  //Flag to check the pull to refresh wait time
  RxBool isRefreshing = false.obs;

  //Initialized the dependencies
  final bottomAppBarServices = Get.find<BottomAppBarServices>();
  final startupController = Get.find<StartupController>();
  final HomeCollectionService homeCollectionService = HomeCollectionService();

  //This stores the home tabs widgets that are built based on the flags given in the start up api, for e.g. books, videos, audios, shlokas flags needs to true in startup API
  List<HomeTabsModel> homeTabsModelList = [];

  // RxBool isLoadingData = false.obs;

//This Stores the home collection data list
  RxList<homecollectionlisting.Result?> homeCollectionListing =
      <homecollectionlisting.Result?>[].obs;
  RxInt totalHomeCollection = 0.obs;

  RxString? checkItem = "".obs;

  // Pagination
  RxInt collectionPageNo = 1.obs;
  final collectionLimit = 5;
  RxBool isCollectionLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;
  RxBool isNoDataLoading = false.obs;
  // RxInt pageNo = 1.obs;
  // final limit = 10;

  RxBool checkRefresh = false.obs;

  RxBool collectionZeroFlag = false.obs;

  //Common Filters Data
  LanguageModel? languageModel;
  LanguageModel? audiolanguageModel;
  LanguageModel? videolanguageModel;
  LanguageModel? booklanguageModel;
  LanguageModel? shloklanguageModel;
  AuthorModel? authorModel;

  AuthorModel? bookCategoryModel;
  AuthorModel? audioCategoryModel;
  AuthorModel? videoCategoryModel;

  List<HomeTabsModel> homeYatharthModelList = [];

  // RxBool fiveSecondsPassed = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    //fetches the home collection data when the controller is initialized and the data is not empty or null
    if (homeCollectionListing != null || homeCollectionListing == []) {
      await fetchHomeCollectionListing(token: bottomAppBarServices.token.value);
    }

    //Based on the Startup Flags, these methods creates the home tabs(dei)
    createHomeTabsList();
    createYatharthBlock();
  }

  //Based on the Startup Flags, these methods creates the home tabs(ashram)
  createHomeTabsList() {
    Home? home =
        startupController.startupData.first.data!.result!.screens!.home;

    if (home != null) {
      if (home.ashramBooks == true) {
        homeTabsModelList.add(
          HomeTabsModel(
            title: 'Ashram Books',
            // imgUrl: 'assets/images/home/books_new.png',
            imgUrl: startupController
                .startupData.first.data!.result!.booksImage!
                .toString(),
          ),
        );
      }
      if (home.ashramAudios == true) {
        homeTabsModelList.add(
          HomeTabsModel(
            title: 'Ashram Audios',
            //imgUrl: 'assets/images/home/audios_new.png',
            imgUrl: startupController
                .startupData.first.data!.result!.audioImage!
                .toString(),
          ),
        );
      }
      if (home.satsangVideos == true) {
        homeTabsModelList.add(
          HomeTabsModel(
              title: 'Satsang Videos',
              //imgUrl: 'assets/images/home/videos_new.png',
              imgUrl: startupController
                  .startupData.first.data!.result!.videosImage!
                  .toString()),
        );
      }
      if (home.yatharthGeetaShlokas == true) {
        homeTabsModelList.add(
          HomeTabsModel(
            title: 'Geeta Shlokas',
            // imgUrl: 'assets/images/home/shlokas_new.png',
            imgUrl: startupController
                .startupData.first.data!.result!.shlokasImage!
                .toString(),
          ),
        );
      }
    }
  }

  //Based on the Startup Flags, these methods creates the home tabs(yatharth geeta)

  createYatharthBlock() {
    Home? home =
        startupController.startupData.first.data!.result!.screens!.home;
    if (home != null) {
      if (home.yatharthGeetaBooks == true) {
        homeYatharthModelList.add(
          HomeTabsModel(
            title: 'Yatharth Geeta Books'.tr,
            // imgUrl: 'assets/images/home/books_new.png',
            imgUrl: startupController
                .startupData.first.data!.result!.gaataBooksImage!
                .toString(),
          ),
        );
      }
      if (home.yatharthGeetaAudios == true) {
        homeYatharthModelList.add(
          HomeTabsModel(
            title: 'Yatharth Geeta Audios'.tr,
            //imgUrl: 'assets/images/home/audios_new.png',
            imgUrl: startupController
                .startupData.first.data!.result!.gaataAudiosImage!
                .toString(),
          ),
        );
      }
    }
  }

  //API call for the home collection data fetching
  Future<void> fetchHomeCollectionListing({String? token}) async {
    log('homeCollectionlisting = $homeCollectionListing');
    log("collection page no ${collectionPageNo.value}");
    isCollectionLoadingData.value = true;

    final response = await homeCollectionService.homeCollectionListingApi(
      pageNo: collectionPageNo.value.toString(),
      limit: collectionLimit.toString(),
      token: bottomAppBarServices.token.value,
    );
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());

        //Show error toast here
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // Get.back();
          isNoDataLoading.value = true;
          isCollectionLoadingData.value = false;
          log('success is 0');
          // if (collectionPageNo.value == 1 && homeCollectionListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else {
          final homeCollectionListingModel = homecollectionlisting
              .homeCollectionListingModelFromJson(response.body);
          homeCollectionListing
              .addAll(homeCollectionListingModel.data!.result!);

          collectionPageNo++;
          isCollectionLoadingData.value = false;
          isNoDataLoading.value = false;

          if (homeCollectionListing.isNotEmpty) {
            collectionZeroFlag.value = false;

            totalHomeCollection.value =
                homeCollectionListingModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("homeCollection listing result = ${homeCollectionListing.first.toString()}");

            log('total homeCollectionListing value---> ${totalHomeCollection.value}');
            log('homeCollectionListing length----> ${homeCollectionListing.length}');
          } else {
            collectionZeroFlag.value = true;
          }
        }
        checkRefresh.value = false;
      }
    }
  }

  // void setFlagAfter5Seconds() {
  //   // Set a 5-second delay and then set the flag to true
  //   Future.delayed(Duration(seconds: 5), () {
  //     fiveSecondsPassed.value = true;
  //   });
  // }

  //Flags and data resetting
  clearHomeCollectionListing() {
    // fiveSecondsPassed.value = false;
    homeCollectionListing.clear();
    collectionPageNo = 1.obs;
    isCollectionLoadingData = false.obs;
    collectionPageNo = 1.obs;
    collectionZeroFlag.value = false;
    // setFlagAfter5Seconds();

    // isDataNotFound = false.obs;
  }

  //For setting up filters data
  getSortData() async {
    var data = await FilterService().filterServiceApi();
    languageModel = LanguageModel.fromJson(json.decode(data[0].body));
    authorModel = AuthorModel.fromJson(json.decode(data[1].body));
    audiolanguageModel = LanguageModel.fromJson(json.decode(data[3].body));
    videolanguageModel = LanguageModel.fromJson(json.decode(data[4].body));
    booklanguageModel = LanguageModel.fromJson(json.decode(data[5].body));
    shloklanguageModel = LanguageModel.fromJson(json.decode(data[6].body));
    bookCategoryModel = AuthorModel.fromJson(json.decode(data[2].body));
    audioCategoryModel = AuthorModel.fromJson(json.decode(data[7].body));
    videoCategoryModel = AuthorModel.fromJson(json.decode(data[8].body));

    // print("languageModel!.message:${languageModel!.message}");
    // print("booklanguageModel!.message:${booklanguageModel!.message}");
    // print("audiolanguageModel!.message:${audiolanguageModel!.message}");
    // print("videolanguageModel!.message:${videolanguageModel!.message}");
    // print("shloklanguageModel!.message:${shloklanguageModel!.message}");
    // print("authorModel!.message:${authorModel!.message}");
    // print("bookCategoryModel!.message:${bookCategoryModel!.message}");
    // print("audioCategoryModel!.message:${audioCategoryModel!.message}");
    // print("videoCategoryModel!.message:${videoCategoryModel!.message}");
    // print(languageModel!.data!.totalCount);
    // print(booklanguageModel!.data!.totalCount);
    // print(audiolanguageModel!.data!.totalCount);
    // print(videolanguageModel!.data!.totalCount);
    // print(shloklanguageModel!.data!.totalCount);
    // print(authorModel!.data!.totalCount);
    // print(bookCategoryModel!.data!.totalCount);
    // print(audioCategoryModel!.data!.totalCount);
    // print(videoCategoryModel!.data!.totalCount);
  }
}
