import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/admin_policies/terms_and_conditions/terms_and_conditions_model.dart';
import '../../services/admin_policies/admin_policies_service.dart';

class TermsAndConditionsController extends GetxController {
  final AdminPoliciesService adminPoliciesService = AdminPoliciesService();
  Rx<Result?> termsAndConditions = Result().obs;
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;

  RxString? checkItem = "".obs;

  //function to get terms and conditions from api
  Future<void> fetchTermsAndConditions({
    String? token,
    BuildContext? ctx,
    required type,
  }) async {
    log('termsAndConditions = $termsAndConditions');
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
          log('success is 0');

          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final termsAndConditionsModel =
              termsAndConditionsModelFromJson(response.body);

          termsAndConditions.value = termsAndConditionsModel.data!.result;

          checkItem!.value = mapdata['message'];

          log('termsAndConditions item message = $checkItem');

          isLoadingData.value = false;
        }
      }
    }
  }

  //Resetting the values
  clearTermsAndConditionsData() {
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
