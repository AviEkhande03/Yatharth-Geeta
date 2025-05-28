import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
// import 'package:wakelock/wakelock.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../controllers/video_player/video_player_controller.dart';
import '../../models/video_details/video_details_model.dart';
import '../../views/landscape_player/landscape_player_screen.dart';
import 'popop.dart';

class PotraitPlayer extends StatelessWidget {
  final link;
  final double aspectRatio;
  const PotraitPlayer(
      {super.key, required this.link, required this.aspectRatio});
  @override
  Widget build(BuildContext context) {
    var networkService = Get.find<NetworkService>();

    // enabling wake lock so that the device does not sleep while playing the video
    WakelockPlus.enable();
    VideoPlayerSreenController controller =
        Get.find<VideoPlayerSreenController>();
    // controller.value.manifest =
    // controller.value.controller.value = VideoPlayerController.networkUrl(element.url,
    //     videoPlayerOptions: VideoPlayerOptions())
    //   ..initialize().then((value) {
    //     controller.value.controller.value.seekTo(position);
    //     controller.value.isInitialized.value = true;
    //     controller.value.controller.value.play();
    //     controller.value.isPlaying.value = true;
    //   });
    // orientation builder was used to reduce renderflex overlow issue when the orientation is changes
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? AspectRatio(
                aspectRatio: aspectRatio,
                // on tap of the player toggling the visibility of the controls
                child: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isVisible.value = !controller.isVisible.value;
                      Future.delayed(const Duration(seconds: 5), () {
                        controller.isVisible.value = false;
                      });
                    },
                    // if the video is initialized then showing the video player and stacking controls onto it
                    child: controller.isInitialized.value
                        ? Stack(
                            fit: StackFit.passthrough,
                            children: [
                              VideoPlayer(
                                  controller.controller!.value), //Video Player
                              Obx(
                                () => controller.caption.isNotEmpty
                                    ? ClosedCaption(
                                        text: controller.currentSubtitle?.data,
                                        textStyle: TextStyle(
                                            fontSize: 15.w,
                                            color: Colors.white),
                                      )
                                    : const SizedBox.shrink(),
                              ), //Captions

                              // controls are added on the basis on isVisible check so that when on tap the visibility of the controls also changes and is displayed accordingly
                              Visibility(
                                visible: controller.isVisible.value,
                                // visible: true,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black45),
                                  height: double.infinity,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // TextButton(
                                            //   child: SvgPicture.asset(
                                            //     "assets/icons/10rev.svg",
                                            //     width: 30.h,
                                            //     height: 30.h,
                                            //   ),
                                            //   onPressed: () {
                                            //     controller.value.controller.value.seekTo(controller.value
                                            //             .controller.value.value.position -
                                            //         const Duration(seconds: 10));
                                            //   },
                                            // ),
                                            // play pause button
                                            Obx(
                                              () => controller
                                                      .internetGone.value
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: kColorPrimary,
                                                      ),
                                                    )
                                                  : TextButton(
                                                      child: SvgPicture.asset(
                                                        controller
                                                                .isPlaying.value
                                                            ? "assets/icons/pause_video.svg"
                                                            : "assets/icons/play_video.svg",
                                                        width: 48.w,
                                                        // width: width >= 600 ? 40.w : 40.w,
                                                        // height: width >= 600 ? 40.h : 40.h,
                                                      ),
                                                      onPressed: () {
                                                        controller.isPlaying
                                                                .value =
                                                            !controller
                                                                .isPlaying
                                                                .value;
                                                        controller
                                                                .controller!
                                                                .value
                                                                .value
                                                                .isPlaying
                                                            ? controller
                                                                .controller!
                                                                .value
                                                                .pause()
                                                            : controller
                                                                .controller!
                                                                .value
                                                                .play();
                                                      },
                                                    ),
                                            ),

                                            // TextButton(
                                            //   child: SvgPicture.asset(
                                            //     "assets/icons/10for.svg",
                                            //     width: 30.h,
                                            //     height: 30.h,
                                            //   ),
                                            //   onPressed: () {
                                            //     controller.value.controller.value.seekTo(controller.value
                                            //             .controller.value.value.position +
                                            //         const Duration(seconds: 10));
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      ), //Controls
                                      // back button
                                      InkWell(
                                        onTap: () {
                                          controller.controller!.value.pause();
                                          Get.back();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(15.h),
                                          child: SvgPicture.asset(
                                            "assets/icons/back.svg",
                                            color: kColorWhite,
                                            width: 25.w,
                                            height: 25.h,
                                          ),
                                        ),
                                      ),

                                      // Container(
                                      //     padding: EdgeInsets.only(
                                      //         top: 230.w, left: 25.w, right: 25.w),
                                      //     //Duration
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       children: [
                                      //         RichText(
                                      //           text: TextSpan(
                                      //             text: controller.value.formatDuration(
                                      //                 controller.value.position.value),
                                      //             style: const TextStyle(
                                      //               fontSize: 10.0,
                                      //               color: Colors.white,
                                      //               decoration: TextDecoration.none,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         Text(
                                      //           controller.value.formatDuration(
                                      //               controller.value.duration.value),
                                      //           style: const TextStyle(
                                      //             fontSize: 10.0,
                                      //             color: Colors.white,
                                      //             decoration: TextDecoration.none,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     )),

                                      //Brightness and VOlume Sliders
                                      Positioned(
                                        bottom: width >= 600 ? 130.h : 75.h,
                                        left: 10.w,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: controller
                                                  .brightVisible.value,
                                              child: RotatedBox(
                                                quarterTurns: -1,
                                                child: SizedBox(
                                                  width: 80.w,
                                                  // margin: EdgeInsets.only(
                                                  //     top: 30.w,
                                                  //     bottom: 30.w,
                                                  //     left: 20.w,
                                                  //     right: 18.w),
                                                  child: SliderTheme(
                                                    data: SliderThemeData(
                                                        trackHeight: 2.w,
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    6.w),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    1.w),
                                                        thumbColor:
                                                            Colors.white,
                                                        activeTrackColor:
                                                            Colors.white,
                                                        inactiveTrackColor:
                                                            Colors.grey),
                                                    child: Slider(
                                                      value: controller
                                                          .setBrightness.value,
                                                      min: 0.0,
                                                      max: 1.0,
                                                      // divisions: duration.value.inSeconds.round(),
                                                      onChanged:
                                                          (double newValue) {
                                                        // position.value =
                                                        // Duration(seconds: newValue.toInt());
                                                        controller.setBrightness
                                                            .value = newValue;
                                                        ScreenBrightness()
                                                            .setScreenBrightness(
                                                                newValue);
                                                      },
                                                      mouseCursor: MouseCursor
                                                          .uncontrolled,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 55.w,
                                              height: 55.h,
                                              child: TextButton(
                                                onPressed: () {
                                                  controller
                                                          .brightVisible.value =
                                                      !controller
                                                          .brightVisible.value;
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 5),
                                                      () => controller
                                                          .brightVisible
                                                          .value = false);
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/icons/brightness.svg",
                                                  width: 25.w,
                                                  height: 25.h,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: width >= 600 ? 130.h : 75.h,
                                        right: 10.w,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible:
                                                  controller.volVisible.value,
                                              child: RotatedBox(
                                                quarterTurns: -1,
                                                child: SizedBox(
                                                  width: 90.w,
                                                  // margin: EdgeInsets.only(
                                                  //     top: 30.w,
                                                  //     bottom: 30.w,
                                                  //     left: 20.w,
                                                  //     right: 18.w),
                                                  child: SliderTheme(
                                                    data: SliderThemeData(
                                                        trackHeight: 2.w,
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    6.w),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    1.w),
                                                        thumbColor:
                                                            Colors.white,
                                                        activeTrackColor:
                                                            Colors.white,
                                                        inactiveTrackColor:
                                                            Colors.grey),
                                                    child: Slider(
                                                      value: controller
                                                          .setVolumeValue.value,
                                                      min: 0.0,
                                                      max: 1.0,
                                                      // divisions: duration.value.inSeconds.round(),
                                                      onChanged:
                                                          (double newValue) {
                                                        // position.value =
                                                        // Duration(seconds: newValue.toInt());
                                                        controller
                                                            .setVolumeValue
                                                            .value = newValue;
                                                        controller.setVolumeValue
                                                                    .value ==
                                                                0
                                                            ? controller.isMute
                                                                .value = true
                                                            : controller.isMute
                                                                .value = false;
                                                        controller
                                                            .setVolumeValue
                                                            .value = newValue;
                                                        // Volume.setVol(
                                                        //   androidVol: (controller
                                                        //               .setVolumeValue
                                                        //               .value *
                                                        //           100)
                                                        //       .toInt(),
                                                        //   iOSVol: controller
                                                        //       .setVolumeValue
                                                        //       .value,
                                                        //   showVolumeUI: false,
                                                        // );
                                                        controller.volController
                                                            .setVolume(
                                                                controller
                                                                    .setVolumeValue
                                                                    .value,
                                                                showSystemUI:
                                                                    false);
                                                        // controller
                                                        //     .controller.value
                                                        //     .setVolume(newValue);
                                                        // VolumeController()
                                                        //     .setVolume(newValue);
                                                      },
                                                      mouseCursor: MouseCursor
                                                          .uncontrolled,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 55.w,
                                              height: 55.h,
                                              child: TextButton(
                                                onPressed: () {
                                                  controller.volVisible.value =
                                                      !controller
                                                          .volVisible.value;
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 5),
                                                      () => controller
                                                          .volVisible
                                                          .value = false);
                                                },
                                                child:
                                                    Obx(() => SvgPicture.asset(
                                                          !controller
                                                                  .isMute.value
                                                              ? "assets/icons/volume.svg"
                                                              : "assets/icons/mute.svg",
                                                          fit: BoxFit.contain,
                                                          width: 25.w,
                                                          height: 25.h,
                                                        )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 15.h),
                                        alignment: Alignment.bottomCenter,
                                        // height: 220.h,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 30.w,
                                              bottom: 30.w,
                                              left: 20.w,
                                              right: 18.w),
                                          child: Obx(
                                            () => ProgressBar(
                                              // key: controller.value.mywidgetkey.value,
                                              barHeight: 2.h,
                                              baseBarColor: Colors.white,
                                              bufferedBarColor:
                                                  Colors.grey[300],
                                              progressBarColor: kColorPrimary,
                                              thumbColor: kColorPrimary,
                                              thumbRadius: 5.w,
                                              progress:
                                                  controller.position.value,
                                              total: controller.controller!.value
                                                  .value.duration,
                                              // buffered: controller.value
                                              //     .durationRangeToDuration(controller.value
                                              //         .controller.value.value.buffered),
                                              onSeek: (value) => networkService
                                                          .connectionStatus
                                                          .value ==
                                                      1
                                                  ? controller.controller!.value
                                                      .seekTo(value)
                                                  : null,
                                              timeLabelTextStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorWhite,
                                                  fontSize: 10.sp),
                                              barCapShape: BarCapShape.round,
                                              timeLabelPadding: 5.h,
                                              timeLabelType:
                                                  TimeLabelType.remainingTime,
                                            ),
                                          ),
                                        ), //Progress Bar
                                      ),
                                      //Bottom Bar Settings and Full Screen
                                      Positioned(
                                          bottom: 0.w,
                                          right: 10.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.to(
                                                    () => LandscapePlayer(),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  fixedSize: Size(50.w, 50.h),
                                                  minimumSize: Size(50.w, 50.h),
                                                  maximumSize: Size(50.w, 50.h),
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/icons/fullscreen.svg",
                                                  width: 55.w,
                                                  height: 55.h,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      constraints: BoxConstraints(
                                                          minWidth:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width),
                                                      context: context,
                                                      builder: (context) =>
                                                          Popup(),
                                                      isScrollControlled: true);
                                                },
                                                style: TextButton.styleFrom(
                                                  fixedSize: Size(55.w, 55.h),
                                                  minimumSize: Size(55.w, 55.h),
                                                  maximumSize: Size(55.w, 55.h),
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/icons/settings.svg",
                                                  width: 55.w,
                                                  height: 55.h,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : AspectRatio(
                            aspectRatio: aspectRatio,
                            child: Container(
                              color: kColorBlack,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: kColorPrimary,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
