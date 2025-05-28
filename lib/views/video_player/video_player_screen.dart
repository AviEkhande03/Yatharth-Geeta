import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import 'package:yatharthageeta/views/events/events_screen.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../controllers/video_player/video_player_controller.dart';
import '../../utils/utils.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/video_listing/video_listing_card.dart';
import '../../widgets/video_player/potrait_player.dart';
import '../../widgets/video_player/recent_videos.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    // Result videoDetails = Get.arguments!;'
    final networkService = Get.find<NetworkService>();

    VideoPlayerSreenController controller =
        Get.put(VideoPlayerSreenController());
    final scrollController = new ScrollController();

    // @override
    // void dispose() {
    //   if (controller.controller.value.value.isPlaying) {
    //     controller.controller.value.pause();
    //   }
    //   controller.controller.value.dispose();
    //   super.dispose();
    // }

    return Obx(
      () => WillPopScope(
        //canPop: controller.isInitialized.value,
        onWillPop: () async {
          //controller.controller.value.pause();
          //print("PopScope called in player- first part initial");
          //controller.controller.value.dispose();
          //print("PopScope called in player");
          // if(Platform.isIOS){
          //   print("Inside ios");
          //   //Get.delete<VideoPlayerSreenController>();
          //   controller.isInitialized.stream
          //       .listen((value) {
          //     if (value) {
          //       controller.controller.value
          //           .pause();
          //       //print("Paused 1");
          //     }
          //   });
          // }
          return controller.isInitialized.value;
          // if (controller.isInitialized.value) {
            
          //   // controller.isInitialized.value = false;
          // }
          // if (controller.controller.value.value.isPlaying) {
          //     controller.controller.value.pause();
          //   }
          // return true;
        },
        // onWillPop: () async {
        //   // controller.controller.dispose();
        //
        //   // await Get.delete<VideoPlayerSreenController>();
        //   return true;
        // },
        child: Container(
          color: kColorWhite,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: kColorWhite,
              body: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  // direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PotraitPlayer(
                        link: controller.videoDetails, aspectRatio: 6 / 4),
                    // AspectRatio(
                    //     aspectRatio: 16 / 9, child: YoutubePlayerWidget()),
                    // Opacity(
                    //   opacity: controller.isInitialized.value?1:0.3,
                    //   child:

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 20.w, left: 20.w, right: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.videoDetails.title.toString(),
                                style: kTextStylePoppinsRegular.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.sp),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                controller.videoDetails.artistName == '.' ||
                                        controller.videoDetails.artistName ==
                                            null ||
                                        controller.videoDetails.artistName == ''
                                    ? ''
                                    : "${'by'.tr} ${controller.videoDetails.artistName}"
                                        .tr,
                                style: kTextStylePoppinsRegular.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    color: const Color(0xffFEF8F6),
                                    margin: EdgeInsets.only(right: 10.w),
                                    padding: EdgeInsets.only(
                                        left: 12.w,
                                        right: 12.w,
                                        top: 2.h,
                                        bottom: 2.h),
                                    child: TextPoppins(
                                      text:
                                          "${controller.videoDetails.mediaLanguage}"
                                              .tr,
                                      color: kColorPrimary,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SvgPicture.asset("assets/icons/line.svg"),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    margin: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    child: TextPoppins(
                                      text: controller.videoDetails.durationTime
                                          .toString(),
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  // SvgPicture.asset("assets/icons/line.svg"),
                                  // Container(
                                  //   padding:
                                  //       EdgeInsets.only(left: 10.w, right: 10.w),
                                  //   margin:
                                  //       EdgeInsets.only(left: 10.w, right: 10.w),
                                  //   child: Row(children: [
                                  //     SvgPicture.asset(
                                  //       "assets/icons/eye.svg",
                                  //       color: Colors.black,
                                  //       width: 16.w,
                                  //     ),
                                  //     TextPoppins(
                                  //       text:
                                  //           "  ${controller.videoDetails.viewCount}",
                                  //       fontSize: 13.sp,
                                  //     ),
                                  //   ]),
                                  // )
                                  controller.videoDetails.viewCount != '0'
                                      ? SvgPicture.asset(
                                          "assets/icons/line.svg")
                                      : const SizedBox(),
                                  controller.videoDetails.viewCount != '0'
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          margin: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          child: Row(children: [
                                            SvgPicture.asset(
                                              "assets/icons/eye.svg",
                                              color: Colors.black,
                                              width: 16.w,
                                            ),
                                            TextPoppins(
                                              text:
                                                  "  ${controller.videoDetails.viewCount}",
                                              fontSize: 13.sp,
                                            ),
                                          ]),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 24.h),
                          color: kColorWhite2,
                          height: 16.h,
                        ),
                        !controller.isEpisode.value
                            ? !controller.videoDetails.hasEpisodes
                                ? Visibility(
                                    visible: controller.videoDetails
                                        .peopleAlsoViewData!.isNotEmpty,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 24.w, right: 20.w, top: 30.h),
                                      child: Text(
                                        'Related Videos'.tr,
                                        style: kTextStylePoppinsMedium.copyWith(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.videoDetails
                                        .videoEpisodes.episodesList!.isNotEmpty,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 24.w, right: 20.w, top: 30.h),
                                      child: Text(
                                        'Chapters'.tr,
                                        style: kTextStylePoppinsMedium.copyWith(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                            : Visibility(
                                visible: controller
                                    .videoDetails.restOfEpisode!.isNotEmpty,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 24.w, right: 20.w, top: 30.h),
                                  child: Text(
                                    'Chapters'.tr,
                                    style: kTextStylePoppinsMedium.copyWith(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                        !controller.isEpisode.value
                            ? controller.videoDetails.hasEpisodes!
                                ? Column(
                                    children: controller.videoDetails
                                        .videoEpisodes!.episodesList!
                                        .map<AspectRatio>((e) {
                                      log("Grey Screen is Initialized");
                                      return AspectRatio(
                                        aspectRatio: 3 / 1.25,
                                        child: Opacity(
                                          opacity:
                                              controller.isInitialized.value
                                                  ? 1
                                                  : 0.2,
                                          alwaysIncludeSemantics: true,
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (!controller
                                                  .isInitialized.value) {
                                                return;
                                              }
                                              Utils().showLoader();
                                              controller.isInitialized.stream
                                                  .listen((value) {
                                                if (value) {
                                                  controller.controller!.value
                                                      .pause();
                                                  print("Paused 1");
                                                }
                                              });
                                              await scrollController.animateTo(
                                                  0,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  curve: Curves.easeIn);
                                              log("Has Episode");
                                              if (controller.isPlaying.value) {
                                                controller.controller!.value
                                                    .pause();
                                              }
                                              controller.isEpisode.value = true;
                                              var detailsController = Get.find<
                                                  VideoDetailsController>();
                                              controller.videoDetails =
                                                  await detailsController
                                                      .fetchEpisodeDetails(
                                                          token: '',
                                                          ctx: context,
                                                          videoId: e.id,
                                                          isNext: false);
                                              setState(() {});
                                              log("Came here");
                                              Get.back();

                                              await controller
                                                  .initializeVideo();
                                              // controller.controller.pause();
                                              // var detailsController = Get.find<
                                              //     VideoDetailsController>();
                                              // //Call Ebooklisting API here
                                              // await detailsController
                                              //     .fetchVideoDetails(
                                              //         token: '',
                                              //         ctx: context,
                                              //         videoId: e.id,
                                              //         isNext: false);

                                              // Get.back();

                                              // if (!detailsController
                                              //     .isLoadingData.value) {
                                              //   Get.back();
                                              // }
                                            },
                                            child:
                                                /*RecentVideos(
                                                                                  imageUrl: e.coverImageUrl!,
                                                                                  title: e.title!,
                                                                                  artist: e.description!,
                                                                                  language: e.mediaLanguage!,
                                                                                  duration: e.durationTime!,
                                                                                  views: e.viewCount!)*/
                                                Opacity(
                                              opacity:
                                                  controller.isInitialized.value
                                                      ? 1
                                                      : 0.2,
                                              child: VideoListingCard(
                                                imageUrl: e.coverImageUrl!,
                                                title: e.title!,
                                                artist: e.description!,
                                                language: e.mediaLanguage!,
                                                duration: 0,
                                                views: '0',
                                                isEnd: false,
                                                durationTime: e.durationTime!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Column(
                                    children: controller
                                        .videoDetails.peopleAlsoViewData!
                                        .map<AspectRatio>((e) {
                                      log("");
                                      return AspectRatio(
                                        aspectRatio: 3 / 1.25,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (!controller
                                                .isInitialized.value) {
                                              return;
                                            }
                                            await scrollController.animateTo(0,
                                                duration: Duration(seconds: 1),
                                                curve: Curves.easeIn);
                                            Utils().showLoader();
                                            controller.isInitialized.stream
                                                .listen((value) {
                                              if (value) {
                                                controller.controller!.value
                                                    .pause();
                                                print("Paused 2");
                                              }
                                            });
                                            log("Does not Has Episodes");
                                            if (controller.isPlaying.value) {
                                              controller.controller!.value
                                                  .pause();
                                            }
                                            var detailsController = Get.find<
                                                VideoDetailsController>();
                                            controller.videoDetails =
                                                await detailsController
                                                    .fetchVideoDetails(
                                                        token: '',
                                                        ctx: context,
                                                        videoId: e.id,
                                                        isNext: false);
                                            setState(() {});
                                            Get.back();
                                            await controller.initializeVideo();
                                            // if (!detailsController
                                            //     .isLoadingData.value) {
                                            //   Get.back();
                                            // }
                                          },
                                          child:
                                              /*RecentVideos(
                                                                                imageUrl: e.coverImageUrl!,
                                                                                title: e.title!,
                                                                                artist: e.description!,
                                                                                language: e.mediaLanguage!,
                                                                                duration: e.durationTime!,
                                                                                views: e.viewCount!)*/
                                              Opacity(
                                            opacity:
                                                controller.isInitialized.value
                                                    ? 1
                                                    : 0.2,
                                            child: VideoListingCard(
                                              imageUrl: e.coverImageUrl!,
                                              title: e.title!,
                                              artist: e.description!,
                                              language: e.mediaLanguage!,
                                              duration: 0,
                                              views: e.viewCount!,
                                              isEnd: false,
                                              durationTime: e.durationTime!,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                            : Obx(() {
                                return Opacity(
                                  opacity:
                                      networkService.connectionStatus.value == 1
                                          ? 1
                                          : 0.2,
                                  child: Column(
                                    children: controller
                                        .videoDetails.restOfEpisode!
                                        .map<AspectRatio>((e) {
                                      return AspectRatio(
                                        aspectRatio: 3 / 1.25,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (networkService
                                                    .connectionStatus.value ==
                                                0) {
                                              log("no internet executed");
                                              Utils.customToast(
                                                  "Please check your internet connection"
                                                      .tr,
                                                  kColorWhite,
                                                  kRedColor,
                                                  "Error");
                                            } else {
                                              if (!controller
                                                  .isInitialized.value) {
                                                return;
                                              }
                                              await scrollController.animateTo(
                                                  0,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  curve: Curves.easeIn);
                                              Utils().showLoader();
                                              controller.isInitialized.stream
                                                  .listen((value) {
                                                if (value) {
                                                  controller.controller!.value
                                                      .pause();
                                                  print("Paused 3");
                                                }
                                              });
                                              log("Is Episode");
                                              if (controller.isPlaying.value) {
                                                controller.controller!.value
                                                    .pause();
                                              }
                                              controller.isEpisode.value = true;
                                              var detailsController = Get.find<
                                                  VideoDetailsController>();
                                              controller.videoDetails =
                                                  await detailsController
                                                      .fetchEpisodeDetails(
                                                          token: '',
                                                          ctx: context,
                                                          videoId: e.id,
                                                          isNext: false);
                                              setState(() {});
                                              log("Came here");
                                              Get.back();
                                              // ---
                                              log("initializeVideo executed");
                                              await controller
                                                  .initializeVideo();
                                            }

                                            // if (!detailsController
                                            //     .isLoadingData.value) {
                                            //   Get.back();
                                            // }
                                          },
                                          child:
                                              /*RecentVideos(
                                            imageUrl: e.coverImageUrl!,
                                            title: e.title!,
                                            artist: e.description!,
                                            language: e.mediaLanguage!,
                                            duration: e.durationTime!,
                                            views: e.viewCount!)*/
                                              VideoListingCard(
                                            imageUrl: e.coverImageUrl!,
                                            title: e.title!,
                                            artist: e.description!,
                                            language: e.mediaLanguage!,
                                            duration: 0,
                                            views: e.viewCount!,
                                            isEnd: false,
                                            durationTime: e.durationTime!,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),
                        SizedBox(
                          height: 100.h,
                        )
                      ],
                    ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
