import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/language/language_service.dart';
import '../../utils/utils.dart';

//This method return the headers that is required by the APIs
final languageService = Get.find<LangaugeService>();
Future<Map<String, String>>? getHeaders(String? token,
    {isAccessLanguageRequired = true}) async {
  String basicAuth = await Utils.authHeader();
  String acceptedLanguages = isAccessLanguageRequired == true
      ? languageService.getCurrentLocale.languageCode
      : "";
  String platform = Platform.operatingSystem;
  dynamic deviceId = await Utils().getDeviceId();
  debugPrint("deviceId:$deviceId");
  //dynamic deviceVersion = await getAndroidVersion();
  dynamic applicationVersion = await Utils().getAppVersion();

  Map<String, String> header = {
    'authorization': basicAuth,
    'Accept-Language': acceptedLanguages,
    'access-token': token ?? "",
    'uuid': deviceId,
    'platform': platform,
    'version': applicationVersion,
  };

  return header;
}
