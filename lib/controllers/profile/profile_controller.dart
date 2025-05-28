import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../startup/startup_controller.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/notification_status/notification_status_service.dart';
import '../../services/profile/profile_service.dart';
import 'package:http/http.dart' as http;
import '../../const/colors/colors.dart';
import '../../models/profile/profile_model.dart';
import '../../utils/utils.dart';
import '../logout/logout_controller.dart';

class ProfileController extends GetxController {
  RxBool isToggleOn = true.obs;
  RxBool isPersonalVisible = false.obs;
  RxBool isOthersVisible = false.obs;
  RxBool isActionsVisible = false.obs;
  RxBool isGuestUser = false.obs;
  RxBool isLoading = false.obs;
  RxString appVersion = ''.obs;
  var profileData = <ProfileModel>{}.obs;
  final bottomAppService = Get.find<BottomAppBarServices>();
  final startUpController = Get.find<StartupController>();
  final notificationStatusService = NotificationStatusService();
  final profileService = ProfileService();
  final startUpApiController = Get.find<StartupController>();

  @override
  void onInit() async {
    super.onInit();
    debugPrint("Inside onInit profile");
    //Checking if the user is a guest user or not
    isGuestUser.value = await Utils.isGuestUser();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: kColorWhite));

    //kept three maps for personal,others and actions as these keys can have values as true or false and accordingly the sections are made visible or not
    Map<String, dynamic> personal = startUpApiController
        .startupData.first.data!.result!.screens!.meData!.personal!
        .toJson();
    Map<String, dynamic> others = startUpApiController
        .startupData.first.data!.result!.screens!.meData!.others!
        .toJson();
    Map<String, dynamic> actions = startUpApiController
        .startupData.first.data!.result!.screens!.meData!.action!
        .toJson();

    //Checking if any of the personal sections keys have value true or not if any of them is true making isPersonalVisible.value as true
    for (var v in personal.values) {
      if (v == true) {
        isPersonalVisible.value = true;
        break;
      }
    }
    //Checking if any of the others sections keys have value true or not if any of them is true making isOthersVisible.value as true
    for (var v in others.values) {
      if (v == true) {
        isOthersVisible.value = true;
        break;
      }
    }
    //Checking if any of the actions sections keys have value true or not if any of them is true making isActionsVisible.value as true
    for (var v in actions.values) {
      if (v == true) {
        isActionsVisible.value = true;
        break;
      }
    }
    debugPrint("isPersonalVisible.value:${isPersonalVisible.value}");
    debugPrint("isOthersVisible.value:${isOthersVisible.value}");
    debugPrint("isActionsVisible.value:${isActionsVisible.value}");
  }

  @override
  void onReady() async {
    debugPrint("Inside onReady profile");
    super.onReady();
    //Method called for getting the notification status as we need to set the notification toggle accordingly
    await getNotificationStatus();

    //Method called to get the app version as we need to show app version below in the profile section
    await getAppVersion();
    debugPrint("Profile token onReady:${bottomAppService.token.value}");
    if (bottomAppService.token.value != '') {
      //debugPrint("Inside onReady token found");
      //Utils().showLoader();

      //If token is not null i.e. get the profile data from below method
      await getProfile(bottomAppService.token.value);
      isLoading.value = false;
    }
  }

  Future<void> getProfile(token) async {
    //Called getProfileData() method with token value from profileService
    final response = await profileService.getProfileData(token);
    isLoading.value = true;
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        //Get.back();
        //Loading.stop();
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        //Get.back();
        // Loading.stop();
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          debugPrint(mapdata.toString());
          if (mapdata['message'].runtimeType == List<dynamic>) {
            mapdata['message'].forEach((str) {
              Utils.customToast(
                  str, kRedColor, kRedColor.withOpacity(0.2), "Error");
            });
          } else {
            Utils.customToast(mapdata['message'], kRedColor,
                kRedColor.withOpacity(0.2), "Error");
          }
          //Get.back();
          // Loading.stop();
          // Utils.customToast(
          //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2),
          //     "Error");
        } else if (mapdata['success'] == 4) {
          debugPrint("Success 4");
          Utils().showLoader();
          // await Future.delayed(const Duration(seconds: 10));
          Utils.customToast(mapdata['message'], kRedColor,
              kRedColor.withOpacity(0.2), "Error");
          Utils.deleteToken();
          Utils.deleteNotificationStatus();
          await Get.find<LogOutController>().logOutUser();
        } else if (mapdata['success'] == 1) {
          profileData.clear();
          debugPrint("profile data"+mapdata.toString());
          //Get.back();
          final profileModel = profileModelFromJson(response.body.toString());
          profileData.addAll({profileModel});
          print(
              "data:${startUpController.startupData.first.data!.result!.loginWith}");
        }
      }
    }
  }

  //Method to update the notification status on the server ,called when notification toggle is toggled
  Future<void> updateNotificationStatus(bool status) async {
    final response = await notificationStatusService.updateNotificationStatus(
        bottomAppService.token.value, status);
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          print(mapdata);
          Get.back();
          if (mapdata['message'].runtimeType == List<dynamic>) {
            mapdata['message'].forEach((str) {
              Utils.customToast(
                  str, kRedColor, kRedColor.withOpacity(0.2), "Error");
            });
          } else {
            Utils.customToast(mapdata['message'], kRedColor,
                kRedColor.withOpacity(0.2), "Error");
          }
        } else if (mapdata['success'] == 4) {
          debugPrint("Success 4");
          Utils.customToast(mapdata['message'], kRedColor,
              kRedColor.withOpacity(0.2), "Error");
          Utils().showLoader();
          Utils.deleteToken();
          Utils.deleteNotificationStatus();
          await Get.find<LogOutController>().logOutUser();
        } else if (mapdata['success'] == 1) {
          print(mapdata);
          Get.back();
          Utils.customToast(mapdata['message'], kGreenPopUpColor,
              kGreenPopUpColor.withOpacity(0.2), "Success");
        }
      }
    }
  }

  //Method to get the Notification status
  getNotificationStatus() async {
    isToggleOn.value = await Utils.getNotificationStatus();
    debugPrint('isToggleBtnEnabled--->${isToggleOn.value}');
  }

  //Resetting the values in dispose()
  @override
  void dispose() {
    debugPrint("Inside dispose profile");
    isPersonalVisible.value = false;
    isOthersVisible.value = false;
    isActionsVisible.value = false;
    isGuestUser.value = false;
    super.dispose();
  }

  //Method nto get the app version
  getAppVersion() async {
    appVersion.value = await Utils().getAppVersion();
    debugPrint('appVersion.value--->${appVersion.value}');
  }
}
