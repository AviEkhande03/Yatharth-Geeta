import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../models/fcm_token_updated/fcm_token_updated_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/fcm_token_update/fcm_token_update_service.dart';
import '../../utils/utils.dart';

//This controller updates fcm token
//This is called before loading the pages in BottomAppBarService for updating the fcm token prior any page is loaded
class FcmTokenUpdateController extends GetxController {
  //Creating an instance of FcmTokenUpdateService
  final FcmTokenUpdateService fcmTokenUpdateService = FcmTokenUpdateService();
  final bottomAppService = Get.find<BottomAppBarServices>();

  Rx<FcmTokenUpdatedModel?> fcmTokenUpdatedlDetails =
      FcmTokenUpdatedModel().obs;
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;

  RxString? checkItem = "".obs;

  //Api call for updating fcm token
  Future<void> updateFcmTokenApi({
    String? token,
    required fcmToken,
  }) async {
    log('fcmUpdatedDetails = $fcmTokenUpdatedlDetails');
    log('fcmUpdatedDetails accesstoken= ${bottomAppService.token.value}');
    isLoadingData.value = true;

    final response = await fcmTokenUpdateService.fcmTokenUpdateApi(
        token: bottomAppService.token.value, fcmToken: fcmToken);
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
        }
        //This success code appears when the existing token is to be expired ,in such cases from backend we will get another token
        // and we will replace that token with the token in our local so that the user will never be logged out
        else if (mapdata['success'] == 3) {
          debugPrint('success is 3');
          debugPrint("New Token: ${mapdata['data']['result']['token']}");
          Utils.saveToken(mapdata['data']['result']['token']);
          isLoadingData.value = false;
        } else if (mapdata['success'] == 1) {
          debugPrint('success is 1');
          final fcmTokenUpdatedlDetailsModel =
              fcmTokenUpdatedModelFromJson(response.body);

          fcmTokenUpdatedlDetails.value = fcmTokenUpdatedlDetailsModel;

          checkItem!.value = mapdata['message'];

          log('fcm token updated message = $checkItem');

          isLoadingData.value = false;
        }
      }
    }
  }

  //Method for resetting the values
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
}
