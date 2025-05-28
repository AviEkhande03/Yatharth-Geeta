import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/bottom_app_bar/bottom_app_bar_services.dart';

class SearchBarController extends GetxController {
  final bottomAppService = Get.find<BottomAppBarServices>();
  RxBool isListening = false.obs;

  @override
  void onInit() {
    super.onInit();
    //bottomAppService.isCustomSearchBarNewDisposed.value = false;
  }

  @override
  void dispose() {
    debugPrint("onDispose called.");
    //bottomAppService.isCustomSearchBarNewDisposed.value = true;
    super.dispose();
  }

  @override
  void onClose() {
    debugPrint("onClose called.");
    //bottomAppService.isCustomSearchBarNewDisposed.value = true;
    super.onClose();
  }
}
