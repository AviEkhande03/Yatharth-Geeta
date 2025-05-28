import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../home/home_controller.dart';
import '../../models/books_listing/books_listing_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/ebooks_listing/ebooks_listing_service.dart';
import '../../services/explore_service/explore_service.dart';
import '../../services/home/home_service.dart';
import '../../utils/utils.dart';

class EbooksListingController extends GetxController
    with GetTickerProviderStateMixin {
  final EbooksListingService ebooksListingService = EbooksListingService();
  final HomeCollectionService homeCollectionService = HomeCollectionService();
  final bottomAppBarService = Get.find<BottomAppBarServices>();

  //To scope pagination for particular listing
  RxString booksApiCallType = ''.obs;
  TextEditingController searchController = TextEditingController();
  RxString controllerText = "".obs;

  RxList<Result> booksListing = <Result>[].obs;
  RxInt totalBooks = 0.obs;

  RxString? checkItem = "".obs;

  //var searchQuery = "".obs;

  //var searchQuery = "".obs;
  var prevScreen = "".obs;
  var collectionId = "".obs;
  var collectionType = "".obs;

  //   RxInt collectionPageNo = 1.obs;
  // final collectionLimit = 5;
  // RxBool isCollectionLoadingData = false.obs;
  // RxBool isDataNotFound = false.obs;
  // RxBool isNodataLoading = false.obs;
  // // RxInt pageNo = 1.obs;
  // // final limit = 10;

  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 5;
  RxBool isLoadingData = false.obs;
  RxBool isNoDataLoading = false.obs;
  RxBool isDataNotFound = false.obs;
  RxBool checkRefresh = false.obs;
  // RxBool isSearching = false.obs;
  RxString category = "".obs;
  List<Map> languageList = [];
  List<Map> authorsList = [];
  List<Map> typeList = [];
  var sortList = [];

  late TabController tabController;
  var groupValue = "".obs;
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
  var viewAllListingBookTitle = "".obs;
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);

    sortList = [
      {
        "title": "Alphabetically ( A-Z )".tr,
        "value": "Alphabetically ( A-Z )",
        "order_by": "name",
        "sort": "asc",
        "groupValue": groupValue
      },
      {
        "title": "Alphabetically ( Z-A )".tr,
        "value": "Alphabetically ( Z-A )",
        "order_by": "name",
        "sort": "desc",
        "groupValue": groupValue
      },
      {
        "title": "No of Pages ( High to Low )".tr,
        "value": "No of Pages ( High to Low )",
        "order_by": "pages",
        "sort": "desc",
        "groupValue": groupValue
      },
      {
        "title": "No of Pages ( Low to High )".tr,
        "value": "No of Pages ( Low to High )",
        "order_by": "pages",
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
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        controllerText.value = searchController.text;
      }
    });
    debugPrint(
        "bottomAppBarService.isCustomSearchBarNewDisposed.value in service:${bottomAppBarService.isCustomSearchBarNewDisposed.value}");
    debounce(controllerText, (callback) async {
      // if (searchQuery.isEmpty) {
      //   return;
      // }
      debugPrint("Inside debounce");
      debugPrint(
          "bottomAppBarService.isCustomSearchBarNewDisposed.value:${bottomAppBarService.isCustomSearchBarNewDisposed.value}");
      if (bottomAppBarService.isCustomSearchBarNewDisposed.value == false) {
        //debugPrint("Inside debounce");
        Utils().showLoader();
        // isSearching.value = true;
        clearEbooksList();

        if (prevScreen.value == 'collection') {
          log("Explore collection");
          await fetchBooksExploreViewAllListing(
            token: Get.find<BottomAppBarServices>().token.value,
            body: {"query": searchController.text},
            // collectionBookId: collectionId.toString(),
          );
        } else if (prevScreen.value == 'homeCollection') {
          log("Home Collection called");
          await fetchBooksHomeViewAllListing(
            token: Get.find<BottomAppBarServices>().token.value,
            // collectionBookId: collectionId.toString(),
            body: {"query": searchController.text},
          );
        } else if (prevScreen.value == "homeCollectionMultipleType") {
          fetchBooksHomeMultipleListing(
              // id: collectionId.value,
              // type: collectionType.value,
              body: {"query": searchController.text});
        } else {
          await fetchBooksListing(
            token: Get.find<BottomAppBarServices>().token.value,
            body: {"query": searchController.text},
          );
        }
        // isSearching.value = false;
        Get.back();
      }
    }, time: const Duration(seconds: 2));
  }

  void initializeFilter() {
    var homeController = Get.find<HomeController>();
    languageList = homeController.booklanguageModel!.data!.result == null
        ? []
        : homeController.booklanguageModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
    // typeList =
    authorsList = homeController.authorModel!.data!.result == null
        ? []
        : homeController.authorModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
    typeList = homeController.bookCategoryModel!.data!.result == null
        ? []
        : homeController.bookCategoryModel!.data!.result!
            .map((e) => {"title": e.name, "value": false.obs, "id": e.id})
            .toList();
  }

  // Future<void> fetchBookListingFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   isLoadingData.value = true;
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   Utils().showLoader();
  //   final response = await EbooksListingService().bookFilterApi('', body);
  //   if (response == " ") {
  //     clearEbooksList();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       print(404);
  //       clearEbooksList();
  //     } else if (response.statusCode == 500) {
  //       print(500);
  //       clearEbooksList();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         isLoadingData.value = false;
  //         clearEbooksList();
  //         if (pageNo.value == 1 && booksListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final bookListingModel = booksListingModelFromJson(response.body);

  //         clearEbooksList();

  //         booksListing.addAll(bookListingModel.data!.result!);
  //         // totalBooks.value = audioLi`stingModel.data!.totalCount!;
  //         print(booksListing);
  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  // Future<void> fetchBookViewAllFilter(
  //     {String? token, BuildContext? ctx, Map<String, String>? body}) async {
  //   isLoadingData.value = true;
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   Utils().showLoader();
  //   log("book view all filter body = $body");
  //   final response =
  //       await EbooksListingService().bookViewAllFilterApi('', body!);
  //   if (response == " ") {
  //     clearEbooksList();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       print(404);
  //       clearEbooksList();
  //     } else if (response.statusCode == 500) {
  //       print(500);
  //       clearEbooksList();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         isLoadingData.value = false;
  //         clearEbooksList();
  //         if (pageNo.value == 1 && booksListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final bookListingModel = booksListingModelFromJson(response.body);

  //         clearEbooksList();
  //         booksListing.addAll(bookListingModel.data!.result!);
  //         // totalBooks.value = audioLi`stingModel.data!.totalCount!;
  //         print(booksListing);
  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  // Future<void> fetchBookHomeViewAllFilter(
  //     {String? token, BuildContext? ctx, Map<String, String>? body}) async {
  //   isLoadingData.value = true;
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   log("book filter body = $body");
  //   // log(EbooksListingService()
  //   //     .bookViewAllHomeFilterApi(
  //   //         Get.find<BottomAppBarServices>().token.value, body)
  //   //     .toString());
  //   Utils().showLoader();
  //   final response = await EbooksListingService().bookViewAllHomeFilterApi(
  //       Get.find<BottomAppBarServices>().token.value, body!);
  //   // log(response);
  //   if (response == " ") {
  //     log("Baaap re kya hua yeh");
  //     // clearEbooksList();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       print(404);
  //       clearEbooksList();
  //     } else if (response.statusCode == 500) {
  //       print(500);
  //       clearEbooksList();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         isLoadingData.value = false;
  //         clearEbooksList();
  //         if (pageNo.value == 1 && booksListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         checkItem!.value = mapdata['message'];
  //       } else {
  //         final bookListingModel = booksListingModelFromJson(response.body);

  //         clearEbooksList();
  //         booksListing.addAll(bookListingModel.data!.result!);
  //         // totalBooks.value = audioLi`stingModel.data!.totalCount!;
  //         print(booksListing);
  //         // Loading.stop();
  //         pageNo.value++;
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

  Future<void> fetchBooksListing(
      {String? token, Map<String, String>? body}) async {
    log('booklisting = $booksListing');
    isLoadingData.value = true;
    booksApiCallType.value = 'fetchBooksListing';
    Map<String, String> temp = returnFilter();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;

    // debugPrint(args);
    // print("Category Here: ${category.value.toString()}");
    if (category.value != "") {
      body["category"] = category.value;
    }
    log("Body Here Books " + body.toString());
    final response = await ebooksListingService.ebooksListingApi(
        token: bottomAppBarService.token.value,
        pageNo: pageNo.value.toString(),
        limit: limit.toString(),
        body: body);
    log("response");
    if (response == " ") {
      log("firse yaha");
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        print("404");
        //Show error toast here
      } else if (response.statusCode == 500) {
        print("500");
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // Get.back();
          // isLoadingData.value = false;
          // log('success is 0');

          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');

          // if (pageNo.value == 1 && booksListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else {
          final bookListingModel = booksListingModelFromJson(response.body);

          booksListing.addAll(bookListingModel.data!.result!);
          if (booksListing.isNotEmpty) {
            totalBooks.value = bookListingModel.data!.totalCount!;
          }
          checkItem!.value = mapdata['message'];

          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;

          // log('item message = $checkItem');
          // log("book listing result = ${booksListing.first.toString()}");

          // pageNo.value++;
          // log('total books value---> ${totalBooks.value}');
          // log('booksList length----> ${booksListing.length}');

          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
        checkRefresh.value = false;
      }
    }
  }

  //Home Collection View All Listing
  Future<void> fetchBooksHomeViewAllListing({
    String? token,
    BuildContext? ctx,
    Map<String, String>? body,
    // required String collectionBookId,
  }) async {
    log('booklisting = $booksListing');
    isLoadingData.value = true;
    var collectionBookId = collectionId.value;
    log("CollectionBookId = $collectionBookId");
    Map<String, String> temp = returnFilter();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    booksApiCallType.value = 'fetchBooksHomeViewAllListing';
    final response = await homeCollectionService.homeCollectionViewAllApi(
      token: bottomAppBarService.token.value,
      collectionId: collectionBookId,
      body: body,
      pageNo: pageNo.value.toString(),
      limit: limit.toString(),
    );
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        print("404");
        //Show error toast here
      } else if (response.statusCode == 500) {
        print("500");
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // Get.back();
          // isLoadingData.value = false;
          // log('success is 0');
          // if (pageNo.value == 1 && booksListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');

          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final bookListingModel = booksListingModelFromJson(response.body);

          booksListing.addAll(bookListingModel.data!.result!);

          if (booksListing.isNotEmpty) {
            totalBooks.value = bookListingModel.data!.totalCount!;
          }
          checkItem!.value = mapdata['message'];

          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;
          // totalBooks.value = bookListingModel.data!.totalCount!;
          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
          // log("book listing result = ${booksListing.first.toString()}");

          // pageNo.value++;
          // log('total books value---> ${totalBooks.value}');
          // log('booksList length----> ${booksListing.length}');
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }

        checkRefresh.value = false;
      }
    }
  }

  Future<void> fetchBooksHomeMultipleListing(
      {String? token,
      BuildContext? ctx,
      // required String type,
      // required String id,
      Map<String, String>? body}) async {
    log('booklisting = $booksListing');
    isLoadingData.value = true;
    var id = collectionId.value;
    var type = collectionType.value;
    booksApiCallType.value = 'fetchBooksHomeMultipleListing';
    Map<String, String> temp = returnFilter();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    final response =
        await homeCollectionService.homeCollectionListingMultipleApi(
      type: type.toString(),
      id: id.toString(),
      body: body,
      pageNo: pageNo.value.toString(),
      limit: limit.toString(),
    );
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        print("404");
        //Show error toast here
      } else if (response.statusCode == 500) {
        print("500");
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // Get.back();
          // isLoadingData.value = false;
          // log('success is 0');
          // if (pageNo.value == 1 && booksListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');

          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final bookListingModel = booksListingModelFromJson(response.body);

          booksListing.addAll(bookListingModel.data!.result!);
          if (booksListing.isNotEmpty) {
            totalBooks.value = bookListingModel.data!.totalCount!;
          }

          checkItem!.value = mapdata['message'];

          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;
          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
          // log("book listing result = ${booksListing.first.toString()}");

          // pageNo.value++;
          // log('total books value---> ${totalBooks.value}');
          // log('booksList length----> ${booksListing.length}');
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }

        checkRefresh.value = false;
      }
    }
  }

  // Future<void> fetchBooksHomeMultipleListingFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   log('booklisting = $booksListing');
  //   isLoadingData.value = true;

  //   // final response =
  //   //     await homeCollectionService.homeCollectionListingMultipleApi(
  //   //   type: type.toString(),
  //   //   id: id.toString(),
  //   // );
  //   final response = await ebooksListingService
  //       .homeCollectionListingMultipleFilterApi('', body);
  //   clearEbooksList();
  //   log("book multi type filter body = $body");
  //   if (response == " ") {
  //     //Do Something here
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       // Map mapdata = jsonDecode(response.body.toString());
  //       print("404");
  //       //Show error toast here
  //     } else if (response.statusCode == 500) {
  //       print("500");
  //       // Map mapdata = jsonDecode(response.body.toString());
  //       //Show error toast here
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());

  //       if (mapdata['success'] == 0) {
  //         // Get.back();
  //         isLoadingData.value = false;
  //         log('success is 0');
  //         if (pageNo.value == 1 && booksListing.isEmpty) {
  //           isDataNotFound.value = true;
  //         }

  //         // checkItem!.value = mapdata['message'];

  //         // log('item message = $checkItem');
  //       } else {
  //         final bookListingModel = booksListingModelFromJson(response.body);

  //         booksListing.addAll(bookListingModel.data!.result!);
  //         // totalBooks.value = bookListingModel.data!.totalCount!;
  //         checkItem!.value = mapdata['message'];

  //         log('item message = $checkItem');
  //         // log("book listing result = ${booksListing.first.toString()}");

  //         pageNo.value++;
  //         // log('total books value---> ${totalBooks.value}');
  //         log('booksList length----> ${booksListing.length}');
  //         isLoadingData.value = false;
  //         isDataNotFound.value = false;
  //       }
  //     }
  //   }
  // }

  Future<void> fetchBooksExploreViewAllListing({
    String? token,
    BuildContext? ctx,
    Map<String, String>? body,
    // required String collectionBookId,
  }) async {
    log('booklisting = $booksListing');
    isLoadingData.value = true;
    var collectionBookId = collectionId.value;
    Map<String, String> temp = returnFilter();
    temp.addAll(body ?? {});
    body = temp;
    body["query"] = searchController.text;
    booksApiCallType.value = 'fetchBooksExploreViewAllListing';
    log("Explore view all called");
    log("CollectionBookId = $collectionBookId");

    final response = await ExploreService().exploreCollectionViewAllApi(
      token: bottomAppBarService.token.value,
      collectionId: collectionBookId,
      body: body,
      pageNo: pageNo.value.toString(),
      limit: limit.toString(),
    );
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        print("404");
        //Show error toast here
      } else if (response.statusCode == 500) {
        print("500");
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // Get.back();
          // isLoadingData.value = false;
          // log('success is 0');
          // if (pageNo.value == 1 && booksListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');

          isNoDataLoading.value = true;
          isLoadingData.value = false;
          log('success is 0');
        } else {
          final bookListingModel = booksListingModelFromJson(response.body);

          booksListing.addAll(bookListingModel.data!.result!);
          if (booksListing.isNotEmpty) {
            totalBooks.value = bookListingModel.data!.totalCount!;
          }
          checkItem!.value = mapdata['message'];

          pageNo++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;

          // log('item message = $checkItem');
          // log("book listing result = ${booksListing.first.toString()}");

          // pageNo.value++;
          // log('total books value---> ${totalBooks.value}');
          // log('booksList length----> ${booksListing.length}');
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }

        checkRefresh.value = false;
      }
    }
  }

  clearFilters() {
    for (var i in languageList) {
      i["value"].value = false;
    }
    for (var i in authorsList) {
      i["value"].value = false;
    }
    for (var i in typeList) {
      i["value"].value = false;
    }
    for (var i in sortList) {
      i["groupValue"].value = "";
    }
    // tabIndex.value = 1;
  }

  returnFilter() {
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
        body["artist_id[$i]"] = element["id"].toString();
        i++;
      }
    }
    i = 0;
    for (var element in typeList) {
      if (element["value"].value == true) {
        body["book_category_id[$i]"] = element["id"].toString();
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

  clearEbooksList() {
    booksListing.clear();
    isLoadingData.value = false;
    pageNo = 1.obs;
    booksApiCallType.value = '';
    tabIndex.value = 0;

    //For Managing Screen Title(Please call me before removing)
    if (prevScreen.value == 'homeCollectionMultipleType' ||
        prevScreen.value == 'collection' ||
        prevScreen.value == 'homeCollection') {
      viewAllListingBookTitle.value = viewAllListingBookTitle.value;
      log("Book Screen Title: ${viewAllListingBookTitle.value}");
    } else {
      viewAllListingBookTitle.value = '';
      log("Book Screen Title: ${viewAllListingBookTitle.value}, Hence Cleared");
    }

    // isDataNotFound = false.obs;
  }
}
