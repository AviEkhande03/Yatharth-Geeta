import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/constants/constants.dart';
import '../../models/event/event_model.dart';
import '../../models/events_listing/events_listing_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/events_listing/events_listing_service.dart';
import '../../utils/utils.dart';

//Events listing controller that holds API methods and event related states
class EventsListingController extends GetxController
    with GetTickerProviderStateMixin {
  //var searchQuery = "".obs;
  RxBool isLoadingForStart = true.obs;
  RxList<ListElement> pastEventsList = <ListElement>[].obs;
  TextEditingController searchController = TextEditingController();
  RxString controllerText = "".obs;
  late AnimationController animation_controller;
  RxBool checkRefresh = false.obs;

  //Pull to refresh
  RxBool eventsListingCollectionZeroFlag = false.obs;
  RxBool isEventsListingRefreshing = false.obs;

  EventsListingController() {
    animation_controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
  }

  @override
  void onInit() async {
    super.onInit();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        controllerText.value = searchController.text;
      }
    });
    debounce(controllerText, (callback) async {
      debugPrint("searchQuery.value:${searchController.text}");

      Utils().showLoader();
      //Clears the event list
      clearEventsList();

      //this is the api call made by the debounce method when then user searches in the text field for events
      await fetchEventsListing(
          token: Get.find<BottomAppBarServices>().token.value,
          body: {"query": searchController.text});
      Get.back();

      //To exit the onscreen keyboard(this avoids pagination for single object)
      FocusScope.of(Get.context!).unfocus();
    }, time: const Duration(seconds: 2));
  }

  // @override
  // Future<void> onReady() async {
  //   super.onReady();
  //   if (eventsListing.value != null || eventsListing.value == Result()) {
  //     await fetchEventsListing();
  //     isLoadingForStart.value = false;
  //   }
  // }

  final EventsListingService eventsListingService = EventsListingService();

  RxBool isLoadingData = false.obs;

  // RxResult<Result> eventsListing = <Result>[].obs;
  Rx<Result?> eventsListing = Result().obs;
  RxInt totalEvents = 0.obs;

  RxString? checkItem = "".obs;

  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 5;
  RxBool isPastDataNotFound = false.obs;
  RxBool isNoDataLoading = false.obs;
  //RxInt showedPastEvents = 0.obs;
  RxInt totalPastEvents = 0.obs;

  List<Map> languageList = [];
  List<Map> authorsList = [];
  List<Map> typeList = [];
  var sortList = [];

  Future<void> fetchEventsListing(
      {String? token, BuildContext? ctx, Map<String, String>? body}) async {
    log('eventslisting = $eventsListing');
    isLoadingData.value = true;

    // Utils().showLoader();

    final response = await eventsListingService.eventsListingApi(
        token: Get.find<BottomAppBarServices>().token.value,
        pageNo: pageNo.value.toString(),
        limit: limit.toString(),
        body: body ?? {});
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
        isPastDataNotFound.value = true;
        isNoDataLoading.value = true;
        isLoadingData.value = false;
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
        isPastDataNotFound.value = true;
        isNoDataLoading.value = true;
        isLoadingData.value = false;
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // Get.back();
          isLoadingData.value = false;
          if (pageNo.value == 1 && pastEventsList.isEmpty) {
            isPastDataNotFound.value = true;
            isNoDataLoading.value = true;
          }
          log('success is 0');
        } else {
          final eventsListingModel = eventsListingModelFromJson(response.body);

          eventsListing.value = eventsListingModel.data!.result;

          //showedPastEvents.value = eventsListingModel.data!.result!.pastEvents!.list!.length;

          pastEventsList
              .addAll(eventsListingModel.data!.result!.pastEvents!.list!);

          if (eventsListingModel.data!.result!.pastEvents!.list!.isNotEmpty) {
            totalPastEvents.value =
                eventsListingModel.data!.result!.pastEvents!.totalCount!;

            eventsListingCollectionZeroFlag.value = false;
          } else {
            eventsListingCollectionZeroFlag.value = true;
          }

          checkItem!.value = mapdata['message'];

          log('event item message = $checkItem');

          pageNo.value++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;
          isPastDataNotFound.value = false;

          // Get.back();

          //   eventsListing.addAll(eventsListingModel.data!.result!);
          //   totalEvents.value = eventsListingModel.data!.totalCount!;
          //   checkItem!.value = mapdata['message'];

          //   log('item message = $checkItem');
          //   log("events listing result = ${eventsListing.first.toString()}");

          //   pageNo.value++;
          //   log('total events value---> ${totalEvents.value}');
          //   log('eventsList length----> ${eventsListing.length}');
          //   isLoadingData.value = false;
          //   isPastDataNotFound.value = false;
          //
        }

        checkRefresh.value = false;
      }
    }
  }

  @override
  void dispose() {
    animation_controller.dispose();
    super.dispose();
  }

  //Clears the event listing data and resets the states related to it
  clearEventsList() {
    // eventsListing.clear();
    eventsListingCollectionZeroFlag.value = false;
    pastEventsList.clear();
    isLoadingData.value = false;
    pageNo = 1.obs;
    isPastDataNotFound = false.obs;
  }

  final List<EventModel> dummyyEventsList = [
    EventModel(
      eventHeading: 'Upcoming Events'.tr,
      eventsList: [
        Event(
          eventBgImgUrl: 'assets/images/events/eventbg1.png',
          eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
          eventGurujiName: 'Swami Adgadanand Maharaj',
          eventName: 'Guru Purnima Event',
          eventTimings: '7 am - 10 am',
          eventDate: '20th August 2023',
          eventDescription: Constants.eventDummyDesc,
        ),
      ],
    ),
    EventModel(
      eventHeading: 'Past events'.tr,
      eventsList: [
        Event(
          eventBgImgUrl: 'assets/images/events/eventbg2.png',
          eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
          eventGurujiName: 'Swami Adgadanand Maharaj',
          eventName: 'Guru Purnima Event',
          eventTimings: '7 am - 10 am',
          eventDate: '20th August 2023',
          eventDescription: Constants.eventDummyDesc,
        ),
        Event(
          eventBgImgUrl: 'assets/images/events/eventbg3.png',
          eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
          eventGurujiName: 'Swami Adgadanand Maharaj',
          eventName: 'Guru Purnima Event',
          eventTimings: '7 am - 10 am',
          eventDate: '20th August 2023',
          eventDescription: Constants.eventDummyDesc,
        ),
        Event(
          eventBgImgUrl: 'assets/images/events/eventbg4.png',
          eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
          eventGurujiName: 'Swami Adgadanand Maharaj',
          eventName: 'Guru Purnima Event',
          eventTimings: '7 am - 10 am',
          eventDate: '20th August 2023',
          eventDescription: Constants.eventDummyDesc,
        ),
        Event(
          eventBgImgUrl: 'assets/images/events/eventbg5.png',
          eventGurujiImgUrl: 'assets/images/events/event_guruji.png',
          eventGurujiName: 'Swami Adgadanand Maharaj',
          eventName: 'Guru Purnima Event',
          eventTimings: '7 am - 10 am',
          eventDate: '20th August 2023',
          eventDescription: Constants.eventDummyDesc,
        ),
      ],
    ),
  ];
}
