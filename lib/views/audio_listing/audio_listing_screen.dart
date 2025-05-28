import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import '../../controllers/audio_listing/audio_listing_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_listing/audio_listing_card.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_search_bar_new.dart';
import '../../widgets/common/no_data_found_widget.dart';
import '../../services/network/network_service.dart';

class AudioListingScreen extends StatelessWidget {
  const AudioListingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // String? viewAllListingAudioTitle =
    //     Get.arguments["viewAllListingAudioTitle"];

    AudioListingController controller = Get.find<AudioListingController>();
    final networkService = Get.find<NetworkService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        controller.clearAudiosList();
        controller.clearFilters();
        controller.category.value = "";
        // controller.searchController.removeListener(() {});
        Get.back();
        return Future(() => true);
      },
      child: Container(
        color: kColorWhite,
        child: SafeArea(
          child: Obx(
            () => networkService.connectionStatus.value == 0
                ? Utils().noInternetWidget(screenWidth, screenHeight)
                : Scaffold(
                    resizeToAvoidBottomInset: true,
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: GestureDetector(
                      onTap: () =>
                          Get.toNamed(AppRoute.filterScreen, arguments: {
                        'screen': 'audio',
                        'language': controller.languageList,
                        'authors': controller.authorsList,
                        'typeList': controller.typeList,
                        'sortList': controller.sortList,
                        'onTap': controller.prevScreen.value ==
                                "homeCollectionMultipleType"
                            ? controller.fetchAudiosHomeMultipleListing
                            : controller.prevScreen.value == "collection"
                                ? controller.fetchAudioExploreViewAllListing
                                : controller.prevScreen.value ==
                                        "homeCollection"
                                    ? controller.fetchAudioHomeViewAllListing
                                    : controller.fetchAudioListing
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 16.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: kColorWhite,
                            border: Border.all(color: kColorPrimary)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/filters.svg",
                              color: kColorPrimary,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "Filters".tr,
                              style: kTextStylePoppinsRegular.copyWith(
                                color: kColorPrimary,
                                fontSize: 14.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    bottomNavigationBar: Obx(
                      () => Get.find<BottomAppBarServices>()
                              .miniplayerVisible
                              .value
                          ? MiniPlayer()
                          : const SizedBox.shrink(),
                    ),
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
                                            controller.viewAllListingAudioTitle
                                                        .value ==
                                                    ''
                                                ? 'Audio'.tr
                                                : controller.audioApiCallType
                                                            .value ==
                                                        'fetchAudioListing'
                                                    ? 'Audio'.tr
                                                    : controller
                                                        .viewAllListingAudioTitle
                                                        .value,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kTextStyleRosarioRegular
                                                .copyWith(
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
                                          controller.clearAudiosList();
                                          controller.clearFilters();
                                          controller.category.value = "";
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
                                margin:
                                    EdgeInsets.only(left: 24.w, right: 24.w),
                                child: CustomSearchBarNew(
                                  controller: controller.searchController,
                                  fillColor: kColorWhite,
                                  filled: true,
                                  filterAvailable: false,
                                  onChanged: (p0) async {
                                    controller.searchController.text = p0;
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
                        Expanded(
                            child: Obx(
                          () => controller.audiosListing.isNotEmpty
                              ? LazyLoadScrollView(
                                  isLoading: controller
                                                  .audioApiCallType.value ==
                                              'fetchAudioListing' ||
                                          controller.audioApiCallType.value ==
                                              'fetchAudioHomeViewAllListing' ||
                                          controller.audioApiCallType.value ==
                                              'fetchAudiosHomeMultipleListing' ||
                                          controller.audioApiCallType.value ==
                                              'fetchAudioExploreViewAllListing'
                                      ? controller.isLoadingData.value
                                      : false,
                                  onEndOfPage: () async {
                                    if (controller.audioApiCallType.value ==
                                        'fetchAudioListing') {
                                      if (controller.checkRefresh.value ==
                                              false &&
                                          controller.audiosListing.length
                                                  .toString() !=
                                              controller.totalAudios.value
                                                  .toString()) {
                                        await controller.fetchAudioListing();
                                      } else {
                                        log(
                                          "No more Items to Load. audiolist : ${controller.audiosListing.length.toString()} totalcollectionlength: ${controller.totalAudios.value.toString()}",
                                        );
                                      }
                                    } else if (controller
                                            .audioApiCallType.value ==
                                        'fetchAudioHomeViewAllListing') {
                                      if (controller.checkRefresh.value ==
                                              false &&
                                          controller.audiosListing.length
                                                  .toString() !=
                                              controller.totalAudios.value
                                                  .toString()) {
                                        await controller
                                            .fetchAudioHomeViewAllListing();
                                      } else {
                                        log(
                                          "No more Items to Load. audiolist : ${controller.audiosListing.length.toString()} totalcollectionlength: ${controller.totalAudios.value.toString()}",
                                        );
                                      }
                                    } else if (controller
                                            .audioApiCallType.value ==
                                        'fetchAudiosHomeMultipleListing') {
                                      if (controller.checkRefresh.value ==
                                              false &&
                                          controller.audiosListing.length
                                                  .toString() !=
                                              controller.totalAudios.value
                                                  .toString()) {
                                        await controller.fetchAudiosHomeMultipleListing(
                                            // id: controller.collectionId.value,
                                            // type: controller.collectionType.value,
                                            );
                                      } else {
                                        log(
                                          "No more Items to Load. audiolist : ${controller.audiosListing.length.toString()} totalcollectionlength: ${controller.totalAudios.value.toString()}",
                                        );
                                      }
                                    } else if (controller
                                            .audioApiCallType.value ==
                                        'fetchAudioExploreViewAllListing') {
                                      if (controller.checkRefresh.value ==
                                              false &&
                                          controller.audiosListing.length
                                                  .toString() !=
                                              controller.totalAudios.value
                                                  .toString()) {
                                        await controller
                                            .fetchAudioExploreViewAllListing(
                                                // collectionAudioId:
                                                //     controller.collectionId.value,
                                                );
                                      } else {
                                        log(
                                          "No more Items to Load. audiolist : ${controller.audiosListing.length.toString()} totalcollectionlength: ${controller.totalAudios.value.toString()}",
                                        );
                                      }
                                    } else if (controller
                                            .audioApiCallType.value ==
                                        'fetchAudioListingFilter') {
                                      log("Api call is not fetchAudioListing");
                                    } else {
                                      log("Something else found");
                                    }
                                  },
                                  // isLoading: controller.isLoadingData.value,
                                  // onEndOfPage: () async {
                                  //   if (controller.prevScreen.value ==
                                  //       'collection') {
                                  //     var body = controller.returnFilterBody();
                                  //     body['id'] = controller.collectionId.value
                                  //         .toString();
                                  //     controller.fetchAudioHomeViewAllFilter(
                                  //         body: body);
                                  //   } else if (controller.prevScreen.value ==
                                  //       'home') {
                                  //     var body = controller.returnFilterBody();
                                  //     controller.fetchAudioHomeViewAllFilter(
                                  //         body: body);
                                  //   }
                                  // },
                                  // onEndOfPage: () async {},
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        //To check which api call is made
                                        // Text(controller.audioApiCallType
                                        //     .toString()),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              controller.audiosListing.length,
                                          itemBuilder: (context, i) {
                                            return Column(
                                              children: [
                                                i == 0
                                                    ? Container(
                                                        color: kColorWhite2,
                                                        height: 16.h,
                                                      )
                                                    : Container(),
                                                GestureDetector(
                                                  onTap: () async {
                                                    var detailsController = Get.put(
                                                        AudioDetailsController());
                                                    Utils().showLoader();
                                                    detailsController
                                                            .prevRoute.value =
                                                        Get.currentRoute;
                                                    await detailsController
                                                        .fetchAudioDetails(
                                                            audioId: controller
                                                                .audiosListing[
                                                                    i]
                                                                .id,
                                                            ctx: context,
                                                            token: '');
                                                    Get.back();
                                                    if (!detailsController
                                                        .isLoadingData.value) {
                                                      Get.toNamed(AppRoute
                                                          .audioDetailsScreen);
                                                    }
                                                  },
                                                  child: AudioListingCard(
                                                    imageUrl: controller
                                                        .audiosListing[i]
                                                        .audioCoverImageUrl!,
                                                    title: controller
                                                        .audiosListing[i]
                                                        .title!
                                                        .tr,
                                                    artist: controller
                                                        .audiosListing[i]
                                                        .authorName!,
                                                    language: controller
                                                        .audiosListing[i]
                                                        .mediaLanguage!,
                                                    hasEpisodes: controller
                                                        .audiosListing[i]
                                                        .hasEpisodes!,
                                                    duration: controller
                                                        .audiosListing[i]
                                                        .episodeCount
                                                        .toString(),
                                                    views: controller
                                                        .audiosListing[i]
                                                        .viewCount
                                                        .toString(),
                                                    isEnd: controller
                                                                .audiosListing
                                                                .length -
                                                            1 ==
                                                        i,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        controller.audioApiCallType.value ==
                                                    'fetchAudioListing' ||
                                                controller.audioApiCallType
                                                        .value ==
                                                    'fetchAudioHomeViewAllListing' ||
                                                controller.audioApiCallType
                                                        .value ==
                                                    'fetchAudiosHomeMultipleListing' ||
                                                controller.audioApiCallType
                                                        .value ==
                                                    'fetchAudioExploreViewAllListing'
                                            ? controller.isNoDataLoading.value
                                                ? const SizedBox()
                                                : controller.isLoadingData.value
                                                    ? Utils().showPaginationLoader(
                                                        controller
                                                            .animation_controller)
                                                    : const SizedBox()
                                            : const SizedBox(),
                                        Container(
                                          color: kColorWhite,
                                          height: 80.h,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : controller.isLoadingData.value
                                  ? const SizedBox.shrink()
                                  : NoDataFoundWidget(
                                      svgImgUrl: "assets/icons/no_audio.svg",
                                      title: controller.checkItem!.value,
                                    ),
                          // : Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //         SvgPicture.asset(
                          //             "assets/icons/no_audio.svg"),
                          //         Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //           children: [
                          //             SvgPicture.asset(
                          //                 "assets/icons/swastik.svg"),
                          //             Text(
                          //               "No Audio Available",
                          //               style:
                          //                   kTextStyleNotoRegular.copyWith(
                          //                       fontWeight: FontWeight.w500,
                          //                       fontSize: 20.sp),
                          //             ),
                          //             SvgPicture.asset(
                          //                 "assets/icons/swastik.svg"),
                          //           ],
                          //         ),
                          //       ]),
                        ))
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
