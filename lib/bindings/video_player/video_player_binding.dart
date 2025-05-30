import 'package:get/get.dart';
import '../../controllers/video_player/video_player_controller.dart';

class VideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoPlayerSreenController());
  }
}
