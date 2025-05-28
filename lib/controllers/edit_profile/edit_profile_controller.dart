import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/startup/startup_controller.dart';
import '../profile/profile_controller.dart';
import '../../services/edit_profile/edit_profile_service.dart';
import '../../utils/validations_mixin.dart';
import 'package:http/http.dart' as http;
import '../../const/colors/colors.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../logout/logout_controller.dart';

class EditProfileController extends GetxController with ValidationsMixin {
  final profileScreenController = Get.find<ProfileController>();
  final bottomAppService = Get.find<BottomAppBarServices>();
  final editProfileService = EditProfileService();
  RxString? nameValidation = ''.obs;
  RxString? phoneValidation = ''.obs;
  RxString? pincodeValidation = ''.obs;
  RxString? stateValidation = ''.obs;
  RxString? emailValidation = ''.obs;
  RxString countryCode = ''.obs;
  RxInt phoneLength = 10.obs;
  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController pincode;
  late TextEditingController state;
  late TextEditingController email;

  @override
  void onInit() {
    super.onInit();
    //Defining text editing controllers for the textFields
    name = TextEditingController(
        text: profileScreenController.profileData.first.data!.result!.name);
    phone = TextEditingController(
        text: profileScreenController.profileData.first.data!.result!.phone);
    pincode = TextEditingController(
        text: profileScreenController.profileData.first.data!.result!.pinCode ??
            '');
    state = TextEditingController(
        text: profileScreenController.profileData.first.data!.result!.state ??
            '');
    email = TextEditingController(
        text: profileScreenController.profileData.first.data!.result!.email ??
            '');
    countryCode.value = profileScreenController
                .profileData.first.data!.result!.phoneCode! ==
            '91'
        ? '+' +
            profileScreenController.profileData.first.data!.result!.phoneCode!
        : profileScreenController.profileData.first.data!.result!.phoneCode!;
    debugPrint("countryCode.value:${countryCode.value}");
  }

  //Method for validating the entries
  bool validateRegistration() {
    // debugPrint("profileScreenController.profileData.first.data!.result!.name:${profileScreenController.profileData.first.data!.result!.name}");
    // debugPrint("profileScreenController.profileData.first.data!.result!.phone:${profileScreenController.profileData.first.data!.result!.phone}");
    // debugPrint("profileScreenController.profileData.first.data!.result!.email:${profileScreenController.profileData.first.data!.result!.email}");
    // debugPrint("profileScreenController.profileData.first.data!.result!.pincode:${profileScreenController.profileData.first.data!.result!.pinCode}");
    // debugPrint("profileScreenController.profileData.first.data!.result!.state:${profileScreenController.profileData.first.data!.result!.state}");
    // debugPrint("name.text:${name.text}");
    // debugPrint("mail.text:${email.text}");
    // debugPrint("phone.text:${phone.text}");
    // debugPrint("pincode.text:${pincode.text}");
    // debugPrint("state.text:${state.text}");

    if (profileScreenController.profileData.first.data!.result!.name ==
            name.text &&
        (profileScreenController.profileData.first.data!.result!.phone ?? '') ==
            phone.text &&
        (profileScreenController.profileData.first.data!.result!.email ?? '') ==
            email.text &&
        (profileScreenController.profileData.first.data!.result!.pinCode ??
                '') ==
            pincode.text &&
        (profileScreenController.profileData.first.data!.result!.state ?? '') ==
            state.text) {
      Utils.customToast("No Changes done yet".tr, kRedColor,
          kRedColor.withOpacity(0.2), "Error");
      return false;
    } else {
      nameValidation?.value = validatedName(name.value.text) ?? '';
      phoneValidation?.value = Get.find<StartupController>()
                  .startupData
                  .first
                  .data!
                  .result!
                  .screens!
                  .meData!
                  .profile!
                  .phoneEditable! &&
              !phone.text.isEmpty
          ? validatedPhoneNumber(phone.value.text, phoneLength.value) ?? ''
          : '';
      pincodeValidation?.value = !pincode.text.isEmpty
          ? validatedPinCode(pincode.value.text) ?? ''
          : '';
      stateValidation?.value =
          !state.text.isEmpty ? validatedStateName(state.value.text) ?? '' : '';
      emailValidation?.value = Get.find<StartupController>()
                  .startupData
                  .first
                  .data!
                  .result!
                  .screens!
                  .meData!
                  .profile!
                  .emailEditable! &&
              !email.text.isEmpty
          ? validatedEmail(email.value.text) ?? ''
          : '';
      if (nameValidation?.value != '') {
        return false;
      } else if (phoneValidation?.value != '') {
        print(phoneValidation?.value);
        return false;
      } else if (pincodeValidation?.value != '') {
        return false;
      } else if (stateValidation?.value != '') {
        return false;
      } else if (emailValidation?.value != '') {
        return false;
      } else {
        return true;
      }
    }
  }

  //Method for validating the fields,called on button tap
  void validate(BuildContext context) {
    bool isValidated = validateRegistration();
    if (isValidated) {
      // Loading(Utils.loaderImage()).start(context);
      Utils().showLoader();
      editProfile(context);
    }
  }

  //Method called for editing the profile,like api call for editing the fields exists here,called after the fields are validated
  Future<void> editProfile(context) async {
    final response = await editProfileService.editUserProfile(
        bottomAppService.token.value,
        name.text.toString(),
        countryCode.value.toString(),
        phone.text.toString(),
        email.text.toString(),
        pincode.text.toString(),
        state.text.toString());
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        debugPrint(mapdata.toString());
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          debugPrint(mapdata.toString());
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
          debugPrint(mapdata.toString());
          //again calling me api as there is after edit waaala part running successfully ,me data might have have changes so updating the local model by calling api again
          await profileScreenController
              .getProfile(bottomAppService.token.value);
          //closing the loader
          Get.back();
          //showing the alert dialog that the profile has updated
          Utils.showAlertDialog(
              context,
              'assets/icons/updated_dialog_icon.svg',
              'Profile Updated!',
              'Great! Your profile has been updated successfully');
        }
      }
    }
  }
}
