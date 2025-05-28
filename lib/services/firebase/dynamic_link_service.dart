import 'dart:developer';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/audio_details/audio_details_controller.dart';
import 'package:yatharthageeta/controllers/ebook_details/ebook_details_controller.dart';
import 'package:yatharthageeta/controllers/video_details/video_details_controller.dart';
import 'package:yatharthageeta/routes/app_route.dart';
import 'package:yatharthageeta/utils/utils.dart';

class DynamicLinkService {
  static final DynamicLinkService _singleton = DynamicLinkService._internal();
  DynamicLinkService._internal();
  static DynamicLinkService get instance => _singleton;

  Future<Uri> createDynamicLink(
      {required String type, required String id}) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.yatharthgeeta.com?type=$type&id=$id"),
      uriPrefix: "https://yatharthgeeta.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.yatharthgeeta.user"),
      iosParameters: const IOSParameters(bundleId: "com.yatharthgeeta.user",appStoreId: "6473667017"),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    debugPrint("${dynamicLink.shortUrl}");
    return dynamicLink.shortUrl;
  }

  initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (instanceLink != null) {
      handleDynamicLink();
    }
  }

  void handleDynamicLink() async {
    final PendingDynamicLinkData? pendingDynamicLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(pendingDynamicLink);
    debugPrint("${pendingDynamicLink?.link}");

    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        _handleDeepLink(dynamicLink);
      },
      onError: (e) {
        debugPrint(e.message);
      },
    );
  }

  void _handleDeepLink(PendingDynamicLinkData? pendingDynamicLink) async {
    final deepLink = pendingDynamicLink?.link;
    if (deepLink != null) {
      debugPrint("deepLink | ${deepLink.queryParameters}");
      final query = deepLink.queryParameters;
      final type = query["type"];
      final id = query["id"];
      // final token = await Utils.getToken();
      // if (token != '') {
      if (type == 'Audio') {
        Utils().showLoader();
        await Get.put(AudioDetailsController())
            .fetchAudioDetails(audioId: int.parse(id.toString()));
        Get.back();
        Get.toNamed(AppRoute.audioDetailsScreen);
      } else if (type == 'Video') {
        Utils().showLoader();
        await Get.put(VideoDetailsController()).fetchVideoDetails(
            videoId: int.parse(id.toString()),
            ctx: Get.context,
            isNext: false,
            token: '');
        Get.back();
        Get.toNamed(AppRoute.videoDetailsScreen);
      } else if (type == 'Book') {
        Utils().showLoader();
        await Get.put(EbookDetailsController())
            .fetchBookDetails(bookId: int.parse(id.toString()));
        Get.back();
        Get.toNamed(AppRoute.ebookDetailsScreen);
      }
      // }
    }
  }
}
