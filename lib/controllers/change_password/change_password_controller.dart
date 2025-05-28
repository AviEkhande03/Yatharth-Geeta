import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/validations_mixin.dart';
import '../../const/colors/colors.dart';
import '../../services/change_password_service/change_password_service.dart';
import 'package:http/http.dart' as http;
import '../../utils/utils.dart';
import '../logout/logout_controller.dart';

class ChangePasswordController extends GetxController with ValidationsMixin {
  RxBool isNewPassWordDisabled = true.obs;
  RxBool isConfirmNewPassWordDisabled = true.obs;

  RxString? newPswdValidation = ''.obs;
  RxString? confirmPswdValidation = ''.obs;

  final bottomAppService = Get.find<BottomAppBarServices>();
  final changePasswordService = ChangePasswordService();
  TextEditingController newPswd = TextEditingController();
  TextEditingController confirmPswd = TextEditingController();

  bool validatePassword() {
    newPswdValidation?.value = validatedPassword(newPswd.value.text) ?? '';
    confirmPswdValidation?.value =
        validatedPassword(confirmPswd.value.text) ?? '';

    if (newPswdValidation?.value != '') {
      return false;
    } else if (confirmPswdValidation?.value != '') {
      return false;
    } else {
      return true;
    }
  }

  void validate(BuildContext context) {
    bool isValidated = validatePassword();
    if (isValidated) {
      Utils().showLoader();
      changeUserPassword(context);
    }
  }

  Future<void> changeUserPassword(context) async {
    final response = await changePasswordService.changePassword(
        bottomAppService.token.value,
        newPswd.text.toString(),
        confirmPswd.text.toString());
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
        //debugPrint("gfghggjhjhuhfc");
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          debugPrint(mapdata.toString());
          Get.back();
          // debugPrint("Type:${mapdata['message'].runtimeType}");
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
          Get.back();
          Utils.showAlertDialog(
              context,
              'assets/icons/updated_dialog_icon.svg',
              'Password Updated!',
              'Great! Your password has been updated successfully');
          newPswd.clear();
          confirmPswd.clear();
        }
      }
    }
  }
}
