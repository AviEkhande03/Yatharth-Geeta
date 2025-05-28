import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../routes/app_route.dart';
import '../../const/colors/colors.dart';
import 'package:http/http.dart' as http;
import '../../services/firebase/firebase_cloud_messaging.dart';
import '../../services/registration/registration_service.dart';
import '../../utils/utils.dart';
import '../../utils/validations_mixin.dart';

class RegistrationController extends GetxController with ValidationsMixin {
  RxBool isPassWordDisabled = true.obs;
  RxString? phoneValidation = ''.obs;
  RxBool isGuestUser = false.obs;
  TextEditingController phone = TextEditingController();
  final registrationService = RegistrationService();

  bool validateRegistration() {
    phoneValidation?.value = validatedPhoneNumber(phone.value.text, 10) ?? '';
    if (phoneValidation?.value != '') {
      return false;
    } else {
      return true;
    }
  }

  void validate(context) {
    bool isValidated = validateRegistration();
    //print("isValidated:$isValidated");
    if (isValidated) {
      Utils().showLoader();
      registerUser();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: kColorTransparent));
    isGuestUser.value = await Utils.isGuestUser();
  }

  Future<void> registerUser() async {
    final response = await registrationService.registerUser(
        phone.text.toString(), FirebaseCloudMessaging.fcmToken.toString());
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
          Get.back();
          Get.toNamed(AppRoute.otpVerificationScreen, arguments: [
            {'phone': phone.text.toString()},
            {'workflow': "registration"}
          ]);
          phone.clear();
        }
      }
    }
  }

  @override
  void dispose() {
    isGuestUser.value = false;
    super.dispose();
  }
}
