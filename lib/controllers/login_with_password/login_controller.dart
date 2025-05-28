import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../const/colors/colors.dart';
import '../../routes/app_route.dart';
import '../../services/firebase/firebase_cloud_messaging.dart';
import '../../services/login_with_password/login_with_password_service.dart';
import '../../utils/utils.dart';
import '../../utils/validations_mixin.dart';
import '../startup/startup_controller.dart';
import '../audio_player/player_controller.dart';

class LoginController extends GetxController with ValidationsMixin {
  RxBool isPassWordDisabled = true.obs;
  RxString? phoneValidation = ''.obs;
  RxString? passwordValidation = ''.obs;
  RxBool isGuestUser = false.obs;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final loginWithPasswordService = LoginWithPasswordService();
  final startupController = Get.find<StartupController>();

  bool validateLogin() {
    phoneValidation?.value = validatedPhoneNumber(phone.value.text, 10) ?? '';
    passwordValidation?.value = validatedPassword(password.value.text) ?? '';
    if (phoneValidation?.value != '') {
      return false;
    } else if (passwordValidation?.value != '') {
      return false;
    } else {
      return true;
    }
  }

  void validate() {
    bool isValidated = validateLogin();
    if (isValidated) {
      Utils().showLoader();
      loginWithPassword();
    }
  }

  Future<void> loginWithPassword() async {
    final response = await loginWithPasswordService.loginUserWithPassword(
        phone.text.toString(),
        password.text.toString(),
        FirebaseCloudMessaging.fcmToken.toString());
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
        } else {
          print(mapdata);
          debugPrint(
              '----Token Login---> ${mapdata['data']['result']['remember_token']}');
          Utils.saveToken(mapdata['data']['result']['remember_token']);
          //await startUpController.fetchStartupData();
          if (await Utils.isGuestUser()) {
            Utils.setGuestUser(false);
          }
          startupController.startupData.first.data!.result!.screens!.meData!
                  .personal!.myPlayedList =
              mapdata['data']['result']['me_data']['Personal']
                  ['My Played List'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .personal!.likedList =
              mapdata['data']['result']['me_data']['Personal']['Liked List'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.notification =
              mapdata['data']['result']['me_data']['Others']['Notification'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.languagePreference =
              mapdata['data']['result']['me_data']['Others']
                  ['Language Preference'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.contactUs =
              mapdata['data']['result']['me_data']['Others']['Contact Us'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.aboutUs =
              mapdata['data']['result']['me_data']['Others']['About Us'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.termsNConditions =
              mapdata['data']['result']['me_data']['Others']
                  ['Terms n conditions'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.privacyPolicy =
              mapdata['data']['result']['me_data']['Others']['Privacy Policy'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.rateUs =
              mapdata['data']['result']['me_data']['Others']['Rate Us'];
          startupController
              .startupData
              .first
              .data!
              .result!
              .screens!
              .meData!
              .others!
              .help = mapdata['data']['result']['me_data']['Others']['Help'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .others!.shareApp =
              mapdata['data']['result']['me_data']['Others']['Share App'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .action!.changePassword =
              mapdata['data']['result']['me_data']['Action']['Change Password'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .action!.deleteAccount =
              mapdata['data']['result']['me_data']['Action']['Delete account'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .action!.logout =
              mapdata['data']['result']['me_data']['Action']['Logout'];
          startupController
              .startupData
              .first
              .data!
              .result!
              .screens!
              .meData!
              .action!
              .login = mapdata['data']['result']['me_data']['Action']['Login'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .extraaTabs!.edit =
              mapdata['data']['result']['me_data']['extraa_tabs']['Edit'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .extraaTabs!.wishlistIcon =
              mapdata['data']['result']['me_data']['extraa_tabs']
                  ['Wishlist Icon'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .extraaTabs!.notificationIcon =
              mapdata['data']['result']['me_data']['extraa_tabs']
                  ['Notification Icon'];
          startupController.startupData.first.data!.result!.screens!.meData!
                  .extraaTabs!.downloadIcon =
              mapdata['data']['result']['me_data']['extraa_tabs']
                  ['Download Icon'];
          await Utils.saveNotificationStatus(
              mapdata['data']['result']['fcm_notification']);
          Get.back();
          if (Get.isRegistered<PlayerController>()) {
            // Get.delete<PlayerController>();
            Get.find<PlayerController>().audioPlayer.value.pause();
            Get.find<PlayerController>().audioPlayer.value.dispose();
          }
          Get.offAllNamed(AppRoute.bottomAppBarScreen);
          phone.clear();
          password.clear();
        }
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    isGuestUser.value = await Utils.isGuestUser();
  }

  @override
  void dispose() {
    isGuestUser.value = false;
    super.dispose();
  }
}
