import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/notification/notificatin_listing_service.dart';
import 'package:http/http.dart' as http;
import '../../const/colors/colors.dart';
import '../../models/notification/notification_model.dart' as notification;
import '../../utils/utils.dart';
import '../logout/logout_controller.dart';

class NotificationController extends GetxController  with GetTickerProviderStateMixin{
  /*RxList<NotificationItemModel> notificationListForToday = [
    NotificationItemModel(
        assetPath: "assets/icons/music_for_notification.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in Audios"),
    NotificationItemModel(
        assetPath: "assets/icons/book-opened.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in E Books"),
    NotificationItemModel(
        assetPath: "assets/icons/film.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in Videos"),
    NotificationItemModel(
        assetPath: "assets/icons/horn.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in Audios"),
  ].obs;*/

  /*RxList<NotificationItemModel> notificationListYesterday = [
    NotificationItemModel(
        assetPath: "assets/icons/music_for_notification.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in Audios"),
    NotificationItemModel(
        assetPath: "assets/icons/book-opened.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in E books"),
    NotificationItemModel(
        assetPath: "assets/icons/film.svg",
        titleText: "“Guru Purnima Event”",
        subText: "   is to be held on 21st July 2023"),
    NotificationItemModel(
        assetPath: "assets/icons/horn.svg",
        titleText: "“Guru Purnima Event”",
        subText: "   is to be held on 21st July 2023"),
    NotificationItemModel(
        assetPath: "assets/icons/film.svg",
        titleText: "“Guru Purnima Event”",
        subText: "   is to be held on 21st July 2023")
  ].obs;

  RxList<NotificationItemModel> notificationListFor18July = [
    NotificationItemModel(
        assetPath: "assets/icons/music_for_notification.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in Audios"),
    NotificationItemModel(
        assetPath: "assets/icons/book-opened.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in Audios"),
    NotificationItemModel(
        assetPath: "assets/icons/film.svg",
        titleText: "“Srimad Bhagwad Gita Padhchhed”",
        subText: "  is available now in Audios"),
    NotificationItemModel(
        assetPath: "assets/icons/horn.svg",
        titleText: "“Guru Purnima Event”",
        subText: "   is to be held on 21st July 2023"),
  ].obs;*/

  //late RxList<DayWiseNotificationModel> dayWiseNotificationList;
  RxInt pageNo = 1.obs;
  final limit = 12;
  RxBool isLoadingData = false.obs;
  RxBool isNoDataLoading = false.obs;
  RxBool isDataNotFound = false.obs;
  //RxBool checkRefresh = false.obs;
  RxInt totalNotifications = 0.obs;
  RxInt showedNotifications = 0.obs;
  RxList<notification.Result> notificationList = <notification.Result>[].obs;
  final notificationService = NotificationListingService();
  late AnimationController animation_controller;
  RxString? checkItem = "".obs;

  // @override
  // void onInit() {
  //   super.onInit();
  /*dayWiseNotificationList = [
      DayWiseNotificationModel(
          date: "Today", dayWiseNotificationList: notificationListForToday),
      DayWiseNotificationModel(
          date: "Yesterday",
          dayWiseNotificationList: notificationListYesterday),
      DayWiseNotificationModel(
          date: "18th July 2023",
          dayWiseNotificationList: notificationListFor18July),
    ].obs;*/
  // }

  NotificationController(){
    //Animation controller for pagination loader
    animation_controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
  }

  @override
  void dispose() {
    //disposing animation controller
    animation_controller.dispose();
    super.dispose();
  }

