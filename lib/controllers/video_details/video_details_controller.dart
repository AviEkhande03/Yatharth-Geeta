import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/services/audio_details/audio_details_service.dart';
import 'package:yatharthageeta/services/firebase/dynamic_link_service.dart';
import '../../models/video_details/video_details_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/video_details/video_details_services.dart';
import '../../models/video_details/video_episode_model.dart' as epModel;
import '../../utils/utils.dart';

class VideoDetailsController extends GetxController {
  final VideoDetailsService videoDetailsService = VideoDetailsService();
  Rx<Result?> videoDetails = Result().obs;
  RxBool isLoadingData = false.obs;
  RxBool isGuestUser = false.obs;
  var bottomAppService = Get.find<BottomAppBarServices>();
  RxBool isDataNotFound = false.obs;
  Map<String, String> header = {};
  RxString? checkItem = "".obs;
  var nextVideo = false.obs;
  var prevRoute = "".obs;
  var wishlistFlag = false.obs;
  void toggleWishlistFlag(bool newValue) {
    wishlistFlag.value = newValue;
  }

/*
  * Phase 2 Methods are called here
  * ----------------------------------------------------------------
  */

  Future<void> increaseCount({required String id}) async {
    final response = await AudioDetailsService.increaseCountApi(
        token: bottomAppService.token.value, id: id, master: 'Video');
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
        } else {
          log("Count Updated Successfully");
        }
      }
    }
  }

  sharePage() async {
    Utils().showLoader();
    final dynamicLink = DynamicLinkService.instance;
    final link = await dynamicLink.createDynamicLink(
        type: "Video", id: videoDetails.value!.id.toString());
    final shareData =
        "${"Immerse yourself in the uplifting message and profound teachings contained in this thought-provoking video lecture/discourse".tr} *${videoDetails.value!.title.toString()}* ${"only on *Yatharth Geeta* Mobile Application".tr} \n\n${link.toString()}";
    await Share.share(shareData);
    Get.back();
  }

  Future<epModel.Result?> fetchEpisodeDetails(
      {String? token,
      BuildContext? ctx,
      required videoId,
      required isNext}) async {
    log('videodetails = $videoDetails');
    isLoadingData.value = true;

    final response = await videoDetailsService.episodeDetailsApi(
        token: bottomAppService.token.value, videoId: videoId);
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
          print('success is 0');
          nextVideo.value = false;
          Utils.customToast("Something went wrong", kRedColor,
              kRedColor.withOpacity(0.2), "error");
          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final videoDetailsModel2 =
              epModel.VideoEpisodeModelFromJson(response.body);
          nextVideo.value = true;
          Rx<epModel.Result?> videoDetails1 =
              videoDetailsModel2.data!.result.obs;
          // RxBool wishlistFlag1 = videoDetails.value!.wishList!.obs;
          checkItem!.value = mapdata['message'];

          log('video item message = $checkItem');
          log("Video details ${videoDetails1.value!.toJson()}");

          isLoadingData.value = false;
          await increaseCount(id: videoId.toString());
          return videoDetails1.value;
        }
      }
    }
  }

  /*
  * ----------------------------------------------------------------
  * Phase 2 Methods end here
   */

  Future<Result?> fetchVideoDetails(
      {String? token,
      BuildContext? ctx,
      required videoId,
      required isNext}) async {
    log('videodetails = $videoDetails');
    isLoadingData.value = true;
    log("Video Id of the link is " + videoId.toString());
    final response = await videoDetailsService.videoDetailsApi(
        token: bottomAppService.token.value, videoId: videoId, isNext: isNext);
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
          print('success is 0');
          nextVideo.value = false;

          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final videoDetailsModel = VideoDetailsModelFromJson(response.body);
          nextVideo.value = true;
          videoDetails.value = videoDetailsModel.data!.result;
          wishlistFlag.value = videoDetails.value!.wishList!;
          checkItem!.value = mapdata['message'];

          log('video item message = $checkItem');
          log("Video details ${videoDetails.value!.toJson()}");
          print("videoDetails.value!.description!:${videoDetails.value!.description!}");

          isLoadingData.value = false;

          return videoDetails.value;
        }
      }
    }
  }

  Future<void> fetchVideoHomeCollectionDetails(
      {String? token, required videoId, required type}) async {
    log('videodetails = $videoDetails');
    isLoadingData.value = true;

    final response = await videoDetailsService.videoHomeCollectionDetailsApi(
        token: bottomAppService.token.value, videoId: videoId, type: type);
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
          print('success is 0');
          Utils.customToast("Something went wrong", kRedColor,
              kRedColor.withOpacity(0.2), "error");

          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final videoDetailsModel = VideoDetailsModelFromJson(response.body);

          videoDetails.value = videoDetailsModel.data!.result;
          wishlistFlag.value = videoDetails.value!.wishList!;
          checkItem!.value = mapdata['message'];

          log('video item message = $checkItem');

          isLoadingData.value = false;
          await increaseCount(id: videoId.toString());
        }
      }
    }
  }

  // final EbooksModel demoEbook = EbooksModel(
  //   title: 'Srimad Bhagwad Gita Padhchhed',
  //   bookCoverImgUrl: 'assets/images/ebook_details/bookcover1.png',
  //   langauge: 'Hindi',
  //   author: 'Swami Adganand Maharaj',
  //   favoriteFlag: 0,
  //   views: 32000,
  //   pagesCount: 500,
  //   desription: Constants.ebookDummyDesc,
  //   chaptersCount: 18,
  //   versesCount: 700,
  //   audioCoverImgUrl: 'assets/images/ebook_details/audio_book_bg1.png',
  //   videoCoverImgUrl: 'assets/images/ebook_details/video_cover_bg.png',
  // );
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
