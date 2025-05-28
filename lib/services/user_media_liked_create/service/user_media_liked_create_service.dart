import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yatharthageeta/models/user_media_wishlist_create/user_media_wishlist_create_model.dart'
    as likedcreate;
import 'package:yatharthageeta/services/user_media_liked_create/api/user_media_liked_create_api.dart';

import '../../../const/colors/colors.dart';
import '../../../controllers/logout/logout_controller.dart';
import '../../../utils/utils.dart';

//This service is created for the liked media list for the user as the controller needs to be persisted through out the app since medias are liked and disliked from varous different screens
class UserMediaLikedCreateServices extends GetxService {
  //Dependencies are initialized here
  final UserMediaLikedCreateApi userMediaLikedCreateApi =
      UserMediaLikedCreateApi();
  //final bottomAppService = Get.find<BottomAppBarServices>();

  Rx<likedcreate.Result?> userMediaLikedCreateDetails =
      likedcreate.Result().obs;
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;

  RxString? checkItem = "".obs;

//API method for updating the liked media status for the user(if the media is liked the call we dislike it else like it)
  Future<void> updateUserMediaLikedCreate(
      {String? token,
      BuildContext? ctx,
      required mediaType,
      required likedMediaId}) async {
    log('userMediaWishlistCreateDetails = $userMediaLikedCreateApi');
    isLoadingData.value = true;

    debugPrint("Token of bottomservices in Wishlistcreate:-->${token!}");
    final response = await userMediaLikedCreateApi.userMediaLikedCreateApi(
        mediaType: mediaType, likedMediaId: likedMediaId, token: token);
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
        } else if (mapdata['success'] == 4) {
          debugPrint("Success 4");
          Utils.customToast(mapdata['message'], kRedColor,
              kRedColor.withOpacity(0.2), "Error");
          Utils().showLoader();
          Utils.deleteToken();
          Utils.deleteNotificationStatus();
          await Get.find<LogOutController>().logOutUser();
        } else if (mapdata['success'] == 1) {
          final userMediaLikedCreateDetailsModel =
              likedcreate.userMediaWishlistCreateModelFromJson(response.body);

          userMediaLikedCreateDetails.value =
              userMediaLikedCreateDetailsModel.data!.result;

          checkItem!.value = mapdata['message'];

          log('userMediaLikedCreateDetails item message = $checkItem');

          isLoadingData.value = false;
        }
      }
    }
  }

//Resets the data loading flag and no data found flag
  clearLikedCreateDetailsData() {
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
