import 'package:get/get.dart';

import '../../controllers/video_listing/video_listing_controller.dart';

class VideoListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoListingController());
  }
}
