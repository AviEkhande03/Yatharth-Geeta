import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../controllers/landscape_player/landscape_controller.dart';
import '../../controllers/video_player/video_player_controller.dart';
import '../../widgets/landscape_video/landscape_video.dart';

// ignore: must_be_immutable
class LandscapePlayer extends StatelessWidget {
  LandscapePlayer({Key? key}) : super(key: key);
  LandscapeController controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => Get.find<VideoPlayerSreenController>().isInitialized.value
            ? LandscapeVideo()
            : Container(
                color: kColorBlack,
                child: const Center(
                    child: CircularProgressIndicator(
                  color: kColorPrimary,
                ))),
      ),
    );
  }
}
