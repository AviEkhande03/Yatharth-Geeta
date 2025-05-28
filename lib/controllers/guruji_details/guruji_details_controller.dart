import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/events_listing/events_listing_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/guruji_details/guruji_details_service.dart';
import 'package:http/http.dart' as http;
import '../../models/guruji_details/guruji_details_model.dart';
import '../../services/events_listing/events_listing_service.dart';

class GurujiDetailsController extends GetxController {
  var currentIndex = 0.obs;
  var readMore = false.obs;
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;
  RxBool isEventsLoadingData = false.obs;
  RxBool isEventsDataNotFound = false.obs;
  RxString selectedAshramTab = 'About'.obs;
  RxList<ListElement> pastEventsList = <ListElement>[].obs;
  // EventsListingController eventController = Get.find<EventsListingController>();
  final gurujiDetilsService = GurujiDetailsService();
  final eventListingService = EventsListingService();
  final bottomAppService = Get.find<BottomAppBarServices>();
  RxString? checkItem = "".obs;
  var gurujiDetails = <GurujiDetailsModel>{}.obs;
  var gurujiEvents = <EventsListingModel>{}.obs;

  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 5;
  // RxBool isPastDataNotFound = false.obs;
  // RxBool isNoDataLoading = false.obs;
  // RxInt totalPastEvents = 0.obs;

