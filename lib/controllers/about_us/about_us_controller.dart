import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/admin_policies/about_us/about_us_model.dart';
import '../../services/admin_policies/admin_policies_service.dart';

class AboutUsController extends GetxController {
  final AdminPoliciesService adminPoliciesService = AdminPoliciesService();
  Rx<Result?> aboutUs = Result().obs;
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;

  RxString? checkItem = "".obs;

  //Method to fetch aboutUs data
  Future<void> fetchAboutUs({
    String? token,
    BuildContext? ctx,
    required type,
  }) async {
    log('aboutUs = $aboutUs');
    isLoadingData.value = true;

    //calling adminInfoApi of adminPoliciesService by passing type
    //type attribute has values privacy policy,terms and conditions and about us
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
          final aboutUsModel = aboutUsModelFromJson(response.body);

          aboutUs.value = aboutUsModel.data!.result;
          debugPrint("aboutUs.value:${aboutUs.value.toString()}");
          checkItem!.value = mapdata['message'];

          log('aboutUs item message = $checkItem');
          debugPrint("");
          isLoadingData.value = false;
        }
      }
    }
  }

  //clear about us data
  clearAboutUsData() {
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
