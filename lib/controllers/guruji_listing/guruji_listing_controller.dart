import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/guruji_listing/guruji_listing_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/guruji_listing/guruji_listing_service.dart';
import '../../services/home/home_service.dart';
import '../../utils/utils.dart';

class GurujiListingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GurujiListingService gurujiListingService = GurujiListingService();
  final HomeCollectionService homeCollectionService = HomeCollectionService();
  final bottomAppBarService = Get.find<BottomAppBarServices>();
  var searchController = TextEditingController();

  RxString gurujiApiCallType = ''.obs;

  RxBool isLoadingData = false.obs;

  RxList<Result> gurujiListing = <Result>[].obs;
  RxInt totalGurujis = 0.obs;

  RxString? checkItem = "".obs;
  var searchQuery = "".obs;
  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 10;
  RxBool isDataNotFound = false.obs;

  var prevScreen = "".obs;
  var collectionId = "".obs;
  var collectionType = "".obs;

  var viewAllListingGurujiTitle = "".obs;

  late TabController tabController;
  RxString controllerText = "".obs;
  @override
  void onInit() {
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
          "bottomAppBarService.isCustomSearchBarNewDisposed.value:${bottomAppBarService.isCustomSearchBarNewDisposed.value}");
      if (bottomAppBarService.isCustomSearchBarNewDisposed.value == false) {
        Utils().showLoader();
        clearGurujiListing();
        prevScreen.value == "homeCollection"
            ? await fetchGurujiHomeViewAllListing(
                collectionArtsitId: collectionId.toString(),
                body: {"query": searchController.text})
            : prevScreen.value == "homeCollectionMultipleType"
                ? fetchGurujiHomeMultipleListing(
                    id: collectionId.value,
                    type: "Multiple",
                    body: {"query": searchController.text})
                : await fetchGurujiListing(
                    token: Get.find<BottomAppBarServices>().token.value,
                    body: {"query": searchController.text});
        Get.back();
      }
    }, time: const Duration(seconds: 2));
  }

  Future<void> fetchGurujiListing(
      {String? token, BuildContext? ctx, Map<String, String>? body}) async {
    log('gurujiListing = $gurujiListing');
    isLoadingData.value = true;
    log(prevScreen.value);
    final response = await gurujiListingService.gurujiListingApi(
        token: bottomAppBarService.token.value);
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
          isLoadingData.value = false;
          log('success is 0');
          if (pageNo.value == 1 && gurujiListing.isEmpty) {
            isDataNotFound.value = true;
          }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else {
          final gurujisListingModel =
              gurujisListingModelFromJson(response.body);

          gurujiListing.addAll(gurujisListingModel.data!.result!);
          if (gurujiListing.isNotEmpty) {
            totalGurujis.value = gurujisListingModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("guruji listing result = ${gurujiListing.first.toString()}");

            log('total gurujis value---> ${totalGurujis.value}');
            log('gurujiList length----> ${gurujiListing.length}');
          }

          pageNo.value++;

          isLoadingData.value = false;
          isDataNotFound.value = false;
        }
      }
    }
  }

  Future<void> fetchGurujiHomeViewAllListing(
      {String? token,
      BuildContext? ctx,
      Map<String, String>? body,
      required String collectionArtsitId}) async {
    log('gurujiListing = $gurujiListing');
    isLoadingData.value = true;

    log("CollectionArtistId = $collectionArtsitId");
    log(prevScreen.value);
    final response = await homeCollectionService.homeCollectionViewAllApi(
        collectionId: collectionArtsitId, body: body);
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
        var mapdata = jsonDecode(
            response.body.toString());

        if (mapdata['success'] == 0) {
          // Get.back();
          isLoadingData.value = false;
          log('success is 0');
          if (pageNo.value == 1 && gurujiListing.isEmpty) {
            isDataNotFound.value = true;
          }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else {
          final gurujisListingModel =
              gurujisListingModelFromJson(response.body);

          checkItem!.value = mapdata['message'];
          gurujiListing.addAll(gurujisListingModel.data!.result!);
          if (gurujiListing.isNotEmpty) {
            totalGurujis.value = gurujisListingModel.data!.totalCount!;

            log('item message = $checkItem');
            log("guruji listing result = ${gurujiListing.first.toString()}");

            log('total gurujis value---> ${totalGurujis.value}');
            log('gurujiList length----> ${gurujiListing.length}');
          }

          pageNo.value++;

          isLoadingData.value = false;
          isDataNotFound.value = false;
        }
      }
    }
  }

  Future<void> fetchGurujiHomeMultipleListing(
      {String? token,
      BuildContext? ctx,
      required String type,
      required String id,
      Map<String, String>? body}) async {
    log('gurujiListing = $gurujiListing');
    log(prevScreen.value);
    isLoadingData.value = true;
    log("inside multiple guruji");
    final response =
        await homeCollectionService.homeCollectionListingMultipleApi(
            type: type, id: id.toString(), body: body);
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
          isLoadingData.value = false;
          log('success is 0');
          if (pageNo.value == 1 && gurujiListing.isEmpty) {
            isDataNotFound.value = true;
          }

          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else {
          final gurujisListingModel =
              gurujisListingModelFromJson(response.body);

          gurujiListing.addAll(gurujisListingModel.data!.result!);
          if (gurujiListing.isNotEmpty) {
            totalGurujis.value = gurujisListingModel.data!.totalCount!;
            checkItem!.value = mapdata['message'];

            log('item message = $checkItem');
            log("guruji listing result = ${gurujiListing.first.toString()}");

            log('total gurujis value---> ${totalGurujis.value}');
            log('gurujiList length----> ${gurujiListing.length}');
          }

          pageNo.value++;

          isLoadingData.value = false;
          isDataNotFound.value = false;
        }
      }
    }
  }

  clearGurujiListing() {
    gurujiListing.clear();
    isLoadingData.value = false;
    pageNo = 1.obs;
    viewAllListingGurujiTitle.value = '';
    // isDataNotFound = false.obs;
  }
}
