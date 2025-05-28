import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:yatharthageeta/controllers/profile/profile_controller.dart';

import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/logout/logout_service.dart';
import '../../utils/utils.dart';
import '../audio_player/player_controller.dart';
import '../startup/startup_controller.dart';

class LogOutController extends GetxController {
  final logOutService = LogoutService();
  final bottomAppService = Get.find<BottomAppBarServices>();
  final startupController = Get.find<StartupController>();
  final profileController = Get.find<ProfileController>();

  //method to logout user
  Future<void> logOutUser() async {
    //In case of Google SignIn just signOut
    await GoogleSignIn().signOut();

    //SignOut from firebase if logged in
    FirebaseAuth.instance.signOut();

    //Calling the api of logout from logOutService with token
    final response =
        await logOutService.logoutUser(bottomAppService.token.value);
    if (response == " ") {
    } else if (response is http.Response) {
      //If response is 404 then back() closes the loader and show the error toast
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      }
      //If response is 500 then back() closes the loader and show the error toast
      else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          print(mapdata);
          // Utils.customToast(mapdata['message'], kRedColor,
          //     kRedColor.withOpacity(0.2), "Error");
        } else {
          print(mapdata);
          //updating startup Model(as after logging out startup should be updated)
          Utils().updateStartUpData(mapdata);

          // debugPrint(
          //     "Get.find<StartupController>().startupData.first.data!.result!.loginWith!.otp:${Get.find<StartupController>().startupData.first.data!.result!.loginWith!.otp}");
          //Utils.customToast(mapdata['message'], kGreenPopUpColor,
          //   kGreenPopUpColor.withOpacity(0.2), "Success");

          //If audio is playing then it must be stopped
          if (Get.isRegistered<PlayerController>()) {
            Get.find<PlayerController>().audioPlayer.value.pause();
          }

          //If login with OTP is true then after logging out go to loginWithOTPScreen
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
          }
          //If login with OTP is false and login with password is true then after logging out go to loginWithPasswordScreen
          else if (Get.find<StartupController>()
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
