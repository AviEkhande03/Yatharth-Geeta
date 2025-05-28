import 'package:get/get.dart';

import '../../controllers/video_details/video_details_controller.dart';

class VideoDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoDetailsController(), fenix: true);
  }
}
