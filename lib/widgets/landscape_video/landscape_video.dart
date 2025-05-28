import 'dart:developer';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
//import 'package:lecle_volume_flutter/lecle_volume_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/landscape_player/landscape_controller.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../controllers/video_player/video_player_controller.dart';
import '../../utils/utils.dart';
import '../common/text_poppins.dart';

class LandscapeVideo extends StatefulWidget {
  LandscapeVideo({Key? key}) : super(key: key);

  @override
  State<LandscapeVideo> createState() => _LandscapeVideoState();
}

class _LandscapeVideoState extends State<LandscapeVideo> {
  final VideoPlayerSreenController controller =
      Get.find<VideoPlayerSreenController>();

  final LandscapeController _controller = Get.put(LandscapeController());

  @override
  Widget build(BuildContext context) {
    var networkService = Get.find<NetworkService>();
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (!_controller.lock.value) {
            _controller.isVisible.value = !_controller.isVisible.value;
            Future.delayed(const Duration(seconds: 10), () {
              _controller.isVisible.value = false;
            });
          }
        },
        child: controller.isInitialized.value
            ? Stack(
                // fit: StackFit.expand,
                // clipBehavior: Clip.antiAlias,
                children: [
                  VideoPlayer(controller.controller!.value), //Video Player
                  Obx(
                    () => controller.caption.isNotEmpty
                        ? ClosedCaption(
                            text: controller.currentSubtitle?.data,
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ), //Captions
                  Visibility(
                    visible: _controller.isVisible.value,
                    // visible: true,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.black45),
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 2.w,
                            top: 2.w,
                            child: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/back.svg",
                                  color: kColorWhite,
                                  width: 25.w,
                                  height: 25.h,
                                )),
                          ),
                          Positioned(
                              left: 30.w,
                              top: 7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.videoDetails.title!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width >= 600 ? 10.sp : 8.sp),
                                  ),
                                  Text(
                                    controller.videoDetails.artistName!,
                                    style: TextStyle(color: Colors.white54),
                                  )
                                ],
                              )),
                          Center(
                            child: SizedBox(
                              width: 250.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    child: SvgPicture.asset(
                                      "assets/icons/reverse.svg",
                                      color: networkService
                                                  .connectionStatus.value ==
                                              1
                                          ? null
                                          : Colors.grey,
                                      // width: width >= 600 ? 40.w : 25.w,
                                      // height: width >= 600 ? 40.h : 25.h,
                                    ),
                                    onPressed: () {
                                      if (networkService
                                              .connectionStatus.value ==
                                          1) {
                                        controller.controller!.value.seekTo(
                                            controller.controller!.value.value
                                                    .position -
                                                const Duration(seconds: 10));
                                      } else {
                                        return;
                                      }
                                    },
                                  ),
                                  Obx(
                                    () => controller.internetGone.value
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: kColorPrimary,
                                            ),
                                          )
                                        : TextButton(
                                            child: SvgPicture.asset(
                                              controller.isPlaying.value
                                                  ? "assets/icons/pause_video.svg"
                                                  : "assets/icons/play_video.svg",
                                              // width: width >= 600 ? 40.w : 40.w,
                                              // height: width >= 600 ? 40.h : 40.h,
                                            ),
                                            onPressed: () {
                                              controller.isPlaying.value =
                                                  !controller.isPlaying.value;
                                              controller.controller!.value.value
                                                      .isPlaying
                                                  ? controller.controller!.value
                                                      .pause()
                                                  : controller.controller!.value
                                                      .play();
                                            },
                                          ),
                                  ),
                                  TextButton(
                                    child: SvgPicture.asset(
                                      "assets/icons/forward.svg",
                                      color: networkService
                                              .connectionStatus.value ==
                                          1 ? null : Colors.grey,
                                      // width: width >= 600 ? 40.w : 25.w,
                                      // height: width >= 600 ? 40.h : 25.h,
                                    ),
                                    onPressed: () {
                                      if (networkService
                                              .connectionStatus.value ==
                                          1) {
                                        controller.controller!.value.seekTo(
                                            controller.controller!.value.value
                                                    .position +
                                                const Duration(seconds: 10));
                                      } else {
                                        return;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ), //Controls
                          Positioned(
                            bottom: 180.h,
                            left: 30.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: controller.brightVisible.value,
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
                                            trackHeight: 2.h,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 6.h),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 1.h),
                                            thumbColor: Colors.white,
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.grey),
                                        child: Slider(
                                          value: controller.setBrightness.value,
                                          min: 0.0,
                                          max: 1.0,
                                          // divisions: duration.value.inSeconds.round(),
                                          onChanged: (double newValue) {
                                            // position.value =
                                            // Duration(seconds: newValue.toInt());
                                            controller.setBrightness.value =
                                                newValue;
                                            ScreenBrightness()
                                                .setScreenBrightness(newValue);
                                          },
                                          mouseCursor: MouseCursor.uncontrolled,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                  height: 30.h,
                                  child: InkWell(
                                    onTap: () {
                                      controller.brightVisible.value =
                                          !controller.brightVisible.value;
                                      Future.delayed(
                                          const Duration(seconds: 5),
                                          () => controller.brightVisible.value =
                                              false);
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/brightness.svg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 180.h,
                            right: 30.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: controller.volVisible.value,
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
                                            trackHeight: 2.h,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 6.h),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 1.h),
                                            thumbColor: Colors.white,
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.grey),
                                        child: Slider(
                                          value:
                                              controller.setVolumeValue.value,
                                          min: 0.0,
                                          max: 1.0,
                                          // divisions: duration.value.inSeconds.round(),
                                          onChanged: (double newValue) {
                                            // position.value =
                                            // Duration(seconds: newValue.toInt());
                                            controller.setVolumeValue.value =
                                                newValue;
                                            controller.setVolumeValue.value == 0
                                                ? controller.isMute.value = true
                                                : controller.isMute.value =
                                                    false;
                                            controller.setVolumeValue.value =
                                                newValue;
                                            controller.volController.setVolume(
                                                controller.setVolumeValue.value,
                                                showSystemUI: false);
                                            // controller.controller.value
                                            //     .setVolume(newValue);
                                            // Volume.setVol(
                                            //   androidVol: (controller
                                            //               .setVolumeValue
                                            //               .value *
                                            //           15)
                                            //       .toInt(),
                                            //   iOSVol: controller
                                            //       .setVolumeValue.value,
                                            //   showVolumeUI: false,
                                            // );
                                          },
                                          mouseCursor: MouseCursor.uncontrolled,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                  height: 30.h,
                                  child: InkWell(
                                    onTap: () {
                                      controller.volVisible.value =
                                          !controller.volVisible.value;
                                      Future.delayed(
                                          const Duration(seconds: 5),
                                          () => controller.volVisible.value =
                                              false);
                                    },
                                    child: Obx(() => SvgPicture.asset(
                                          !controller.isMute.value
                                              ? "assets/icons/volume.svg"
                                              : "assets/icons/mute.svg",
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 20.h),
                            alignment: Alignment.bottomCenter,
                            // height: 100.h,
                            width: double.infinity,
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 45.w,
                                  bottom: 30.w,
                                  left: 20.w,
                                  right: 18.w),
                              // child: SliderTheme(
                              //   data: SliderThemeData(
                              //     trackHeight: 1.w,
                              //     thumbShape: RoundSliderThumbShape(
                              //         enabledThumbRadius: 3.w),
                              //     overlayShape: RoundSliderOverlayShape(
                              //         overlayRadius: 4.w),
                              //     thumbColor: kColorPrimary,
                              //     activeTrackColor: kColorPrimary,
                              //     inactiveTrackColor: Colors.grey,
                              //     showValueIndicator:
                              //         ShowValueIndicator.always,
                              //   ),
                              //   child: Slider(
                              //     label: controller.formatDuration(
                              //         controller.position.value),
                              //     value: controller.position.value.inSeconds
                              //         .toDouble(),
                              //     min: 0.0,
                              //     max: controller.duration.value.inSeconds
                              //         .toDouble(),
                              //     // divisions: duration.value.inSeconds.round(),
                              //     onChanged: (double newValue) {
                              //       // position.value =
                              //       // Duration(seconds: newValue.toInt());
                              //       controller.controller.seekTo(
                              //           Duration(seconds: newValue.toInt()));
                              //     },
                              //     mouseCursor: MouseCursor.defer,
                              //   ),
                              // ),
                              child: Obx(
                                () => ProgressBar(
                                  // key: controller.mywidgetkey.value,
                                  barHeight: 2.h,
                                  baseBarColor: Colors.white,
                                  bufferedBarColor: Colors.grey[300],
                                  progressBarColor: kColorPrimary,
                                  thumbColor: kColorPrimary,
                                  thumbRadius: 5.h,
                                  progress: controller.position.value,
                                  total: controller
                                      .controller!.value.value.duration,
                                  // buffered: controller
                                  //     .durationRangeToDuration(controller
                                  //         .controller.value.buffered),
                                  onSeek: (value) =>
                                      networkService.connectionStatus.value == 1
                                          ? controller.controller!.value
                                              .seekTo(value)
                                          : null,
                                  timeLabelTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: kColorWhite,
                                      fontSize: 6.sp),
                                  barCapShape: BarCapShape.round,
                                  timeLabelPadding: 5.h,
                                  timeLabelType: TimeLabelType.remainingTime,
                                ),
                              ),
                            ), //Progress Bar
                          ),
                          // Container(
                          //     padding: EdgeInsets.only(
                          //         top: 420.h, left: 25.w, right: 25.w),
                          //     //Duration
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         RichText(
                          //           text: TextSpan(
                          //             text: controller.formatDuration(
                          //                 controller.position.value),
                          //             style: const TextStyle(
                          //               fontSize: 10.0,
                          //               color: Colors.white,
                          //               decoration: TextDecoration.none,
                          //             ),
                          //           ),
                          //         ),
                          //         Text(
                          //           controller.formatDuration(
                          //               controller.duration.value),
                          //           style: const TextStyle(
                          //             fontSize: 10.0,
                          //             color: Colors.white,
                          //             decoration: TextDecoration.none,
                          //           ),
                          //         ),
                          //       ],
                          //     )),
                          //Bottom Bar Settings and Full Screen
                          Positioned(
                              top: 2.h,
                              right: 10.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _controller.lock.value =
                                          !_controller.lock.value;
                                      _controller.isVisible.value = false;
                                    },
                                    style: TextButton.styleFrom(
                                      fixedSize: Size(30.w, 30.w),
                                      minimumSize: Size(30.w, 30.w),
                                      maximumSize: Size(30.w, 30.w),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/lock.svg",
                                      width: 20.w,
                                      height: 20.w,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: TextButton.styleFrom(
                                      fixedSize: Size(35.w, 35.w),
                                      minimumSize: Size(35.w, 35.w),
                                      maximumSize: Size(35.w, 35.w),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/minimize.svg",
                                      width: 35.w,
                                      height: 35.w,
                                    ),
                                  ),
                                ],
                              )),
                          Align(
                              // bottom: 16,
                              // right: 48.w,
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     // Get.defaultDialog(content: Popup());
                                    //     getBottomSheet(0, context);
                                    //   },
                                    //   child: Row(
                                    //     children: [
                                    //       SvgPicture.asset(
                                    //           "assets/icons/quality.svg"),
                                    //       SizedBox(
                                    //         width: 4.w,
                                    //       ),
                                    //       Text(
                                    //         "Quality".tr,
                                    //         style: TextStyle(
                                    //           color: Colors.white,
                                    //           fontSize: 8.sp,
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 16.w,
                                    // ),
                                    GestureDetector(
                                      onTap: () => getBottomSheet(0, context),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/playback.svg"),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Text(
                                            "Playback Speed".tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8.sp,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                    networkService.connectionStatus == 0
                                        ? SizedBox.shrink()
                                        : Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/icons/play1.svg"),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  controller.isInitialized
                                                      .value = false;
                                                  print("Next Called");
                                                  controller.controller!.value
                                                      .pause();
                                                  if (controller
                                                      .isEpisode.value) {
                                                    print("Is Episode");
                                                    if (controller
                                                            .videoDetails
                                                            .restOfEpisode!
                                                            .length ==
                                                        0) {
                                                      Utils.customToast(
                                                          "No Next Video".tr,
                                                          kRedColor,
                                                          kRedColor
                                                              .withOpacity(0.2),
                                                          "error");
                                                      controller.isInitialized
                                                          .value = true;
                                                      return;
                                                    }
                                                    controller.controller!.value
                                                        .pause();
                                                    controller.isEpisode.value =
                                                        true;
                                                    var detailsController =
                                                        Get.find<
                                                            VideoDetailsController>();
                                                    //Call Ebooklisting API here
                                                    controller.videoDetails =
                                                        await detailsController.fetchEpisodeDetails(
                                                            token: '',
                                                            ctx: context,
                                                            videoId: controller
                                                                .videoDetails
                                                                .restOfEpisode!
                                                                .first
                                                                .id,
                                                            isNext: false);
                                                    // setState(() {});
                                                    log("Came here");
                                                    Get.back();
                                                    await controller
                                                        .initializeVideo();

                                                    return;
                                                  }
                                                  if (controller.videoDetails
                                                          .hasEpisodes &&
                                                      controller
                                                              .videoDetails
                                                              .videoEpisodes!
                                                              .episodesList!
                                                              .length >
                                                          0) {
                                                    controller.controller!.value
                                                        .pause();
                                                    controller.isEpisode.value =
                                                        true;
                                                    var detailsController =
                                                        Get.find<
                                                            VideoDetailsController>();
                                                    //Call Ebooklisting API here
                                                    controller.videoDetails =
                                                        await detailsController
                                                            .fetchEpisodeDetails(
                                                                token: '',
                                                                ctx: context,
                                                                videoId: controller
                                                                    .videoDetails
                                                                    .videoEpisodes!
                                                                    .episodesList!
                                                                    .first
                                                                    .id,
                                                                isNext: false);
                                                    // setState(() {});
                                                    log("Came here");
                                                    // Get.back();

                                                    await controller
                                                        .initializeVideo();
                                                  }
                                                  await Get.find<
                                                          VideoDetailsController>()
                                                      .fetchVideoDetails(
                                                          videoId: controller
                                                              .videoDetails.id,
                                                          isNext: true);

                                                  if (Get.find<
                                                          VideoDetailsController>()
                                                      .nextVideo
                                                      .value) {
                                                    // Utils().showLoader();
                                                    controller.controller!.value
                                                        .pause();
                                                    // Get.back();
                                                    controller.isInitialized
                                                        .value = false;
                                                    controller.isPlaying.value =
                                                        false;
                                                    controller
                                                        .videoDetails = Get.find<
                                                            VideoDetailsController>()
                                                        .videoDetails
                                                        .value!;

                                                    controller.manifest = await controller
                                                        .yt.videos.streamsClient
                                                        .getManifest(controller
                                                            .getYouTubeVideoId(
                                                                controller
                                                                    .videoDetails!
                                                                    .link!));
                                                    controller.qualities.value =
                                                        controller
                                                            .manifest!.muxed
                                                            .toList();
                                                    yt.MuxedStreamInfo
                                                        streamInfo = controller
                                                            .manifest!
                                                            .muxed
                                                            .bestQuality;
                                                    var url = streamInfo.url;
                                                    log(url.toString());
                                                    controller
                                                            .controller!.value =
                                                        VideoPlayerController
                                                            .networkUrl(url,
                                                                videoPlayerOptions:
                                                                    VideoPlayerOptions())
                                                          ..initialize().then(
                                                              (value) async {
                                                            controller
                                                                .isInitialized
                                                                .value = true;
                                                            controller
                                                                .controller!
                                                                .value
                                                                .play();
                                                            controller.isPlaying
                                                                .value = true;
                                                            controller.isPlaying
                                                                .value = true;
                                                            await controller
                                                                .controller!
                                                                .value
                                                                .setLooping(
                                                                    true);
                                                          });
                                                    controller.controller!.value
                                                        .addListener(() {
                                                      controller
                                                              .position.value =
                                                          controller
                                                              .controller!
                                                              .value
                                                              .value
                                                              .position;
                                                      controller.sliderVal
                                                          .value = controller
                                                              .position
                                                              .value
                                                              .inSeconds /
                                                          controller.duration
                                                              .value.inSeconds;
                                                    });
                                                    Get.back();
                                                  } else {
                                                    Utils.customToast(
                                                        "No next video".tr,
                                                        kColorBlackWithOpacity75,
                                                        Color(0xff515151),
                                                        "Error");
                                                  }
                                                },
                                                child: Text(
                                                  "Next Video".tr,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8.sp,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _controller.lock.value,
                    child: Positioned(
                      top: 2.h,
                      right: 35.w,
                      child: TextButton(
                        onPressed: () {
                          _controller.lock.value = !_controller.lock.value;
                          controller.isVisible.value = false;
                        },
                        style: TextButton.styleFrom(
                          fixedSize: Size(35.w, 35.w),
                          minimumSize: Size(35.w, 35.w),
                          maximumSize: Size(35.w, 35.w),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/minus.svg",
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: kColorPrimary,
                ),
              ),
      ),
    );
  }

  void getBottomSheet(int num, BuildContext context) {
    controller.tabController.index = num;
    showModalBottomSheet(
      // backgroundColor: Colors.black,
      // title: "Settings",
      // titleStyle: TextStyle(
      //     color: Colors.white,
      //     fontWeight: FontWeight.w400),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      context: context,
      builder: (context) => Container(
          // height: 180.h,
          color: Colors.transparent,
          margin: Platform.isIOS
              ? EdgeInsets.zero
              : EdgeInsets.only(left: 200.h, right: 200.h),
          height: 310.h,
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.h),
                    topRight: Radius.circular(20.h)),
                color: kColorWhite),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Settings".tr,
                      style: TextStyle(
                          color: kColorFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          // color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(
                  height: 2.w,
                ),
                TabBar(
                  labelColor: kColorPrimary,
                  unselectedLabelColor: kColorFont,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 8.sp),
                  indicatorColor: Colors.white,
                  indicator: const BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          image: AssetImage("assets/icons/indicator.png"))),
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: EdgeInsets.zero,
                  tabs: [
                    // Tab(
                    //   text: "Quality".tr,
                    // ),
                    Tab(
                      text: "Playback Speed".tr,
                    ),
                    // Tab(
                    //   text: "Subtitle",
                    // ),
                  ],
                  controller: controller.tabController,
                ),
                SizedBox(
                    height: 150.h,
                    child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          // SingleChildScrollView(
                          //   child: Obx(
                          //     () => Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       // children: [
                          //       //   RadioListTile(
                          //       //       // onPressed: () {},
                          //       //       controlAffinity:
                          //       //           ListTileControlAffinity.leading,
                          //       //       groupValue:
                          //       //           controller.qualityGroupValue.value,
                          //       //       onChanged: (val) {
                          //       //         controller.qualityGroupValue.value =
                          //       //             val!;
                          //       //       },
                          //       //       activeColor: kColorPrimary,
                          //       //       value: "Full HD upto 1080p",
                          //       //       title: Text.rich(
                          //       //         TextSpan(text: "Full HD ", children: [
                          //       //           TextSpan(
                          //       //               text: "upto 1080p",
                          //       //               style: kTextStylePoppinsMedium
                          //       //                   .copyWith(
                          //       //                 fontWeight: FontWeight.w300,
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "Full HD upto 1080p"
                          //       //                     ? kColorPrimary
                          //       //                         .withOpacity(0.5)
                          //       //                     : Colors.black
                          //       //                         .withOpacity(0.5),
                          //       //               ))
                          //       //         ]),
                          //       //         style:
                          //       //             kTextStylePoppinsRegular.copyWith(
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "Full HD upto 1080p"
                          //       //                     ? kColorPrimary
                          //       //                     : Colors.black,
                          //       //                 fontWeight: FontWeight.w600),
                          //       //       )),
                          //       //   RadioListTile(
                          //       //       // onPressed: () {},
                          //       //       controlAffinity:
                          //       //           ListTileControlAffinity.leading,
                          //       //       groupValue:
                          //       //           controller.qualityGroupValue.value,
                          //       //       onChanged: (val) {
                          //       //         controller.qualityGroupValue.value =
                          //       //             val!;
                          //       //       },
                          //       //       activeColor: kColorPrimary,
                          //       //       value: "HD upto 1080p",
                          //       //       title: Text.rich(
                          //       //         TextSpan(text: "HD ", children: [
                          //       //           TextSpan(
                          //       //               text: "upto 720p",
                          //       //               style: kTextStylePoppinsMedium
                          //       //                   .copyWith(
                          //       //                 fontWeight: FontWeight.w300,
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "HD upto 720p"
                          //       //                     ? kColorPrimary
                          //       //                         .withOpacity(0.5)
                          //       //                     : Colors.black
                          //       //                         .withOpacity(0.5),
                          //       //               ))
                          //       //         ]),
                          //       //         style:
                          //       //             kTextStylePoppinsRegular.copyWith(
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "HD upto 720p"
                          //       //                     ? kColorPrimary
                          //       //                     : Colors.black,
                          //       //                 fontWeight: FontWeight.w600),
                          //       //       )),
                          //       //   RadioListTile(
                          //       //       // onPressed: () {},
                          //       //       controlAffinity:
                          //       //           ListTileControlAffinity.leading,
                          //       //       groupValue:
                          //       //           controller.qualityGroupValue.value,
                          //       //       onChanged: (val) {
                          //       //         controller.qualityGroupValue.value =
                          //       //             val!;
                          //       //       },
                          //       //       activeColor: kColorPrimary,
                          //       //       value: "SD upto 480p",
                          //       //       title: Text.rich(
                          //       //         TextSpan(text: "SD ", children: [
                          //       //           TextSpan(
                          //       //               text: "upto 480p",
                          //       //               style: kTextStylePoppinsMedium
                          //       //                   .copyWith(
                          //       //                 fontWeight: FontWeight.w300,
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "SD upto 480p"
                          //       //                     ? kColorPrimary
                          //       //                         .withOpacity(0.5)
                          //       //                     : Colors.black
                          //       //                         .withOpacity(0.5),
                          //       //               ))
                          //       //         ]),
                          //       //         style:
                          //       //             kTextStylePoppinsRegular.copyWith(
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "SD upto 480p"
                          //       //                     ? kColorPrimary
                          //       //                     : Colors.black,
                          //       //                 fontWeight: FontWeight.w600),
                          //       //       )),
                          //       //   RadioListTile(
                          //       //       // onPressed: () {},
                          //       //       controlAffinity:
                          //       //           ListTileControlAffinity.leading,
                          //       //       groupValue:
                          //       //           controller.qualityGroupValue.value,
                          //       //       onChanged: (val) {
                          //       //         controller.qualityGroupValue.value =
                          //       //             val!;
                          //       //       },
                          //       //       activeColor: kColorPrimary,
                          //       //       value: "Low Data Saver",
                          //       //       title: Text.rich(
                          //       //         TextSpan(text: "Low ", children: [
                          //       //           TextSpan(
                          //       //               text: "Data Saver",
                          //       //               style: kTextStylePoppinsMedium
                          //       //                   .copyWith(
                          //       //                 fontWeight: FontWeight.w300,
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "Low Data Saver"
                          //       //                     ? kColorPrimary
                          //       //                         .withOpacity(0.5)
                          //       //                     : Colors.black
                          //       //                         .withOpacity(0.5),
                          //       //               ))
                          //       //         ]),
                          //       //         style:
                          //       //             kTextStylePoppinsRegular.copyWith(
                          //       //                 color: controller
                          //       //                             .qualityGroupValue
                          //       //                             .value ==
                          //       //                         "Low Data Saver"
                          //       //                     ? kColorPrimary
                          //       //                     : Colors.black,
                          //       //                 fontWeight: FontWeight.w600),
                          //       //       )),
                          //       //   SizedBox(
                          //       //     height: 20.h,
                          //       //   )
                          //       // ],
                          //       children: controller.qualities.map((element) {
                          //         var quality = element.qualityLabel == "144p"
                          //             ? "${"Low".tr} "
                          //             : element.qualityLabel == "240p"
                          //                 ? "${"Low".tr} "
                          //                 : element.qualityLabel == "360p"
                          //                     ? "${"SD".tr} "
                          //                     : element.qualityLabel == "480p"
                          //                         ? "${"SD".tr} "
                          //                         : element.qualityLabel ==
                          //                                 "720p"
                          //                             ? "${"HD".tr} "
                          //                             : "${"Full HD".tr} ";
                          //         quality +=
                          //             "${"upto".tr} ${element.qualityLabel}";
                          //         return RadioListTile(
                          //             // onPressed: () {},
                          //             controlAffinity:
                          //                 ListTileControlAffinity.leading,
                          //             groupValue:
                          //                 controller.qualityGroupValue.value,
                          //             onChanged: (val) {
                          //               controller.controller.value.pause();
                          //               controller.qualityGroupValue.value =
                          //                   val!;
                          //               Duration position = controller
                          //                   .controller.value.value.position;
                          //               controller.isPlaying.value = false;
                          //               controller.isInitialized.value = false;
                          //               controller.controller.value =
                          //                   VideoPlayerController.contentUri(
                          //                       element.url,
                          //                       videoPlayerOptions:
                          //                           VideoPlayerOptions())
                          //                     ..initialize().then((value) {
                          //                       controller.controller.value
                          //                           .seekTo(position);
                          //                       controller.isInitialized.value =
                          //                           true;
                          //                       controller.controller.value
                          //                           .play();
                          //                       controller.isPlaying.value =
                          //                           true;
                          //                     });
                          //               controller.controller.value
                          //                   .addListener(() {
                          //                 controller.position.value = controller
                          //                     .controller.value.value.position;
                          //                 controller.sliderVal.value =
                          //                     controller.position.value
                          //                             .inSeconds /
                          //                         controller
                          //                             .duration.value.inSeconds;
                          //               });
                          //             },
                          //             visualDensity: const VisualDensity(
                          //                 vertical:
                          //                     VisualDensity.minimumDensity,
                          //                 horizontal:
                          //                     VisualDensity.minimumDensity),
                          //             activeColor: kColorPrimary,
                          //             value: quality,
                          //             title: Text.rich(
                          //               TextSpan(
                          //                   text: element.qualityLabel == "144p"
                          //                       ? "${"Low".tr} "
                          //                       : element.qualityLabel == "240p"
                          //                           ? "${"Low".tr} "
                          //                           : element.qualityLabel ==
                          //                                   "360p"
                          //                               ? "${"SD".tr} "
                          //                               : element.qualityLabel ==
                          //                                       "480p"
                          //                                   ? "${"SD".tr} "
                          //                                   : element.qualityLabel ==
                          //                                           "720p"
                          //                                       ? "${"HD".tr} "
                          //                                       : "${"Full HD".tr} ",
                          //                   style: TextStyle(
                          //                     fontWeight: FontWeight.w600,
                          //                     fontSize: 8.sp,
                          //                   ),
                          //                   children: [
                          //                     TextSpan(
                          //                         text:
                          //                             "${"upto".tr} ${element.qualityLabel}",
                          //                         style: kTextStylePoppinsMedium
                          //                             .copyWith(
                          //                           fontWeight: FontWeight.w300,
                          //                           fontSize: 9.sp,
                          //                           color: controller
                          //                                       .qualityGroupValue
                          //                                       .value ==
                          //                                   quality
                          //                               ? kColorPrimary
                          //                                   .withOpacity(0.5)
                          //                               : Colors.black
                          //                                   .withOpacity(0.5),
                          //                         ))
                          //                   ]),
                          //               style:
                          //                   kTextStylePoppinsRegular.copyWith(
                          //                       color: controller
                          //                                   .qualityGroupValue
                          //                                   .value ==
                          //                               quality
                          //                           ? kColorPrimary
                          //                           : Colors.black,
                          //                       fontSize: 10.sp,
                          //                       fontWeight: FontWeight.w600),
                          //             ));
                          //       }).toList(),
                          //     ),
                          //   ),
                          // ),

                          Obx(
                            () => SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.playback.value = 4;
                                        controller.controller!.value
                                            .setPlaybackSpeed(1);
                                      },
                                      groupValue: controller.playback.value,
                                      value: 4,
                                      activeColor: kColorPrimary,
                                      title: TextPoppins(
                                          text: "Normal".tr,
                                          color: controller.playback.value == 4
                                              ? kColorPrimary
                                              : Colors.black)),
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.controller!.value
                                            .setPlaybackSpeed(0.25);
                                        controller.playback.value = val!;
                                      },
                                      value: 1,
                                      groupValue: controller.playback.value,
                                      title: TextPoppins(
                                          text: "0.25x",
                                          color: controller.playback.value == 1
                                              ? kColorPrimary
                                              : Colors.black)),
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.playback.value = val!;
                                        controller.controller!.value
                                            .setPlaybackSpeed(0.5);
                                      },
                                      activeColor: kColorPrimary,
                                      value: 2,
                                      groupValue: controller.playback.value,
                                      title: TextPoppins(
                                          text: "0.5x",
                                          color: controller.playback.value == 2
                                              ? kColorPrimary
                                              : Colors.black)),
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.playback.value = 3;
                                        controller.controller!.value
                                            .setPlaybackSpeed(0.75);
                                      },
                                      groupValue: controller.playback.value,
                                      value: 3,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: kColorPrimary,
                                      title: TextPoppins(
                                          text: "0.75x",
                                          color: controller.playback.value == 3
                                              ? kColorPrimary
                                              : Colors.black)),
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.controller!.value
                                            .setPlaybackSpeed(1.25);
                                        controller.playback.value = 5;
                                      },
                                      groupValue: controller.playback.value,
                                      value: 5,
                                      activeColor: kColorPrimary,
                                      title: TextPoppins(
                                          text: "1.25x",
                                          color: controller.playback.value == 5
                                              ? kColorPrimary
                                              : Colors.black)),
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.playback.value = 6;
                                        controller.controller!.value
                                            .setPlaybackSpeed(1.5);
                                      },
                                      groupValue: controller.playback.value,
                                      value: 6,
                                      activeColor: kColorPrimary,
                                      title: TextPoppins(
                                          text: "1.5x",
                                          color: controller.playback.value == 6
                                              ? kColorPrimary
                                              : Colors.black)),
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.playback.value = 7;
                                        controller.controller!.value
                                            .setPlaybackSpeed(1.75);
                                      },
                                      groupValue: controller.playback.value,
                                      value: 7,
                                      activeColor: kColorPrimary,
                                      title: TextPoppins(
                                          text: "1.75x",
                                          color: controller.playback.value == 7
                                              ? kColorPrimary
                                              : Colors.black)),
                                  RadioListTile(
                                      onChanged: (val) {
                                        controller.playback.value = 8;
                                        controller.controller!.value
                                            .setPlaybackSpeed(2);
                                      },
                                      groupValue: controller.playback.value,
                                      value: 8,
                                      activeColor: kColorPrimary,
                                      title: TextPoppins(
                                          text: "2x",
                                          color: controller.playback.value == 8
                                              ? kColorPrimary
                                              : Colors.black)),
                                  SizedBox(
                                    height: 20.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ])),
              ],
            ),
          )),
      isScrollControlled: true,
    );
  }
}
