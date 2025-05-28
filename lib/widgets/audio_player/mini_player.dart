import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../models/audio_player/position_data.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../common/text_poppins.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.shouldDisplay.value = true;
    });
    super.initState();
  }

  final PlayerController controller = Get.find<PlayerController>();
  bool shouldDisplay = false;
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
    return Obx(
      () => Visibility(
        visible: Get.find<BottomAppBarServices>().miniplayerVisible.value &&
            controller.shouldDisplay.value,
        child: AspectRatio(
          aspectRatio: 16 / 3,
          child: Container(
            color: Colors.transparent,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            // height: 90.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => GestureDetector(
                    onVerticalDragStart: (details) {
                      controller.startPos.value = details.globalPosition;
                    },
                    onVerticalDragUpdate: (details) {
                      controller.endPos.value = details.globalPosition;
                    },
                    onVerticalDragEnd: (details) {
                      if (controller.startPos.value.distance -
                              controller.endPos.value.distance >
                          Offset.zero.distance) {
                        Get.toNamed(AppRoute.audioPlayerScreen);
                      }
                    },
                    onTap: () => Get.toNamed(AppRoute.audioPlayerScreen),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: Container(
                        height: 70.w,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff875B4A), Color(0xff725830)],
                                stops: [0.2, 0.9])),
                        padding: EdgeInsets.only(left: 20.w),
                        // child: Row(children: [
                        //   Container(
                        //     height: 40.w,
                        //     width: 40.w,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.all(Radius.circular(40.w)),
                        //         image: const DecorationImage(
                        //             image: AssetImage(
                        //                 "assets/PlaylistAssets/songCard.png"))),
                        //   ),
                        //   SvgPicture.asset("assets/PlaylistAssets/play.svg"),
                        // ]),
                        child: StreamBuilder<SequenceState?>(
                            stream: controller
                                .audioPlayer.value.sequenceStateStream,
                            builder: (context, snapshot) {
                              final state = snapshot.data;
                              if (state?.sequence.isEmpty ?? true) {
                                return const SizedBox();
                              }
                              var data = state?.currentSource?.tag as MediaItem;
                              controller.currIndex.value = int.parse(data.id);
                              controller.currDur.value =
                                  controller.audioPlayer.value.position;
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Hero(
                                            tag: "image",
                                            transitionOnUserGestures: true,
                                            child: SizedBox(
                                              height: 50.h,
                                              width: 50.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child: data.artUri != null
                                                    ? FadeInImage(
                                                        image: NetworkImage(data
                                                            .artUri
                                                            .toString()),
                                                        placeholderFit:
                                                            BoxFit.scaleDown,
                                                        placeholder:
                                                            const AssetImage(
                                                                "assets/icons/default.png"),
                                                        width: width >= 600
                                                            ? 45.w
                                                            : 25.w,
                                                        height: width >= 600
                                                            ? 45.h
                                                            : 25.h,
                                                        imageErrorBuilder:
                                                            (context, error,
                                                                stackTrace) {
                                                          return Image.asset(
                                                              "assets/icons/default.png");
                                                        },
                                                      )
                                                    : Image.asset(
                                                        "assets/images/default_mini_player.png"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8.h, bottom: 8.h),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 190.w,
                                                  height: 25.h,
                                                  child: TextPoppins(
                                                      text: data.title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: kColorWhite,
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: FontSize
                                                          .listingScreenMediaLanguageTag
                                                          .sp),
                                                ),
                                                SizedBox(
                                                    height: 25.h,
                                                    width: 190.w,
                                                    child: TextPoppins(
                                                      text: controller
                                                              .isShloka.value
                                                          ? data
                                                              .displaySubtitle!
                                                          : data.artist!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: kColorWhite
                                                          .withOpacity(0.75),
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: FontSize
                                                          .detailsScreenSubMediaLangaugeTag
                                                          .sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )
                                                    //  Marquee(
                                                    //   scrollAxis: Axis.horizontal,
                                                    //   crossAxisAlignment:
                                                    //       CrossAxisAlignment.start,
                                                    //   velocity: 50.0,
                                                    //   blankSpace: 10.w,
                                                    //   pauseAfterRound:
                                                    //       const Duration(seconds: 2),
                                                    //   text: data.artist!,
                                                    //   style: TextStyle(
                                                    //     color: Colors.white70,
                                                    //     decoration: TextDecoration.none,
                                                    //     fontFamily: "Poppins",
                                                    //     fontSize: 10.sp,
                                                    //   ),
                                                    // ),
                                                    )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 16.w),
                                      height: 50.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 45.h,
                                            child: Obx(() {
                                              // Using Obx to listen to changes
                                              if (controller
                                                  .internetGone.value) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: kColorPrimary),
                                                );
                                              }
                                              return StreamBuilder<PlayerState>(
                                                  stream: controller.audioPlayer
                                                      .value.playerStateStream,
                                                  builder: (context, snapshot) {
                                                    final playerState =
                                                        snapshot.data;
                                                    final processingState =
                                                        playerState
                                                            ?.processingState;
                                                    final playing =
                                                        playerState?.playing;
                                                    if (!(playing ?? false)) {
                                                      return InkWell(
                                                          onTap: () {
                                                            controller
                                                                .audioPlayer
                                                                .value
                                                                .play();
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/icons/play.svg",
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            width: width >= 600
                                                                ? 35.w
                                                                : 25.w,
                                                            height: width >= 600
                                                                ? 35.h
                                                                : 25.h,
                                                          ));
                                                    } else if (processingState !=
                                                        ProcessingState
                                                            .completed) {
                                                      return InkWell(
                                                          onTap: () {
                                                            controller
                                                                .audioPlayer
                                                                .value
                                                                .pause();
                                                          },
                                                          child: SvgPicture.asset(
                                                              "assets/icons/pause.svg",
                                                              width:
                                                                  width >= 600
                                                                      ? 35.w
                                                                      : 25.w,
                                                              height:
                                                                  width >= 600
                                                                      ? 35.h
                                                                      : 25.h,
                                                              fit: BoxFit
                                                                  .scaleDown));
                                                    }
                                                    return SvgPicture.asset(
                                                        "assets/icons/play.svg",
                                                        width: width >= 600
                                                            ? 35.w
                                                            : 25.w,
                                                        height: width >= 600
                                                            ? 35.h
                                                            : 25.h,
                                                        fit: BoxFit.scaleDown);
                                                  });
                                            }),
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //-- VAIBHAV CHNAGES -- 04/03/25
                                              //-- added bool value to listen close miniplayer and stop audio
                                              controller.audioPlayer.value
                                                  .stop();
                                              if (controller
                                                  .internetGone.value) {
                                                controller.internetGone.value =
                                                    false;
                                              }
                                              controller.closeMiniPlayer = true;
                                              Get.find<BottomAppBarServices>()
                                                  .miniplayerVisible
                                                  .value = false;
                                              if (controller.isShloka.isFalse ||
                                                  Get.currentRoute !=
                                                      AppRoute
                                                          .shlokasListingScreen) {
                                                controller.audioPlayer.value
                                                    .stop();
                                              }
                                              controller.shouldDisplay.value =
                                                  false;
                                            },
                                            child: SvgPicture.asset(
                                              "assets/icons/cross.svg",
                                              width: width >= 600 ? 35.w : 25.w,
                                              height:
                                                  width >= 600 ? 35.h : 25.h,
                                              color: kColorWhite,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]);
                            }),
                      ),
                    ),
                  ),
                ),
                StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data;
                      return Container(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: ProgressBar(
                          barHeight: 5.h,
                          baseBarColor: const Color(0xff957E64),
                          bufferedBarColor: const Color(0xff957E64),
                          progressBarColor: kColorPrimary,
                          thumbColor: kColorPrimary,
                          thumbRadius: 2.w,
                          progress: position?.position ?? Duration.zero,
                          total: position?.duration ?? Duration.zero,
                          buffered: position?.bufferedPosition ?? Duration.zero,
                          onSeek: (value) =>
                              controller.audioPlayer.value.seek(value),
                          barCapShape: BarCapShape.round,
                          timeLabelLocation: TimeLabelLocation.none,
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    ).paddingOnly(bottom: MediaQuery.of(context).padding.bottom);
  }
}
