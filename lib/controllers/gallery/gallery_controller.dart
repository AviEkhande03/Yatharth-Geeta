import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryController extends GetxController {
  List<String> imageList = [
    "assets/images/grid1.png",
    "assets/images/grid2.png",
    "assets/images/grid3.png",
    "assets/images/grid4.png",
    "assets/images/grid5.png",
    "assets/images/grid1.png",
    "assets/images/grid2.png",
    "assets/images/grid5.png",
    "assets/images/grid4.png",
    "assets/images/grid1.png",
  ];
  Future<bool> isLandscape(Image imageVal) async {
    final Image image = imageVal;
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));
    ui.Image info = await completer.future;
    int width = info.width;
    int height = info.height;
    if (width > height) {
      return true;
    }
    return false;
  }

  List<String?> galleryImages = [];
  @override
  void onInit() {
    galleryImages = Get.arguments;
    super.onInit();
  }
}
