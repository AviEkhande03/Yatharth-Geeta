import 'package:get/get.dart';

import '../../controllers/audio_details/audio_details_controller.dart';

class AudioDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioDetailsController());
  }
}
