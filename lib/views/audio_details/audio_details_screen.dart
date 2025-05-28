import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yatharthageeta/services/network/network_service.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../controllers/user_liked_List/user_liked_list_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/user_media_liked_create/service/user_media_liked_create_service.dart';
import '../../services/user_media_played_create/service/user_media_played_create_service.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_listing/audio_listing_card.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/profile_bottom_dialogs.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/ebook_details/description_text_widget.dart';

class AudioDetailsScreen extends StatefulWidget {
  const AudioDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AudioDetailsScreen> createState() => _AudioDetailsScreenState();
}

class _AudioDetailsScreenState extends State<AudioDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkService>();
    final screenHeight = MediaQuery.of(context).size.height;
    AudioDetailsController controller = Get.find<AudioDetailsController>();
    ScrollController scrollController = new ScrollController();
    final userMediaLikedCreateServices =
        Get.find<UserMediaLikedCreateServices>();
    final userMediaPlayedCreateServices =
        Get.find<UserMediaPlayedCreateServices>();
    // Result audioDetails = Get.arguments;
    // print(controller.audioDetails.value);
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => Container(
        color: kColorWhite,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: kColorWhite,
            bottomNavigationBar: Obx(
              () => Get.find<BottomAppBarServices>().miniplayerVisible.value
                  ? const MiniPlayer()
                  : const SizedBox.shrink(),
            ),
            body: Column(
              children: [
                CustomAppBar(
                  title: 'Audio'.tr,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 234.h,
                              width: double.infinity,
                              color: kColorWhite2,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: 110.h,
                              ),
                              // margin:
                              //     EdgeInsets.only(left: 25.w, right: 25.w),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.w, right: 25.w),
                                    child: Text(
                                      controller.audioDetails.value!.title!.tr,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize:
                                            FontSize.detailsScreenMediaTitle.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextPoppins(
                                    text:
                                        "${'by'.tr} ${controller.audioDetails.value!.authorName}",
                                    fontSize:
                                        FontSize.detailsScreenMediaAuthor.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: const Color(0xffFEF8F6),
                                        margin: EdgeInsets.only(
                                            right: 10.w, left: 24.w),
                                        padding: EdgeInsets.only(
                                            left: 12.w,
                                            right: 12.w,
                                            top: 2.h,
                                            bottom: 2.h),
                                        child: TextPoppins(
                                          text: controller.audioDetails.value!
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
                                      //         // "${controller.audioDetails.value!.duration!} minutes",
                                      //         controller.audioDetails.value!
                                      //             .durationTime!,
                                      //     fontSize: FontSize
                                      //         .detailsScreenMediaTags.sp,
                                      //   ),
                                      // ),
                                      controller.audioDetails.value!
                                                  .viewCount !=
                                              '0'
                                          ? SvgPicture.asset(
                                              "assets/icons/line.svg")
                                          : const SizedBox(),
                                      controller.audioDetails.value!
                                                  .viewCount !=
                                              '0'
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  left: 10.w, right: 10.w),
                                              margin: EdgeInsets.only(
                                                  left: 10.w, right: 10.w),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/eye_ebookdetail.svg",
                                                    width: 16.w,
                                                    color: Colors.black,
                                                  ),
                                                  TextPoppins(
                                                    text:
                                                        " ${controller.audioDetails.value!.viewCount}",
                                                    fontSize: FontSize
                                                        .detailsScreenMediaTags
                                                        .sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (networkService
                                                  .connectionStatus.value ==
                                              1) {
                                            if (!controller.audioDetails.value!
                                                    .chapters.isNull &&
                                                controller
                                                    .audioDetails
                                                    .value!
                                                    .chapters!
                                                    .chaptersList!
                                                    .isEmpty) {
                                              return;
                                            }
                                            Utils().showLoader();
                                            var playerController =
                                                Get.put(PlayerController());
                                            await playerController
                                                .createPlaylist(controller
                                                    .audioDetails.value!);
                                            controller.audioDetails.value!
                                                    .hasEpisodes!
                                                ? await playerController
                                                    .initData(controller
                                                            .audioDetails
                                                            .value!
                                                            .chapters!
                                                            .chaptersList?[0] ??
                                                        0)
                                                : await playerController
                                                    .initData(0);
                                            StreamSubscription<PlayerState>?
                                                subscription;

                                            subscription = playerController
                                                .audioPlayer
                                                .value
                                                .playerStateStream
                                                .listen((event) async {
                                              if (event.processingState ==
                                                  ProcessingState.ready) {
                                                subscription!.cancel();
                                                if (controller.audioDetails
                                                        .value!.hasEpisodes! &&
                                                    !playerController
                                                        .isShloka.value) {
                                                  playerController
                                                          .chapterName.value =
                                                      playerController
                                                          .modelList
                                                          .keys
                                                          .first
                                                          .chapterName!;
                                                  playerController
                                                          .verseName.value =
                                                      playerController
                                                          .modelList
                                                          .values
                                                          .first
                                                          .first
                                                          .versesName!;
                                                  log("Here us the chapter name : ${playerController.chapterName.value.toString()}");
                                                }
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
                                                await controller.increaseCount(
                                                    id: controller
                                                        .audioDetails.value!.id
                                                        .toString());
                                                Get.back();
                                                playerController
                                                    .audioPlayer.value
                                                    .play();
                                                Get.toNamed(
                                                    AppRoute.audioPlayerScreen);
                                              }
                                            });
                                          } else {
                                            Utils.customToast(
                                                "Please Check your initernet connection",
                                                kColorWhite,
                                                kRedColor,
                                                "error");
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 36.w, vertical: 12.h),
                                          decoration: BoxDecoration(
                                              color: !controller
                                                          .audioDetails
                                                          .value!
                                                          .chapters
                                                          .isNull &&
                                                      controller
                                                          .audioDetails
                                                          .value!
                                                          .chapters!
                                                          .chaptersList!
                                                          .isEmpty
                                                  ? Colors.grey[700]
                                                  : kColorPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(200.r)),
                                          child: Text(
                                            controller.audioDetails.value!
                                                    .hasEpisodes!
                                                ? "Play All".tr
                                                : "Play".tr,
                                            style: kTextStyleInterSemiBold
                                                .copyWith(
                                              fontSize: FontSize
                                                  .detailsScreenMediaButton.sp,
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
                                            if (networkService
                                                    .connectionStatus.value ==
                                                1) {
                                              if (Get.find<
                                                          BottomAppBarServices>()
                                                      .token
                                                      .value !=
                                                  '') {
                                                // Show a loading indicator while the API call is in progress.
                                                controller.toggleWishlistFlag(
                                                    !controller.audioDetails
                                                        .value!.wishList!);
                                                setState(() {});

                                                try {
                                                  await userMediaLikedCreateServices
                                                      .updateUserMediaLikedCreate(
                                                    token: Get.find<
                                                            BottomAppBarServices>()
                                                        .token
                                                        .value,
                                                    mediaType: controller
                                                        .audioDetails
                                                        .value!
                                                        .selectedType
                                                        .toString(),
                                                    likedMediaId: controller
                                                        .audioDetails.value!.id
                                                        .toString(),
                                                  );

                                                  log("Successfully ${controller.audioDetails.value!.wishList! ? "removed from" : "added to"} wishlist");
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
                                                            type: "Audio");
                                                    Get.back();
                                                  }
                                                  // Call Ebooklisting API here to fetch updated details.
                                                  await controller
                                                      .fetchAudioDetails(
                                                          token: Get.find<
                                                                  BottomAppBarServices>()
                                                              .token
                                                              .value,
                                                          audioId: controller
                                                              .audioDetails
                                                              .value!
                                                              .id);

                                                  log("Audio details API called");

                                                  // After the API call is complete, update the icon.
                                                  setState(() {});
                                                } catch (error) {
                                                  // Handle error and revert the local state if necessary.
                                                  // Remove the loading indicator and update the UI accordingly.
                                                  controller.toggleWishlistFlag(
                                                      !controller.audioDetails
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
                                                                .tr,
                                                        btn1Text: 'Login'
                                                            .tr, //Save button
                                                        btn2Text: 'Go back'.tr,
                                                      );
                                                    });
                                              }
                                            } else {
                                              Utils.customToast(
                                                  "Please Check your initernet connection",
                                                  kColorWhite,
                                                  kRedColor,
                                                  "error");
                                            }
                                          },
                                          child: SizedBox(
                                            height: 41.h,
                                            width: 41.h,
                                            child:
                                                controller.wishlistFlag.value ==
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
                                        onTap: () {
                                          if (networkService
                                                  .connectionStatus.value ==
                                              1) {
                                            controller.sharePage();
                                          } else {
                                            Utils.customToast(
                                                "Please Check your initernet connection",
                                                kColorWhite,
                                                kRedColor,
                                                "error");
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/share.svg",
                                          height: 41.h,
                                          width: 41.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 24.w, right: 24.w, top: 24.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextPoppins(
                                        text: "Description:".tr,
                                        fontSize:
                                            FontSize.detailsScreenMediaDesc.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DescriptionTextWidget(
                                    // description: Constants.ebookDummyDesc,
                                    description: controller
                                        .audioDetails.value!.description
                                        .toString(),
                                  ),
                                  SizedBox(
                                    height: 24.h,
                                  ),
                                  controller.audioDetails.value!.hasEpisodes!
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
                                                            // "${controller.audioDetails.value!.chapters!.chaptersList!.length} ${"Chapters".tr}, ${controller.audioDetails.value!.chapters!.totalVerses} ${"Verses".tr}",
                                                            "${controller.audioDetails.value!.chapters!.totalChapters} ${"Chapters".tr}",
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
                                                    onTap: () {
                                                      if (networkService
                                                              .connectionStatus
                                                              .value ==
                                                          1) {
                                                        Get.toNamed(
                                                            AppRoute
                                                                .allChaptersScreen,
                                                            arguments: true);
                                                      } else {
                                                        Utils.customToast(
                                                            "Please Check your initernet connection",
                                                            kColorWhite,
                                                            kRedColor,
                                                            "error");
                                                      }
                                                    },
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
                                                                      .audioDetails
                                                                      .value!
                                                                      .chapters!
                                                                      .chaptersList!
                                                                      .length >
                                                                  5
                                                              ? 5
                                                              : controller
                                                                  .audioDetails
                                                                  .value!
                                                                  .chapters!
                                                                  .chaptersList!
                                                                  .length));
                                                      index++) ...[
                                                    Column(
                                                      children: [
                                                        Obx(
                                                          () => ListTile(
                                                            onTap: () async {
                                                              if (networkService
                                                                      .connectionStatus
                                                                      .value ==
                                                                  1) {
                                                                Utils()
                                                                    .showLoader();
                                                                if (!controller
                                                                    .isGuestUser
                                                                    .value) {
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
                                                                        .audioDetails
                                                                        .value!
                                                                        .id
                                                                        .toString(),
                                                                  );
                                                                }
                                                                var playerController =
                                                                    Get.put(
                                                                        PlayerController());
                                                                await playerController
                                                                    .createPlaylist(controller
                                                                        .audioDetails
                                                                        .value!);
                                                                // playerController
                                                                //     .modelList
                                                                //     .clear();
                                                                // log("PLaylist after clearing ${playerController.modelList.length}");
                                                                await playerController
                                                                    .initData(controller
                                                                        .audioDetails
                                                                        .value!
                                                                        .chapters!
                                                                        .chaptersList?[index]);
                                                                if (controller
                                                                    .audioDetails
                                                                    .value!
                                                                    .hasEpisodes!) {
                                                                  playerController
                                                                      .chapterName
                                                                      .value = controller
                                                                          .audioDetails
                                                                          .value!
                                                                          .chapters!
                                                                          .chaptersList?[
                                                                              index]
                                                                          .chapterName!
                                                                          .toString() ??
                                                                      "";
                                                                }
                                                                // StreamSubscription<
                                                                //         PlayerState>?
                                                                //     subscription;

                                                                // subscription = playerController
                                                                //     .audioPlayer
                                                                //     .value
                                                                //     .playerStateStream
                                                                //     .listen(
                                                                //         (event) async {
                                                                //   if (event
                                                                //           .processingState ==
                                                                //       ProcessingState
                                                                //           .ready) {
                                                                //     subscription!
                                                                //         .cancel();

                                                                //     // int i = 0;
                                                                //     int seek =
                                                                //         0;
                                                                //     for (var i =
                                                                //             0;
                                                                //         i < playerController.modelList.keys.length;
                                                                //         i++) {
                                                                //       if (playerController.modelList.keys.elementAt(i) ==
                                                                //           controller.audioDetails.value!.chapters!.chaptersList![index]) {
                                                                //         playerController.chapterName.value = playerController
                                                                //             .modelList
                                                                //             .keys
                                                                //             .first
                                                                //             .chapterName!;
                                                                //         playerController.verseName.value = playerController
                                                                //             .modelList
                                                                //             .values
                                                                //             .first
                                                                //             .first
                                                                //             .versesName!;
                                                                //         break;
                                                                //       }
                                                                //       playerController
                                                                //           .modelList
                                                                //           .values
                                                                //           .elementAt(i)
                                                                //           .forEach((element) {
                                                                //         seek +=
                                                                //             1;
                                                                //       });
                                                                //     }
                                                                //     print(
                                                                //         "------>");
                                                                await controller.increaseCount(
                                                                    id: controller
                                                                        .audioDetails
                                                                        .value!
                                                                        .id
                                                                        .toString());
                                                                await playerController
                                                                    .audioPlayer
                                                                    .value
                                                                    .seek(
                                                                        Duration
                                                                            .zero,
                                                                        index:
                                                                            index);
                                                                Get.back();
                                                                playerController
                                                                    .audioPlayer
                                                                    .value
                                                                    .play();
                                                                Get.toNamed(AppRoute
                                                                    .audioPlayerScreen);
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
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            visualDensity: VisualDensity(
                                                                vertical:
                                                                    screenWidth >=
                                                                            600
                                                                        ? 2
                                                                        : -2),
                                                            title: TextPoppins(
                                                              text: controller
                                                                  .audioDetails
                                                                  .value!
                                                                  .chapters!
                                                                  .chaptersList![
                                                                      index]
                                                                  .chapterName!,
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
                                                              text: Utils.minutesToTime(Get
                                                                      .find<
                                                                          AudioDetailsController>()
                                                                  .audioDetails
                                                                  .value!
                                                                  .chapters!
                                                                  .chaptersList![
                                                                      index]
                                                                  .duration!),
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: FontSize
                                                                  .detailsScreenSubMediaLangaugeTag
                                                                  .sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    index != 4
                                                        ? Divider(
                                                            thickness: 1.sp,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    0.1),
                                                          )
                                                        : const SizedBox
                                                            .shrink()
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            controller.audioDetails.value!.peopleAlsoReadData!
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
                                            top: 24.h,
                                            bottom: 24.h),
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
                                              text: "People also listen".tr,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            SizedBox(
                                              height: 24.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            ListView.builder(
                              shrinkWrap: true,
                              // padding: EdgeInsets.only(left: 24.w),
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.audioDetails.value!
                                  .peopleAlsoReadData!.length,
                              itemBuilder: (context, index) {
                                var element = controller.audioDetails.value!
                                    .peopleAlsoReadData![index];
                                return InkWell(
                                  onTap: () async {
                                    if (networkService.connectionStatus.value ==
                                        1) {
                                      Utils().showLoader();
                                      await scrollController.animateTo(0,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.easeIn);
                                      await controller.fetchAudioDetails(
                                          audioId: element.id,
                                          ctx: context,
                                          token:
                                              Get.find<BottomAppBarServices>()
                                                  .token
                                                  .value);
                                      Get.back();
                                      setState(() {});
                                    } else {
                                      Utils.customToast(
                                          "Please Check your initernet connection",
                                          kColorWhite,
                                          kRedColor,
                                          "error");
                                    }
                                    // var detailsController =
                                    //     Get.put(AudioDetailsController());
                                  },
                                  child: AudioListingCard(
                                    imageUrl: element.audioCoverImageUrl!,
                                    title: element.title!.tr,
                                    artist: element.authorName!,
                                    language: element.mediaLanguage!,
                                    hasEpisodes: element.hasEpisodes!,
                                    duration: element.episodesCount.toString(),
                                    views: element.viewCount.toString(),
                                    isEnd: controller.audioDetails.value!
                                                .peopleAlsoReadData!.length -
                                            1 ==
                                        index,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 100.h,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: 100.h,
                              ),
                              // clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                height: 200.h,
                                // width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200.r),
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    height: 200.h,
                                    width: 200.h,
                                    child: FadeInImage(
                                      image: NetworkImage(controller
                                          .audioDetails
                                          .value!
                                          .audioCoverImageUrl!),
                                      fit: BoxFit.fill,
                                      placeholderFit: BoxFit.scaleDown,
                                      placeholder: const AssetImage(
                                          "assets/icons/default.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            "assets/icons/default.png");
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            width: double.infinity,
                            // height: 200,
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.only(top: 280.h),
                            child: SizedBox(
                              width: 50.w,
                              child: SvgPicture.asset(
                                "assets/icons/music.svg",
                                width: 35.w,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
