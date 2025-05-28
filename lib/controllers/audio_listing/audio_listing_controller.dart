import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../../models/audio_listing/audio_listing_model.dart';
import '../../services/audio_listing/audio_listing_sevice.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/explore_service/explore_service.dart';
import '../../services/home/home_service.dart';
import '../../utils/utils.dart';
import 'package:http/http.dart' as http;

class AudioListingController extends GetxController
    with GetTickerProviderStateMixin {
  final HomeCollectionService homeCollectionService = HomeCollectionService();
  final bottomAppBarService = Get.find<BottomAppBarServices>();
  late AnimationController animation_controller;

  //To scope pagination for particular listing
  RxString audioApiCallType = ''.obs;

  late TabController tabController;
  var groupValue = "".obs;
  var tabIndex = 0.obs;
  var searchQuery = "".obs;
  var prevScreen = "".obs;
  var collectionId = "".obs;
  var collectionType = "".obs;
  //Pagination
  RxInt pageNo = 1.obs;
  final limit = 5;
  var viewAllListingAudioTitle = "".obs;
  RxBool isLoadingData = false.obs;
  RxBool isNoDataLoading = false.obs;
  RxBool isDataNotFound = false.obs;
  RxBool checkRefresh = false.obs;
  // RxBool isLoadingData = false.obs;
  RxString? checkItem = "".obs;
  RxList<Result> audiosListing = <Result>[].obs;
  RxInt totalAudios = 0.obs;
  RxBool isCollection = false.obs;
  RxBool isMultiCollection = false.obs;
  RxString category = "".obs;
  // RxInt pageNo = 1.obs;
  // final limit = 10;
  // RxBool isDataNotFound = false.obs;
  Map<String, String> header = {};
  String token = "";
  TextEditingController searchController = TextEditingController();
  RxString controllerText = "".obs;
  http.Client? client;

  AudioListingController() {
    animation_controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
  }

  @override
  void onInit() async {
    tabController = TabController(length: 3, vsync: this);
    print("Init state callled");
    await _oninit();
    //initializing data of sort
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
        "title": "Audio Duration ( High to Low )".tr,
        "value": "Audio Duration ( High to Low )",
        "order_by": "duration",
        "sort": "desc",
        "groupValue": groupValue
      },
      {
        "title": "Audio Duration ( Low to High )".tr,
        "value": "Audio Duration ( Low to High )",
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

  _oninit() async {
    header = await Utils().getHeaders();
    isCollection.value = prevScreen.value == "collection" ||
        prevScreen.value == "homeCollection";
    log(isCollection.toString());
    isMultiCollection.value = prevScreen.value == "homeCollectionMultipleType";
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
          "bottomAppBarService.isCustomSearchBarNewDisposed.value:${bottomAppBarService.isCustomSearchBarNewDisposed.value}");
      if (bottomAppBarService.isCustomSearchBarNewDisposed.value == false) {
        Utils().showLoader();
        clearAudiosList();
        prevScreen.value == "collection"
            ? await fetchAudioExploreViewAllListing(
                // collectionAudioId: collectionId.toString(),
                body: {"query": searchController.text})
            : prevScreen.value == "homeCollection"
                ? await fetchAudioHomeViewAllListing(
                    // collectionAudioId: collectionId.toString(),
                    body: {"query": searchController.text})
                : prevScreen.value == "homeCollectionMultipleType"
                    ? fetchAudiosHomeMultipleListing(
                        // id: collectionId.value,
                        // type: collectionType.value,
                        body: {"query": searchController.text})
                    : await fetchAudioListing(
                        token: Get.find<BottomAppBarServices>().token.value,
                        body: {"query": searchController.text});
        Get.back();
      }
    }, time: const Duration(seconds: 2));
  }

  void initializeFilter() {
    var homeController = Get.find<HomeController>();
    languageList = homeController.audiolanguageModel!.data!.result == null
        ? []
        : homeController.audiolanguageModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
    authorsList = homeController.authorModel!.data!.result == null
        ? []
        : homeController.authorModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
    typeList = homeController.audioCategoryModel!.data!.result == null
        ? []
        : homeController.audioCategoryModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
  }

  //Home Tabs Audio Listing Filter
  // Future<void> fetchAudioListingFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   audioApiCallType.value = 'fetchAudioListingFilter';
  //   Utils().showLoader();
  //   final response = await AudioListingService().audioFilterApi('', body);
  //   if (response == " ") {
  //     clearAudiosList();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 500) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         isLoadingData.value = false;
  //         clearAudiosList();
  //         if (pageNo.value == 1 && audiosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final audioListingModel = AudioListingModelFromJson(response.body);

  //         // clearAudiosList();
  //         audiosListing.addAll(audioListingModel.data!.result!);
  //         // totalBooks.value = audioListingModel.data!.totalCount!;

  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  //Explore collection View all
  // Future<void> fetchAudioViewAllFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   Utils().showLoader();
  //   final response =
  //       await AudioListingService().audioViewAllFilterApi('', body);
  //   if (response == " ") {
  //     clearAudiosList();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 500) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         isLoadingData.value = false;
  //         clearAudiosList();
  //         if (pageNo.value == 1 && audiosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final audioListingModel = AudioListingModelFromJson(response.body);

  //         clearAudiosList();
  //         audiosListing.addAll(audioListingModel.data!.result!);
  //         // totalBooks.value = audioListingModel.data!.totalCount!;

  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  //Home collection View All filter
  // Future<void> fetchAudioHomeViewAllFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   // audioApiCallType.value = 'fetchAudioListingFilter';
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   Utils().showLoader();
  //   final response =
  //       await AudioListingService().audioHomeViewAllFilterApi('', body);
  //   if (response == " ") {
  //     clearAudiosList();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 500) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         isLoadingData.value = false;
  //         clearAudiosList();
  //         if (pageNo.value == 1 && audiosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         log("Here");

  //         // checkItem!.value = mapdata['message'];
  //       } else {
  //         final audioListingModel = AudioListingModelFromJson(response.body);

  //         clearAudiosList();
  //         audiosListing.addAll(audioListingModel.data!.result!);
  //         // totalBooks.value = audioListingModel.data!.totalCount!;

  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  //Home Tabs Audio Listing
  Future<void> fetchAudioListing(
      {String? token, Map<String, String>? body}) async {
    client?.close();
    client = http.Client();
    isLoadingData.value = true;
    audioApiCallType.value = 'fetchAudioListing';
    Map<String, String> temp = returnFilterBody();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    if (category.value != "") {
      body["category"] = category.value;
    }
    // Loading(Utils.loaderImage()).start(ctx!);
    // Utils().showLoader();
    // body = body != null || body.isNotEmpty ? returnFilterBody() : {};
    // if (body == null) {
    //   body = {};
    // } else {
    //   body = body.isEmpty ? {} : returnFilterBody();
    // }
    log(body.toString());
    final response = await AudioListingService().audioListingApi(
        token: bottomAppBarService.token.value,
        pageNo: pageNo.value.toString(),
        limit: limit.toString(),
        body: body,
        client: client!);
    log(response.toString());
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

          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');

          // checkItem!.value = mapdata['message'];
        } else {
          final videoListingModel = AudioListingModelFromJson(response.body);

          audiosListing.addAll(videoListingModel.data!.result!);
          if (audiosListing.isNotEmpty) {
            totalAudios.value = videoListingModel.data!.totalCount!;
          }

          checkItem!.value = mapdata['message'];

          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;

          // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        checkRefresh.value = false;
      }
    }
    // Get.back();
  }

  //Home Collection View all
  Future<void> fetchAudioHomeViewAllListing({
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
    body["query"] = searchController.text;
    audioApiCallType.value = 'fetchAudioHomeViewAllListing';
    log("CollectionAudioId = $collectionAudioId");
    log("View all api is called");
    // Loading(Utils.loaderImage()).start(ctx!);
    final response = await homeCollectionService.homeCollectionViewAllApi(
      token: bottomAppBarService.token.value,
      collectionId: collectionAudioId,
      body: body,
      pageNo: pageNo.value.toString(),
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
          //
          // checkItem!.value = mapdata['message'];
          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final videoListingModel = AudioListingModelFromJson(response.body);

          audiosListing.addAll(videoListingModel.data!.result!);
          if (audiosListing.isNotEmpty) {
            totalAudios.value = videoListingModel.data!.totalCount!;
          }
          checkItem!.value = mapdata['message'];
          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        checkRefresh.value = false;
      }
    }
  }

  //Explore Audio View All Listing
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
    body["query"] = searchController.text;
    audioApiCallType.value = 'fetchAudioExploreViewAllListing';
    log("CollectionVideoId = $collectionAudioId");

    // Loading(Utils.loaderImage()).start(ctx!);
    final response = await ExploreService().exploreCollectionViewAllApi(
      token: bottomAppBarService.token.value,
      collectionId: collectionAudioId,
      body: body,
      pageNo: pageNo.value.toString(),
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
          final videoListingModel = AudioListingModelFromJson(response.body);

          audiosListing.addAll(videoListingModel.data!.result!);
          if (audiosListing.isNotEmpty) {
            totalAudios.value = videoListingModel.data!.totalCount!;
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
  }

  Future<void> fetchAudiosHomeMultipleListing({
    String? token,
    BuildContext? ctx,
    Map<String, String>? body,
  }) async {
    isLoadingData.value = true;
    var id = collectionId;
    var type = collectionType;
    Map<String, String> temp = returnFilterBody();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    audioApiCallType.value = 'fetchAudiosHomeMultipleListing';
    log("--->Called");
    // Loading(Utils.loaderImage()).start(ctx!);
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
          final videoListingModel = AudioListingModelFromJson(response.body);

          audiosListing.addAll(videoListingModel.data!.result!);

          // totalBooks.value = videoListingModel.data!.totalCount!;
          if (audiosListing.isNotEmpty) {
            totalAudios.value = videoListingModel.data!.totalCount!;
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
  }

  // Future<void> fetchAudioHomeMultipleTypeFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   Utils().showLoader();
  //   final response =
  //       await AudioListingService().audioHomeMultipleTypeFilterApi('', body);

  //   log("Audio multi body = $body");
  //   if (response == " ") {
  //     clearAudiosList();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 500) {
  //       clearAudiosList();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       log("Response audio multi = ${response.body.toString()}");

  //       if (mapdata['success'] == 0) {
  //         isLoadingData.value = false;
  //         clearAudiosList();
  //         if (pageNo.value == 1 && audiosListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         log("Here BRo");

  //         // checkItem!.value = mapdata['message'];
  //       } else {
  //         final audioListingModel = AudioListingModelFromJson(response.body);

  //         clearAudiosList();
  //         audiosListing.addAll(audioListingModel.data!.result!);
  //         // totalBooks.value = audioListingModel.data!.totalCount!;

  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

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
    for (var i in typeList) {
      i["value"].value = false;
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
    for (var element in typeList) {
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

  clearAudiosList() {
    audiosListing.clear();
    isLoadingData.value = false;
    pageNo = 1.obs;
    isDataNotFound = false.obs;
    audioApiCallType.value = '';
    tabIndex.value = 0;
    // viewAllListingAudioTitle.value = "";

    //For Managing Screen Title(Please call me before removing)
    if (prevScreen.value == 'homeCollectionMultipleType' ||
        prevScreen.value == 'collection' ||
        prevScreen.value == 'homeCollection') {
      viewAllListingAudioTitle.value = viewAllListingAudioTitle.value;
      log("Video Screen Title: ${viewAllListingAudioTitle.value}");
    } else {
      viewAllListingAudioTitle.value = '';
      log("Video Screen Title: ${viewAllListingAudioTitle.value} Hence Cleared");
    }
  }

  @override
  void dispose() {
    animation_controller.dispose();
    clearFilters();
    client?.close();
    super.dispose();
  }

  List<Map> languageList = [];
  List<Map> authorsList = [];
  List<Map> typeList = [];
  var sortList = [];
  @override
  void onClose() {
    clearFilters();
    super.onClose();
  }
}
