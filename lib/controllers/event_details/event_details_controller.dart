import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yatharthageeta/models/event_details/event_details_model.dart'
    as event;
import 'package:yatharthageeta/services/event_details/event_details_service.dart';

import '../../const/constants/constants.dart';
import '../../models/event/event_model.dart';

//Event details controller that holds events details related states and API method
class EventDetailsController extends GetxController
    with GetTickerProviderStateMixin {
  final EventDetailsService eventDetailsService = EventDetailsService();

  //Event details states
  Rx<event.Result?> eventDetails = event.Result().obs;

  //To check is the data has loaded or still loading
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;

  RxString? checkItem = "".obs;

//Event Details API method, (This mthods takes eventId: 1 as a parameter)
  Future<void> fetchEventDetails({
    String? token,
    BuildContext? ctx,
    required eventId,
  }) async {
    log('eventdDetails = $eventDetails');
    isLoadingData.value = true;

    final response =
        await eventDetailsService.eventDetailsApi(eventId: eventId);
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
          isLoadingData.value = false;
          print('success is 0');

          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final eventDetailsModel =
              event.eventDetailsModelFromJson(response.body);

          eventDetails.value = eventDetailsModel.data!.result;

          checkItem!.value = mapdata['message'];

          log('event item message = $checkItem');

          isLoadingData.value = false;
        }
      }
    }
  }

//Clears up the event details data when no longer needed/user exits the screen
  clearEbookDetailsData() {
    isLoadingData.value = false;
    isDataNotFound = false.obs;
  }

  @override
  void onClose() {
    super.onClose();
    isLoadingData.value = false;
    isDataNotFound = false.obs;
  }

  final EventDetails dummyEventDetail = EventDetails(
    eventBgImgUrl: 'assets/images/events/event_detail_img.png',
    eventName: 'Gurupurnima Event',
    eventOrganizer: 'Swami Adgadanand Maharaj',
    eventBrief: Constants.eventBrief,
    aboutEvent: Constants.eventDummyAbout,
    eventTimings: '7 am to 10 am',
    eventDate: '20th August 2023',
    eventLocation: 'Chalisgaon, Maharashtra',
    eventMapImgUrl: 'assets/images/map.png',
  );
  createCoordinatedUrl(String latitude, String longitude, String? label) {
    Uri uri;
    if (Platform.isAndroid) {
      var query = '$latitude,$longitude';

      if (label != null) query += '($label)';

      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      var params = {
        'll': '$latitude,$longitude',
        'q': label ?? '$latitude, $longitude',
      };

      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    }
    return uri;
  }
}
