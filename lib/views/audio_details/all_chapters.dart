import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/controllers/video_details/video_details_controller.dart';
import 'package:yatharthageeta/extension/number_extension.dart';
import 'package:yatharthageeta/models/audio_details/audio_details_model.dart';
import 'package:yatharthageeta/models/video_details/video_details_model.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import 'package:yatharthageeta/services/user_media_played_create/service/user_media_played_create_service.dart';
import 'package:yatharthageeta/widgets/common/custom_search_bar_new.dart';
import 'package:yatharthageeta/widgets/common/no_data_found_widget.dart';
import 'package:yatharthageeta/widgets/common/text_poppins.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_app_bar.dart';

class AllChapters extends StatelessWidget {
  const AllChapters({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkService>();
    final screenHeight = MediaQuery.of(context).size.height;

    // checking if the chapter screen is coming from audio details screen
    final bool isAudio = Get.arguments;
    log("Is Audio ${isAudio}");
    // iniializing UserMediaPlayedCreateServices
    final userMediaPlayedCreateServices =
        Get.find<UserMediaPlayedCreateServices>();
    final searchController = TextEditingController().obs;
    final searchText = ''.obs;
    final length = 0.obs;
    // defining Controllers
    final controller;
    // initializing controllers based on the isAudio parameter
    if (isAudio) {
      controller = Get.find<AudioDetailsController>();
      length.value = controller.audioDetails.value!.chapters!.chaptersList!
          .where((ChaptersList element) {
            if (searchText.value != '') {
              return element.chapterName!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase());
            }
            return true;
          })
          .toList()
          .length;
    } else {
      controller = Get.find<VideoDetailsController>();
      length.value = controller.videoDetails.value!.videoEpisodes?.episodesList!
          .where((EpisodesList element) {
            if (searchText.value != '') {
              return element.title!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase());
            }
            return true;
          })
          .toList()
          .length;
    }
    // setting screenWidth to the width of the screen
    var screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      color: kColorWhite,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          // miniplayer check
          bottomNavigationBar: Obx(
            () => Get.find<BottomAppBarServices>().miniplayerVisible.value
                ? MiniPlayer()
                : SizedBox.shrink(),
          ),
          backgroundColor: kColorWhite,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kColorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 15),
                      blurRadius: 20,
                    ),
                  ],
                  border: Border(
                    bottom: BorderSide(
                      color: kColorPrimaryWithOpacity25,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            // Container(
                            //   alignment: Alignment.center,
                            //   padding: EdgeInsets.only(
                            //     top: 12.h,
                            //     bottom: 12.h,
                            //   ),
                            //   child: Text(
                            //     'Audio'.tr,
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                top: 12.h,
                                // bottom: 12.h,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: 310.w,
                                child: Text(
                                  // controller.audioApiCallType.value ==
                                  //         'fetchAudioListing'
                                  //     ? 'Audio'.tr
                                  //     : controller
                                  //         .viewAllListingAudioTitle
                                  //         .value,
                                  isAudio
                                      ? "${controller.audioDetails.value!.chapters!.totalChapters!} ${"Chapters".tr}"
                                      : "${controller.videoDetails.value!.videoEpisodes?.episodesList!.length!} ${"Episodes".tr}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyleRosarioRegular.copyWith(
                                    color: kColorFont,
                                    fontSize: FontSize.screenTitle.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 24.w),
                              height: 24.h,
                              width: 24.h,
                              child: SvgPicture.asset('assets/icons/back.svg'),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 50.h,
                                width: 70.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28.h,
                    ),

                    //Search Bar
                    Container(
                      margin: EdgeInsets.only(left: 24.w, right: 24.w),
                      child: CustomSearchBarNew(
                        controller: searchController.value,
                        fillColor: kColorWhite,
                        filled: true,
                        filterAvailable: false,
                        hasMic: false,
                        onChanged: (p0) async {
                          searchText.value = p0;
                          if (isAudio) {
                            // controller = Get.find<AudioDetailsController>();
                            length.value = controller
                                .audioDetails.value!.chapters!.chaptersList!
                                .where((ChaptersList element) {
                                  if (searchText.value != '') {
                                    return element.chapterName!
                                        .toLowerCase()
                                        .contains(
                                            searchText.value.toLowerCase());
                                  }
                                  return true;
                                })
                                .toList()
                                .length;
                          } else {
                            // controller = Get.find<VideoDetailsController>();
                            length.value = controller.videoDetails.value!
                                .videoEpisodes?.episodesList!
                                .where((EpisodesList element) {
                                  if (searchText.value != '') {
                                    return element.title!
                                        .toLowerCase()
                                        .contains(
                                            searchText.value.toLowerCase());
                                  }
                                  return true;
                                })
                                .toList()
                                .length;
                          }
                          debugPrint("searchQuery.valuep0:$p0");
                        },
                        // filterBottomSheet: SearchFilter(
                        //     tabIndex: controller.tabIndex,
                        //     languages: controller.languageList,
                        //     authors: controller.authorsList,
                        //     sortList: controller.sortList,
                        //     screen: "audio",
                        //     onTap: controller.prevScreen.value ==
                        //             "homeCollectionMultipleType"
                        //         ? controller
                        //             .fetchAudiosHomeMultipleListing
                        //         : controller.prevScreen.value ==
                        //                 "collection"
                        //             ? controller
                        //                 .fetchAudioExploreViewAllListing
                        //             : controller.prevScreen.value ==
                        //                     "homeCollection"
                        //                 ? controller
                        //                     .fetchAudioHomeViewAllListing
                        //                 : controller.fetchAudioListing
                        // screen: "audio",
                        // onTap: controller.prevScreen.value !=
                        //         "collection"
                        //     ? controller.fetchAudioListingFilter
                        //     : controller.fetchAudioViewAllFilter,
                        // ),
                        contentPadding: EdgeInsets.all(16.h),
                        hintText: 'Search...'.tr,
                        hintStyle: kTextStylePoppinsRegular.copyWith(
                          color: kColorFontOpacity25,
                          fontSize: FontSize.searchBarHint.sp,
                        ),
                      ),
                    ),

                    Container(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
              Container(
                color: kColorWhite2,
                height: 24.h,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Obx(
                    () => SingleChildScrollView(
                      child: Column(
                        children: [
                          // if audio then listening to audio details controller else from video details controller
                          length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: isAudio
                                      ? controller.audioDetails.value!.chapters!
                                          .chaptersList!
                                          .where((ChaptersList element) {
                                            if (searchText.value != '') {
                                              return element.chapterName!
                                                  .toLowerCase()
                                                  .contains(searchText.value
                                                      .toLowerCase());
                                            }
                                            return true;
                                          })
                                          .toList()
                                          .length
                                      : controller.videoDetails.value!
                                          .videoEpisodes?.episodesList!
                                          .where((EpisodesList element) {
                                            if (searchText.value != '') {
                                              return element.title!
                                                  .toLowerCase()
                                                  .contains(searchText.value
                                                      .toLowerCase());
                                            }
                                            return true;
                                          })
                                          .toList()
                                          .length,
                                  itemBuilder: (context, index) {
                                    var item = isAudio
                                        ? controller.audioDetails.value!
                                            .chapters!.chaptersList!
                                            .where((ChaptersList element) {
                                            if (searchText.value != '') {
                                              return element.chapterName!
                                                  .toLowerCase()
                                                  .contains(searchText.value
                                                      .toLowerCase());
                                            }
                                            return true;
                                          }).toList()[index]
                                        : controller.videoDetails.value!
                                            .videoEpisodes?.episodesList!
                                            .where((EpisodesList element) {
                                            if (searchText.value != '') {
                                              return element.title!
                                                  .toLowerCase()
                                                  .contains(searchText.value
                                                      .toLowerCase());
                                            }
                                            return true;
                                          }).toList()[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          onTap: () async {
                                            if (networkService
                                                    .connectionStatus.value ==
                                                1) {
                                              // performing on click operation for audio
                                              if (isAudio) {
                                                Utils().showLoader();
                                                // if not guest then only add to watch list
                                                if (!controller
                                                    .isGuestUser.value) {
                                                  await userMediaPlayedCreateServices
                                                      .updateUserMediaPlayedCreatelist(
                                                    token: Get.find<
                                                            BottomAppBarServices>()
                                                        .token
                                                        .value,
                                                    mediaType: controller
                                                        .audioDetails
                                                        .value!
                                                        .selectedType
                                                        .toString(),
                                                    playedId: controller
                                                        .audioDetails.value!.id
                                                        .toString(),
                                                  );
                                                }
                                                // increase count regardless
                                                await controller.increaseCount(
                                                    id: controller
                                                        .audioDetails.value!.id
                                                        .toString());

                                                // create playlist from audio details controller
                                                var playerController =
                                                    Get.put(PlayerController());
                                                await playerController
                                                    .createPlaylist(controller
                                                        .audioDetails.value!);

                                                // initialize the chapters
                                                await playerController
                                                    .initData(item);

                                                // initialize the chapter name
                                                playerController.chapterName
                                                    .value = item.chapterName!
                                                        .toString() ??
                                                    "";
                                                // seek to current index on which the click is hapenned
                                                await playerController
                                                    .audioPlayer.value
                                                    .seek(Duration.zero,
                                                        index: controller
                                                            .audioDetails
                                                            .value!
                                                            .chapters!
                                                            .chaptersList!
                                                            .indexOf(item));
                                                Get.back();
                                                Get.back();

                                                // start playing and go to audio player
                                                playerController
                                                    .audioPlayer.value
                                                    .play();
                                                Get.toNamed(
                                                    AppRoute.audioPlayerScreen);
                                              }
                                              // performing on click operation for video
                                              else {
                                                // add to watch list if not guest
                                                if (!controller
                                                    .isGuestUser.value) {
                                                  // Utils().showLoader();
                                                  await userMediaPlayedCreateServices
                                                      .updateUserMediaPlayedCreatelist(
                                                    token: Get.find<
                                                            BottomAppBarServices>()
                                                        .token
                                                        .value,
                                                    mediaType: "Video",
                                                    playedId: controller
                                                        .videoDetails.value!.id
                                                        .toString(),
                                                  );
                                                }
                                                // initialize all the episodes to play
                                                var data = await controller
                                                    .fetchEpisodeDetails(
                                                        videoId: item.id,
                                                        isNext: true);
                                                Get.back();

                                                // if not null then pass it to the video player screen
                                                if (data != null) {
                                                  log(data.toJson().toString());
                                                  await controller
                                                      .increaseCount(
                                                          id: controller
                                                              .videoDetails
                                                              .value!
                                                              .id
                                                              .toString());
                                                  // if player controller is registered and the audio is playing then pause it before navigating
                                                  if (Get.isRegistered<
                                                      PlayerController>()) {
                                                    Get.find<PlayerController>()
                                                            .audioPlayer
                                                            .value
                                                            .playerState
                                                            .playing
                                                        ? await Get.find<
                                                                PlayerController>()
                                                            .audioPlayer
                                                            .value
                                                            .pause()
                                                        : null;
                                                  }
                                                  // Get.back();
                                                  Get.toNamed(
                                                      AppRoute
                                                          .videoPlayerScreen,
                                                      arguments: {
                                                        'data': data,
                                                        'isEpisode': true
                                                      });
                                                }
                                              }

                                              //   }
                                              // });
                                            } else {
                                              Utils.customToast(
                                                  "Please Check your initernet connection",
                                                  kColorWhite,
                                                  kRedColor,
                                                  "error");
                                            }
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity(
                                              vertical:
                                                  screenWidth >= 600 ? 2 : -2),
                                          title: isAudio
                                              ? TextPoppins(
                                                  text: item.chapterName!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: FontSize
                                                      .detailsScreenMediaDesc
                                                      .sp,
                                                  fontWeight: FontWeight.w500,
                                                )
                                              : TextPoppins(
                                                  text: item.title!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: FontSize
                                                      .detailsScreenMediaDesc
                                                      .sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          trailing: isAudio
                                              ? TextPoppins(
                                                  text: Utils.minutesToTime(
                                                      item.duration!),
                                                  color: Colors.black54,
                                                  fontSize: FontSize
                                                      .detailsScreenSubMediaLangaugeTag
                                                      .sp,
                                                )
                                              : TextPoppins(
                                                  text: item.durationTime!,
                                                  color: Colors.black54,
                                                  fontSize: FontSize
                                                      .detailsScreenSubMediaLangaugeTag
                                                      .sp,
                                                ),
                                        ),
                                        index !=
                                                (isAudio
                                                    ? controller
                                                            .audioDetails
                                                            .value!
                                                            .chapters!
                                                            .chaptersList!
                                                            .length -
                                                        1
                                                    : controller
                                                            .videoDetails
                                                            .value!
                                                            .videoEpisodes
                                                            ?.episodesList!
                                                            .length -
                                                        1)
                                            ? Divider(
                                                thickness: 1.sp,
                                                color: kColorBlack
                                                    .withOpacity(0.1),
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    );
                                  },
                                )
                              // : controller.videoDetails.value!.videoEpisodes
                              //             ?.episodesList!
                              //             .where((EpisodesList element) {
                              //               if (searchText.value != '') {
                              //                 return element.title!
                              //                     .toLowerCase()
                              //                     .contains(searchText.value
                              //                         .toLowerCase());
                              //               }
                              //               return true;
                              //             })
                              //             .toList()
                              //             .length >
                              //         0
                              //     ? ListView.builder(
                              //         shrinkWrap: true,
                              //         physics:
                              //             NeverScrollableScrollPhysics(),
                              //         itemCount: isAudio
                              //             ? controller.audioDetails.value!
                              //                 .chapters!.chaptersList!
                              //                 .where(
                              //                     (ChaptersList element) {
                              //                   if (searchText.value !=
                              //                       '') {
                              //                     return element
                              //                         .chapterName!
                              //                         .toLowerCase()
                              //                         .contains(searchText
                              //                             .value
                              //                             .toLowerCase());
                              //                   }
                              //                   return true;
                              //                 })
                              //                 .toList()
                              //                 .length
                              //             : controller.videoDetails.value!
                              //                 .videoEpisodes?.episodesList!
                              //                 .where(
                              //                     (EpisodesList element) {
                              //                   if (searchText.value !=
                              //                       '') {
                              //                     return element.title!
                              //                         .toLowerCase()
                              //                         .contains(searchText
                              //                             .value
                              //                             .toLowerCase());
                              //                   }
                              //                   return true;
                              //                 })
                              //                 .toList()
                              //                 .length,
                              //         itemBuilder: (context, index) {
                              //           var item = isAudio
                              //               ? controller.audioDetails.value!
                              //                   .chapters!.chaptersList!
                              //                   .where(
                              //                       (ChaptersList element) {
                              //                   if (searchText.value !=
                              //                       '') {
                              //                     return element
                              //                         .chapterName!
                              //                         .toLowerCase()
                              //                         .contains(searchText
                              //                             .value
                              //                             .toLowerCase());
                              //                   }
                              //                   return true;
                              //                 }).toList()[index]
                              //               : controller
                              //                   .videoDetails
                              //                   .value!
                              //                   .videoEpisodes
                              //                   ?.episodesList!
                              //                   .where(
                              //                       (EpisodesList element) {
                              //                   if (searchText.value !=
                              //                       '') {
                              //                     return element.title!
                              //                         .toLowerCase()
                              //                         .contains(searchText
                              //                             .value
                              //                             .toLowerCase());
                              //                   }
                              //                   return true;
                              //                 }).toList()[index];
                              //           return Column(
                              //             children: [
                              //               ListTile(
                              //                 onTap: () async {
                              //                   // performing on click operation for audio
                              //                   if (isAudio) {
                              //                     Utils().showLoader();
                              //                     // if not guest then only add to watch list
                              //                     if (!controller
                              //                         .isGuestUser.value) {
                              //                       await userMediaPlayedCreateServices
                              //                           .updateUserMediaPlayedCreatelist(
                              //                         token: Get.find<
                              //                                 BottomAppBarServices>()
                              //                             .token
                              //                             .value,
                              //                         mediaType: controller
                              //                             .audioDetails
                              //                             .value!
                              //                             .selectedType
                              //                             .toString(),
                              //                         playedId: controller
                              //                             .audioDetails
                              //                             .value!
                              //                             .id
                              //                             .toString(),
                              //                       );
                              //                     }
                              //                     // increase count regardless
                              //                     await controller
                              //                         .increaseCount(
                              //                             id: controller
                              //                                 .audioDetails
                              //                                 .value!
                              //                                 .id
                              //                                 .toString());

                              //                     // create playlist from audio details controller
                              //                     var playerController =
                              //                         Get.put(
                              //                             PlayerController());
                              //                     await playerController
                              //                         .createPlaylist(
                              //                             controller
                              //                                 .audioDetails
                              //                                 .value!);

                              //                     // initialize the chapters
                              //                     await playerController
                              //                         .initData(item);

                              //                     // initialize the chapter name
                              //                     playerController
                              //                         .chapterName
                              //                         .value = item
                              //                             .chapterName!
                              //                             .toString() ??
                              //                         "";
                              //                     // seek to current index on which the click is hapenned
                              //                     await playerController
                              //                         .audioPlayer.value
                              //                         .seek(Duration.zero,
                              //                             index: controller
                              //                                 .audioDetails
                              //                                 .value!
                              //                                 .chapters!
                              //                                 .chaptersList!
                              //                                 .indexOf(
                              //                                     item));
                              //                     Get.back();
                              //                     Get.back();

                              //                     // start playing and go to audio player
                              //                     playerController
                              //                         .audioPlayer.value
                              //                         .play();
                              //                     Get.toNamed(AppRoute
                              //                         .audioPlayerScreen);
                              //                   }
                              //                   // performing on click operation for video
                              //                   else {
                              //                     // add to watch list if not guest
                              //                     if (!controller
                              //                         .isGuestUser.value) {
                              //                       // Utils().showLoader();
                              //                       await userMediaPlayedCreateServices
                              //                           .updateUserMediaPlayedCreatelist(
                              //                         token: Get.find<
                              //                                 BottomAppBarServices>()
                              //                             .token
                              //                             .value,
                              //                         mediaType: "Video",
                              //                         playedId: controller
                              //                             .videoDetails
                              //                             .value!
                              //                             .id
                              //                             .toString(),
                              //                       );
                              //                     }
                              //                     // initialize all the episodes to play
                              //                     var data = await controller
                              //                         .fetchEpisodeDetails(
                              //                             videoId: item.id,
                              //                             isNext: true);
                              //                     Get.back();

                              //                     // if not null then pass it to the video player screen
                              //                     if (data != null) {
                              //                       log(data
                              //                           .toJson()
                              //                           .toString());
                              //                       await controller
                              //                           .increaseCount(
                              //                               id: controller
                              //                                   .videoDetails
                              //                                   .value!
                              //                                   .id
                              //                                   .toString());
                              //                       // if player controller is registered and the audio is playing then pause it before navigating
                              //                       if (Get.isRegistered<
                              //                           PlayerController>()) {
                              //                         Get.find<PlayerController>()
                              //                                 .audioPlayer
                              //                                 .value
                              //                                 .playerState
                              //                                 .playing
                              //                             ? await Get.find<
                              //                                     PlayerController>()
                              //                                 .audioPlayer
                              //                                 .value
                              //                                 .pause()
                              //                             : null;
                              //                       }
                              //                       // Get.back();
                              //                       Get.toNamed(
                              //                           AppRoute
                              //                               .videoPlayerScreen,
                              //                           arguments: {
                              //                             'data': data,
                              //                             'isEpisode': true
                              //                           });
                              //                     }
                              //                   }

                              //                   //   }
                              //                   // });
                              //                 },
                              //                 contentPadding:
                              //                     EdgeInsets.zero,
                              //                 visualDensity: VisualDensity(
                              //                     vertical:
                              //                         screenWidth >= 600
                              //                             ? 2
                              //                             : -2),
                              //                 title: isAudio
                              //                     ? TextPoppins(
                              //                         text:
                              //                             item.chapterName!,
                              //                         maxLines: 2,
                              //                         overflow: TextOverflow
                              //                             .ellipsis,
                              //                         fontSize: FontSize
                              //                             .detailsScreenMediaDesc
                              //                             .sp,
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                       )
                              //                     : TextPoppins(
                              //                         text: item.title!,
                              //                         maxLines: 2,
                              //                         overflow: TextOverflow
                              //                             .ellipsis,
                              //                         fontSize: FontSize
                              //                             .detailsScreenMediaDesc
                              //                             .sp,
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                       ),
                              //                 trailing: isAudio
                              //                     ? TextPoppins(
                              //                         text: Utils
                              //                             .minutesToTime(item
                              //                                 .duration!),
                              //                         color: Colors.black54,
                              //                         fontSize: FontSize
                              //                             .detailsScreenSubMediaLangaugeTag
                              //                             .sp,
                              //                       )
                              //                     : TextPoppins(
                              //                         text: item
                              //                             .durationTime!,
                              //                         color: Colors.black54,
                              //                         fontSize: FontSize
                              //                             .detailsScreenSubMediaLangaugeTag
                              //                             .sp,
                              //                       ),
                              //               ),
                              //               index !=
                              //                       (isAudio
                              //                           ? controller
                              //                                   .audioDetails
                              //                                   .value!
                              //                                   .chapters!
                              //                                   .chaptersList!
                              //                                   .length -
                              //                               1
                              //                           : controller
                              //                                   .videoDetails
                              //                                   .value!
                              //                                   .videoEpisodes
                              //                                   ?.episodesList!
                              //                                   .length -
                              //                               1)
                              //                   ? Divider(
                              //                       thickness: 1.sp,
                              //                       color: kColorBlack
                              //                           .withOpacity(0.1),
                              //                     )
                              //                   : SizedBox.shrink()
                              //             ],
                              //           );
                              //         },
                              //       )
                              : Container(
                                  alignment: Alignment.center,
                                  height: 60.pch(context).toDouble(),
                                  child: NoDataFoundWidget(
                                    title: isAudio
                                        ? "No Audio Found"
                                        : "No Video Found",
                                    svgImgUrl: isAudio
                                        ? "assets/icons/no_audio.svg"
                                        : "assets/icons/no_video.svg",
                                  )),
                          // : SizedBox.shrink(),
                          SizedBox(
                            height: 100.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
