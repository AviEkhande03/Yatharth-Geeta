import 'package:get/get.dart';

import '../../controllers/audio_player/player_controller.dart';
import '../../controllers/explore/explore_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExploreController());
    Get.lazyPut(() => PlayerController());
  }
}