  //Method for fetching notifications listing
  Future<void> fetchNotifications() async {
    //setting isLoadingData.value to true as fetching has started
    isLoadingData.value = true;
    //Calling fetchNotificationListing() of notificationService,takes 3 parameters
    //1.token
    //2.page Number
    //3.limit
    final response = await notificationService.fetchNotificationListing(
        Get.find<BottomAppBarServices>().token.value,
        pageNo.value.toString(),
        limit.toString());
    if (response == " ") {
    } else if (response is http.Response) {
      //If response is 404 then back() closes the loader and show the error toast
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        isDataNotFound.value = true;
        isNoDataLoading.value = true;
        isLoadingData.value = false;
        //Get.back();
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      }
      //If response is 500 then back() closes the loader and show the error toast
      else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        isDataNotFound.value = true;
        isNoDataLoading.value = true;
        isLoadingData.value = false;
        //Get.back();
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      }
      else if (response.statusCode == 200) {
        //If status is 200 i.e OK then
        //jsonDecode() records data into mapdata
        Map mapdata = jsonDecode(response.body.toString());
        //If success is 0 then make the isLoadingData to false
        if (mapdata['success'] == 0) {
          debugPrint(mapdata.toString());
          isLoadingData.value = false;
          if (pageNo.value == 1 && notificationList.isEmpty) {
            isDataNotFound.value = true;
            isNoDataLoading.value = true;
          }
          //As success code is o there might be list pof validation errors, so checking if message parameter's type is list then iterate through it and toast out the messages.
          if (mapdata['message'].runtimeType == List<dynamic>) {
            mapdata['message'].forEach((str) {
              Utils.customToast(
                  str, kRedColor, kRedColor.withOpacity(0.2), "Error");
            });
          }
          //Else if it's simply a message simply show it out via toast
          else {
            Utils.customToast(mapdata['message'], kRedColor,
                kRedColor.withOpacity(0.2), "Error");
          }
          //Get.back();
          // Utils.customToast(
          //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2),
          //     "Error");
        }
        //If success code is 4 then show loader,delete token as user will be logged out,also notification status will be reset and then logout api will be called
        else if (mapdata['success'] == 4) {
          //Get.back();
          isDataNotFound.value = true;
          isNoDataLoading.value = true;
          isLoadingData.value = false;
          debugPrint("Success 4");
          Utils().showLoader();
          // await Future.delayed(const Duration(seconds: 10));
          Utils.customToast(mapdata['message'], kRedColor,
              kRedColor.withOpacity(0.2), "Error");
          Utils.deleteToken();
          Utils.deleteNotificationStatus();
          await Get.find<LogOutController>().logOutUser();
        }
        //Else idf success code is 1 then
        else if (mapdata['success'] == 1) {
          debugPrint(mapdata.toString());
          //Get.back();

          //Converting json data to model
          final notificationModel =
              notification.notificationModelFromJson(response.body.toString());
          debugPrint("Notification List:${notificationModel.data!.result!}");

          //keeping a track of showed notifications
          for (var n in notificationModel.data!.result!) {
            showedNotifications.value += n.value!.length;
          }
          //Storing the message coming from backend
          checkItem!.value = mapdata['message'];

          //Checking if the notification list is empty or not, if it's not empty then getting its last element and getting the first element from the model after api call
          //If date of both the entries are same that means entries of same date are in the model ,so added all the entries of the model to notification list
          //Then removing the first element of the model as it's entries are added in the list and then adding all the entries of the model to list
          //For better understanding refer the results from print statements
          if (notificationList.isNotEmpty) {
            var lastData = notificationList[notificationList.length - 1];
            debugPrint("lastData:${lastData.date} ${lastData.value}");
            var firstData = notificationModel.data!.result![0];
            debugPrint("firstData:${firstData.date} ${firstData.value}");
            if (lastData.date == firstData.date) {
              notificationList[notificationList.length - 1]
                  .value!
                  .addAll(firstData.value as Iterable<notification.Value>);
              debugPrint(
                  "Added values:${notificationList[notificationList.length - 1].value!}");
              notificationModel.data!.result!.removeAt(0);
              debugPrint("After removal:${notificationModel.data!.result!}");
              notificationList.addAll(notificationModel.data!.result!);
            } else {
              notificationList.addAll(notificationModel.data!.result!);
            }
          }
          //If there are no notifications in notificationList add the response from model into notification list
          else {
            notificationList.addAll(notificationModel.data!.result!);
          }

          //Maintaining the total count of notifications from notification model if notification list is not empty
          if (notificationList.isNotEmpty) {
            totalNotifications.value = notificationModel.data!.totalCount!;
          }

          //Increasing pageNo for maintaining pagination count
          pageNo.value++;
          isLoadingData.value = false;
          isNoDataLoading.value = false;
          isDataNotFound.value = false;
        }
        //checkRefresh.value = false;
      }
    }
  }

  //Function for clearing notification list from api and resetting the values.
  clearNotificationList() {
    //clear the notification list
    notificationList.clear();
    isLoadingData.value = false;
    pageNo = 1.obs;
    isDataNotFound = false.obs;
    totalNotifications.value = 0;
    showedNotifications.value = 0;
  }
}
