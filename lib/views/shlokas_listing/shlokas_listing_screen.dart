import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/widgets/common/chapter_filter.dart';
import 'package:yatharthageeta/widgets/common/language_filter_shlok.dart';
import 'package:yatharthageeta/widgets/common/verse_filter.dart';
import 'package:yatharthageeta/widgets/shlokas_listing/dropdown.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/shlokas_listing/shlokas_listing_controller.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/no_data_found_widget.dart';

import '../../services/network/network_service.dart';
import '../../utils/utils.dart';

class ShlokasListingScreen extends StatefulWidget {
  const ShlokasListingScreen({super.key});

  @override
  State<ShlokasListingScreen> createState() => _ShlokasListingScreenState();
}

class _ShlokasListingScreenState extends State<ShlokasListingScreen>
    with TickerProviderStateMixin {
  final shlokasListingController = Get.find<ShlokasListingController>();
  late AnimationController animation_controller;
  var playerController = Get.find<PlayerController>();

  @override
  void dispose() {
    animation_controller.dispose();
    super.dispose();
    shlokasListingController.clearShlokasListsData();
    log("shlokasChaptersList cleared = ${shlokasListingController.shlokasChaptersList}");
    log("shlokasListing cleared = ${shlokasListingController.shlokasListing}");
  }

  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    animation_controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
    print(
        "\x1B[32mverse list data checking: ${shlokasListingController.verseList}");
    //debugPrint("Shlokas build called");
    return Obx(
      () => networkService.connectionStatus.value == 0
          ? Utils().noInternetWidget(screenWidth, screenHeight)
          : Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: kColorWhite,
              bottomNavigationBar:
                  Get.find<BottomAppBarServices>().miniplayerVisible.value
                      ? const MiniPlayer()
                      : const SizedBox.shrink(),
              body: SafeArea(
                child: Column(
                  children: [
                    //App Bar
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
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      top: 12.h,
                                      bottom: 12.h,
                                    ),
                                    child: Text(
                                      'Shlokas'.tr,
                                      style: kTextStyleRosarioRegular.copyWith(
                                        color: kColorFont,
                                        fontSize: 24.sp,
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
                                    child: SvgPicture.asset(
                                        'assets/icons/back.svg'),
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
                              GestureDetector(
                                onTap: () {
                                  // Get.bottomSheet(LanguageFilter(
                                  //     tabIndex:
                                  //         shlokasListingController.tabIndex,
                                  //     languages: shlokasListingController
                                  //         .languageList));
                                  Get.bottomSheet(LanguageFilterShlok(
                                      tabIndex:
                                          shlokasListingController.tabIndex,
                                      languages: shlokasListingController
                                          .languageList));
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 110.w,
                                    margin:
                                        EdgeInsets.only(right: 24.w, top: 12.h),
                                    child: GestureDetector(
                                      // onTap: () => Get.bottomSheet(
                                      //     ChapterFilter(
                                      //         tabIndex: 0.obs,
                                      //         languages:
                                      //             shlokasListingController
                                      //                 .languageList)),
                                      child: DropDown(
                                        text: shlokasListingController
                                            .groupValue.value,
                                        color: kColorSecondary,
                                        textSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 28.h,
                          ),

                          //Search Bar
                          Container(
                            margin: EdgeInsets.only(
                                left: 25.w, right: 25.w, bottom: 24.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(ChapterFilter(
                                          tabIndex:
                                              shlokasListingController.tabIndex,
                                          languages: shlokasListingController
                                              .chaptersList));
                                    },
                                    child: DropDown(
                                        text:
                                            "${"Chapter".tr} ${shlokasListingController.chapGroupValue}",
                                        color: kColorPrimary,
                                        textSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(VerseFilter(
                                          tabIndex:
                                              shlokasListingController.tabIndex,
                                          languages: shlokasListingController
                                              .verseList));
                                    },
                                    child: DropDown(
                                        text:
                                            "${"Verse".tr} ${shlokasListingController.verseGroupValue}",
                                        color: kColorPrimary,
                                        textSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            // child: CustomSearchBarNew(
                            //   controller:
                            //       shlokasListingController.searchController,
                            //   fillColor: kColorWhite,
                            //   filled: true,
                            //   filterAvailable: true,
                            //   onChanged: (p0) {
                            //     shlokasListingController.searchController.text =
                            //         p0;
                            //     debugPrint("searchQuery.valuep0:$p0");
                            //   },
                            //   contentPadding: EdgeInsets.all(16.h),
                            //   filterBottomSheet: LanguageFilter(
                            //       tabIndex: shlokasListingController.tabIndex,
                            //       languages:
                            //           shlokasListingController.languageList),
                            //   hintText: 'Search...'.tr,
                            //   hintStyle: kTextStylePoppinsRegular.copyWith(
                            //     color: kColorFontOpacity25,
                            //     fontSize: FontSize.searchBarHint.sp,
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => shlokasListingController.verseList.length != 0
                          ? Expanded(
                              child: SingleChildScrollView(
                                controller:
                                    shlokasListingController.scrollController,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 24.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 24.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff17120B)
                                                .withOpacity(0.15),
                                            width: 1.sp),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "मुख्य श्लोक",
                                            textAlign: TextAlign.center,
                                            style: kTextStylePoppinsMedium
                                                .copyWith(
                                                    color: kColorSecondary,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          // SizedBox(
                                          //   height: 12.h,
                                          // ),
                                          html.Html(
                                            data: shlokasListingController
                                                .returnVerse(
                                                    verseNumber: int.parse(
                                                        shlokasListingController
                                                            .verseGroupValue
                                                            .value))!
                                                .mainShlok!,
                                            style: {
                                              'p': html.Style(
                                                  fontSize:
                                                      html.FontSize.medium,
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.center,
                                                  fontFamily: "Poppins-Regular")
                                            },
                                            // child: Text(
                                            //   ,
                                            //   textAlign: TextAlign.center,
                                            //   style:
                                            //       kTextStylePoppinsMedium.copyWith(
                                            //           fontSize: 14.sp,
                                            //           fontWeight: FontWeight.w400),
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 24.w,
                                        right: 24.w,
                                        top: 24.h,
                                        bottom: 24.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: kColorBlack,
                                              thickness: 1.w,
                                            ),
                                          ),
                                          Text(
                                            "    ${"Shloka Meaning".tr}    ",
                                            style: kTextStyleNiconneRegular
                                                .copyWith(
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: kColorBlack,
                                              thickness: 1.w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w),
                                      child: html.Html(
                                        data: shlokasListingController
                                            .returnVerse(
                                                verseNumber: int.parse(
                                                    shlokasListingController
                                                        .verseGroupValue
                                                        .value))!
                                            .explainationShlok!,
                                        style: {
                                          'p': html.Style(
                                            fontSize: html.FontSize.medium,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                            fontFamily: "NotoSans-Medium",
                                          )
                                        },
                                        // child: Text(

                                        //   textAlign: TextAlign.center,
                                        //   style: kTextStyleNotoMedium.copyWith(
                                        //       fontSize: 14.sp,
                                        //       fontWeight: FontWeight.w400),
                                        // ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 36.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          (shlokasListingController.verseList
                                                      .indexWhere((verse) =>
                                                          verse["value"] ==
                                                          shlokasListingController
                                                              .verseGroupValue) !=
                                                  0)
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    // await playerController
                                                    //     .audioPlayer.value
                                                    //     .play();
                                                    int index = shlokasListingController
                                                        .verseList
                                                        .indexWhere((verse) =>
                                                            verse["value"] ==
                                                            shlokasListingController
                                                                .verseGroupValue);
                                                    if (index > 0) {
                                                      shlokasListingController
                                                          .verseGroupValue
                                                          .value = (int.parse(
                                                                  shlokasListingController
                                                                      .verseGroupValue
                                                                      .value) -
                                                              1)
                                                          .toString();
                                                      await shlokasListingController
                                                          .scrollController
                                                          .animateTo(0,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              curve: Curves
                                                                  .linear);
                                                      if (shlokasListingController
                                                          .startupService
                                                          .startupData
                                                          .first
                                                          .data!
                                                          .result!
                                                          .shlokas_language_ids!
                                                          .contains(
                                                              shlokasListingController
                                                                  .groupValueId
                                                                  .value)) {
                                                        var playerController =
                                                            Get.find<
                                                                PlayerController>();
                                                        // int backForth = playerController
                                                        //         .audioPlayer
                                                        //         .value
                                                        //         .currentIndex! -
                                                        //     shlokasListingController
                                                        //         .verseList
                                                        //         .indexWhere((verse) =>
                                                        //             verse[
                                                        //                 "value"] ==
                                                        //             shlokasListingController
                                                        //                 .verseGroupValue);
                                                        // log(backForth.toString() +
                                                        //     " number of time go back or forth");
                                                        // while (backForth != 0) {
                                                        //   if (backForth > 0) {
                                                        //     await playerController
                                                        //         .audioPlayer.value
                                                        //         .seekToPrevious();
                                                        //     backForth--;
                                                        //   } else {
                                                        //     await playerController
                                                        //         .audioPlayer.value
                                                        //         .seekToNext();
                                                        //     backForth++;
                                                        //   }
                                                        // }
                                                        await playerController
                                                            .audioPlayer.value
                                                            .seekToPrevious();
                                                        await playerController
                                                            .audioPlayer.value
                                                            .pause();
                                                      }
                                                      //   await shlokasListingController
                                                      //       .initializeAudio(
                                                      //           verseNumber: int.parse(
                                                      //               shlokasListingController
                                                      //                   .verseGroupValue
                                                      //                   .value));
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.h,
                                                            horizontal: 16.w),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.r),
                                                      border: Border.all(
                                                          color: kColorPrimary,
                                                          width: 1.sp),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/previous.svg",
                                                          width: 15.w,
                                                        ),
                                                        SizedBox(width: 6.5.w),
                                                        Text(
                                                          "Previous".tr,
                                                          style: kTextStyleNotoRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      kColorPrimary),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                          //-- Vaibhav changes 25/03/2025
                                          // Condition to check whether the "Next" button should be visible
                                          // Check if the current verse is NOT the last verse in the list
                                          (shlokasListingController.verseList
                                                          .indexWhere((verse) =>
                                                              verse["value"] ==
                                                              shlokasListingController
                                                                  .verseGroupValue) !=
                                                      shlokasListingController
                                                              .verseList
                                                              .length -
                                                          1 ||
                                                  // OR condition: If audio exists, check if there is a next track available
                                                  (playerController.playListData
                                                          .isNotEmpty &&
                                                      playerController
                                                                  .currentIndex
                                                                  .value +
                                                              1 !=
                                                          shlokasListingController
                                                              .verseList
                                                              .length))
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    int index =
                                                        shlokasListingController
                                                            .verseList
                                                            .indexWhere(
                                                                (verse) {
                                                      return verse["value"]
                                                              .value ==
                                                          shlokasListingController
                                                              .verseGroupValue
                                                              .value;
                                                    });
                                                    print(index);
                                                    if (index <
                                                        shlokasListingController
                                                                .verseList
                                                                .length -
                                                            1) {
                                                      log("COmes Here ");
                                                      shlokasListingController
                                                          .verseGroupValue
                                                          .value = (int.parse(
                                                                  shlokasListingController
                                                                      .verseGroupValue
                                                                      .value) +
                                                              1)
                                                          .toString();
                                                      shlokasListingController
                                                              .verseList[index]
                                                                  ["groupValue"]
                                                              .value =
                                                          shlokasListingController
                                                              .verseGroupValue
                                                              .value;
                                                      log("Verse Condition ${shlokasListingController.verseList.indexWhere((verse) => verse["value"] == shlokasListingController.verseGroupValue) != shlokasListingController.verseList.length - 1}");
                                                      log("Verse Index ${shlokasListingController.verseList.indexWhere((verse) => verse["value"] == shlokasListingController.verseGroupValue)}");
                                                      log("Shloka Group Index ${shlokasListingController.verseList.indexWhere((verse) => verse["value"] == shlokasListingController.verseGroupValue)}");
                                                      log("Player Index ${playerController.currentIndex.value}");
                                                      log("Value iska dekh bhai ${shlokasListingController.verseList[index]["groupValue"].value}");
                                                      //   await shlokasListingController
                                                      //       .initializeAudio(
                                                      //           verseNumber: int.parse(
                                                      //               shlokasListingController
                                                      //                   .verseGroupValue
                                                      //                   .value));

                                                      if (shlokasListingController
                                                          .startupService
                                                          .startupData
                                                          .first
                                                          .data!
                                                          .result!
                                                          .shlokas_language_ids!
                                                          .contains(
                                                              shlokasListingController
                                                                  .groupValueId
                                                                  .value)) {
                                                        var playerController =
                                                            Get.find<
                                                                PlayerController>();
                                                        // int backForth = playerController
                                                        //         .audioPlayer
                                                        //         .value
                                                        //         .currentIndex! -
                                                        //     shlokasListingController
                                                        //         .verseList
                                                        //         .indexWhere((verse) =>
                                                        //             verse[
                                                        //                 "value"] ==
                                                        //             shlokasListingController
                                                        //                 .verseGroupValue);
                                                        // log(backForth.toString() +
                                                        //     " number of time go back or forth");
                                                        // while (backForth != 0) {
                                                        //   if (backForth > 0) {
                                                        //     await playerController
                                                        //         .audioPlayer.value
                                                        //         .seekToPrevious();
                                                        //     backForth--;
                                                        //   } else {
                                                        //     await playerController
                                                        //         .audioPlayer.value
                                                        //         .seekToNext();
                                                        //     backForth++;
                                                        //   }
                                                        // }
                                                        await playerController
                                                            .audioPlayer.value
                                                            .seekToNext();
                                                        await playerController
                                                            .audioPlayer.value
                                                            .pause();
                                                        // await playerController
                                                        //     .audioPlayer.value
                                                        //     .play();
                                                      }
                                                      await shlokasListingController
                                                          .scrollController
                                                          .animateTo(0,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              curve: Curves
                                                                  .linear);
                                                    }
                                                    // await playerController
                                                    //     .audioPlayer.value
                                                    //     .seekToNext();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.h,
                                                            horizontal: 16.w),
                                                    margin: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    decoration: BoxDecoration(
                                                      color: kColorPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.r),
                                                      // border: Border.all(
                                                      //     color: kColorPrimary,
                                                      //     width: 1.sp),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Next".tr,
                                                          style: kTextStyleNotoMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      kColorWhite),
                                                        ),
                                                        SizedBox(
                                                          width: 6.5.w,
                                                        ),
                                                        SvgPicture.asset(
                                                          "assets/icons/next.svg",
                                                          width: 15.w,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )

                          // shlokasListingController.shlokasChaptersList.isNotEmpty
                          //     ? Container(
                          //         decoration: BoxDecoration(
                          //           color: kColorWhite,
                          //           border: Border(
                          //             bottom: BorderSide(
                          //               color: kColorPrimaryWithOpacity25,
                          //             ),
                          //           ),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black.withOpacity(0.05),
                          //               offset: const Offset(0, 15),
                          //               blurRadius: 20,
                          //             ),
                          //           ],
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             SizedBox(
                          //               height: 16.h,
                          //             ),

                          //             //Chapters List
                          //             SizedBox(
                          //               height: 35.h,
                          //               // color: Colors.red,
                          //               // width: screenSize.width,
                          //               child: ShlokasChaptersListWidget(
                          //                 sholokasChaptersList:
                          //                     shlokasListingController
                          //                         .shlokasChaptersList.value,
                          //               ),
                          //             ),

                          //             Container(
                          //               height: 16.h,
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     : const SizedBox(),

                          // //Shlokas List
                          // Obx(
                          //   () => Expanded(
                          //     child: shlokasListingController
                          //             .shlokasListing.isNotEmpty
                          //         ? LazyLoadScrollView(
                          //             isLoading: shlokasListingController
                          //                 .isLoadingShlokasListingData.value,
                          //             onEndOfPage: () async {
                          //               debugPrint(
                          //                   "shlokasListingController.shlokasListing.length.toString():${shlokasListingController.shlokasListing.length.toString()}");
                          //               debugPrint(
                          //                   "shlokasListingController.totalShlokas.value.toString():${shlokasListingController.totalShlokas.value.toString()}");
                          //               if (shlokasListingController
                          //                       .shlokasListing.length
                          //                       .toString() !=
                          //                   shlokasListingController
                          //                       .totalShlokas.value
                          //                       .toString()) {
                          //                 await shlokasListingController
                          //                     .fetchShlokasListing(
                          //                         langaugeId: shlokasListingController
                          //                             .groupValueId.value
                          //                             .toString(),
                          //                         chapterNumber:
                          //                             shlokasListingController
                          //                                 .selectedChapter.value
                          //                                 .toString(),
                          //                         body: shlokasListingController
                          //                             .returnBody());
                          //               }
                          //             },
                          //             child: SingleChildScrollView(
                          //               child: Container(
                          //                 color: kColorWhite,
                          //                 child: Column(
                          //                   children: [
                          //                     Container(
                          //                       color: kColorWhite2,
                          //                       height: 16.h,
                          //                     ),

                          //                     //Shlokas Card
                          //                     Container(
                          //                       color: kColorWhite,
                          //                       padding: EdgeInsets.only(
                          //                           top: 16.h, bottom: 16.h),
                          //                       child: ShlokasCardListWidget(),
                          //                     ),

                          //                     shlokasListingController
                          //                             .isNoDataLoading.value
                          //                         ? const SizedBox()
                          //                         : shlokasListingController
                          //                                 .isLoadingShlokasListingData
                          //                                 .value
                          //                             ? Utils().showPaginationLoader(
                          //                                 animation_controller)
                          //                             : const SizedBox(),

                          //                     SizedBox(
                          //                       height: 16.h,
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          : shlokasListingController
                                  .isLoadingShlokasListingData.value
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  height: screenHeight * 0.7,
                                  child: Center(
                                    child: NoDataFoundWidget(
                                      svgImgUrl: "assets/icons/no_shlokas.svg",
                                      title: shlokasListingController
                                          .checkShlokaItem!.value,
                                    ),
                                  ),
                                ),
                    ),
                    //   ),
                    // )
                  ],
                ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom),
              ),
            ),
    );
  }
}
