import 'package:get/get.dart';
// import 'package:yatharthageeta/controllers/events_listing/events_listing_controller.dart';
import 'package:yatharthageeta/controllers/guruji_details/guruji_details_controller.dart';
import 'package:yatharthageeta/controllers/video_details/video_details_controller.dart';

class GurujiDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GurujiDetailsController());
    Get.lazyPut(() => VideoDetailsController(), fenix: true);
  }
}
