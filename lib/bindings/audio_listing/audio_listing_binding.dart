import 'package:get/get.dart';
import '../../controllers/audio_listing/audio_listing_controller.dart';

class AudioListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioListingController());
  }
}