  Future<void> fetchGurujiDetails({required String id}) async {
    debugPrint("Inside fetchGurujiDetails");
    final response = await gurujiDetilsService.fetchGurujiDetails(
        bottomAppService.token.value, id.toString());
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          debugPrint(mapdata.toString());
          isLoadingData.value = false;
          isDataNotFound.value = true;
        } else {
          gurujiDetails.clear();
          log(mapdata.toString());
          final gurujiDetailsModel =
              gurujiDetailsModelFromJson(response.body.toString());
          gurujiDetails.addAll({gurujiDetailsModel});
          isLoadingData.value = false;
          isDataNotFound.value = false;
        }
      }
    }
  }

  Future<void> fetchGurujiHomeDetails(
      {String? token, required artistId, required type}) async {
    debugPrint("Inside fetchGurujiHomeDetails ");
    final response = await gurujiDetilsService.fetchGurujiHomeDetails(
      token: bottomAppService.token.value,
      artistId: artistId.toString(),
      type: type,
    );
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          debugPrint(mapdata.toString());
          isLoadingData.value = false;
          isDataNotFound.value = true;
        } else {
          gurujiDetails.clear();
          log(mapdata.toString());
          final gurujiDetailsModel =
              gurujiDetailsModelFromJson(response.body.toString());
          gurujiDetails.addAll({gurujiDetailsModel});
          isLoadingData.value = false;
          isDataNotFound.value = false;
        }
      }
    }
  }

  Future<void> fetchGurujiEvents(id) async {
    debugPrint("Inside fetchGurujiEvents");
    gurujiEvents.clear();
    //isEventsLoadingData.value = true;
    final response = await eventListingService.eventsListingApi(
        token: bottomAppService.token.value,
        pageNo: pageNo.value.toString(),
        limit: limit.toString(),
        body: {"artist_id": id.toString()});
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        // isPastDataNotFound.value = true;
        // isNoDataLoading.value = true;
        isEventsLoadingData.value = false;
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        // isPastDataNotFound.value = true;
        // isNoDataLoading.value = true;
        isEventsLoadingData.value = false;
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          debugPrint(mapdata.toString());
          isEventsLoadingData.value = false;
          if (pageNo.value == 1 && pastEventsList.isEmpty) {
            // isPastDataNotFound.value = true;
            // isNoDataLoading.value = true;
          }
        } else {
          // gurujiEvents.clear();
          debugPrint(mapdata.toString());
          checkItem!.value = mapdata['message'];
          final gurujiEventsModel =
              eventsListingModelFromJson(response.body.toString());
          gurujiEvents.addAll({gurujiEventsModel});

          pastEventsList
              .addAll(gurujiEventsModel.data!.result!.pastEvents!.list!);

          isEventsDataNotFound.value = false;

          // if (gurujiEventsModel.data!.result!.pastEvents!.list!.isNotEmpty) {
          //   totalPastEvents.value = gurujiEventsModel.data!.result!.pastEvents!.totalCount!;
          // }
          //
          // debugPrint("Total Length:${totalPastEvents.value}");
          // debugPrint("PastEvents Length:${pastEventsList.length}");

          //pageNo.value++;
          isEventsLoadingData.value = false;
          // isNoDataLoading.value = false;
          // isPastDataNotFound.value = false;
        }
      }
    }
  }

  clearGurujiDetails() {
    pageNo.value = 0;
    gurujiDetails.clear();
    gurujiEvents.clear();
    pastEventsList.clear();
    selectedAshramTab.value = 'About';
    // totalPastEvents.value = 0;
    currentIndex.value = 0;
    readMore.value = false;
    isLoadingData.value = false;
    isDataNotFound.value = false;
    isEventsLoadingData.value = false;
    isEventsDataNotFound.value = false;
  }

  @override
  void dispose() {
    debugPrint("onDispose in guruji");
    pageNo.value = 0;
    //totalPastEvents.value = 0;
    isLoadingData.value = false;
    isDataNotFound.value = false;
    isEventsLoadingData.value = false;
    isEventsDataNotFound.value = false;
    // isNoDataLoading.value = false;
    // isPastDataNotFound.value = false;
    super.dispose();
  }

  // final List<EventModel> dummyyEventsList = [
  //   EventModel(
  //     eventHeading: 'Upcoming Events',
  //     eventsList: [
  //       Event(
  //         eventBgImgUrl: 'assets/images/events/eventbg1.png',
  //         eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
  //         eventGurujiName: 'Swami Adgadanand Maharaj',
  //         eventName: 'Guru Purnima Event',
  //         eventTimings: '7 am - 10 am',
  //         eventDate: '20th August 2023',
  //         eventDescription: Constants.eventDummyDesc,
  //       ),
  //     ],
  //   ),
  //   EventModel(
  //     eventHeading: 'Past events',
  //     eventsList: [
  //       Event(
  //         eventBgImgUrl: 'assets/images/events/eventbg2.png',
  //         eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
  //         eventGurujiName: 'Swami Adgadanand Maharaj',
  //         eventName: 'Guru Purnima Event',
  //         eventTimings: '7 am - 10 am',
  //         eventDate: '20th August 2023',
  //         eventDescription: Constants.eventDummyDesc,
  //       ),
  //       Event(
  //         eventBgImgUrl: 'assets/images/events/eventbg3.png',
  //         eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
  //         eventGurujiName: 'Swami Adgadanand Maharaj',
  //         eventName: 'Guru Purnima Event',
  //         eventTimings: '7 am - 10 am',
  //         eventDate: '20th August 2023',
  //         eventDescription: Constants.eventDummyDesc,
  //       ),
  //       Event(
  //         eventBgImgUrl: 'assets/images/events/eventbg4.png',
  //         eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
  //         eventGurujiName: 'Swami Adgadanand Maharaj',
  //         eventName: 'Guru Purnima Event',
  //         eventTimings: '7 am - 10 am',
  //         eventDate: '20th August 2023',
  //         eventDescription: Constants.eventDummyDesc,
  //       ),
  //       Event(
  //         eventBgImgUrl: 'assets/images/events/eventbg5.png',
  //         eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
  //         eventGurujiName: 'Swami Adgadanand Maharaj',
  //         eventName: 'Guru Purnima Event',
  //         eventTimings: '7 am - 10 am',
  //         eventDate: '20th August 2023',
  //         eventDescription: Constants.eventDummyDesc,
  //       ),
  //     ],
  //   ),
  // ];
}
