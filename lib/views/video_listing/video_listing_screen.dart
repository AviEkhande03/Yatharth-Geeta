import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../controllers/video_listing/video_listing_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_search_bar_new.dart';
import '../../widgets/common/no_data_found_widget.dart';
import '../../widgets/common/search_filter.dart';
import '../../widgets/video_listing/video_listing_card.dart';
import '../../utils/utils.dart';

import '../../services/network/network_service.dart';

class VideoListingScreen extends StatelessWidget {
  const VideoListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String? viewAllListingVideoTitle =
    //     Get.arguments["viewAllListingVideoTitle"];

    VideoListingController controller = Get.find<VideoListingController>();
    final networkService = Get.find<NetworkService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        controller.clearVideosList();
        controller.clearFilters();
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
                        'screen': 'video',
                        'language': controller.languageList,
                        'authors': controller.authorsList,
                        'sortList': controller.sortList,
                        'typeList': controller.categoryList,
                        'onTap': controller.prevScreen.value ==
                                "homeCollectionMultipleType"
                            ? controller.fetchVideosHomeMultipleListing
                            // : controller.prevScreen.value ==
                            //         "homeCollectionMultipleType"
                            //     ? controller
                            //         .fetchVideoHomeMultipleTypeFilter
                            // : controller.prevScreen.value ==
                            //         "collection"
                            //     ? controller
                            //         .fetchVideoViewAllFilter
                            : controller.prevScreen.value == "homeCollection"
                                ? controller.fetchVideoHomeViewAllListing
                                : controller.fetchVideoListing,
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
                          ? const MiniPlayer()
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
                                              // controller.videoApiCallType
                                              //             .value ==
                                              //         'fetchVideoListing'
                                              //     ? 'Video'.tr
                                              //     : controller
                                              //         .viewAllListingVideoTitle
                                              //         .value,
                                              controller.viewAllListingVideoTitle
                                                          .value ==
                                                      ''
                                                  ? 'Video'.tr
                                                  : controller.videoApiCallType
                                                              .value ==
                                                          'fetchVideoListing'
                                                      ? 'Audio'.tr
                                                      : controller
                                                          .viewAllListingVideoTitle
                                                          .value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStyleRosarioRegular
                                                  .copyWith(
                                                color: kColorFont,
                                                fontSize:
                                                    FontSize.screenTitle.sp,
                                              ),
                                            ),
                                          )),
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
                                          controller.clearFilters();
                                          controller.clearVideosList();
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
                                    EdgeInsets.only(left: 25.w, right: 25.w),
                                child: CustomSearchBarNew(
                                  controller: controller.searchController,
                                  fillColor: kColorWhite,
                                  filled: true,
                                  filterAvailable: false,
                                  onChanged: (p0) {
                                    controller.searchController.text = p0;
                                    debugPrint("searchQuery.valuep0:$p0");
                                  },
                                  // filterBottomSheet: SearchFilter(
                                  //   tabIndex: controller.tabIndex,
                                  //   languages: controller.languageList,
                                  //   authors: controller.authorsList,
                                  //   sortList: controller.sortList,
                                  //   screen: "video",
                                  //   onTap: controller.prevScreen.value ==
                                  //           "homeCollectionMultipleType"
                                  //       ? controller
                                  //           .fetchVideosHomeMultipleListing
                                  //       // : controller.prevScreen.value ==
                                  //       //         "homeCollectionMultipleType"
                                  //       //     ? controller
                                  //       //         .fetchVideoHomeMultipleTypeFilter
                                  //       // : controller.prevScreen.value ==
                                  //       //         "collection"
                                  //       //     ? controller
                                  //       //         .fetchVideoViewAllFilter
                                  //       : controller.prevScreen.value ==
                                  //               "homeCollection"
                                  //           ? controller
                                  //               .fetchVideoHomeViewAllListing
                                  //           : controller.fetchVideoListing,
                                  // onTap: controller.prevScreen.value !=
                                  //         "collection"
                                  //     ? controller.fetchVideoListingFilter
                                  //     : controller.fetchVideoViewAllFilter,
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
                            child: Container(
                          // margin: EdgeInsets.only(top: 20.h),
                          color: kColorWhite,
                          child: Obx(
                            () => controller.videosListing.isNotEmpty
                                ? LazyLoadScrollView(
                                    isLoading: controller
                                                    .videoApiCallType.value ==
                                                'fetchVideoListing' ||
                                            controller.videoApiCallType.value ==
                                                'fetchVideoHomeViewAllListing' ||
                                            controller.videoApiCallType.value ==
                                                "fetchVideosHomeMultipleListing"
                                        ? controller.isLoadingData.value
                                        : false,
                                    onEndOfPage: () async {
                                      if (controller.videoApiCallType.value ==
                                          'fetchVideoListing') {
                                        if (controller.checkRefresh.value ==
                                                false &&
                                            controller.videosListing.length
                                                    .toString() !=
                                                controller.totalVideos.value
                                                    .toString()) {
                                          await controller.fetchVideoListing();
                                        } else {
                                          log(
                                            "No more Items to Load. videolist : ${controller.videosListing.length.toString()} totalcollectionlength: ${controller.totalVideos.value.toString()}",
                                          );
                                        }
                                      } else if (controller
                                              .videoApiCallType.value ==
                                          'fetchVideoHomeViewAllListing') {
                                        if (controller.checkRefresh.value ==
                                                false &&
                                            controller.videosListing.length
                                                    .toString() !=
                                                controller.totalVideos.value
                                                    .toString()) {
                                          await controller
                                              .fetchVideoHomeViewAllListing(
                                                  // collectionVideoId:
                                                  //     controller.collectionId.value,
                                                  );
                                        } else {
                                          log(
                                            "No more Items to Load. booklist : ${controller.videosListing.length.toString()} totalcollectionlength: ${controller.totalVideos.value.toString()}",
                                          );
                                        }
                                      } else if (controller
                                              .videoApiCallType.value ==
                                          'fetchVideosHomeMultipleListing') {
                                        if (controller.checkRefresh.value ==
                                                false &&
                                            controller.videosListing.length
                                                    .toString() !=
                                                controller.totalVideos.value
                                                    .toString()) {
                                          await controller
                                              .fetchVideosHomeMultipleListing(
                                                  // id: controller.collectionId.value,
                                                  // type:
                                                  //     controller.collectionType.value,
                                                  );
                                        } else {
                                          log(
                                            "No more Items to Load. booklist : ${controller.videosListing.length.toString()} totalcollectionlength: ${controller.totalVideos.value.toString()}",
                                          );
                                        }
                                      } else {
                                        log("Api call is not fetchVideoListing");
                                      }
                                    },
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          //To check which api call is made
                                          // Text(controller.videoApiCallType
                                          //     .toString()),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                controller.videosListing.length,
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
                                                      var detailsController =
                                                          Get.find<
                                                              VideoDetailsController>();
                                                      Utils().showLoader();
                                                      detailsController
                                                              .prevRoute.value =
                                                          Get.currentRoute;
                                                      await detailsController
                                                          .fetchVideoDetails(
                                                              videoId: controller
                                                                  .videosListing[
                                                                      i]
                                                                  .id,
                                                              ctx: context,
                                                              isNext: false,
                                                              token: '');
                                                      Get.back();
                                                      if (!detailsController
                                                              .isLoadingData
                                                              .value &&
                                                          detailsController
                                                                  .videoDetails
                                                                  .value!
                                                                  .title !=
                                                              null) {
                                                        Get.toNamed(AppRoute
                                                            .videoDetailsScreen);
                                                      } else {
                                                        Utils.customToast(
                                                            "Something went wrong",
                                                            kRedColor,
                                                            kRedColor
                                                                .withOpacity(
                                                                    0.2),
                                                            "error");
                                                      }
                                                    },
                                                    child: VideoListingCard(
                                                        imageUrl: controller
                                                            .videosListing[i]
                                                            .coverImageUrl!,
                                                        title: controller
                                                            .videosListing[i]
                                                            .title!
                                                            .tr,
                                                        artist: controller
                                                            .videosListing[i]
                                                            .artistName!,
                                                        language: controller
                                                            .videosListing[i]
                                                            .mediaLanguage!,
                                                        durationTime: controller
                                                                    .videosListing[
                                                                        i]
                                                                    .videoEpisodes ==
                                                                null
                                                            ? ""
                                                            : controller
                                                                        .videosListing[
                                                                            i]
                                                                        .videoEpisodes ==
                                                                    0
                                                                ? ""
                                                                : "${controller.videosListing[i].videoEpisodes} " +
                                                                    "${controller.videosListing[i].videoEpisodes != null ? "episodes".tr : ""}",
                                                        views: controller
                                                            .videosListing[i]
                                                            .viewCount!
                                                            .toString(),
                                                        isEnd: i ==
                                                            controller
                                                                    .videosListing
                                                                    .length -
                                                                1),
                                                  )
                                                ],
                                              );
                                            },
                                            // children: [
                                            //   Container(
                                            //     color: kColorWhite2,
                                            //     height: 16.h,
                                            //   ),
                                            //   for (int i = 0; i < controller.audioList.length; i++) ...[
                                            //     GestureDetector(
                                            //       onTap: () => Get.toNamed(AppRoute.videoDetailsScreen),
                                            //       child: VideoListingCard(
                                            //           imageUrl: controller.audioList[i].imageUrl,
                                            //           title: controller.audioList[i].title.tr,
                                            //           artist: controller.audioList[i].artist,
                                            //           language: controller.audioList[i].language,
                                            //           duration: controller.audioList[i].duration,
                                            //           views: controller.audioList[i].views),
                                            //     )
                                            //   ]
                                            // ],
                                          ),
                                          controller.videoApiCallType.value ==
                                                      'fetchVideoListing' ||
                                                  controller.videoApiCallType
                                                          .value ==
                                                      'fetchVideoHomeViewAllListing' ||
                                                  controller.videoApiCallType
                                                          .value ==
                                                      "fetchVideosHomeMultipleListing"
                                              ? controller.isNoDataLoading.value
                                                  ? const SizedBox()
                                                  : controller
                                                          .isLoadingData.value
                                                      ? Utils()
                                                          .showPaginationLoader(
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
                                    ? const SizedBox()
                                    : NoDataFoundWidget(
                                        svgImgUrl: "assets/icons/no_video.svg",
                                        title: controller.checkItem!.value,
                                      ),
                            // : Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //         SvgPicture.asset("assets/icons/no_video.svg"),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           children: [
                            //             SvgPicture.asset(
                            //                 "assets/icons/swastik.svg"),
                            //             Text(
                            //               "No Video Available",
                            //               style: kTextStyleNotoRegular.copyWith(
                            //                   fontWeight: FontWeight.w500,
                            //                   fontSize: 20.sp),
                            //             ),
                            //             SvgPicture.asset(
                            //                 "assets/icons/swastik.svg"),
                            //           ],
                            //         ),
                            //       ]),
                          ),
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
