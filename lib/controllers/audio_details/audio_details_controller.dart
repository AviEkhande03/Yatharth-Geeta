import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/services/firebase/dynamic_link_service.dart';
import '../../models/audio_details/audio_details_model.dart';
import '../../services/audio_details/audio_details_service.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';

class AudioDetailsController extends GetxController {
  //Static variables
  final AudioDetailsService audioDetailsService = AudioDetailsService();
  Rx<Result?> audioDetails = Result().obs;
  var bottomAppService = Get.find<BottomAppBarServices>();
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;
  RxBool isGuestUser = false.obs;
  Map<String, String> header = {};
  var prevRoute = "".obs;
  RxString? checkItem = "".obs;
  var wishlistFlag = false.obs;

  //to toggle Wishlist flag
  void toggleWishlistFlag(bool newValue) {
    wishlistFlag.value = newValue;
  }

  //api call to get audio details
  Future<void> fetchAudioDetails({
    String? token,
    BuildContext? ctx,
    required audioId,
  }) async {
    log('audiodetails = $audioDetails');
    isLoadingData.value = true;

    final response = await audioDetailsService.audioDetailsApi(
        token: bottomAppService.token.value, audioId: audioId);
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
          // isLoadingData.value = false;
          Utils.customToast("Something went wrong", kRedColor,
              kRedColor.withOpacity(0.2), "error");

          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final audioDetailsModel = AudioDetailsModelFromJson(response.body);
          log(response.body);
          audioDetails.value = audioDetailsModel.data!.result;

          checkItem!.value = mapdata['message'];

          wishlistFlag.value = audioDetails.value!.wishList!;
          log(wishlistFlag.value.toString());

          log('video item message = $checkItem');

          isLoadingData.value = false;
        }
      }
    }
  }

  //api call to get audio details of Home Collection
  Future<void> fetchAudioHomeCollectionDetails(
      {String? token,
      BuildContext? ctx,
      required audioId,
      required type}) async {
    log('audiodetails = $audioDetails');
    isLoadingData.value = true;

    final response = await audioDetailsService.audioHomeCollectionDetailsApi(
        token: bottomAppService.token.value, audioId: audioId, type: type);
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
          // isLoadingData.value = false;
          Utils.customToast("Something went wrong", kRedColor,
              kRedColor.withOpacity(0.2), "error");
          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final audioDetailsModel = AudioDetailsModelFromJson(response.body);

          audioDetails.value = audioDetailsModel.data!.result;

          checkItem!.value = mapdata['message'];

          wishlistFlag.value = audioDetails.value!.wishList!;
          log(wishlistFlag.value.toString());

          log('video item message = $checkItem');

          isLoadingData.value = false;
          await increaseCount(id: audioId.toString());
        }
      }
    }
  }

  /*
  * Phase 2 Methods are called here
  * ----------------------------------------------------------------
  */
  //increaseCount of the audio
  Future<void> increaseCount({required String id}) async {
    final response = await AudioDetailsService.increaseCountApi(
        token: bottomAppService.token.value, id: id, master: 'Audio');
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(re~sponse.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
          Utils.customToast("Something went wrong", kRedColor,
              kRedColor.withOpacity(0.2), "error");
        } else {
          log("Count Updated");
        }
      }
    }
  }

  //Share the page
  sharePage() async {
    Utils().showLoader();
    final dynamicLink = DynamicLinkService.instance;
    final link = await dynamicLink.createDynamicLink(
        type: "Audio", id: audioDetails.value!.id.toString());
    final shareData =
        "${"Experience the divine melodies and soul-stirring devotional music that will uplift your spirits and connect you with the divine.".tr} *${audioDetails.value!.title.toString()}* ${"only on *Yatharth Geeta* Mobile Application".tr}\n\n${link.toString()}";
    await Share.share(shareData);
    Get.back();
  }

  /*
  * ----------------------------------------------------------------
  * Phase 2 Methods end here
   */

  @override
  void onInit() async {
    header = await Utils().getHeaders();
    super.onInit();
    isGuestUser.value = await Utils.isGuestUser();
  }

  @override
  void onClose() {
    super.onClose();
    isLoadingData.value = false;
    isDataNotFound = false.obs;
  }
}
