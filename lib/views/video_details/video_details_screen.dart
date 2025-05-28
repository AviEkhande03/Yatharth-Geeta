import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/services/network/network_service.dart';

import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/user_liked_List/user_liked_list_controller.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/user_media_liked_create/service/user_media_liked_create_service.dart';
import '../../services/user_media_played_create/service/user_media_played_create_service.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/profile_bottom_dialogs.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/ebook_details/description_text_widget.dart';
import '../../widgets/video_listing/video_list_video_details.dart';

class VideoDetailsScreen extends StatefulWidget {
  const VideoDetailsScreen({Key? key}) : super(key: key);

  @override
  State<VideoDetailsScreen> createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    VideoDetailsController controller = Get.put(VideoDetailsController());
    final userMediaPlayedCreateServices =
        Get.find<UserMediaPlayedCreateServices>();
    final userMediaLikedCreateServices =
        Get.find<UserMediaLikedCreateServices>();
    // Result videoDetails = Get.arguments;
        final networkService = Get.find<NetworkService>();

      final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ScrollController scrollController = new ScrollController();
    return Obx(
       ()  => networkService.connectionStatus.value == 0
          ? Utils().noInternetWidget(screenWidth, screenHeight)
          : 
         Container(
          color: kColorWhite,
          child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                bottomNavigationBar: Obx(
                  () => Get.find<BottomAppBarServices>().miniplayerVisible.value
                      ? const MiniPlayer()
                      : const SizedBox.shrink(),
                ),
                body: Obx(
                  () => Column(
                    children: [
                      CustomAppBar(
                        title: "Video".tr,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 150.h,
                                    width: double.infinity,
                                    color: kColorWhite2,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 130.h),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.w, right: 25.w),
                                          child: TextPoppins(
                                            text: controller
                                                .videoDetails.value!.title!.tr,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize:
                                                FontSize.detailsScreenMediaTitle.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextPoppins(
                                          text:
                                              "${'by'.tr} ${controller.videoDetails.value!.artistName!.tr}",
                                          fontSize:
                                              FontSize.detailsScreenMediaAuthor.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                text: controller.videoDetails.value!
                                                    .mediaLanguage!,
                                                color: kColorPrimary,
                                                fontSize: FontSize
                                                    .detailsScreenMediaTags.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            // SvgPicture.asset(
                                            //     "assets/icons/line.svg"),
                                            // Container(
                                            //   padding: EdgeInsets.only(
                                            //       left: 10.w, right: 10.w),
                                            //   margin: EdgeInsets.only(
                                            //       left: 10.w, right: 10.w),
                                            //   child: TextPoppins(
                                            //     text:
                                            //         // "${controller.videoDetails.value!.duration!} minutes",
                                            //         "${controller.videoDetails.value!.durationTime!}",
                                            //     fontSize: FontSize
                                            //         .detailsScreenMediaTags.sp,
                                            //   ),
                                            // ),
                                            controller.videoDetails.value!
                                                        .viewCount !=
                                                    '0'
                                                ? SvgPicture.asset(
                                                    "assets/icons/line.svg")
                                                : const SizedBox(),
                                            controller.videoDetails.value!
                                                        .viewCount !=
                                                    '0'
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10.w, right: 10.w),
                                                    margin: EdgeInsets.only(
                                                        right: 10.w),
                                                    child: Row(children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/eye.svg",
                                                        width: 16.w,
                                                        color: Colors.black,
                                                      ),
                                                      TextPoppins(
                                                        text:
                                                            " ${controller.videoDetails.value!.viewCount}",
                                                        fontSize: FontSize
                                                            .detailsScreenMediaTags
                                                            .sp,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ]),
                                                  )
                                                : const SizedBox()
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (controller.videoDetails.value!
                                                    .hasEpisodes!) {
                                                  Utils().showLoader();
                                                  print("Comes here");
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
                                                  var data = await controller
                                                      .fetchEpisodeDetails(
                                                          videoId: controller
                                                              .videoDetails
                                                              .value!
                                                              .videoEpisodes!
                                                              .episodesList![0]
                                                              .id,
                                                          isNext: true);
                                                  Get.back();
                                                  if (data != null) {
                                                    if (data.title == null) {
                                                      return;
                                                    }
                                                    await controller.increaseCount(
                                                        id: controller
                                                            .videoDetails.value!.id
                                                            .toString());
                                                    log(data.toJson().toString());
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
                                                    Get.toNamed(
                                                        AppRoute.videoPlayerScreen,
                                                        arguments: {
                                                          'data': data,
                                                          'isEpisode': true
                                                        });
                                                  }
                                                  return;
                                                } else {
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
                                                  Get.back();
                                                  await controller.increaseCount(
                                                      id: controller
                                                          .videoDetails.value!.id
                                                          .toString());
                                                  Get.toNamed(
                                                      AppRoute.videoPlayerScreen,
                                                      arguments: {
                                                        'data': controller
                                                            .videoDetails.value!,
                                                        'isEpisode': false
                                                      });
                                                  return;
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 36.w,
                                                    vertical: 12.h),
                                                decoration: BoxDecoration(
                                                    color: kColorPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200.r)),
                                                child: Text(
                                                  "${"Play".tr} ${"Video".tr}",
                                                  style: kTextStyleInterSemiBold
                                                      .copyWith(
                                                    fontSize: FontSize
                                                        .detailsScreenMediaButton
                                                        .sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Obx(
                                              () => GestureDetector(
                                                onTap: () async {
                                                  if (Get.find<
                                                              BottomAppBarServices>()
                                                          .token
                                                          .value !=
                                                      '') {
                                                    // Show a loading indicator while the API call is in progress.
                                                    controller.toggleWishlistFlag(
                                                        !controller.videoDetails
                                                            .value!.wishList!);
                                                    setState(() {});
        
                                                    try {
                                                      await userMediaLikedCreateServices
                                                          .updateUserMediaLikedCreate(
                                                        token: Get.find<
                                                                BottomAppBarServices>()
                                                            .token
                                                            .value,
                                                        mediaType: "Video",
                                                        likedMediaId: controller
                                                            .videoDetails.value!.id
                                                            .toString(),
                                                      );
        
                                                      log("Successfully ${controller.videoDetails.value!.wishList! ? "removed from" : "added to"} wishlist");
                                                      if (controller
                                                              .prevRoute.value ==
                                                          AppRoute
                                                              .likedListScreen) {
                                                        Utils().showLoader();
                                                        Get.find<
                                                                UserLikedListsController>()
                                                            .clearMediaLikedLists();
                                                        await Get.find<
                                                                UserLikedListsController>()
                                                            .fetchLikedListingFilter(
                                                                type: "Video");
                                                        Get.back();
                                                      }
                                                      // Call Ebooklisting API here to fetch updated details.
                                                      await controller
                                                          .fetchVideoDetails(
                                                              videoId: controller
                                                                  .videoDetails
                                                                  .value!
                                                                  .id,
                                                              isNext: false);
        
                                                      log("Book details API called");
        
                                                      // After the API call is complete, update the icon.
                                                      setState(() {});
                                                    } catch (error) {
                                                      // Handle error and revert the local state if necessary.
                                                      // Remove the loading indicator and update the UI accordingly.
                                                      controller.toggleWishlistFlag(
                                                          !controller.videoDetails
                                                              .value!.wishList!);
                                                      setState(() {});
                                                    }
                                                  } else {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        constraints: BoxConstraints(
                                                            minWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width),
                                                        builder: (context) {
                                                          return ProfileDialog(
                                                            title: 'Login'.tr,
                                                            asssetIcon:
                                                                'assets/icons/login_icon_2.svg',
                                                            contentText:
                                                                'You will need to login to carry out this action. Login?'
                                                                    .tr
                                                                    .tr,
                                                            btn1Text: 'Login'
                                                                .tr
                                                                .tr, //Save button
                                                            btn2Text: 'Go back'.tr,
                                                          );
                                                        });
                                                  }
                                                },
                                                child: SizedBox(
                                                  height: 41.h,
                                                  width: 41.h,
                                                  child: controller
                                                              .wishlistFlag.value ==
                                                          false
                                                      ? SvgPicture.asset(
                                                          'assets/icons/fav_empty.svg',
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/icons/fav.svg',
                                                        ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            GestureDetector(
                                              onTap: () => controller.sharePage(),
                                              child: SvgPicture.asset(
                                                "assets/icons/share.svg",
                                                height: 41.h,
                                                width: 41.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 24.w, right: 24.w),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextPoppins(
                                              text: "Description:".tr,
                                              fontSize: FontSize
                                                  .detailsScreenMediaSubHeadings.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        DescriptionTextWidget(
                                          description: controller
                                              .videoDetails.value!.description!,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        controller.videoDetails.value!.hasEpisodes!
                                            ? Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 24.w, right: 24.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                                "assets/icons/list.svg"),
                                                            SizedBox(
                                                              width: 14.w,
                                                            ),
                                                            TextPoppins(
                                                              text:
                                                                  "${controller.videoDetails.value!.videoEpisodes?.episodesList!.length} ${"Chapters".tr}",
                                                              fontSize: FontSize
                                                                  .detailsScreenMediaDesc
                                                                  .sp,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              color:
                                                                  kColorBlackWithOpacity75,
                                                            ),
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          onTap: () => Get.toNamed(
                                                              AppRoute
                                                                  .allChaptersScreen,
                                                              arguments: false),
                                                          child: TextPoppins(
                                                            text: "See All".tr,
                                                            color: kColorPrimary,
                                                            fontSize: FontSize
                                                                .detailsScreenMediaDesc
                                                                .sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 24.w, right: 24.w),
                                                    child: Column(
                                                      children: [
                                                        for (int index = 0;
                                                            (index <
                                                                (controller
                                                                            .videoDetails
                                                                            .value!
                                                                            .videoEpisodes!
                                                                            .episodesList!
                                                                            .length >
                                                                        5
                                                                    ? 5
                                                                    : controller
                                                                        .videoDetails
                                                                        .value!
                                                                        .videoEpisodes!
                                                                        .episodesList!
                                                                        .length));
                                                            index++) ...[
                                                          Column(
                                                            children: [
                                                              Obx(() => ListTile(
                                                                    onTap:
                                                                        () async {
                                                                      Utils()
                                                                          .showLoader();
                                                                      if (!controller
                                                                          .isGuestUser
                                                                          .value) {
                                                                        // Utils().showLoader();
                                                                        await userMediaPlayedCreateServices
                                                                            .updateUserMediaPlayedCreatelist(
                                                                          token: Get.find<
                                                                                  BottomAppBarServices>()
                                                                              .token
                                                                              .value,
                                                                          mediaType:
                                                                              "Video",
                                                                          playedId: controller
                                                                              .videoDetails
                                                                              .value!
                                                                              .id
                                                                              .toString(),
                                                                        );
                                                                      }
                                                                      var data = await controller.fetchEpisodeDetails(
                                                                          videoId: controller
                                                                              .videoDetails
                                                                              .value!
                                                                              .videoEpisodes!
                                                                              .episodesList![
                                                                                  index]
                                                                              .id,
                                                                          isNext:
                                                                              true);
                                                                      await controller.increaseCount(
                                                                          id: controller
                                                                              .videoDetails
                                                                              .value!
                                                                              .id
                                                                              .toString());
                                                                      Get.back();
                                                                      if (data !=
                                                                          null) {
                                                                        log(data
                                                                            .toJson()
                                                                            .toString());
                                                                        if (Get.isRegistered<
                                                                            PlayerController>()) {
                                                                          Get.find<PlayerController>()
                                                                                  .audioPlayer
                                                                                  .value
                                                                                  .playerState
                                                                                  .playing
                                                                              ? await Get.find<PlayerController>()
                                                                                  .audioPlayer
                                                                                  .value
                                                                                  .pause()
                                                                              : null;
                                                                        }
                                                                        Get.toNamed(
                                                                            AppRoute
                                                                                .videoPlayerScreen,
                                                                            arguments: {
                                                                              'data':
                                                                                  data,
                                                                              'isEpisode':
                                                                                  true
                                                                            });
                                                                      }
                                                                    },
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    visualDensity:
                                                                        VisualDensity(
                                                                            vertical: screenWidth >=
                                                                                    600
                                                                                ? 2
                                                                                : -2),
                                                                    title:
                                                                        TextPoppins(
                                                                      text: controller
                                                                          .videoDetails
                                                                          .value!
                                                                          .videoEpisodes!
                                                                          .episodesList![
                                                                              index]
                                                                          .title!,
                                                                      maxLines: 2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize: FontSize
                                                                          .detailsScreenMediaDesc
                                                                          .sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    trailing:
                                                                        TextPoppins(
                                                                      text: Get.find<
                                                                              VideoDetailsController>()
                                                                          .videoDetails
                                                                          .value!
                                                                          .videoEpisodes!
                                                                          .episodesList![
                                                                              index]
                                                                          .durationTime!
                                                                          .toString(),
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize: FontSize
                                                                          .detailsScreenSubMediaLangaugeTag
                                                                          .sp,
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                          index != 4
                                                              ? Divider(
                                                                  thickness: 1.sp,
                                                                  color: kColorBlack
                                                                      .withOpacity(
                                                                          0.1),
                                                                )
                                                              : SizedBox.shrink()
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  controller.videoDetails.value!.peopleAlsoViewData!
                                          .isNotEmpty
                                      ? Column(
                                          children: [
                                            Container(
                                              height: 16.h,
                                              color: kColorWhite2,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 24.w,
                                                  right: 24.w,
                                                  top: 24.h),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      height: screenWidth >= 600
                                                          ? 40.h
                                                          : 26.h,
                                                      width: screenWidth >= 600
                                                          ? 40.h
                                                          : 26.h,
                                                      child: SvgPicture.asset(
                                                          "assets/icons/swastik.svg")),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  TextPoppins(
                                                    text: "People also view".tr,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24.h,
                                            ),
                                            Container(
                                              alignment: Alignment.bottomLeft,
                                              // padding: EdgeInsets.only(left: 24.w),
                                              height: screenWidth >= 600
                                                  ? 320.h
                                                  : 180.h,
                                              child: VideoListVideoDetails(
                                                  videosList: controller
                                                      .videoDetails
                                                      .value!
                                                      .peopleAlsoViewData!,
                                                  scrollController:
                                                      scrollController),
                                            ),
                                            SizedBox(
                                              height: 100.h,
                                            )
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              Container(
                                // alignment: Alignment.center,
                                height: 215.h,
                                margin: EdgeInsets.only(top: 24.h),
                                width: width,
                                padding: EdgeInsets.only(left: 50.w, right: 50.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: FadeInImage(
                                    image: NetworkImage(controller
                                        .videoDetails.value!.coverImageUrl!),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    placeholderFit: BoxFit.scaleDown,
                                    // alignment: Alignment.center,
                                    placeholder: const AssetImage(
                                        "assets/icons/default.png"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          "assets/icons/default.png");
                                    }, // width: 300.w,
                                  ),
                                ),
                              ),
                              Container(
                                  // alignment: Alignment.topRight,
                                  // bottom: 0.h,
                                  // right: width * 0.29,
                                  height: 45.h,
                                  width: width,
                                  margin: EdgeInsets.only(top: 214.h),
                                  child: SvgPicture.asset(
                                    "assets/icons/video.svg",
                                    fit: BoxFit.fitHeight,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      
    );
  }
}
