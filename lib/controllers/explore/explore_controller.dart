import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/home/home_controller.dart';
import 'package:yatharthageeta/models/books_listing/books_listing_model.dart'
    as book;
import 'package:yatharthageeta/models/explore/mantra_model.dart' as mantra;
import 'package:yatharthageeta/models/explore/quote_model.dart' as quote;
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:yatharthageeta/services/explore_service/explore_service.dart';
import 'package:yatharthageeta/models/explore/explore_model.dart' as explore;
import 'package:yatharthageeta/models/explore/satsang_model.dart' as satsang;
import 'package:yatharthageeta/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ExploreController extends GetxController
    with GetTickerProviderStateMixin {
  final bottomAppBarServices = Get.find<BottomAppBarServices>();

  var tabIndex = 0.obs;
  late TabController controller;
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;
  late AnimationController animation_controller;
  RxString? checkItem = "".obs;
  RxList<quote.Result> quotesListing = <quote.Result>[].obs;
  RxList<mantra.Result> mantraListing = <mantra.Result>[].obs;
  RxList<explore.Result> exploreListing = <explore.Result>[].obs;
  RxList<satsang.Result> satsangListing = <satsang.Result>[].obs;
  RxList<book.Result> booksListing = <book.Result>[].obs;
  // RxInt pageNo = 1.obs;
  final limit = 10;
  // RxBool isDataNotFound = false.obs;

  String token = "";
  final List<String> imageList = [
    'assets/icons/mantra_canvas.png',
    'assets/icons/mantra_canvas.png',
    'assets/icons/mantra_canvas.png',
    'assets/icons/mantra_canvas.png',
  ];
  // String url() {
  //   if (Platform.isAndroid) {
  //     // add the [https]
  //     return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
  //   } else {
  //     // add the [https]
  //     return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
  //   }
  // }

  ExploreController() {
    animation_controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
  }

  // Pagination Common
  // RxInt collectionPageNo = 1.obs;
  final collectionLimit = 5;
  // RxBool isCollectionLoadingData = false.obs;
  // RxBool isDataNotFound = false.obs;
  // RxBool isNoDataLoading = false.obs;
  // RxBool isLoadingData = false.obs;
  // RxInt pageNo = 1.obs;

  //Pagination
  // final collectionLimit = 5;
  RxBool checkRefresh = false.obs;
  //Pagination All Section
  RxInt allCollectionPageNo = 1.obs;
  RxBool isAllCollectionLoadingData = false.obs;
  RxBool isAllCollectionDataNotFound = false.obs;
  RxBool isAllCollectionNoDataLoading = false.obs;
  RxInt totalExploreAllItems = 0.obs;
  RxBool allCollectionCheckRefresh = false.obs;
  // RxBool collectionZeroFlag = false.obs;

  //Pagination Quotes Section
  RxInt quotesPageNo = 1.obs;
  RxBool isQuotesLoadingData = false.obs;
  RxBool isQuotesDataNotFound = false.obs;
  RxBool isQuotesNoDataLoading = false.obs;
  RxInt totalQuotesItems = 0.obs;
  RxBool quotesCheckRefresh = false.obs;

  //Pagination Mantras Section
  RxInt mantrasPageNo = 1.obs;
  RxBool isMantrasLoadingData = false.obs;
  RxBool isMantrasDataNotFound = false.obs;
  RxBool isMantrasNoDataLoading = false.obs;
  RxInt totalMantrasItems = 0.obs;
  RxBool mantrasCheckRefresh = false.obs;

  //Pagination Satsang Section
  final satsangCollectionLimit = 10;
  RxInt satsangPageNo = 1.obs;
  RxBool isSatsangLoadingData = false.obs;
  RxBool isSatsangDataNotFound = false.obs;
  RxBool isSatsangNoDataLoading = false.obs;
  RxInt totalSatsangItems = 0.obs;
  RxBool satsangCheckRefresh = false.obs;
  var groupValue = "".obs;

  var prevScreen = "".obs;
  var collectionId = "".obs;
  var collectionType = "".obs;
  RxInt pageNo = 1.obs;
  var viewAllListingAudioTitle = "".obs;
  RxBool isLoadingData = false.obs;
  RxBool isNoDataLoading = false.obs;
  RxBool isDataNotFound = false.obs;
  RxList<satsang.Result> audiosListing = <satsang.Result>[].obs;
  RxInt totalAudios = 0.obs;
  RxBool isCollection = false.obs;
  RxBool isMultiCollection = false.obs;
  RxString audioApiCallType = ''.obs;
  // RxInt pageNo = 1.obs;
  // final limit = 10;

  //Pull to Refresh
  RxBool isExpAllRefreshing = false.obs;
  RxBool exploreAllCollectionZeroFlag = false.obs;
  RxBool isSatsangRefreshing = false.obs;
  RxBool satsangCollectionZeroFlag = false.obs;
  RxBool isMantrasRefreshing = false.obs;
  RxBool mantrasCollectionZeroFlag = false.obs;
  RxBool isQuotesRefreshing = false.obs;
  RxBool quotesCollectionZeroFlag = false.obs;

  RxString? checkAllItem = "".obs;
  RxString? checkSatsangItem = "".obs;
  RxString? checkMantrasItem = "".obs;
  RxString? checkQuotesItem = "".obs;

  void initializeFilter() {
    var homeController = Get.find<HomeController>();
    languageList = homeController.languageModel!.data!.result == null
        ? []
        : homeController.languageModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
    authorsList = homeController.authorModel!.data!.result == null
        ? []
        : homeController.authorModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
  }

  Future<void> downloadFile(String fileUrl, String fileName) async {
    final response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      final appDirectory = await getExternalStorageDirectory();
      final downloadDirectory = Directory('${appDirectory!.path}/MyApp');
      await downloadDirectory.create(recursive: true);

      final saveFile = File('${downloadDirectory.path}/$fileName');

      await saveFile.writeAsBytes(response.bodyBytes);

      // Now, you can use the downloaded file as needed, e.g., share it
    } else {
      throw Exception('Failed to download file');
    }
  }

  Future<void> fetchQuotes({String? token, BuildContext? ctx}) async {
    isQuotesLoadingData.value = true;

    // Loading(Utils.loaderImage()).start(ctx!);
    final response = await ExploreService().quotesApi(
      pageNo: quotesPageNo.value.toString(),
      limit: collectionLimit.toString(),
      token: bottomAppBarServices.token.value,
    );
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && quotesListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];
          isQuotesNoDataLoading.value = false;
          isQuotesLoadingData.value = false;

          log('success is 0');
        } else {
          final videoListingModel = quote.quoteModelFromJson(response.body);

          checkQuotesItem!.value = mapdata['message'];
          quotesListing.addAll(videoListingModel.data!.result!);

          quotesPageNo++;
          isQuotesLoadingData.value = false;
          isQuotesNoDataLoading.value = false;

          if (quotesListing.isNotEmpty) {
            totalQuotesItems.value = videoListingModel.data!.totalCount!;
            quotesCollectionZeroFlag.value = false;
          } else {
            quotesCollectionZeroFlag.value = true;
          }

          // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        quotesCheckRefresh.value = false;
      }
    }
  }

  Future<void> fetchMantra({String? token, BuildContext? ctx}) async {
    // isLoadingData.value = true;
    isMantrasLoadingData.value = true;

    // Loading(Utils.loaderImage()).start(ctx!);
    final response = await ExploreService().mantrasApi(
      pageNo: mantrasPageNo.value.toString(),
      limit: collectionLimit.toString(),
      token: bottomAppBarServices.token.value,
    );
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && quotesListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          isMantrasNoDataLoading.value = true;
          isMantrasLoadingData.value = false;
          log('success is 0');
        } else {
          final mantraModel = mantra.mantraModelFromJson(response.body);

          checkMantrasItem!.value = mapdata['message'];
          mantraListing.addAll(mantraModel.data!.result!);

          mantrasPageNo++;
          isMantrasLoadingData.value = false;
          isMantrasNoDataLoading.value = false;

          if (mantraListing.isNotEmpty) {
            totalMantrasItems.value = mantraModel.data!.totalCount!;
            mantrasCollectionZeroFlag.value = false;
          } else {
            mantrasCollectionZeroFlag.value = true;
          }

          // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        mantrasCheckRefresh.value = false;
      }
    }
  }

  Future<void> fetchSatsang(
      {String? token, BuildContext? ctx, Map<String, String>? body}) async {
    // isLoadingData.value = true;
    isSatsangLoadingData.value = true;
    // Loading(Utils.loaderImage()).start(ctx!);
    log(body.toString());
    // clearSatsangList();
    final response = await ExploreService().satsangApi(
        pageNo: satsangPageNo.value.toString(),
        limit: satsangCollectionLimit.toString(),
        token: bottomAppBarServices.token.value,
        body: body);
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // clearSatsangList();
      } else if (response.statusCode == 500) {
        // clearSatsangList();
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());
        // clearSatsangList();
        if (mapdata['success'] == 0) {
          // clearSatsangList();
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && quotesListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          isSatsangNoDataLoading.value = true;
          isSatsangLoadingData.value = false;
          log('success is 0');
        } else {
          // clearSatsangList();
          final satsangModel = satsang.SatsangModelFromJson(response.body);
          log(satsangModel.data!.result!.toString());

          checkSatsangItem!.value = mapdata['message'];
          satsangListing.addAll(satsangModel.data!.result!);

          satsangPageNo++;
          isSatsangLoadingData.value = false;
          isSatsangNoDataLoading.value = false;

          if (satsangListing.isNotEmpty) {
            totalSatsangItems.value = satsangModel.data!.totalCount!;
            satsangCollectionZeroFlag.value = false;
          } else {
            satsangCollectionZeroFlag.value = true;
          }
          // totalBooks.value = mantraListing.data!.totalCount!;

          // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        satsangCheckRefresh.value = false;
      }
    }
  }

  Future<void> fetchSatsangFilter(
      {String? token, BuildContext? ctx, Map<String, String>? body}) async {
    // isLoadingData.value = true;
    isSatsangLoadingData.value = true;
    // Loading(Utils.loaderImage()).start(ctx!);
    log(body.toString());
    Utils().showLoader();
    clearSatsangList();
    body = returnFilterBody();
    final response = await ExploreService().satsangApi(
        // pageNo: satsangPageNo.value.toString(),
        // limit: satsangCollectionLimit.toString(),
        token: bottomAppBarServices.token.value,
        body: body);
    if (response == " ") {
      clearSatsangList();
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        clearSatsangList();
      } else if (response.statusCode == 500) {
        clearSatsangList();
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());
        clearSatsangList();
        if (mapdata['success'] == 0) {
          clearSatsangList();
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && quotesListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          isSatsangNoDataLoading.value = true;
          isSatsangLoadingData.value = false;
          log('success is 0');
        } else {
          clearSatsangList();
          final satsangModel = satsang.SatsangModelFromJson(response.body);
          log(satsangModel.data!.result!.toString());

          checkSatsangItem!.value = mapdata['message'];
          satsangListing.addAll(satsangModel.data!.result!);

          satsangPageNo++;
          isSatsangLoadingData.value = false;
          isSatsangNoDataLoading.value = false;

          if (satsangListing.isNotEmpty) {
            totalSatsangItems.value = satsangModel.data!.totalCount!;
            satsangCollectionZeroFlag.value = false;
          } else {
            satsangCollectionZeroFlag.value = true;
          }
          // totalBooks.value = mantraListing.data!.totalCount!;

          // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        Get.back();
        satsangCheckRefresh.value = false;
      }
    }
  }

  Future<void> fetchAll({String? token, BuildContext? ctx}) async {
    // isLoadingData.value = true;
    isAllCollectionLoadingData.value = true;

    // Loading(Utils.loaderImage()).start(ctx!);
    final response = await ExploreService().exploreApi(
      pageNo: allCollectionPageNo.value.toString(),
      limit: collectionLimit.toString(),
      token: bottomAppBarServices.token.value,
    );
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // isAllCollectionLoadingData.value = false;
          // if (pageNo.value == 1 && quotesListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];
          //   isNoDataLoading.value = true;
          // isCollectionLoadingData.value = false;
          isAllCollectionNoDataLoading.value = false;
          isAllCollectionLoadingData.value = false;

          log('success is 0');
        } else {
          final exploreModel = explore.ExploreModelFromJson(response.body);

          checkAllItem!.value = mapdata['message'];
          exploreListing.addAll(exploreModel.data!.result!);

          allCollectionPageNo++;
          isAllCollectionLoadingData.value = false;
          isAllCollectionNoDataLoading.value = false;

          if (exploreListing.isNotEmpty) {
            totalExploreAllItems.value = exploreModel.data!.totalCount!;
            exploreAllCollectionZeroFlag.value = false;
          } else {
            exploreAllCollectionZeroFlag.value = true;
          }

          // Loading.stop();
          // pageNo.value++;
          // isAllCollectionLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        allCollectionCheckRefresh.value = false;
      }
    }
  }

  Future<void> fetchAudioExploreViewAllListing({
    String? token,
    BuildContext? ctx,
    Map<String, String>? body,
    // required String collectionAudioId,
  }) async {
    isLoadingData.value = true;
    var collectionAudioId = collectionId.value;
    Map<String, String> temp = returnFilterBody();
    temp.addAll(body ?? {});
    body = temp;
    log(body.toString());
    audioApiCallType.value = 'fetchAudioExploreViewAllListing';
    log("CollectionVideoId = $collectionAudioId");

    // Loading(Utils.loaderImage()).start(ctx!);
    final response = await ExploreService().exploreCollectionViewAllApi(
      token: bottomAppBarServices.token.value,
      collectionId: collectionAudioId,
      body: body,
      pageNo: satsangPageNo.value.toString(),
      limit: limit.toString(),
    );
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && audiosListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];
          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final satsangModel = satsang.SatsangModelFromJson(response.body);
          log(satsangModel.data!.result!.toString());
          checkItem!.value = mapdata['message'];
          satsangListing.addAll(satsangModel.data!.result!);

          satsangPageNo++;
          isSatsangLoadingData.value = false;
          isSatsangNoDataLoading.value = false;

          if (satsangListing.isNotEmpty) {
            totalSatsangItems.value = satsangModel.data!.totalCount!;
          }
          // totalBooks.value = mantraListing.data!.totalCount!;

          // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        satsangCheckRefresh.value = false;
      }
    }
  }

  @override
  void onInit() async {
    controller = TabController(length: 5, vsync: this);
    Get.find<HomeController>().languageModel ??
        await Get.find<HomeController>().getSortData();
    initializeFilter();
    sortList = [
      {
        "title": "Alphabetically ( A-Z )".tr,
        "value": "Alphabetically ( A-Z )",
        "order_by": "title",
        "sort": "asc",
        "groupValue": groupValue
      },
      {
        "title": "Alphabetically ( Z-A )".tr,
        "value": "Alphabetically ( Z-A )",
        "order_by": "title",
        "sort": "desc",
        "groupValue": groupValue
      },
      {
        "title": "Length ( High to Low )".tr,
        "value": "Length ( High to Low )",
        "order_by": "duration",
        "sort": "desc",
        "groupValue": groupValue
      },
      {
        "title": "Length ( Low to High )".tr,
        "value": "Length ( Low to High )",
        "order_by": "duration",
        "sort": "asc",
        "groupValue": groupValue
      },
      // {
      //   "title": "Popularity".tr,
      //   "value": "Popularity",
      //   "order_by": "view_count",
      //   "sort": "desc",
      //   "groupValue": groupValue
      // },
    ];
    // Utils().showLoader();
    //FlutterDownloader.initialize();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    await fetchAll();
    // Get.back();
    super.onInit();
  }

  clearFilters() {
    for (var i in languageList) {
      i["value"].value = false;
    }
    for (var i in authorsList) {
      i["value"].value = false;
    }
    for (var i in sortList) {
      i["groupValue"].value = "";
    }
    // tabIndex.value = 1;
  }

  Map<String, String> returnFilterBody() {
    Map<String, String> body = {};
    int i = 0;
    for (var element in languageList) {
      if (element["value"].value == true) {
        body["language_id[$i]"] = element["id"].toString();
        i++;
      }
    }
    i = 0;
    for (var element in authorsList) {
      if (element["value"].value == true) {
        body["author_id[$i]"] = element["id"].toString();
        i++;
      }
    }
    for (var element in sortList) {
      if (element["value"] == element["groupValue"].value) {
        body["order_by"] = element["order_by"];
        body["sort_by"] = element["sort"];
      }
    }
    return body;
  }

  clearExploreData() {
    tabIndex.value = 0;
  }

  clearSatsangList() {
    satsangListing.clear();
    isSatsangDataNotFound.value = false;
    satsangPageNo = 1.obs;
    isSatsangDataNotFound = false.obs;
    satsangCollectionZeroFlag.value = false;
  }

  clearAllList() {
    exploreListing.clear();
    isAllCollectionDataNotFound.value = false;
    allCollectionPageNo = 1.obs;
    isAllCollectionDataNotFound = false.obs;
    exploreAllCollectionZeroFlag.value = false;
  }

  clearMantrasList() {
    mantraListing.clear();
    isMantrasDataNotFound.value = false;
    mantrasPageNo = 1.obs;
    isMantrasLoadingData = false.obs;
    mantrasCollectionZeroFlag.value = false;
  }

  clearQuotesList() {
    quotesListing.clear();
    isQuotesDataNotFound.value = false;
    quotesPageNo = 1.obs;
    isQuotesDataNotFound = false.obs;
    quotesCollectionZeroFlag.value = false;
  }

  List<Map> languageList = [];
  List<Map> authorsList = [];
  var sortList = [];

  @override
  void dispose() {
    animation_controller.dispose();
    clearFilters();
    super.dispose();
  }
}
