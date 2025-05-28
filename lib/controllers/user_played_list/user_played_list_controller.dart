import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/constants/constants.dart';
import '../../models/home/audiobooks_model.dart';
import '../../models/home/ebooks_model.dart';
import '../../models/home/videos_model.dart';
import 'package:yatharthageeta/models/user_media_played_viewed/user_media_played_audio_viewed_model.dart'
    as audio;
import 'package:yatharthageeta/models/user_media_played_viewed/user_media_played_book_viewed_model.dart'
    as book;
import 'package:yatharthageeta/models/user_media_played_viewed/user_media_played_video_viewed_model.dart'
    as video;
import 'package:yatharthageeta/models/user_media_played_viewed/user_media_played_viewed_model.dart'
    as general;
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:yatharthageeta/services/user_played_list/user_played_list_service.dart';

import '../../const/colors/colors.dart';
import '../../utils/utils.dart';
import '../logout/logout_controller.dart';

class UserPlayedListsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final UserMediaPlayedListService userMediaPlayedListService =
      UserMediaPlayedListService();

  final bottomAppService = Get.find<BottomAppBarServices>();

  RxString selectedPlaylistTab = 'Audio'.obs;

  //var searchController = TextEditingController();

  RxBool isLoadingData = false.obs;
  RxString searchQuery = "".obs;
  RxList<audio.Result> userMediaAudioPlayedList = <audio.Result>[].obs;
  RxList<book.Result> userMediaBookPlayedList = <book.Result>[].obs;
  RxList<video.Result> userMediaVideoPlayedList = <video.Result>[].obs;
  RxInt totalMediaViewedItems = 0.obs;

  RxString? checkItem = "".obs;

  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 10;
  RxBool isDataNotFound = false.obs;

  List<Map> languageList = [];
  List<Map> authorsList = [];
  List<Map> typeList = [];
  var sortList = [];

  late TabController tabController;
  var groupValue = "Newest".obs;
  var hindi = false.obs;
  var english = false.obs;
  var kannada = false.obs;
  var tamil = false.obs;
  var russian = false.obs;
  var chinese = false.obs;
  var author1 = false.obs;
  var author2 = false.obs;
  var type1 = false.obs;
  var type2 = false.obs;
  var tabIndex = 0.obs;
  TextEditingController searchController = TextEditingController();
  RxString controllerText = "".obs;
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    sortList = [
      {
        "title": "Newest".tr,
        "value": "Newest",
        "order_by": "created_at",
        "sort_by": "desc",
        "groupValue": groupValue
      },
      {
        "title": "Oldest".tr,
        "value": "Oldest",
        "order_by": "created_at",
        "sort_by": "asc",
        "groupValue": groupValue
      },
    ];
    super.onInit();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        controllerText.value = searchController.text;
      }
    });
    debounce(controllerText, (callback) async {
      // if (searchQuery.isEmpty) {
      //   return;
      // }
      debugPrint(
          "bottomAppBarService.isCustomSearchBarNewDisposed.value:${bottomAppService.isCustomSearchBarNewDisposed.value}");
      if (bottomAppService.isCustomSearchBarNewDisposed.value == false) {
        Utils().showLoader();
        clearMediaPlayedLists();
        await fetchFilterUserMediaPlayedViewed(
            token: bottomAppService.token.value,
            body: {
              "query": searchController.text,
              "type": Utils().getMediaTypeBasedOnTab(
                  tabMediaTitle: selectedPlaylistTab.value)
            },
            type: Utils().getMediaTypeBasedOnTab(
                tabMediaTitle: selectedPlaylistTab.value));
        Get.back();
      }
    }, time: const Duration(seconds: 2));
  }

  Future<void> fetchFilterUserMediaPlayedViewed(
      {String? token,
      BuildContext? ctx,
      required String type,
      Map<String, String>? body}) async {
    log('userMediaAudioPlayedViewedList = $userMediaAudioPlayedList');
    log('userMediaBookPlayedViewedList = $userMediaBookPlayedList');
    log('userMediaVideoPlayedViewedList = $userMediaVideoPlayedList');
    isLoadingData.value = true;
    Utils().showLoader();
    if (body != null) {}
    body = body ??
        {
          "type": type.toString(),
        };
    body["query"] = searchController.text;

    final response = await userMediaPlayedListService.userMediaPlayedListApi(
        token: bottomAppService.token.value, mediaType: type, body: body);
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        clearMediaPlayedLists();
        //Show error toast here
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
        clearMediaPlayedLists();
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          clearMediaPlayedLists(); // Get.back();
          isLoadingData.value = false;
          log('success is 0');
          if (pageNo.value == 1 && userMediaAudioPlayedList.isEmpty) {
            isDataNotFound.value = true;
          }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else if (mapdata['success'] == 4) {
          debugPrint("Success 4");
          clearMediaPlayedLists();
          Utils.customToast(mapdata['message'], kRedColor,
              kRedColor.withOpacity(0.2), "Error");
          Utils().showLoader();
          Utils.deleteToken();
          Utils.deleteNotificationStatus();
          await Get.find<LogOutController>().logOutUser();
        } else if (mapdata['success'] == 1) {
          //General model
          final userMediaPlayedListModel =
              general.userMediaPlayedViewedModelFromJson(response.body);
          clearMediaPlayedLists();
          //Based on the type store data
          if (userMediaPlayedListModel.data!.result!.isEmpty) {
            checkItem!.value = mapdata['message'];

            log("USerMediaPlayedList is empty = ${userMediaAudioPlayedList.toString()}");
            log("USerMediaPlayedList is empty = ${userMediaBookPlayedList.toString()}");
            log("USerMediaPlayedList is empty = ${userMediaVideoPlayedList.toString()}");

            log('total userMediaAudioPlayedList items value---> ${totalMediaViewedItems.value}');
          } else if (type == 'Book') {
            final userMediaPlayedBookListModel =
                book.userMediaPlayedBookViewedModelFromJson(response.body);

            userMediaBookPlayedList
                .addAll(userMediaPlayedBookListModel.data!.result!);
            totalMediaViewedItems.value =
                userMediaPlayedBookListModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("userMediaBookPlayedList result = ${userMediaBookPlayedList.first.toString()}");

            pageNo.value++;
            log('total userMediaAudioPlayedList items value---> ${totalMediaViewedItems.value}');
          } else if (type == 'Audio') {
            final userMediaPlayedAudioListModel =
                audio.userMediaPlayedAudioViewedModelFromJson(response.body);

            userMediaAudioPlayedList
                .addAll(userMediaPlayedAudioListModel.data!.result!);
            totalMediaViewedItems.value =
                userMediaPlayedAudioListModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("userMediaBookPlayedList result = ${userMediaAudioPlayedList.first.toString()}");

            pageNo.value++;
            log('total userMediaAudioPlayedList items value---> ${totalMediaViewedItems.value}');
          } else if (type == 'Video') {
            final userMediaPlayedVideoListModel =
                video.userMediaPlayedVideoViewedModelFromJson(response.body);

            userMediaVideoPlayedList
                .addAll(userMediaPlayedVideoListModel.data!.result!);
            totalMediaViewedItems.value =
                userMediaPlayedVideoListModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("userMediaVideoPlayedList result = ${userMediaVideoPlayedList.first.toString()}");

            pageNo.value++;
            log('total userMediaVideoPlayedList items value---> ${totalMediaViewedItems.value}');
          }

          isLoadingData.value = false;
          isDataNotFound.value = false;
        }
      }
    }
    Get.back();
  }

  // Future<void> fetchUserMediaPlayedViewed(
  //     {String? token, BuildContext? ctx, required String type}) async {
  //   log('userMediaAudioPlayedViewedList = $userMediaAudioPlayedList');
  //   log('userMediaBookPlayedViewedList = $userMediaBookPlayedList');
  //   log('userMediaVideoPlayedViewedList = $userMediaVideoPlayedList');
  //   isLoadingData.value = true;

  //   final response = await userMediaPlayedListService.userMediaPlayedListApi(
  //       token: bottomAppService.token.value, mediaType: type);
  //   if (response == " ") {
  //     //Do Something here
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       // Map mapdata = jsonDecode(response.body.toString());

  //       //Show error toast here
  //     } else if (response.statusCode == 500) {
  //       // Map mapdata = jsonDecode(response.body.toString());
  //       //Show error toast here
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         // Get.back();
  //         isLoadingData.value = false;
  //         log('success is 0');
  //         if (pageNo.value == 1 && userMediaAudioPlayedList.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         // checkItem!.value = mapdata['message'];

  //         // log('item message = $checkItem');
  //       } else if (mapdata['success'] == 4) {
  //         debugPrint("Success 4");
  //         Utils.customToast(mapdata['message'], kRedColor,
  //             kRedColor.withOpacity(0.2), "Error");
  //         Utils().showLoader();
  //         Utils.deleteToken();
  //         Utils.deleteNotificationStatus();
  //         await Get.find<LogOutController>().logOutUser();
  //       } else if (mapdata['success'] == 1) {
  //         //General model
  //         final userMediaPlayedListModel =
  //             general.userMediaPlayedViewedModelFromJson(response.body);

  //         //Based on the type store data
  //         if (userMediaPlayedListModel.data!.result!.isEmpty) {
  //           log("USerMediaPlayedList is empty = ${userMediaAudioPlayedList.toString()}");
  //           log("USerMediaPlayedList is empty = ${userMediaBookPlayedList.toString()}");
  //           log("USerMediaPlayedList is empty = ${userMediaVideoPlayedList.toString()}");

  //           log('total userMediaAudioPlayedList items value---> ${totalMediaViewedItems.value}');
  //         } else if (type == 'Book') {
  //           final userMediaPlayedBookListModel =
  //               book.userMediaPlayedBookViewedModelFromJson(response.body);

  //           userMediaBookPlayedList
  //               .addAll(userMediaPlayedBookListModel.data!.result!);
  //           totalMediaViewedItems.value =
  //               userMediaPlayedBookListModel.data!.totalCount!;
  //           checkItem!.value = mapdata['message'];

  //           log('item message = $checkItem');
  //           log("userMediaBookPlayedList result = ${userMediaBookPlayedList.first.toString()}");

  //           pageNo.value++;
  //           log('total userMediaAudioPlayedList items value---> ${totalMediaViewedItems.value}');
  //         } else if (type == 'Audio') {
  //           final userMediaPlayedAudioListModel =
  //               audio.userMediaPlayedAudioViewedModelFromJson(response.body);

  //           userMediaAudioPlayedList
  //               .addAll(userMediaPlayedAudioListModel.data!.result!);
  //           totalMediaViewedItems.value =
  //               userMediaPlayedAudioListModel.data!.totalCount!;
  //           checkItem!.value = mapdata['message'];

  //           log('item message = $checkItem');
  //           log("userMediaBookPlayedList result = ${userMediaAudioPlayedList.first.toString()}");

  //           pageNo.value++;
  //           log('total userMediaAudioPlayedList items value---> ${totalMediaViewedItems.value}');
  //         } else if (type == 'Video') {
  //           final userMediaPlayedVideoListModel =
  //               video.userMediaPlayedVideoViewedModelFromJson(response.body);

  //           userMediaVideoPlayedList
  //               .addAll(userMediaPlayedVideoListModel.data!.result!);
  //           totalMediaViewedItems.value =
  //               userMediaPlayedVideoListModel.data!.totalCount!;
  //           checkItem!.value = mapdata['message'];

  //           log('item message = $checkItem');
  //           log("userMediaVideoPlayedList result = ${userMediaVideoPlayedList.first.toString()}");

  //           pageNo.value++;
  //           log('total userMediaVideoPlayedList items value---> ${totalMediaViewedItems.value}');
  //         }

  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  // }

  clearMediaPlayedLists() {
    userMediaAudioPlayedList.clear();
    userMediaVideoPlayedList.clear();
    userMediaBookPlayedList.clear();
    isLoadingData.value = false;
    // selectedPlaylistTab.value = 'Audio';
    pageNo = 1.obs;
    isDataNotFound = false.obs;
  }

  resetMediaPlayedLists() {
    userMediaAudioPlayedList.clear();
    userMediaVideoPlayedList.clear();
    userMediaBookPlayedList.clear();
    isLoadingData.value = false;
    selectedPlaylistTab.value = 'Audio';
    pageNo = 1.obs;
    isDataNotFound = false.obs;
  }

  //static data
  //   var sortList = [];

  // late TabController tabController;
  // var groupValue = "Alphabetically ( A-Z )".obs;
  // var tabIndex = 0.obs;
  // @override
  // void onInit() {
  //   tabController = TabController(length: 3, vsync: this);

  //   sortList = [
  //     {
  //       "title": "Alphabetically ( A-Z )".tr,
  //       "value": "Alphabetically ( A-Z )",
  //       "groupValue": groupValue
  //     },
  //     {
  //       "title": "Alphabetically ( Z-A )".tr,
  //       "value": "Alphabetically ( Z-A )",
  //       "groupValue": groupValue
  //     },
  //     {
  //       "title": "Recent".tr,
  //       "value": "Recent",
  //       "groupValue": groupValue,
  //     },
  //   ];
  //   super.onInit();
  // }

  // var searchController = TextEditingController();

  final List<AudioBooksModel> audioBooksDummyList = [
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover1.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover2.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover3.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover4.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover1.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover2.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover3.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
    AudioBooksModel(
      audioBookImgUrl: 'assets/images/liked_list/audio_cover4.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      language: 'Hindi',
      duration: '30 mins 20 sec',
      viewsCount: 32000,
    ),
  ];
  final List<EbooksModel> ebooksDummyList = [
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover1.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover2.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover3.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover4.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover5.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover1.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover2.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover3.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover4.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Srimad Bhagwad Gita Padhchhed',
      bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover5.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
  ];
  final List<VideosModel> videoDummyList = [
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover1.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover2.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover3.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover4.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover5.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover1.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover2.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover3.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover4.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/liked_list/video_cover5.png',
      title: 'Srimad Bhagwad Gita Padhchhed',
      author: 'Swami Adgadanand Ji Maharaj',
      duration: '30 mins 20 sec',
      langauge: 'Hindi',
      viewsCount: 32000,
    ),
  ];

  fetchLikedList(String selectedLikedListTab) {
    if (selectedLikedListTab == 'Audio') {
      return audioBooksDummyList;
    } else if (selectedLikedListTab == 'Books') {
      return ebooksDummyList;
    } else if (selectedLikedListTab == 'Video') {
      return videoDummyList;
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:yatharthageeta/const/constants/constants.dart';
// import 'package:yatharthageeta/models/home/audiobooks_model.dart';
// import 'package:yatharthageeta/models/home/ebooks_model.dart';
// import 'package:yatharthageeta/models/home/videos_model.dart';

// class MyPlayedListController extends GetxController
//     with GetSingleTickerProviderStateMixin {
  // var sortList = [];

  // late TabController tabController;
  // var groupValue = "Alphabetically ( A-Z )".obs;
  // var tabIndex = 0.obs;
  // @override
  // void onInit() {
  //   tabController = TabController(length: 3, vsync: this);

  //   sortList = [
  //     {
  //       "title": "Alphabetically ( A-Z )".tr,
  //       "value": "Alphabetically ( A-Z )",
  //       "groupValue": groupValue
  //     },
  //     {
  //       "title": "Alphabetically ( Z-A )".tr,
  //       "value": "Alphabetically ( Z-A )",
  //       "groupValue": groupValue
  //     },
  //     {
  //       "title": "Recent".tr,
  //       "value": "Recent",
  //       "groupValue": groupValue,
  //     },
  //   ];
  //   super.onInit();
  // }

  // var searchController = TextEditingController();

  // RxString selectedPlaylistTab = 'Audio'.obs;

  // final List<AudioBooksModel> audioBooksDummyList = [
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover1.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover2.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover3.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover4.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover1.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover2.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover3.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  //   AudioBooksModel(
  //     audioBookImgUrl: 'assets/images/liked_list/audio_cover4.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     language: 'Hindi',
  //     duration: '30 mins 20 sec',
  //     viewsCount: 32000,
  //   ),
  // ];
  // final List<EbooksModel> ebooksDummyList = [
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover1.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover2.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover3.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover4.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover5.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover1.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover2.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover3.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover4.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  //   EbooksModel(
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover5.png',
  //     langauge: 'Hindi',
  //     author: 'Swami Adganand Maharaj',
  //     favoriteFlag: 0,
  //     views: 32000,
  //     pagesCount: 500,
  //     desription: Constants.ebookDummyDesc,
  //     chaptersCount: 18,
  //     versesCount: 700,
  //   ),
  // ];
  // final List<VideosModel> videoDummyList = [
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover1.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover2.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover3.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover4.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover5.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover1.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover2.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover3.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover4.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  //   VideosModel(
  //     videoCoverImgUrl: 'assets/images/liked_list/video_cover5.png',
  //     title: 'Srimad Bhagwad Gita Padhchhed',
  //     author: 'Swami Adgadanand Ji Maharaj',
  //     duration: '30 mins 20 sec',
  //     langauge: 'Hindi',
  //     viewsCount: 32000,
  //   ),
  // ];

  // fetchLikedList(String selectedLikedListTab) {
  //   if (selectedLikedListTab == 'Audio') {
  //     return audioBooksDummyList;
  //   } else if (selectedLikedListTab == 'Books') {
  //     return ebooksDummyList;
  //   } else if (selectedLikedListTab == 'Video') {
  //     return videoDummyList;
  //   }
  // }
// }
