import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/constants/constants.dart';
import '../../models/home/audiobooks_model.dart';
import '../../models/home/ebooks_model.dart';
import '../../models/home/videos_model.dart';
import '../../models/user_media_played_viewed/user_media_played_audio_viewed_model.dart';

import 'package:yatharthageeta/models/user_media_wishlist/user_media_wishlist_audio_model.dart'
    as likedaudio;
import 'package:yatharthageeta/models/user_media_wishlist/user_media_wishlist_book_model.dart'
    as likedbook;
import 'package:yatharthageeta/models/user_media_wishlist/user_media_wishlist_video_model.dart'
    as likedvideo;
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:yatharthageeta/services/user_liked_list/user_liked_list_service.dart';

import '../../utils/utils.dart';

class UserLikedListsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final UserLikedListService userLikedListService = UserLikedListService();

  final bottomAppService = Get.find<BottomAppBarServices>();

  RxString selectedLikedPlaylistTab = 'Audio'.obs;

  //var searchController = TextEditingController();

  RxBool isLoadingData = false.obs;
  RxString searchQuery = "".obs;
  RxList<likedaudio.Result> userMediaAudioLikedList = <likedaudio.Result>[].obs;
  RxList<likedbook.Result> userMediaBookLikedList = <likedbook.Result>[].obs;
  RxList<likedvideo.Result> userMediaVideoLikedList = <likedvideo.Result>[].obs;
  RxInt totalMediaViewedItems = 0.obs;

  RxString? checkItem = "".obs;

  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 10;
  RxBool isDataNotFound = false.obs;

  List<Map> languageList = [];
  List<Map> authorsList = [];
  List<Map> typeList = [];
  var sortList = [].obs;

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
    sortList.value = [
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
        clearMediaLikedLists();
        await fetchLikedListingFilter(
            token: bottomAppService.token.value,
            body: {
              "query": searchController.text,
              "type": Utils().getMediaTypeBasedOnTab(
                  tabMediaTitle: selectedLikedPlaylistTab.value)
            },
            type: Utils().getMediaTypeBasedOnTab(
                tabMediaTitle: selectedLikedPlaylistTab.value));
        Get.back();
      }
    }, time: const Duration(seconds: 2));
  }

  Future<void> fetchLikedListingFilter(
      {String? token,
      BuildContext? ctx,
      Map<String, String>? body,
      String? type}) async {
    isLoadingData.value = true;
    // Loading(Utils.loaderImage()).start(ctx!);
    Utils().showLoader();
    log(body.toString());
    body = body ??
        {
          "type": type.toString(),
        };
    final response = await userLikedListService.userLikedListApi(
        token: bottomAppService.token.value, mediaType: type!, body: body);
    body["query"] = searchController.text;
    if (response == " ") {
      clearMediaLikedLists();
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        clearMediaLikedLists();
        log("404");
      } else if (response.statusCode == 500) {
        log("500");
        clearMediaLikedLists();
      } else if (response.statusCode == 200) {
        log("200");
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          isLoadingData.value = false;
          clearMediaLikedLists();
          if (pageNo.value == 1 && userMediaAudioLikedList.isEmpty) {
            isDataNotFound.value = true;
          }
          // checkItem!.value = mapdata['message'];
        } else {
          final userMediaPlayedListModel =
              userMediaPlayedAudioViewedModelFromJson(response.body);

          clearMediaLikedLists();
          if (userMediaPlayedListModel.data!.result!.isEmpty) {
            checkItem!.value = mapdata['message'];

            log("USerMediaPlayedList is empty = ${userMediaAudioLikedList.toString()}");
            log("USerMediaPlayedList is empty = ${userMediaBookLikedList.toString()}");
            log("USerMediaPlayedList is empty = ${userMediaVideoLikedList.toString()}");

            log('total userMediaAudioLikedList items value---> ${totalMediaViewedItems.value}');
          } else if (type == 'Book') {
            final userMediaBookLikedListModel =
                likedbook.userMediaWishlistBookModelFromJson(response.body);

            userMediaBookLikedList
                .addAll(userMediaBookLikedListModel.data!.result!);
            totalMediaViewedItems.value =
                userMediaBookLikedListModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("userMediaBookLikedList result = ${userMediaBookLikedList.first.toString()}");

            pageNo.value++;
            log('total userMediaBookLikedList items value---> ${totalMediaViewedItems.value}');
          } else if (type == 'Audio') {
            final userMediaAudioLikedListModel =
                likedaudio.userMediaWishlistAudioModelFromJson(response.body);

            userMediaAudioLikedList
                .addAll(userMediaAudioLikedListModel.data!.result!);
            totalMediaViewedItems.value =
                userMediaAudioLikedListModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("userMediaBookLikedList result = ${userMediaAudioLikedList.first.toString()}");

            pageNo.value++;
            log('total userMediaBookLikedList items value---> ${totalMediaViewedItems.value}');
          } else if (type == 'Video') {
            final userMediaVideoLikedListModel =
                // video.userMediaPlayedVideoViewedModelFromJson(response.body);

                likedvideo.userMediaWishlistVideoModelFromJson(response.body);

            userMediaVideoLikedList
                .addAll(userMediaVideoLikedListModel.data!.result!);
            totalMediaViewedItems.value =
                userMediaVideoLikedListModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("userMediaVideoLikedList result = ${userMediaVideoLikedList.first.toString()}");

            pageNo.value++;
            log('total userMediaVideoLikedList items value---> ${totalMediaViewedItems.value}');
          }

          isLoadingData.value = false;
          isDataNotFound.value = false;
        }
      }
    }
    Get.back();
  }

  // Future<void> fetchUserMediaLikedList(
  //     {String? token, BuildContext? ctx, required String type}) async {
  //   log('userMediaAudioLikedList = $userMediaAudioLikedList');
  //   log('userMediaBookLikedList = $userMediaBookLikedList');
  //   log('userMediaVideoLikedList = $userMediaVideoLikedList');
  //   isLoadingData.value = true;

  //   final response = await userLikedListService.userLikedListApi(
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
  //         if (pageNo.value == 1 && userMediaAudioLikedList.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         // checkItem!.value = mapdata['message'];

  //         // log('item message = $checkItem');
  //       } else if (mapdata['success'] == 4) {
  //         debugPrint("Success 4");
  //         Utils.customToast(mapdata['message'], kRedColor,
  //             kRedColor.withOpacity(0.2), "Error");
  //         //profileData.clear();
  //         Utils().showLoader();
  //         Utils.deleteToken();
  //         Utils.deleteNotificationStatus();
  //         await Get.find<LogOutController>().logOutUser();
  //       } else {
  //         //General model
  //         final userMediaPlayedListModel =
  //             general.userMediaPlayedViewedModelFromJson(response.body);

  //         //Based on the type store data
  //         if (userMediaPlayedListModel.data!.result!.isEmpty) {
  //           log("USerMediaPlayedList is empty = ${userMediaAudioLikedList.toString()}");
  //           log("USerMediaPlayedList is empty = ${userMediaBookLikedList.toString()}");
  //           log("USerMediaPlayedList is empty = ${userMediaVideoLikedList.toString()}");

  //           log('total userMediaAudioLikedList items value---> ${totalMediaViewedItems.value}');
  //         } else if (type == 'Book') {
  //           final userMediaBookLikedListModel =
  //               likedbook.userMediaWishlistBookModelFromJson(response.body);

  //           userMediaBookLikedList
  //               .addAll(userMediaBookLikedListModel.data!.result!);
  //           totalMediaViewedItems.value =
  //               userMediaBookLikedListModel.data!.totalCount!;
  //           checkItem!.value = mapdata['message'];

  //           log('item message = $checkItem');
  //           log("userMediaBookLikedList result = ${userMediaBookLikedList.first.toString()}");

  //           pageNo.value++;
  //           log('total userMediaBookLikedList items value---> ${totalMediaViewedItems.value}');
  //         } else if (type == 'Audio') {
  //           final userMediaAudioLikedListModel =
  //               likedaudio.userMediaWishlistAudioModelFromJson(response.body);

  //           userMediaAudioLikedList
  //               .addAll(userMediaAudioLikedListModel.data!.result!);
  //           totalMediaViewedItems.value =
  //               userMediaAudioLikedListModel.data!.totalCount!;
  //           checkItem!.value = mapdata['message'];

  //           log('item message = $checkItem');
  //           log("userMediaBookLikedList result = ${userMediaAudioLikedList.first.toString()}");

  //           pageNo.value++;
  //           log('total userMediaBookLikedList items value---> ${totalMediaViewedItems.value}');
  //         } else if (type == 'Video') {
  //           final userMediaVideoLikedListModel =
  //               // video.userMediaPlayedVideoViewedModelFromJson(response.body);

  //               likedvideo.userMediaWishlistVideoModelFromJson(response.body);

  //           userMediaVideoLikedList
  //               .addAll(userMediaVideoLikedListModel.data!.result!);
  //           totalMediaViewedItems.value =
  //               userMediaVideoLikedListModel.data!.totalCount!;
  //           checkItem!.value = mapdata['message'];

  //           log('item message = $checkItem');
  //           log("userMediaVideoLikedList result = ${userMediaVideoLikedList.first.toString()}");

  //           pageNo.value++;
  //           log('total userMediaVideoLikedList items value---> ${totalMediaViewedItems.value}');
  //         }

  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  // }

  clearMediaLikedLists() {
    userMediaAudioLikedList.clear();
    userMediaBookLikedList.clear();
    userMediaVideoLikedList.clear();
    isLoadingData.value = false;
    // selectedLikedPlaylistTab.value = 'Audio';
    pageNo = 1.obs;
    isDataNotFound = false.obs;
  }

  resetMediaLikedLists() {
    userMediaAudioLikedList.clear();
    userMediaBookLikedList.clear();
    userMediaVideoLikedList.clear();
    isLoadingData.value = false;
    selectedLikedPlaylistTab.value = 'Audio';
    pageNo = 1.obs;
    isDataNotFound = false.obs;
  }

  @override
  void dispose() {
    resetMediaLikedLists();
    super.dispose();
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

  // fetchLikedList(String selectedLikedListTab) {
  //   if (selectedLikedListTab == 'Audio') {
  //     return audioBooksDummyList;
  //   } else if (selectedLikedListTab == 'Books') {
  //     return ebooksDummyList;
  //   } else if (selectedLikedListTab == 'Video') {
  //     return videoDummyList;
  //   }
  // }
}
