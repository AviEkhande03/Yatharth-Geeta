import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/admin_policies/privacy_policy/privacy_policy_model.dart';
import '../../services/admin_policies/admin_policies_service.dart';

class PrivacyPolicyController extends GetxController {
  final AdminPoliciesService adminPoliciesService = AdminPoliciesService();
  Rx<Result?> privacyPolicy = Result().obs;
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;

  RxString? checkItem = "".obs;

  //function to get Privacy Policy from api
  Future<void> fetchPrivacyPolicy({
    String? token,
    BuildContext? ctx,
    required type,
  }) async {
    log('privacyPolicy = $privacyPolicy');
    isLoadingData.value = true;

    final response = await adminPoliciesService.adminInfoApi(type: type);
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
          final privacyPolicyModel = privacyPolicyModelFromJson(response.body);

          privacyPolicy.value = privacyPolicyModel.data!.result;

          checkItem!.value = mapdata['message'];

          log('policy item message = $checkItem');

          isLoadingData.value = false;
        }
      }
    }
  }

  //Resetting the values
  clearPrivacyPolicyData() {
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
