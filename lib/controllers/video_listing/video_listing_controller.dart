import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../home/home_controller.dart';
import '../../models/video_listing/video_list_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/home/home_service.dart';
import '../../services/video_listing/video_listing_service.dart';
import '../../utils/utils.dart';

class VideoListingController extends GetxController
    with GetTickerProviderStateMixin {
  final HomeCollectionService homeCollectionService = HomeCollectionService();

  final bottomAppBarService = Get.find<BottomAppBarServices>();

  //To scope pagination for particular listing
  RxString videoApiCallType = ''.obs;

  late TabController tabController;
  late AnimationController animation_controller;
  var groupValue = "".obs;
  var hindi = false.obs;
  var english = false.obs;
  var kannada = false.obs;
  var tamil = false.obs;
  var russian = false.obs;
  var chinese = false.obs;
  var author1 = false.obs;
  var tabIndex = 0.obs;
  var author2 = false.obs;
  var prevScreen = "".obs;
  var collectionId = "".obs;
  var collectionType = "".obs;
  List<Map> languageList = [];
  List<Map> authorsList = [];
  List<Map> categoryList = [];
  var sortList = [];
  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 5;
  RxBool isLoadingData = false.obs;
  RxBool isNoDataLoading = false.obs;
  RxBool isDataNotFound = false.obs;
  RxBool checkRefresh = false.obs;

  RxString? checkItem = "".obs;
  RxList<Result> videosListing = <Result>[].obs;
  RxInt totalVideos = 0.obs;
  RxBool isCollection = false.obs;
  RxBool isMultiCollection = false.obs;
  // RxInt pageNo = 1.obs;
  // final limit = 10;
  // RxBool isDataNotFound = false.obs;
  var searchQuery = "".obs;
  String basicAuth = "";
  String token = "";
  Map<String, String> header = {};
  TextEditingController searchController = TextEditingController();
  RxString controllerText = "".obs;
  var viewAllListingVideoTitle = "".obs;

  VideoListingController() {
    animation_controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
  }

  @override
  void onInit() async {
    tabController = TabController(length: 3, vsync: this);
    header = await Utils().getHeaders();
    token = await Utils.getToken();
    basicAuth = await Utils.authHeader();

    isCollection.value = prevScreen.value == "collection" ||
        prevScreen.value == "homeCollection";

    isMultiCollection.value = prevScreen.value == "homeCollectionMultipleType";
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        controllerText.value = searchController.text;
      }
    });
    debounce(controllerText, (callback) async {
      debugPrint(
          "bottomAppBarService.isCustomSearchBarNewDisposed.value:${bottomAppBarService.isCustomSearchBarNewDisposed.value}");
      if (bottomAppBarService.isCustomSearchBarNewDisposed.value == false) {
        Utils().showLoader();
        clearVideosList();
        log(prevScreen.value);
        prevScreen.value == "homeCollection"
            ? await fetchVideoHomeViewAllListing(
                // collectionVideoId: collectionId.value,
                body: {"query": searchController.text})
            : prevScreen.value == "homeCollectionMultipleType"
                ? fetchVideosHomeMultipleListing(
                    // id: collectionId.value,
                    // type: collectionType.value,
                    body: {"query": searchController.text})
                : await fetchVideoListing(
                    token: Get.find<BottomAppBarServices>().token.value,
                    body: {"query": searchController.text});
        Get.back();
      }
    }, time: const Duration(seconds: 2));
    // languageList = [
    //   {"title": "Hindi/Sanskrit".tr, "value": hindi},
    //   {"title": "English".tr, "value": english},
    //   {"title": "Kannada".tr, "value": kannada},
    //   {"title": "Tamil".tr, "value": tamil},
    //   {"title": "Russian".tr, "value": russian},
    //   {"title": "Chinese".tr, "value": chinese},
    //   // CheckboxModel(title: "Hindi/Sanskrit", value: hindi),
    //   // CheckboxModel(title: "English", value: english),
    //   // CheckboxModel(title: "Kannada", value: kannada),
    //   // CheckboxModel(title: "Tamil", value: tamil),
    //   // CheckboxModel(title: "Russian", value: russian),
    //   // CheckboxModel(title: "Chinese", value: chinese),
    // ];
    // authorsList = [
    //   {"title": "Sri Paramahans Maharaj Ji".tr, "value": author1},
    //   {"title": "Swami Adgadanand Ji Maharaj".tr, "value": author2},
    // ];
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
        "title": "Video Duration ( High to Low )".tr,
        "value": "Video Duration ( High to Low )",
        "order_by": "duration",
        "sort": "desc",
        "groupValue": groupValue
      },
      {
        "title": "Video Duration ( Low to High )".tr,
        "value": "Video Duration ( Low to High )",
        "order_by": "duration",
        "sort": "asc",
        "groupValue": groupValue
      },
      {
        "title": "Popularity".tr,
        "value": "Popularity",
        "order_by": "view_count",
        "sort": "desc",
        "groupValue": groupValue
      },
    ];
    super.onInit();
  }

  void initializeFilter() {
    var homeController = Get.find<HomeController>();
    languageList = homeController.videolanguageModel!.data!.result == null
        ? []
        : homeController.videolanguageModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
    authorsList = homeController.authorModel!.data!.result == null
        ? []
        : homeController.authorModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
    categoryList = homeController.videoCategoryModel!.data!.result == null
        ? []
        : homeController.videoCategoryModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
  }

  Future<void> fetchVideoListing(
      {String? token, Map<String, String>? body}) async {
    isLoadingData.value = true;

    // Loading(Utils.loaderImage()).start(ctx!);
    // Utils().showLoader();
    videoApiCallType.value = 'fetchVideoListing';
    Map<String, String> temp = returnFilterBody();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    final response = await VideoListingService().videoListingApi(
      token: bottomAppBarService.token.value,
      pageNo: pageNo.value.toString(),
      limit: limit.toString(),
      body: body,
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
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && videosListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];
          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final videoListingModel = VideoListingModelFromJson(response.body);

          videosListing.addAll(videoListingModel.data!.result!);
          if (videosListing.isNotEmpty) {
            totalVideos.value = videoListingModel.data!.totalCount!;
          }

          // // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;

          checkItem!.value = mapdata['message'];

          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;
        }
        checkRefresh.value = false;
      }
    }
    // Get.back();
  }

  //Home Collection Video View All
  Future<void> fetchVideoHomeViewAllListing({
    String? token,
    BuildContext? ctx,
    Map<String, String>? body,
    // required String collectionVideoId,
  }) async {
    isLoadingData.value = true;
    // videoApiCallType.value = 'fetchVideoHomeViewAllListing';
    var collectionVideoId = collectionId.value;
    log("CollectionVideoId = $collectionVideoId");
    Map<String, String> temp = returnFilterBody();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    log("Video $collectionId --> ${body.toString()}");
    // Loading(Utils.loaderImage()).start(ctx!);
    // Utils().showLoader();
    final response = await homeCollectionService.homeCollectionViewAllApi(
      token: token,
      collectionId: collectionVideoId,
      body: body,
      pageNo: pageNo.value.toString(),
      limit: limit.toString(),
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
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && videosListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final videoListingModel = VideoListingModelFromJson(response.body);

          videosListing.addAll(videoListingModel.data!.result!);
          if (videosListing.isNotEmpty) {
            totalVideos.value = videoListingModel.data!.totalCount!;
          }

          checkItem!.value = mapdata['message'];
          log(videosListing.toString());
          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;

          // // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }

        checkRefresh.value = false;
      }
    }
    // Get.back();
  }

  Future<void> fetchVideosHomeMultipleListing({
    String? token,
    BuildContext? ctx,
    Map<String, String>? body,
    // required String id,
    // required String type,
  }) async {
    isLoadingData.value = true;
    videoApiCallType.value = 'fetchVideosHomeMultipleListing';
    // Loading(Utils.loaderImage()).start(ctx!);
    // Utils().showLoader();
    var id = collectionId.value;
    var type = collectionType.value;
    Map<String, String> temp = returnFilterBody();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    final response =
        await homeCollectionService.homeCollectionListingMultipleApi(
      token: bottomAppBarService.token.value,
      id: id.toString(),
      type: type.toString(),
      body: body,
      pageNo: pageNo.value.toString(),
      limit: limit.toString(),
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
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && videosListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final videoListingModel = VideoListingModelFromJson(response.body);

          videosListing.addAll(videoListingModel.data!.result!);
          if (videosListing.isNotEmpty) {
            totalVideos.value = videoListingModel.data!.totalCount!;
          }

          checkItem!.value = mapdata['message'];

          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;
        }
        checkRefresh.value = false;
      }
    }
    // Get.back();
  }

  // Future<void> fetchVideoListingFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   Utils().showLoader();
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   final response = await VideoListingService().videoFilterApi('', body);
  //   if (response == " ") {
  //     clearVideosList();
  //     //Do Something here
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());

  //       //Show error toast here
  //     } else if (response.statusCode == 500) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());
  //       //Show error toast here
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         clearVideosList();
  //         // Get.back();
  //         isLoadingData.value = false;
  //         if (pageNo.value == 1 && videosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final videoListingModel = VideoListingModelFromJson(response.body);

  //         clearVideosList();
  //         videosListing.addAll(videoListingModel.data!.result!);
  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  // Future<void> fetchVideoViewAllFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   Utils().showLoader();
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   final response =
  //       await VideoListingService().videoFilterViewAllApi('', body);
  //   if (response == " ") {
  //     clearVideosList();
  //     //Do Something here
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());

  //       //Show error toast here
  //     } else if (response.statusCode == 500) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());
  //       //Show error toast here
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         clearVideosList();
  //         // Get.back();
  //         isLoadingData.value = false;
  //         if (pageNo.value == 1 && videosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final videoListingModel = VideoListingModelFromJson(response.body);

  //         clearVideosList();
  //         videosListing.addAll(videoListingModel.data!.result!);
  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  // Future<void> fetchVideoHomeViewAllFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   Utils().showLoader();
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   final response =
  //       await VideoListingService().videoHomeFilterViewAllApi('', body);
  //   if (response == " ") {
  //     clearVideosList();
  //     //Do Something here
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());

  //       //Show error toast here
  //     } else if (response.statusCode == 500) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());
  //       //Show error toast here
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         clearVideosList();
  //         // Get.back();
  //         isLoadingData.value = false;
  //         if (pageNo.value == 1 && videosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final videoListingModel = VideoListingModelFromJson(response.body);

  //         clearVideosList();
  //         videosListing.addAll(videoListingModel.data!.result!);
  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  // Future<void> fetchVideoHomeMultipleTypeFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   Utils().showLoader();
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   final response =
  //       await VideoListingService().videoHomeFilterMultipleTypeApi('', body);
  //   if (response == " ") {
  //     clearVideosList();
  //     //Do Something here
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());

  //       //Show error toast here
  //     } else if (response.statusCode == 500) {
  //       clearVideosList();
  //       // Map mapdata = jsonDecode(response.body.toString());
  //       //Show error toast here
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         clearVideosList();
  //         // Get.back();
  //         isLoadingData.value = false;
  //         if (pageNo.value == 1 && videosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final videoListingModel = VideoListingModelFromJson(response.body);

  //         clearVideosList();
  //         videosListing.addAll(videoListingModel.data!.result!);
  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  Map<String, String> returnFilterBody() {
    int i = 0;
    Map<String, String> body = {};
    for (var element in languageList) {
      if (element["value"].value == true) {
        body["language_id[$i]"] = element["id"].toString();
        i++;
      }
    }
    i = 0;
    for (var element in authorsList) {
      if (element["value"].value == true) {
        body["artist_id[$i]"] = element["id"].toString();
        i++;
      }
    }
    i = 0;
    for (var element in categoryList) {
      if (element["value"].value == true) {
        body["category_id[$i]"] = element["id"].toString();
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
    for (var i in categoryList) {
      i["value"].value = false;
    }
  }

  clearVideosList() {
    videosListing.clear();
    isLoadingData.value = false;
    pageNo = 1.obs;
    isDataNotFound = false.obs;
    videoApiCallType.value = '';
    tabIndex.value = 0;
    // viewAllListingVideoTitle.value = "";

    //For Managing Screen Title(Please call me before removing)
    if (prevScreen.value == 'homeCollectionMultipleType' ||
        prevScreen.value == 'collection' ||
        prevScreen.value == 'homeCollection') {
      viewAllListingVideoTitle.value = viewAllListingVideoTitle.value;

      log("Video Screen Title: ${viewAllListingVideoTitle.value}");
    } else {
      viewAllListingVideoTitle.value = '';
      log("Video Screen Title: ${viewAllListingVideoTitle.value}, Hence cleared");
    }
  }

  @override
  void dispose() {
    animation_controller.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    clearFilters();
    super.onClose();
  }
  //var searchController = TextEditingController();
}
