import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../audio_player/player_controller.dart';
import '../../routes/app_route.dart';
import '../../services/delete_account/delete_account_service.dart';
import '../../const/colors/colors.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:http/http.dart' as http;
import '../../utils/utils.dart';
import '../logout/logout_controller.dart';
import '../profile/profile_controller.dart';
import '../startup/startup_controller.dart';

class DeleteAccountController extends GetxController {
  final deleteAccountService = DeleteAccountService();
  final startupController = Get.find<StartupController>();
  final bottomAppService = Get.find<BottomAppBarServices>();
  final profileController = Get.find<ProfileController>();

  //Method that will be called for deleting account
  Future<void> deleteUserAccount() async {
    //If google account is signed in then signout
    if (profileController.profileData.first.data!.result!.socialLoginType !=
            null &&
        profileController.profileData.first.data!.result!.socialLoginType! ==
            "google") {
      await GoogleSignIn().signOut();
    }
    //signing out from firebase
    FirebaseAuth.instance.signOut();
    print("*************:${bottomAppService.token.value}");
    final response =
        await deleteAccountService.deleteUser(bottomAppService.token.value);
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          print(mapdata);
          // Utils.customToast(mapdata['message'], kRedColor,
          //     kRedColor.withOpacity(0.2), "Error");
        } else if (mapdata['success'] == 4) {
          debugPrint("Success 4");
          Utils.customToast(mapdata['message'], kRedColor,
              kRedColor.withOpacity(0.2), "Error");
          //profileData.clear();
          Utils().showLoader();
          Utils.deleteToken();
          Utils.deleteNotificationStatus();
          await Get.find<LogOutController>().logOutUser();
        } else if (mapdata['success'] == 1) {
          print(mapdata);
          // Utils.customToast(mapdata['message'], kGreenPopUpColor,
          //     kGreenPopUpColor.withOpacity(0.2), "Success");

          //Updating startup Data
          Utils().updateStartUpData(mapdata);

          if (Get.isRegistered<PlayerController>()) {
            Get.find<PlayerController>().audioPlayer.value.pause();
          }
          // Get.offAllNamed(AppRoute.loginWithOTPScreen);
          if (Get.find<StartupController>()
                  .startupData
                  .first
                  .data!
                  .result!
                  .loginWith!
                  .otp ==
              true) {
            if (Get.isRegistered<PlayerController>()) {
              // Get.delete<PlayerController>();
              Get.find<PlayerController>().audioPlayer.value.pause();
              Get.find<PlayerController>().audioPlayer.value.dispose();
            }
            Get.offAllNamed(AppRoute.loginWithOTPScreen);
          } else if (Get.find<StartupController>()
                      .startupData
                      .first
                      .data!
                      .result!
                      .loginWith!
                      .otp ==
                  false &&
              Get.find<StartupController>()
                      .startupData
                      .first
                      .data!
                      .result!
                      .loginWith!
                      .password ==
                  true) {
            if (Get.isRegistered<PlayerController>()) {
              // Get.delete<PlayerController>();
              Get.find<PlayerController>().audioPlayer.value.pause();
              Get.find<PlayerController>().audioPlayer.value.dispose();
            }
            Get.offAllNamed(AppRoute.loginWithPasswordScreen);
          }
        }
      }
    }
  }
}
