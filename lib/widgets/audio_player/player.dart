import 'dart:async';
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:yatharthageeta/controllers/shlokas_listing/shlokas_listing_controller.dart';
import 'package:yatharthageeta/controllers/startup/startup_controller.dart';
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:yatharthageeta/services/download/download_service.dart';
import 'package:yatharthageeta/widgets/common/profile_bottom_dialogs.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../models/audio_player/position_data.dart';
import '../../utils/utils.dart';
import 'controls.dart';
import '../common/text_poppins.dart';

class Player extends StatefulWidget {
  final int index;
  final Duration duration;

  const Player({
    Key? key,
    required this.index,
    required this.duration,
  }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  // final mywidgetkey = GlobalKey();
  MediaItem? metaData; // Holds the current media item's metadata
  String id = '';

  PlayerController controller = Get.find<PlayerController>();
  // PlayerController shlokasController = Get.find<ShlokasListingController>();
  DownloadService downloadService = Get.find<DownloadService>();

  // Stream for position data (current position, buffered position, and duration)
  Stream<PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        controller.audioPlayer.value.positionStream,
        controller.audioPlayer.value.bufferedPositionStream,
        controller.audioPlayer.value.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    // controller.changeIndex(index - 1, duration);

    return GestureDetector(
      // onVerticalDragStart: (details) {
      //   controller.startPos.value = details.globalPosition;
      // },
      // onVerticalDragUpdate: (details) {
      //   controller.endPos.value = details.globalPosition;
      // },
      // onVerticalDragEnd: (details) {
      //   if (controller.startPos.value.distance -
      //           controller.endPos.value.distance <
      //       Offset.zero.distance) {
      //     Get.back();
      //   }
      // },
      onTap: () {},
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [kColorPrimary, Color(0xff1c1b1b)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        padding: EdgeInsets.only(top: 50.h),
        child: Column(
          children: [
            // Stream Builder to fetch the mediaitem from the current source
            StreamBuilder<SequenceState?>(
                stream: controller.audioPlayer.value.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state?.currentSource!.tag as MediaItem;
                  metaData = metadata;
                  // Changing the id so that there is no conflict in the metadata
                  id = metadata.extras!["type"] == 'Shloka'
                      ? metadata.title + " " + metadata.displaySubtitle!
                      : metadata.title;
                  //debugPrint("idgfgfg:$id");
                  //-- VAIBHAV CHANGE 04/03/25
                  //-- created seprated widget
                  log("UI Updated: ${metadata.title}, Subtitle: ${metadata.displaySubtitle}");
                  return _buildUI(metadata); // Update UI normally
                }),
            SizedBox(
              height: 16.h,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data;
                    // controller.currPos.value =
                    //     position.position.inSeconds.toDouble();
                    return Container(
                      height: 40.w,
                      margin: EdgeInsets.only(
                        left: 30.w,
                        right: 30.w,
                      ),
                      child: Container(
                        // height: 22.5.h,
                        padding: EdgeInsets.only(top: 25.h),

                        // child: Obx(
                        //   () => ProgressBar(
                        //     key: controller.mywidgetkey.value,
                        //     barHeight: 2.h,
                        //     baseBarColor: Colors.white,
                        //     bufferedBarColor: Colors.grey[300],
                        //     progressBarColor: kColorPrimary,
                        //     thumbColor: kColorPrimary,
                        //     thumbRadius: 5.w,
                        //     progress: !controller.internetGone.value
                        //         ? position?.position ?? Duration.zero
                        //         : Duration.zero,
                        //     total: !controller.internetGone.value
                        //         ? controller.duration.value ?? Duration.zero
                        //         : Duration.zero,
                        //     buffered: !controller.internetGone.value
                        //         ? position?.bufferedPosition ?? Duration.zero
                        //         : Duration.zero,
                        //     onSeek: (value) =>
                        //         controller.audioPlayer.value.seek(value),
                        // timeLabelTextStyle: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     color: kColorWhite,
                        //     fontSize: 10.sp),
                        //     barCapShape: BarCapShape.round,
                        //     timeLabelPadding: 10.w,
                        //     timeLabelType: TimeLabelType.totalTime,
                        //   ),
                        // ),

                        // this is seek baar
                        child: StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data;
                              return Container(
                                // padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                child: ProgressBar(
                                  barHeight: 5.h,
                                  baseBarColor: const Color(0xff957E64),
                                  bufferedBarColor: const Color(0xff957E64),
                                  progressBarColor: kColorPrimary,
                                  thumbColor: kColorPrimary,
                                  thumbRadius: 5.w,
                                  progress: position?.position ?? Duration.zero,
                                  total: position?.duration ?? Duration.zero,
                                  buffered: position?.bufferedPosition ??
                                      Duration.zero,
                                  onSeek: (value) => controller.networkService
                                              .connectionStatus ==
                                          1
                                      ? controller.audioPlayer.value.seek(value)
                                      : null,
                                  barCapShape: BarCapShape.round,
                                  // timeLabelLocation: TimeLabelLocation.none,
                                  timeLabelType: TimeLabelType.totalTime,
                                  timeLabelTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: kColorWhite,
                                      fontSize: 10.sp),
                                  timeLabelPadding: 10.w,
                                ),
                              );
                            }),
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      //if no internet do nothing
                      if (controller.noInternet.value == 0) {
                      }
                      // else seek 10 sec in backward direction
                      else if (controller.audioPlayer.value.position -
                              const Duration(seconds: 10) >
                          Duration.zero) {
                        controller.audioPlayer.value.seek(
                            controller.audioPlayer.value.position -
                                const Duration(seconds: 10));
                      } else {
                        controller.audioPlayer.value.seek(Duration.zero);
                      }
                    },
                    child: SvgPicture.asset(
                      "assets/icons/10rev.svg",
                      width: 36.w,
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        // if (controller.isShloka.value) {
                        //   if(
                        //     controller.shlokaHasPrevious.value){

                        //   var shlokasListingController =
                        //       Get.find<ShlokasListingController>();
                        //   int index = shlokasListingController.verseList
                        //       .indexWhere((verse) =>
                        //           verse["value"] ==
                        //           shlokasListingController.verseGroupValue);
                        //   if (index > 0) {
                        //     shlokasListingController.verseGroupValue.value =
                        //         (int.parse(shlokasListingController
                        //                     .verseGroupValue.value) -
                        //                 1)
                        //             .toString();
                        //     await shlokasListingController.initializeAudio(
                        //         verseNumber: int.parse(shlokasListingController
                        //             .verseGroupValue.value));
                        //     return;
                        //     }
                        //     else {
                        //   Utils.customToast(
                        //       "Previous Shloka Has No Audio Please Navigate From Main Page",
                        //       kRedColor,
                        //       kRedColor.withOpacity(0.2),
                        //       "error");
                        //       return;
                        // }
                        //   }
                        // }

                        print((controller.audioPlayer.value.audioSource!
                                    .sequence.length !=
                                1)
                            .toString());
                        // print((controller.currentIndex.value > 0).toString());
                        print((controller.currentIndex.value > 0).toString());
                        if (controller.noInternet.value == 0) {
                          return;
                        }

                        // if the playlist has single audio or the player is on the 1st audio setting chapPrev to false, it will disable the prev button
                        if (controller.audioPlayer.value.audioSource!.sequence
                                    .length ==
                                1 ||
                            controller.audioPlayer.value.currentIndex == 0) {
                          log("Single Audio");
                          controller.chapPrev.value = false;
                        } else {
                          // else seekinhg to previous
                          controller.audioPlayer.value.seekToPrevious();
                          // if it is not shloka then setting chapter name from audio chapter list
                          if (!controller.isShloka.value) {
                            controller.chapterName.value = controller
                                .chapterList[
                                    controller.audioPlayer.value.previousIndex!]
                                .chapterName
                                .toString();
                          }
                          // else setting chapter name from verse list
                          else {
                            final shlokaController =
                                Get.find<ShlokasListingController>();
                            controller.chapterName.value =
                                "${"Verse".tr} ${shlokaController.verseList[controller.audioPlayer.value.previousIndex!]['title']}";
                          }
                          // if ((controller.audioPlayer.value.currentIndex ==
                          //         0) &&
                          //     controller.modelList.keys.first !=
                          //         Get.find<AudioDetailsController>()
                          //             .audioDetails
                          //             .value!
                          //             .chapters!
                          //             .chaptersList!
                          //             .first) {
                          //   controller.chapPrev.value = true;
                          //   Utils().showLoader();
                          //   // controller.modelList.clear();
                          //   log("PLaylist after clearing ${controller.modelList.length}");
                          //   await controller.initData(
                          //       Get.find<AudioDetailsController>()
                          //               .audioDetails
                          //               .value!
                          //               .chapters!
                          //               .chaptersList![
                          //           Get.find<AudioDetailsController>()
                          //                   .audioDetails
                          //                   .value!
                          //                   .chapters!
                          //                   .chaptersList!
                          //                   .indexOf(controller
                          //                       .modelList.keys.first) -
                          //               1]);
                          //   StreamSubscription<PlayerState>? subscription;

                          //   subscription = controller
                          //       .audioPlayer.value.playerStateStream
                          //       .listen((event) async {
                          //     if (event.processingState ==
                          //         ProcessingState.ready) {
                          //       subscription!.cancel();

                          //       // int i = 0;
                          //       int seek = 0;
                          //       for (var i = 0;
                          //           i < controller.modelList.keys.length;
                          //           i++) {
                          //         if (controller.modelList.keys.elementAt(i) ==
                          //             Get.find<AudioDetailsController>()
                          //                     .audioDetails
                          //                     .value!
                          //                     .chapters!
                          //                     .chaptersList![
                          //                 Get.find<AudioDetailsController>()
                          //                     .audioDetails
                          //                     .value!
                          //                     .chapters!
                          //                     .chaptersList!
                          //                     .indexOf(controller
                          //                         .modelList.keys.first)]) {
                          //           controller.chapterName.value = controller
                          //               .modelList.keys.first.chapterName!;
                          //           controller.verseName.value = controller
                          //               .modelList
                          //               .values
                          //               .first
                          //               .first
                          //               .versesName!;
                          //           break;
                          //         }
                          //         controller.modelList.values
                          //             .elementAt(i)
                          //             .forEach((element) {
                          //           seek += 1;
                          //         });
                          //       }
                          //       print("------>");
                          //       for (var i = 0; i < seek; i++) {
                          //         await controller.audioPlayer.value
                          //             .seekToNext();
                          //       }
                          //       Get.back();
                          //       controller.audioPlayer.value.play();
                          //       }
                          //     });
                          //   } else {
                          //     print("Hereeeeeeeeeeeee");
                          //     controller.audioPlayer.value.seekToPrevious();
                          //     print(controller
                          //         .modelList
                          //         .values
                          //         .first[
                          //             controller.audioPlayer.value.currentIndex! -
                          //                 1]
                          //         .versesName!);
                          //     controller.verseName.value = controller
                          //         .modelList
                          //         .values
                          //         .first[
                          //             controller.audioPlayer.value.currentIndex! -
                          //                 1]
                          //         .versesName!;
                          //     controller.streamController.add(const Subtitle(
                          //         data: "",
                          //         start: Duration.zero,
                          //         end: Duration.zero,
                          //         index: 0));
                          //   }
                          print(controller.currentIndex.value);
                        }
                      },
                      child: Obx(() => SvgPicture.asset(
                            "assets/icons/gotoback.svg",
                            // changing the color to indicate the button is working or disabled
                            color: controller.noInternet.value == 1 &&
                                    (controller.audioPlayer.value.audioSource!
                                                .sequence.length !=
                                            1 &&
                                        controller.currentIndex.value > 0)
                                ? kColorWhite
                                : Colors.grey[700],
                            width: 36.w,
                          ))),
                  SizedBox(
                      width: 64.w,
                      // controls is the widget for play and pause buttons
                      child: Controls(
                        audioPlayer: controller.audioPlayer.value,
                        internetGone: controller.internetGone.value,
                      )),
                  InkWell(
                      onTap: () async {
                        // if (controller.isShloka.value) {
                        //   if (controller.shlokaHasNext.value) {
                        //     var shlokasListingController =
                        //         Get.find<ShlokasListingController>();
                        //     int index = shlokasListingController.verseList
                        //         .indexWhere((verse) {
                        //       return verse["value"].value ==
                        //           shlokasListingController
                        //               .verseGroupValue.value;
                        //     });
                        //     print(index);
                        //     if (index <
                        //         shlokasListingController.verseList.length - 1) {
                        //       shlokasListingController.verseGroupValue.value =
                        //           (int.parse(shlokasListingController
                        //                       .verseGroupValue.value) +
                        //                   1)
                        //               .toString();
                        //       await shlokasListingController.initializeAudio(
                        //           verseNumber: int.parse(
                        //               shlokasListingController
                        //                   .verseGroupValue.value));
                        //     }
                        //     return;
                        //   } else {
                        //     Utils.customToast(
                        //         "Next Shloka Has No Audio Please Navigate From Main Page",
                        //         kRedColor,
                        //         kRedColor.withOpacity(0.2),
                        //         "error");
                        //   }
                        // }
                        if (controller.noInternet.value == 0) {
                          return;
                        }
                        print(controller.isShloka.value &&
                            controller.hasNext.value);
                        // if the playlist has single audio or the player is on the 1st audio setting chapPrev to false, it will disable the next button
                        if (controller.audioPlayer.value.audioSource!.sequence
                                    .length ==
                                1 ||
                            controller.audioPlayer.value.currentIndex ==
                                controller.audioPlayer.value.audioSource!
                                        .sequence.length -
                                    1) {
                          log("Single Audio");
                          controller.chapPrev.value = false;
                        } else {
                          controller.audioPlayer.value.seekToNext();
                          // if it is not shloka then setting chapter name from audio chapter list
                          if (!controller.isShloka.value) {
                            controller.chapterName.value = controller
                                .chapterList[
                                    controller.audioPlayer.value.nextIndex!]
                                .chapterName
                                .toString();
                          }
                          // else setting chapter name as verse name
                          else {
                            print("Click on the next button");
                            final shlokaController =
                                Get.find<ShlokasListingController>();
                            await controller.audioPlayer.value.pause();
                            await controller.audioPlayer.value.play();
                            controller.chapterName.value =
                                "${"Verse".tr} ${shlokaController.verseList[controller.audioPlayer.value.currentIndex!]['title']}";

                            print(
                                "next button vallue:${controller.chapterName.value}");
                            // controller.chapterName.value =
                            //     "${"Verse".tr} ${shlokaController.verseList[controller.audioPlayer.value.nextIndex!]['title']}";
                          }
                          // if ((controller.modelList.values.first.length - 1 ==
                          //         controller.audioPlayer.value.currentIndex) &&
                          //     controller.modelList.keys.first !=
                          //         Get.find<AudioDetailsController>()
                          //             .audioDetails
                          //             .value!
                          //             .chapters!
                          //             .chaptersList!
                          //             .last) {
                          //   controller.chapNext.value = true;
                          //   controller.chapPrev.value = true;
                          //   Utils().showLoader();
                          //   // controller.modelList.clear();
                          //   log("PLaylist after clearing ${controller.modelList.length}");
                          //   await controller.initData(
                          //       Get.find<AudioDetailsController>()
                          //               .audioDetails
                          //               .value!
                          //               .chapters!
                          //               .chaptersList![
                          //           Get.find<AudioDetailsController>()
                          //                   .audioDetails
                          //                   .value!
                          //                   .chapters!
                          //                   .chaptersList!
                          //                   .indexOf(controller
                          //                       .modelList.keys.first) +
                          //               1]);
                          //   StreamSubscription<PlayerState>? subscription;

                          //   subscription = controller
                          //       .audioPlayer.value.playerStateStream
                          //       .listen((event) async {
                          //     if (event.processingState ==
                          //         ProcessingState.ready) {
                          //       subscription!.cancel();

                          //       // int i = 0;
                          //       int seek = 0;
                          //       for (var i = 0;
                          //           i < controller.modelList.keys.length;
                          //           i++) {
                          //         if (controller.modelList.keys.elementAt(i) ==
                          //             Get.find<AudioDetailsController>()
                          //                     .audioDetails
                          //                     .value!
                          //                     .chapters!
                          //                     .chaptersList![
                          //                 Get.find<AudioDetailsController>()
                          //                     .audioDetails
                          //                     .value!
                          //                     .chapters!
                          //                     .chaptersList!
                          //                     .indexOf(controller
                          //                         .modelList.keys.first)]) {
                          //           controller.chapterName.value = controller
                          //               .modelList.keys.first.chapterName!;
                          //           controller.verseName.value = controller
                          //               .modelList
                          //               .values
                          //               .first
                          //               .first
                          //               .versesName!;
                          //           break;
                          //         }
                          //         controller.modelList.values
                          //             .elementAt(i)
                          //             .forEach((element) {
                          //           seek += 1;
                          //         });
                          //       }
                          //       print("------>");
                          //       for (var i = 0; i < seek; i++) {
                          //         await controller.audioPlayer.value
                          //             .seekToNext();
                          //       }
                          //       Get.back();
                          //       controller.audioPlayer.value.play();
                          //     }
                          //   });
                          // } else {
                          //   print("Hereeeeeeeeeeeee");
                          //   controller.audioPlayer.value.seekToNext();
                          //   print(controller
                          //       .modelList
                          //       .values
                          //       .first[
                          //           controller.audioPlayer.value.currentIndex! +
                          //               1]
                          //       .versesName!);
                          //   controller.verseName.value = controller
                          //       .modelList
                          //       .values
                          //       .first[
                          //           controller.audioPlayer.value.currentIndex! +
                          //               1]
                          //       .versesName!;
                          //   controller.streamController.add(const Subtitle(
                          //       data: "",
                          //       start: Duration.zero,
                          //       end: Duration.zero,
                          //       index: 0));
                          // }
                        }
                      },
                      child: Obx(() => SvgPicture.asset(
                            "assets/icons/next.svg",
                            // changing the color to indicate the button is working or disabled
                            color: controller.noInternet.value == 1 &&
                                    ((controller.audioPlayer.value.audioSource!
                                                .sequence.length !=
                                            1 &&
                                        controller.currentIndex.value !=
                                            controller
                                                    .audioPlayer
                                                    .value
                                                    .audioSource!
                                                    .sequence
                                                    .length -
                                                1))
                                //             ||
                                // (controller.isShloka.value &&
                                //     controller.shlokaHasNext.value))
                                ? kColorWhite
                                : Colors.grey[700],
                            width: 36.w,
                          ))),
                  InkWell(
                      onTap: () {
                        // if no internet do nothing
                        if (controller.noInternet.value == 0) {
                        }
                        // else seek 10 sec in forward direction
                        else if (controller.audioPlayer.value.position +
                                const Duration(seconds: 10) <
                            (controller.audioPlayer.value.duration ??
                                Duration.zero)) {
                          controller.audioPlayer.value.seek(
                              controller.audioPlayer.value.position +
                                  const Duration(seconds: 10));
                        } else {
                          controller.audioPlayer.value
                              .seek(controller.audioPlayer.value.duration);
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/icons/10for.svg",
                        width: 36.w,
                      )),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 40.w, right: 24.w, top: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // changing the loop modes in circlular manner
                            controller.loopMode.value += 1;
                            controller.loopMode.value %= 3;
                            print(controller.loopMode.value);
                            if (controller.loopMode.value == 0) {
                              controller.audioPlayer.value
                                  .setLoopMode(LoopMode.off);
                            } else if (controller.loopMode.value == 1) {
                              controller.audioPlayer.value
                                  .setLoopMode(LoopMode.all);
                            } else {
                              controller.audioPlayer.value
                                  .setLoopMode(LoopMode.one);
                            }
                          },
                          child: Obx(() => SvgPicture.asset(
                                controller.loopMode.value == 0
                                    ? "assets/icons/repeat.svg"
                                    : controller.loopMode.value == 1
                                        ? "assets/icons/loopOff.svg"
                                        : "assets/icons/loopOne.svg",
                                // color: Colors.red,
                              )),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        InkWell(
                          onTap: () {
                            // bottom sheet pop up for playback speed
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      decoration: BoxDecoration(
                                          color: kColorWhite,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24.r),
                                              topRight: Radius.circular(24.r))),
                                      height: 310.h,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 16.w,
                                                      left: width * 0.32),
                                                  // width: width * 0.75,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // SvgPicture.asset(
                                                      //   "assets/icons/playback.svg",
                                                      //   alignment: Alignment.center,
                                                      //   theme: SvgTheme(
                                                      //       currentColor:
                                                      //           kColorBlack),
                                                      //   color: kColorBlack,
                                                      // ),
                                                      TextPoppins(
                                                          text: "Playback Speed"
                                                              .tr,
                                                          // color: kColorFont70,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10.w, top: 16.w),
                                                  child: TextButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: kColorBlack,
                                                      )),
                                                )
                                              ],
                                            ),
                                            Obx(
                                              () => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller
                                                            .playback.value = 4;
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(1);
                                                      },
                                                      groupValue: controller
                                                          .playback.value,
                                                      value: 4,
                                                      activeColor:
                                                          kColorPrimary,
                                                      title: TextPoppins(
                                                          text: "Normal".tr,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  4
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(0.25);
                                                        controller.playback
                                                            .value = val!;
                                                      },
                                                      value: 1,
                                                      activeColor:
                                                          kColorPrimary,
                                                      groupValue: controller
                                                          .playback.value,
                                                      title: TextPoppins(
                                                          text: "0.25x",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  1
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller.playback
                                                            .value = val!;
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(0.5);
                                                      },
                                                      activeColor:
                                                          kColorPrimary,
                                                      value: 2,
                                                      groupValue: controller
                                                          .playback.value,
                                                      title: TextPoppins(
                                                          text: "0.5x",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  2
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller
                                                            .playback.value = 3;
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(0.75);
                                                      },
                                                      groupValue: controller
                                                          .playback.value,
                                                      value: 3,
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      activeColor:
                                                          kColorPrimary,
                                                      title: TextPoppins(
                                                          text: "0.75x",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  3
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(1.25);
                                                        controller
                                                            .playback.value = 5;
                                                      },
                                                      groupValue: controller
                                                          .playback.value,
                                                      value: 5,
                                                      activeColor:
                                                          kColorPrimary,
                                                      title: TextPoppins(
                                                          text: "1.25x",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  5
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller
                                                            .playback.value = 6;
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(1.5);
                                                      },
                                                      groupValue: controller
                                                          .playback.value,
                                                      value: 6,
                                                      activeColor:
                                                          kColorPrimary,
                                                      title: TextPoppins(
                                                          text: "1.5x",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  6
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller
                                                            .playback.value = 7;
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(1.75);
                                                      },
                                                      groupValue: controller
                                                          .playback.value,
                                                      value: 7,
                                                      activeColor:
                                                          kColorPrimary,
                                                      title: TextPoppins(
                                                          text: "1.75x",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  7
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                  RadioListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      onChanged: (val) {
                                                        controller
                                                            .playback.value = 8;
                                                        controller
                                                            .audioPlayer.value
                                                            .setSpeed(2);
                                                      },
                                                      groupValue: controller
                                                          .playback.value,
                                                      value: 8,
                                                      activeColor:
                                                          kColorPrimary,
                                                      title: TextPoppins(
                                                          text: "2x",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: controller
                                                                      .playback
                                                                      .value ==
                                                                  8
                                                              ? kColorPrimary
                                                              : Colors.black)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                isScrollControlled: true);
                          },
                          child: SvgPicture.asset(
                            "assets/icons/playback.svg",
                          ),
                        ),
                      ],
                    ),
                    // Obx(() => controller.noInternet.value == 1 &&
                    //         (controller.audioPlayer.value.audioSource!.sequence
                    //                 .length >
                    //             1)
                    //     ? InkWell(
                    //         onTap: () {
                    //           showModalBottomSheet(
                    //               context: context,
                    //               builder: (context) => Container(
                    //                     height: height * 0.9,
                    //                     decoration: BoxDecoration(
                    //                         color: kColorWhite,
                    //                         borderRadius: BorderRadius.only(
                    //                             topLeft: Radius.circular(16.r),
                    //                             topRight:
                    //                                 Radius.circular(16.r))),
                    //                     padding: EdgeInsets.only(
                    //                         left: 24.w, right: 24.w, top: 24.h),
                    //                     child: Column(children: [
                    //                       Row(
                    //                         children: [
                    //                           InkWell(
                    //                             onTap: () => Get.back(),
                    //                             child: SvgPicture.asset(
                    //                                 "assets/icons/down.svg"),
                    //                           ),
                    //                           SizedBox(
                    //                             width: width * 0.8,
                    //                             child: TextPoppins(
                    //                               text: metaData!.title,
                    //                               overflow:
                    //                                   TextOverflow.ellipsis,
                    //                               maxLines: 1,
                    //                               fontSize: 16.sp,
                    //                               fontWeight: FontWeight.w500,
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ),
                    //                       // Container(
                    //                       //   margin: EdgeInsets.only(
                    //                       //       top: 16.h, bottom: 16.h),
                    //                       //   height: 65.h,
                    //                       //   child: CustomSearchBarNew(
                    //                       //     filterAvailable: false,
                    //                       //     hintText: "Search...".tr,
                    //                       //     hintStyle:
                    //                       //         kTextStylePoppinsRegular.copyWith(
                    //                       //             color: kColorFontOpacity75,
                    //                       //             fontSize: 16.sp,
                    //                       //             fontWeight: FontWeight.w400),
                    //                       //     style: kTextStylePoppinsRegular.copyWith(
                    //                       //         color: kColorFont,
                    //                       //         fontSize: 16.sp,
                    //                       //         fontWeight: FontWeight.w400),
                    //                       //   ),
                    //                       // ),
                    //                       Expanded(
                    //                         child: ListView.builder(
                    //                           itemCount: controller
                    //                               .currVerseList.length,
                    //                           itemBuilder: (context, index) {
                    //                             return Column(
                    //                               children: [
                    //                                 ListTile(
                    //                                   contentPadding:
                    //                                       EdgeInsets.zero,
                    //                                   visualDensity:
                    //                                       const VisualDensity(
                    //                                     vertical: -4,
                    //                                   ),
                    //                                   onTap: () async {
                    //                                     // Utils().showLoader();
                    //                                     // int userIndex = 0;

                    //                                     // for (var chapter
                    //                                     //     in controller
                    //                                     //         .modelList
                    //                                     //         .keys) {
                    //                                     //   if (chapter ==
                    //                                     //       controller
                    //                                     //           .chapterPlaying
                    //                                     //           .value) {
                    //                                     //     if (controller
                    //                                     //         .modelList[
                    //                                     //             chapter]!
                    //                                     //         .contains(controller
                    //                                     //                 .currVerseList[
                    //                                     //             index])) {
                    //                                     //       userIndex += controller
                    //                                     //           .modelList[
                    //                                     //               chapter]!
                    //                                     //           .indexOf(controller
                    //                                     //                   .currVerseList[
                    //                                     //               index]);
                    //                                     //       break;
                    //                                     //     }
                    //                                     //   } else {
                    //                                     //     userIndex +=
                    //                                     //         controller
                    //                                     //             .modelList[
                    //                                     //                 chapter]!
                    //                                     //             .length;
                    //                                     //   }
                    //                                     // }
                    //                                     // var seekTo = userIndex -
                    //                                     //     controller
                    //                                     //         .audioPlayer
                    //                                     //         .value
                    //                                     //         .currentIndex!;
                    //                                     // for (var i = 0;
                    //                                     //     i < seekTo.abs();
                    //                                     //     i++) {
                    //                                     //   if (seekTo
                    //                                     //       .isNegative) {
                    //                                     //     await controller
                    //                                     //         .audioPlayer
                    //                                     //         .value
                    //                                     //         .seekToPrevious();
                    //                                     //   } else {
                    //                                     //     await controller
                    //                                     //         .audioPlayer
                    //                                     //         .value
                    //                                     //         .seekToNext();
                    //                                     //   }
                    //                                     // }
                    //                                     // Get.back();
                    //                                     print(index);
                    //                                     await controller
                    //                                         .audioPlayer.value
                    //                                         .seek(Duration.zero,
                    //                                             index: index);
                    //                                     Get.back();
                    //                                   },
                    //                                   title: TextPoppins(
                    //                                     text: controller
                    //                                         .currVerseList[
                    //                                             index]
                    //                                         .versesName!,
                    //                                     fontSize: FontSize
                    //                                         .detailsScreenMediaDesc
                    //                                         .sp,
                    //                                     fontWeight:
                    //                                         FontWeight.w300,
                    //                                   ),
                    //                                   trailing: index ==
                    //                                           controller
                    //                                               .audioPlayer
                    //                                               .value
                    //                                               .currentIndex
                    //                                       ? SvgPicture.asset(
                    //                                           "assets/icons/playing.svg")
                    //                                       : TextPoppins(
                    //                                           text: Utils.minutesToTime(
                    //                                               controller
                    //                                                   .currVerseList[
                    //                                                       index]
                    //                                                   .duration!),
                    //                                           fontSize: FontSize
                    //                                               .detailsScreenSubMediaLangaugeTag
                    //                                               .sp,
                    //                                           color: Colors
                    //                                               .black54,
                    //                                         ),
                    //                                 ),
                    //                                 Divider(
                    //                                   thickness: 1.sp,
                    //                                   color: kColorBlack
                    //                                       .withOpacity(0.1),
                    //                                 )
                    //                               ],
                    //                             );
                    //                           },
                    //                         ).paddingOnly(top: 26.h),
                    //                       )
                    //                     ]),
                    //                   ),
                    //               isScrollControlled: true);
                    //         },
                    //         child: Container(
                    //           padding: EdgeInsets.only(
                    //               left: 16.w,
                    //               right: 16.w,
                    //               top: 10.h,
                    //               bottom: 10.h),
                    //           width: width * 0.3,
                    //           decoration: BoxDecoration(
                    //               color: const Color(0xff6B5E49),
                    //               borderRadius: BorderRadius.circular(200.r)),
                    //           child: Row(
                    //             children: [
                    //               Obx(
                    //                 () => SizedBox(
                    //                   width: width * 0.15,
                    //                   child: TextPoppins(
                    //                     text: controller.verseName.value,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     color: kColorWhite,
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize:
                    //                         FontSize.detailsScreenMediaDesc.sp,
                    //                   ),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: 5.w,
                    //               ),
                    //               SvgPicture.asset("assets/icons/viewall.svg")
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     : SizedBox.shrink()),

                    // bottom sheet pop up for chapter list
                    Obx(() => controller.noInternet.value == 1 &&
                            controller.audioPlayer.value.audioSource!.sequence
                                    .length !=
                                1
                        ? InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints(
                                      minWidth:
                                          MediaQuery.of(context).size.width),
                                  builder: (context) => Container(
                                        height: height * 0.9,
                                        decoration: BoxDecoration(
                                            color: kColorWhite,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16.r),
                                                topRight:
                                                    Radius.circular(16.r))),
                                        padding: EdgeInsets.only(
                                            left: 24.w, right: 24.w, top: 24.h),
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () => Get.back(),
                                                child: SvgPicture.asset(
                                                    "assets/icons/down.svg"),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: TextPoppins(
                                                    text: metaData!.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          // Container(
                                          //   margin: EdgeInsets.only(
                                          //       top: 16.h, bottom: 16.h),
                                          //   height: 65.h,
                                          //   child: CustomSearchBarNew(
                                          //     filterAvailable: false,
                                          //     hintText: "Search...".tr,
                                          //     hintStyle:
                                          //         kTextStylePoppinsRegular.copyWith(
                                          //             color: kColorFontOpacity75,
                                          //             fontSize: FontSize
                                          //                 .detailsScreenMediaDesc,
                                          //             fontWeight: FontWeight.w400),
                                          //     style: kTextStylePoppinsRegular.copyWith(
                                          //         color: kColorFont,
                                          //         fontSize:
                                          //             FontSize.detailsScreenMediaDesc,
                                          //         fontWeight: FontWeight.w400),
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: !controller
                                                      .isShloka.value
                                                  ? controller
                                                      .chapterList.length
                                                  : Get.find<
                                                          ShlokasListingController>()
                                                      .verseList
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () async {
                                                        // Utils().showLoader();
                                                        // var playerController =
                                                        //     Get.find<
                                                        //         PlayerController>();
                                                        // var detailsController =
                                                        //     Get.find<
                                                        //         AudioDetailsController>();
                                                        // detailsController
                                                        //         .audioDetails
                                                        //         .value!
                                                        //         .hasEpisodes!
                                                        //     ? await playerController.initData(detailsController
                                                        //                 .audioDetails
                                                        //                 .value!
                                                        //                 .chapters!
                                                        //                 .chaptersList?[
                                                        //             index] ??
                                                        //         0)
                                                        //     : await playerController
                                                        //         .initData(0);
                                                        // StreamSubscription<
                                                        //         PlayerState>?
                                                        //     subscription;

                                                        // subscription =
                                                        //     playerController
                                                        //         .audioPlayer
                                                        //         .value
                                                        //         .playerStateStream
                                                        //         .listen(
                                                        //             (event) async {
                                                        //   if (event
                                                        //           .processingState ==
                                                        //       ProcessingState
                                                        //           .ready) {
                                                        //     subscription!
                                                        //         .cancel();
                                                        //     playerController
                                                        //             .chapterName
                                                        //             .value =
                                                        //         "${detailsController.audioDetails.value!.chapters!.chaptersList?[index].chapterName}";
                                                        //     playerController
                                                        //             .verseName
                                                        //             .value =
                                                        //         "${metaData!.displaySubtitle}";

                                                        //     Get.back();
                                                        //     playerController
                                                        //         .audioPlayer
                                                        //         .value
                                                        //         .play();
                                                        //   }
                                                        // });
                                                        // Get.back();
                                                        Utils().showLoader();
                                                        print(index);
                                                        await controller
                                                            .audioPlayer.value
                                                            .seek(Duration.zero,
                                                                index: index);
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      visualDensity:
                                                          const VisualDensity(
                                                        vertical: -4,
                                                      ),
                                                      title: TextPoppins(
                                                        text: !controller
                                                                .isShloka.value
                                                            ? controller
                                                                .chapterList[
                                                                    index]
                                                                .chapterName!
                                                                .toString()
                                                            : "${"Verse".tr} ${Get.find<ShlokasListingController>().verseList[index]['title']}"
                                                                .toString(),
                                                        fontSize: FontSize
                                                            .detailsScreenMediaDesc
                                                            .sp,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      trailing: index ==
                                                              controller
                                                                  .audioPlayer
                                                                  .value
                                                                  .currentIndex
                                                          ? SvgPicture.asset(
                                                              "assets/icons/playing.svg")
                                                          : TextPoppins(
                                                              text: !controller
                                                                      .isShloka
                                                                      .value
                                                                  ? Utils.minutesToTime(controller
                                                                      .chapterList[
                                                                          index]
                                                                      .duration!)
                                                                  : "",
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: FontSize
                                                                  .detailsScreenSubMediaLangaugeTag,
                                                            ),
                                                    ),
                                                    Divider(
                                                      thickness: 1.sp,
                                                      color: kColorBlack
                                                          .withOpacity(0.1),
                                                    )
                                                  ],
                                                );
                                              },
                                            ).paddingOnly(top: 26.h),
                                          )
                                        ]),
                                      ),
                                  isScrollControlled: true);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  top: 10.h,
                                  bottom: 10.h),
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                  color: const Color(0xff6B5E49),
                                  borderRadius: BorderRadius.circular(200.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => StreamBuilder<int?>(
                                        stream: controller.audioPlayer.value
                                            .currentIndexStream,
                                        builder: (context, snapshot) {
                                          log("Here us the chapter name : ${controller.chapterName.value.toString()}");
                                          return SizedBox(
                                            width: width * 0.165,
                                            child: TextPoppins(
                                              overflow: TextOverflow.ellipsis,
                                              text: controller.chapterName.value
                                                  .toString(),
                                              // .chapters!
                                              // .chaptersList![snapshot.data!]
                                              // .chapterName!
                                              // .toString(),
                                              color: kColorWhite,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  SvgPicture.asset("assets/icons/viewall.svg")
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink())
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // load the hero image of the audio
  Widget _buildFlipAnimation(metadata) {
    return metadata.artUri == null
        ? _buildRear(metadata)
        : _buildFront(metadata);
  }

  // front side of the audio
  Widget _buildFront(metadata) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(380.r),
      child: SizedBox(
        height: 380.h,
        width: 380.h,
        // height: 400.h,
        child: FadeInImage(
          image: NetworkImage(metadata.artUri.toString()),
          fit: BoxFit.cover,
          placeholder: const AssetImage("assets/icons/default.png"),
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/icons/default.png");
          },
        ),
      ),
    );
  }

  // lyrics of the audio (it is implemented but still not added from the backend [future me kaam aayega hopefully])
  Widget _buildRear(metadata) {
    updateData(metadata);
    return Container(
      height: 380.h,
      width: 380.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: Image.asset("assets/images/frame.png").image)),
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h, bottom: 10.h),
      child: StreamBuilder(
          stream: controller.streamController.stream,
          builder: (context, snapshot) {
            // snapshot.hasData ? controller.scrollPos.value += 0.0001 : null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (snapshot.hasData) {
                final index = snapshot.data.index;
                final itemExtent =
                    95.h; // Adjust this value based on your ListTile height
                final offset = index * itemExtent;
                controller.scrollController.animateTo(
                  offset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
            return Obx(
              () => SizedBox(
                height: 248.h,
                width: 342.w,
                child: ListWheelScrollView(
                    // diameterRatio: 0.8,
                    controller: controller.scrollController,
                    itemExtent: 95.h,
                    physics: const NeverScrollableScrollPhysics(),
                    children: controller.caption.map((element) {
                      // print("#${scroll}");
                      return ListTile(
                          title: TextPoppins(
                        text: element.data,
                        color: snapshot.hasData
                            ? snapshot.data.index ==
                                    controller.caption.indexOf(element)
                                ? kColorWhite
                                : kColorWhite2.withOpacity(0.60)
                            : kColorWhite2.withOpacity(0.60),
                        fontSize: snapshot.hasData
                            ? snapshot.data.index ==
                                    controller.caption.indexOf(element)
                                ? 20.sp
                                : 16.sp
                            : 16.sp,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ));
                    }).toList()),
              ),
            );
          }),
    );
  }

  void updateData(metadata) async {
    // List<Subtitle> srtFile = await Get.find<PlayerController>()
    //     .getCloseCaptionFile(metadata.extras?["lyrics"]);
    // const AsyncSnapshot.waiting();
    // print("---->$srtFile");
    // print("---->${metadata.extras?["lyrics"]}");
    // Get.find<PlayerController>().caption.value = srtFile;
  }

  // Vaibhav changes -- created a widget of the image banner and the title and verse
  Widget _buildUI(MediaItem metadata) {
    return Obx(() {
      return Container(
        // alignment: Alignment.center,
        margin: EdgeInsets.only(left: 24.w, right: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: "image",
              transitionOnUserGestures: true,
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(0),
              //   child: CachedNetworkImage(
              //     imageUrl: metadata.artUri.toString(),
              //     placeholder: (context, url) => const Center(
              //       child: CircularProgressIndicator(
              //         value: 0.3,
              //         color: Colors.greenAccent,
              //         backgroundColor: Colors.grey,
              //       ),
              //     ),
              //     errorWidget: (context, url, error) =>
              //         const Icon(Icons.error),
              //     height: 260.h,
              //     width: 300.w,
              //   ),
              // ),
              child: _buildFlipAnimation(metadata),
            ),
            SizedBox(
              height: 50.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: width * 0.7,
                        child: TextPoppins(
                            text: metadata.title, //title from metadata
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    // if there are more than one audio in the playlist display subtitle else display nothing (display subtitle is verse number)
                    controller.audioPlayer.value.audioSource!.sequence.length >
                            1
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: TextPoppins(
                                text: metadata.displaySubtitle ?? "subtitle",
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 8.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextPoppins(
                          text: metadata.artist ??
                              "artist", // add artist name to display
                          // textAlign: TextAlign.start,

                          color: Colors.white70,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                // if startup has download true(shloka and audio has the same screen, therefore using type to differentiate)
                Obx(() {
                  return controller.noInternet.value == 0
                      ? SizedBox.shrink()
                      : Get.find<StartupController>()
                                          .startupData
                                          .first
                                          .data!
                                          .result!
                                          .screens!
                                          .meData!
                                          .extraaTabs!
                                          .downloadIcon! ==
                                      true &&
                                  ((metaData!.extras!['type'] == 'Shloka' &&
                                          Get.find<StartupController>()
                                              .startupData
                                              .first
                                              .data!
                                              .result!
                                              .screens!
                                              .meData!
                                              .extraaTabs!
                                              .shlokDownloadIcon!) &&
                                      metaData!.extras!['file'].toString() !=
                                          "https://ygadmin.yatharthgeeta.org/storage/shlok/no_audio_found.mp3") ||
                              (metaData!.extras!['type'] == 'Audio' &&
                                  Get.find<StartupController>()
                                      .startupData
                                      .first
                                      .data!
                                      .result!
                                      .screens!
                                      .meData!
                                      .extraaTabs!
                                      .audioDownloadIcon!)
                          ? InkWell(
                              onTap: () {
                                log('metadata.extras.toString():${metadata.toString()}');
                                // if not logged in show login pop up
                                if (Get.find<BottomAppBarServices>()
                                        .token
                                        .value ==
                                    '') {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                              .size
                                              .width),
                                      builder: (context) {
                                        return ProfileDialog(
                                          title: 'Login'.tr,
                                          asssetIcon:
                                              'assets/icons/login_icon_2.svg',
                                          contentText:
                                              'You will need to login to carry out this action. Login?'
                                                  .tr,
                                          btn1Text: 'Login'.tr, //Save button
                                          btn2Text: 'Go back'.tr,
                                        );
                                      });
                                  return;
                                }
                                // download  the audio
                                downloadService.requestDownload(
                                    metadata.extras!["file"], id, id, 'audio');
                              },
                              child:
                                  // SvgPicture.asset(
                                  //     "assets/icons/download.svg"))
                                  Container(
                                height: 41.r,
                                width: 41.r,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          height: downloadService
                                                  .downloadProgress.values
                                                  .any((map) =>
                                                      map['audioId'] == id)
                                              ? 38.r
                                              : 41.r,
                                          width: downloadService
                                                  .downloadProgress.values
                                                  .any((map) =>
                                                      map['audioId'] == id)
                                              ? 38.r
                                              : 41.r,
                                          child: SvgPicture.asset(
                                            'assets/icons/download.svg',
                                          ),
                                        ),
                                      ),
                                    ),
                                    downloadService.downloadProgress.values
                                            .any((map) => map['audioId'] == id)
                                        ? CircularProgressIndicator(
                                            value: downloadService
                                                    .downloadProgress.values
                                                    .where((map) =>
                                                        map.containsKey(
                                                            'audioId') &&
                                                        map['audioId'] == id)
                                                    .map((map) =>
                                                        map['progress'])
                                                    .first
                                                    .value /
                                                100,
                                            strokeWidth: 3.w,
                                            backgroundColor:
                                                kColorPrimaryWithOpacity25,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    kColorPrimary),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ))
                          : SizedBox.shrink();
                })
              ],
            ),
          ],
        ),
      );
    });
  }
}
