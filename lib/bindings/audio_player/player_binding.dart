import 'package:get/get.dart';

import '../../controllers/audio_player/player_controller.dart';
import '../../controllers/audio_player/player_view_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayerViewController());
    Get.lazyPut(() => PlayerController(), fenix: true);
  }
}
