import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_listing/audio_listing_controller.dart';
import '../../controllers/ebooks_listing/ebooks_listing_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/shlokas_listing/shlokas_listing_controller.dart';
import '../../controllers/video_listing/video_listing_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../common/custom_showcase.dart';
import 'book_listing_skeleton_widget.dart';

class HomeScreenSkeletonWidget extends StatelessWidget {
  HomeScreenSkeletonWidget({
    super.key,
  });

  final ebooksListingController =
      Get.put(EbooksListingController(), permanent: true);
  final videoListingController = Get.put(VideoListingController());
  final audioListingController = Get.put(AudioListingController());
  final shlokasListingController = Get.put(ShlokasListingController());
  final homeController = Get.find<HomeController>();

  // bool isRefreshingSk = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      color: kColorPrimary,
      onRefresh: () async {
        // homeController.checkRefresh.value = true;
        // homeController.clearHomeCollectionListing();
        // await homeController.fetchHomeCollectionListing();
        // homeController.checkRefresh.value = false;

        // // Set a 2-second delay to enable the refresh again
        // Timer(const Duration(seconds: 2), () {
        //   isRefreshing = false;
        // });

        if (!homeController.isRefreshing.value) {
          homeController.isRefreshing.value = true;
          homeController.checkRefresh.value = true;
          homeController.clearHomeCollectionListing();
          await homeController.fetchHomeCollectionListing();
          homeController.checkRefresh.value = false;

          // Set a 0.5-second delay to enable the refresh again
          Timer(const Duration(milliseconds: 500), () {
            homeController.isRefreshing.value = false;
          });
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            //App Bar
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kColorWhite,
                    border: Border(
                      bottom: BorderSide(
                        color: kColorPrimaryWithOpacity25,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 20.h,
                    bottom: 20.h,
                  ),
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xff955D00), Color(0xffC18A00)])
                        .createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: SizedBox(
                        // height: 74.h,
                        width: 172.w,
                        child: Image.asset('assets/images/app_title.png')),
                  ),
                ),
                // Get.find<StartupController>()
                //             .startupData
                //             .first
                //             .data!
                //             .result!
                //             .screens!
                //             .meData!
                //             .extraaTabs!
                //             .notificationIcon ==
                //         true
                //     ? Positioned.fill(
                //         child: Align(
                //           alignment: Alignment.centerRight,
                //           child: Container(
                //             margin: EdgeInsets.only(right: 24.w),
                //             height: 24.h,
                //             width: 24.h,
                //             child: InkWell(
                //                 onTap: () {
                //                   Get.toNamed(AppRoute.notificationScreen);
                //                 },
                //                 child:
                //                     SvgPicture.asset('assets/icons/bell.svg')),
                //           ),
                //         ),
                //       )
                //     : const SizedBox()
              ],
            ),

            Container(
              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 25.w),
              // color: kColorWhite,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 232.h,
                  // width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.h),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),

            // SizedBox(
            //   height: 35.h,
            // ),
            // SizedBox(
            //   height: 15.h,
            // ),

            //Home Tabs
            Container(
              color: kColorWhite,
              padding: EdgeInsets.only(
                left: 25.w,
                right: 25.w,
                top: 15.h,
                bottom: 15.h,
              ),
              child: CustomShowcase(
                desc: "Tap or click on the tabs to view their related content",
                title: "",
                showKey: Get.find<BottomAppBarServices>().keyThree,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: homeController.homeYatharthModelList
                          .map((e) => GestureDetector(
                                onTap: () async {
                                  if (e.title == "Yatharth Geeta Books".tr) {
                                    Utils().showLoader();
                                    ebooksListingController.prevScreen.value =
                                        "home";

                                    ebooksListingController.booksApiCallType
                                        .value = 'fetchBooksListing';
                                    //Call Ebooklisting API here
                                    homeController.languageModel ??
                                        await homeController.getSortData();
                                    ebooksListingController.initializeFilter();
                                    await ebooksListingController
                                        .fetchBooksListing(token: '', body: {
                                      "category": "yatharth_geeta_books"
                                    });

                                    // Loading.stop();
                                    ebooksListingController.category.value =
                                        "yatharth_geeta_books";
                                    Get.back();

                                    if (!ebooksListingController
                                        .isLoadingData.value) {
                                      Get.toNamed(
                                        AppRoute.ebooksListingScreen,
                                        arguments: {
                                          "viewAllListingBookTitle": 'Books',
                                          "category": "yatharth_geeta_books"
                                        },
                                      );
                                    }
                                  } else {
                                    Utils().showLoader();
                                    audioListingController.prevScreen.value =
                                        "home";
                                    audioListingController.audioApiCallType
                                        .value = 'fetchAudioListing';
                                    homeController.languageModel ??
                                        await homeController.getSortData();
                                    audioListingController.initializeFilter();
                                    await audioListingController
                                        .fetchAudioListing(token: '', body: {
                                      "category": "yatharth_geeta_audios"
                                    });
                                    audioListingController.category.value =
                                        "yatharth_geeta_audios";
                                    Get.back();
                                    if (!audioListingController
                                        .isLoadingData.value) {
                                      Get.toNamed(
                                        AppRoute.audioListingScreen,
                                        arguments: {
                                          "viewAllListingAudioTitle": 'Audio',
                                          "category": "yatharth_geeta_audios"
                                        },
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  width: screenWidth * 0.43,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 16.h),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffFFFCBE),
                                        Color(0xffFFEECB),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(children: [
                                    FadeInImage(
                                      image: NetworkImage(e.imgUrl),
                                      fit: BoxFit.cover,
                                      width: 95.w,
                                      height: 66.h,
                                      placeholderFit: BoxFit.scaleDown,
                                      placeholder: AssetImage(
                                          "assets/icons/default.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/icons/default.png",
                                          width: 95.w,
                                          height: 66.h,
                                        );
                                      },
                                    ),
                                    Text(e.title,
                                        style: kTextStylePoppinsMedium.copyWith(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: kColorFont,
                                        )),
                                  ]),
                                ),
                              ))
                          .toList(),
                    ).marginOnly(
                      bottom: 8.h,
                    ),
                    GridView.builder(
                      // scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: homeController.homeTabsModelList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 5 / 1.8,
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.h,
                        mainAxisSpacing: 8.h,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            if (homeController.homeTabsModelList[index].title ==
                                'Shlokas') {
                              Utils().showLoader();
                              homeController.languageModel ??
                                  await homeController.getSortData();
                              shlokasListingController.initializeFilter();
                              //Call ShlokasChaptersList API here
                              await shlokasListingController
                                  .fetchShlokasChaptersList(
                                langaugeId: '1',
                              );
                              await shlokasListingController
                                  .fetchShlokasListing(
                                      langaugeId: '1',
                                      chapterNumber: shlokasListingController
                                              .shlokasChaptersList.isNotEmpty
                                          ? shlokasListingController
                                              .shlokasChaptersList[0]
                                              .toString()
                                          : '1');

                              Get.back();

                              if (!shlokasListingController
                                      .isLoadingShlokasChaptersListData.value &&
                                  !shlokasListingController
                                      .isLoadingShlokasListingData.value) {
                                Get.toNamed(AppRoute.shlokasListingScreen);
                              }

                              // Get.toNamed(AppRoute.shlokasListingScreen);
                            } else if (homeController
                                    .homeTabsModelList[index].title ==
                                'Audios') {
                              Utils().showLoader();
                              audioListingController.prevScreen.value = "home";
                              audioListingController.audioApiCallType.value =
                                  'fetchAudioListing';
                              homeController.languageModel ??
                                  await homeController.getSortData();
                              audioListingController.initializeFilter();
                              await audioListingController.fetchAudioListing(
                                token: '',
                              );
                              Get.back();
                              if (!audioListingController.isLoadingData.value) {
                                Get.toNamed(
                                  AppRoute.audioListingScreen,
                                  arguments: {
                                    "viewAllListingAudioTitle": 'Audio',
                                  },
                                );
                              }
                            } else if (homeController
                                    .homeTabsModelList[index].title ==
                                'Videos') {
                              Utils().showLoader();
                              homeController.languageModel ??
                                  await homeController.getSortData();
                              videoListingController.initializeFilter();

                              videoListingController.prevScreen.value = "home";

                              videoListingController.videoApiCallType.value =
                                  'fetchVideoListing';
                              await videoListingController.fetchVideoListing(
                                token: '',
                              );
                              Get.back();
                              if (!videoListingController.isLoadingData.value) {
                                Get.toNamed(
                                  AppRoute.videoListingScreen,
                                  arguments: {
                                    "viewAllListingVideoTitle": 'Video',
                                  },
                                );
                              }
                            } else if (homeController
                                    .homeTabsModelList[index].title ==
                                'Books') {
                              Utils().showLoader();
                              ebooksListingController.prevScreen.value = "home";

                              ebooksListingController.booksApiCallType.value =
                                  'fetchBooksListing';
                              //Call Ebooklisting API here
                              homeController.languageModel ??
                                  await homeController.getSortData();
                              ebooksListingController.initializeFilter();
                              await ebooksListingController.fetchBooksListing(
                                token: '',
                              );

                              // Loading.stop();

                              Get.back();

                              if (!ebooksListingController
                                  .isLoadingData.value) {
                                Get.toNamed(
                                  AppRoute.ebooksListingScreen,
                                  arguments: {
                                    "viewAllListingBookTitle": 'Books',
                                  },
                                );
                              }
                            }
                          },
                          child: Container(
                            // color: Colors.white,
                            decoration: BoxDecoration(
                              color: kColorHomeTabsColor,
                              borderRadius: BorderRadius.circular(8.h),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 110.w,
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Text(
                                    homeController
                                        .homeTabsModelList[index].title.tr,
                                    style: kTextStylePoppinsMedium.copyWith(
                                      fontSize: 14.sp,
                                      color: kColorFont,
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.h),
                                    bottomRight: Radius.circular(8.h),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(4.h),
                                    // color: Colors.amber,
                                    height: 95.h,
                                    // width: 85.w,
                                    // width: screenSize.width,
                                    child:
                                        // Image.asset(
                                        //   homeController
                                        //       .homeTabsModelList[index].imgUrl,
                                        //   fit: BoxFit.cover,
                                        // )
                                        FadeInImage(
                                      image: NetworkImage(homeController
                                          .homeTabsModelList[index].imgUrl),
                                      fit: BoxFit.cover,
                                      placeholderFit: BoxFit.scaleDown,
                                      placeholder: AssetImage(
                                          "assets/icons/default.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            "assets/icons/default.png");
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Widget 2
            Container(
              padding: EdgeInsets.only(
                left: 25.w,
                right: 25.w,
              ),
              child: Column(
                children: [
                  Container(
                    height: 120.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Shimmer.fromColors(
                        //   baseColor: Colors.grey.shade300,
                        //   highlightColor: Colors.grey.shade100,
                        //   child: Expanded(
                        //       child: Container(
                        //     height: 150.h,
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey.shade300,
                        //       borderRadius: BorderRadius.circular(8.h),
                        //     ),
                        //   )),
                        // ).marginOnly(bottom: 8.h),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            // color: Colors.white,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8.h),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15.w),
                                  width: screenWidth * 0.43,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            // color: Colors.white,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8.h),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15.w),
                                  width: screenWidth * 0.43,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).marginOnly(bottom: 8.h),
                  GridView.builder(
                    // scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          // color: Colors.white,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15.w),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 5 / 1.8,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.h,
                      mainAxisSpacing: 8.h,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 25.h,
            ),

            //Widget 3
            const BookListingSkeletonWidget(),

            SizedBox(
              height: 15.h,
            ),

            //Widget 4
            const BookListingSkeletonWidget(),
            // SizedBox(
            //   height: 70.h,
            // ),
            // Center(
            //   child:
            //       // CircularProgressIndicator(),
            //       Image.asset('assets/loader/loader_yatharth.gif'),
            // ),
          ],
        ),
      ),
    );
  }
}
