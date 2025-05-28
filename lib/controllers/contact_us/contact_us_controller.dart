import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/models/contact_us/contact_us_details_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/contact_us/contact_us_service.dart';
import 'package:http/http.dart' as http;
import '../../const/colors/colors.dart';
import '../../utils/utils.dart';

class ContactUsController extends GetxController {
  //defining the controllers
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  final bottomAppServices = Get.find<BottomAppBarServices>();
  final contactUsService = ContactUsService();
  var isLoadingData = false.obs;
  var contactUsDetails = Result();
  void validate() {
    Utils().showLoader();
    contactUsUser();
  }

  //method for creating a contact us request
  Future<void> contactUsUser() async {
    final response = await contactUsService.contactUs(
        bottomAppServices.token.value,
        name.text.toString(),
        email.text.toString(),
        subject.text.toString(),
        message.text.toString());
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
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
          //for closing the loader
          Get.back();
          //for showing the toast message
          Utils.customToast(mapdata['message'], kGreenPopUpColor,
              kGreenPopUpColor.withOpacity(0.2), "Success");
          //Clearing all fields
          name.clear();
          email.clear();
          subject.clear();
          message.clear();
        }
      }
    }
  }

  createCoordinatedUrl(String latitude, String longitude, String? label) {
    Uri uri;
    if (Platform.isAndroid) {
      var query = '$latitude,$longitude';

      if (label != null) query += '($label)';

      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      var params = {
        'll': '$latitude,$longitude',
        'q': label ?? '$latitude, $longitude',
      };

      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    }
    return uri;
  }

  //Method for getting details on contact us page like urls of instagram and youtube on contact us page
  Future<void> fetchContactUsDetails(
      {String? token, Map<String, String>? body}) async {
    isLoadingData.value = true;
    // Loading(Utils.loaderImage()).start(ctx!);
    // Utils().showLoader();
    // body = body != null || body.isNotEmpty ? returnFilterBody() : {};
    // if (body == null) {
    //   body = {};
    // } else {
    //   body = body.isEmpty ? {} : returnFilterBody();
    // }
    log(body.toString());

    final response = await ContactUsService().contactUsDetails(
      Get.find<BottomAppBarServices>().token.value,
    );
    log(response.toString());
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          // isLoadingData.value = false;
          // if (pageNo.value == 1 && audiosListing.isEmpty) {
          //   isDataNotFound.value = true;
          // }

          isLoadingData.value = false;
          log('success is 0');

          // checkItem!.value = mapdata['message'];
        } else {
          //getting the data from json to model
          final contactUsDetailsModel =
              ContactUsDetailsModelFromJson(response.body);

          contactUsDetails = contactUsDetailsModel.data!.result!;

          // Loading.stop();
          // pageNo.value++;
          // isLoadingData.value = false;
          // isDataNotFound.value = false;
        }
      }
    }
    // Get.back();
  }
}
