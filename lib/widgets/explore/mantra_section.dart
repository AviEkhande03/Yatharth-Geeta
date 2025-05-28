import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../utils/utils.dart';
import '../common/no_data_found_widget.dart';
import '../common/text_poppins.dart';
import 'mantra_meaning.dart';
import '../skeletons/mantras_skeleton.dart';

class MantraSection extends StatelessWidget {
  const MantraSection({Key? key, required this.controller}) : super(key: key);
  final ExploreController controller;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => controller.mantraListing.isEmpty &&
              controller.mantrasCollectionZeroFlag.value == false
          ? RefreshIndicator(
              color: kColorPrimary,
              onRefresh: () async {
                if (!controller.isMantrasRefreshing.value) {
                  controller.isMantrasRefreshing.value = true;
                  controller.checkRefresh.value = true;
                  if (controller.tabIndex.value == 0) {
                    controller.clearAllList();
                    await controller.fetchAll();
                  } else if (controller.tabIndex.value == 1) {
                    controller.clearSatsangList();
                    controller.fetchSatsang();
                  } else if (controller.tabIndex.value == 2) {
                    controller.clearMantrasList();
                    controller.fetchMantra();
                  } else if (controller.tabIndex.value == 3) {
                    controller.clearQuotesList();
                    controller.fetchQuotes();
                  }

                  controller.checkRefresh.value = false;

                  // Set a 0.5-second delay to enable the refresh again
                  Timer(const Duration(milliseconds: 500), () {
                    controller.isMantrasRefreshing.value = false;
                  });
                }
              },
              child:
                  const SingleChildScrollView(child: MantrasSkeletonWidget()))
          : LazyLoadScrollView(
              // isLoading:
              //     bottomAppServices.isCollectionLoadingData.value,
              isLoading: controller.isMantrasLoadingData.value,
              onEndOfPage: () async {
                if (controller.mantraListing.isNotEmpty) {
                  if (controller.mantrasCheckRefresh.value == false &&
                      controller.mantraListing.length.toString() !=
                          controller.totalMantrasItems.value.toString()) {
                    await controller.fetchMantra();
                  } else {
                    dev.log(
                      "No more Items to Load mantralist : ${controller.mantraListing.length.toString()} totalcollectionlength: ${controller.totalMantrasItems.value.toString()}",
                    );
                  }
                }
              },

              child: RefreshIndicator(
                color: kColorPrimary,
                onRefresh: () async {
                  if (!controller.isMantrasRefreshing.value) {
                    controller.isMantrasRefreshing.value = true;
                    controller.checkRefresh.value = true;
                    if (controller.tabIndex.value == 0) {
                      controller.clearAllList();
                      await controller.fetchAll();
                    } else if (controller.tabIndex.value == 1) {
                      controller.clearSatsangList();
                      controller.fetchSatsang();
                    } else if (controller.tabIndex.value == 2) {
                      controller.clearMantrasList();
                      controller.fetchMantra();
                    } else if (controller.tabIndex.value == 3) {
                      controller.clearQuotesList();
                      controller.fetchQuotes();
                    }

                    controller.checkRefresh.value = false;

                    // Set a 0.5-second delay to enable the refresh again
                    Timer(const Duration(milliseconds: 500), () {
                      controller.isMantrasRefreshing.value = false;
                    });
                  }
                },
                child: SingleChildScrollView(
                  child: Container(
                    color: kColorWhite,
                    margin: EdgeInsets.only(bottom: 40.h),
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Column(
                      children: [
                        controller.mantrasCollectionZeroFlag.value == false
                            ? Container(
                                color: kColorWhite2,
                                height: 16.h,
                              )
                            : const SizedBox.shrink(),
                        controller.mantrasCollectionZeroFlag.value == false
                            ? Column(
                                // carouselController: _controller,
                                // options: CarouselOptions(
                                //   autoPlay: false,
                                //   aspectRatio: 16 / 8,
                                //   enlargeCenterPage: false,
                                //   initialPage: 0,
                                //   // disableCenter: true,
                                //   enableInfiniteScroll: false,
                                //   viewportFraction: 0.95,
                                //   enlargeFactor: 0.2,
                                //   onPageChanged: (index, reason) {
                                //     setState(() {
                                //       _currentIndex = index;
                                //     });
                                //   },
                                // ),
                                children: controller.mantraListing
                                    .map(
                                      (entry) => GestureDetector(
                                        onTap: () => showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            constraints: BoxConstraints(
                                                minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width),
                                            builder: (context) => MantraMeaning(
                                                mantra: entry.sanskritTitle!,
                                                meaning: entry.meaning!),
                                            isScrollControlled: true,
                                            useSafeArea: false),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 16.w,
                                              right: 16.w,
                                              top: 24.w),
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                "assets/icons/mantra_canvas1.png",
                                                fit: BoxFit.fill,
                                                // height: 220.h,
                                                // width: 1000,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 220.h,
                                                alignment: Alignment.center,
                                                // color: Colors.red.withOpacity(0.2),
                                                margin: EdgeInsets.only(
                                                    bottom: 23.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // SizedBox(
                                                    //   height: 35.h,
                                                    // ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20.w,
                                                          right: 20.w),
                                                      child: Text(
                                                        entry.sanskritTitle!,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            kTextStylePoppinsRegular
                                                                .copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: kColorFont,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 16.h,
                                                    ),
                                                    TextPoppins(
                                                      text:
                                                          "Click for Mantra Meaning",
                                                      fontSize: FontSize
                                                          .mantraMeaning.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Text(
                                                      '- ${entry.referenceName!}',
                                                      style: kTextStylePoppinsRegular
                                                          .copyWith(
                                                              fontSize: FontSize
                                                                  .mantraGita
                                                                  .sp,
                                                              color: kColorShlokasMeaning
                                                                  .withOpacity(
                                                                      0.50)),
                                                    ),
                                                    SizedBox(
                                                      height: 4.h,
// =======
//         child: SingleChildScrollView(
//           child: Container(
//             color: kColorWhite,
//             margin: EdgeInsets.only(bottom: 40.h),
//             padding: EdgeInsets.only(bottom: 24.h),
//             child: Column(
//               children: [
//                 Container(
//                   height: 16.h,
//                   color: kColorWhite2,
//                 ),
//                 controller.mantraListing.isNotEmpty
//                     ? Column(
//                         // carouselController: _controller,
//                         // options: CarouselOptions(
//                         //   autoPlay: false,
//                         //   aspectRatio: 16 / 8,
//                         //   enlargeCenterPage: false,
//                         //   initialPage: 0,
//                         //   // disableCenter: true,
//                         //   enableInfiniteScroll: false,
//                         //   viewportFraction: 0.95,
//                         //   enlargeFactor: 0.2,
//                         //   onPageChanged: (index, reason) {
//                         //     setState(() {
//                         //       _currentIndex = index;
//                         //     });
//                         //   },
//                         // ),
//                         children: controller.mantraListing
//                             .map(
//                               (entry) => GestureDetector(
//                                 onTap: () => Get.bottomSheet(
//                                     MantraMeaning(
//                                         mantra: entry.sanskritTitle!,
//                                         meaning: entry.meaning!),
//                                     isScrollControlled: true),
//                                 child: Container(
//                                   padding: EdgeInsets.only(
//                                       left: 16.w, right: 16.w, top: 24.w),
//                                   child: Stack(
//                                     children: [
//                                       Image.asset(
//                                         "assets/icons/mantra_canvas1.png",
//                                         fit: BoxFit.fill,
//                                         height: 220.h,
//                                         // width: 1000,
//                                       ),
//                                       Container(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         height: 220.h,
//                                         alignment: Alignment.center,
//                                         // color: Colors.red.withOpacity(0.2),
//                                         margin: EdgeInsets.only(bottom: 23.h),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             // SizedBox(
//                                             //   height: 35.h,
//                                             // ),
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   left: 20.w, right: 20.w),
//                                               child: Text(
//                                                 entry.sanskritTitle!,
//                                                 textAlign: TextAlign.center,
//                                                 style: kTextStylePoppinsRegular
//                                                     .copyWith(
//                                                   fontSize: 14.sp,
//                                                   fontWeight: FontWeight.w400,
//                                                   color: kColorFont,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 16.h,
//                                             ),
//                                             TextPoppins(
//                                               text: "Click for Mantra Meaning",
//                                               fontSize:
//                                                   FontSize.mantraMeaning.sp,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                             SizedBox(
//                                               height: 10.h,
//                                             ),
//                                             Text(
//                                               '- ${entry.referenceName!}',
//                                               style: kTextStylePoppinsRegular
//                                                   .copyWith(
//                                                       fontSize: FontSize
//                                                           .mantraGita.sp,
//                                                       color:
//                                                           kColorShlokasMeaning
//                                                               .withOpacity(
//                                                                   0.50)),
//                                             ),
//                                             SizedBox(
//                                               height: 4.h,
//                                             ),
//                                             Text(
//                                               entry.referenceUrl!,
//                                               style: kTextStylePoppinsRegular
//                                                   .copyWith(
//                                                 fontSize:
//                                                     FontSize.mantraGita.sp,
//                                                 color: kColorFont
//                                                     .withOpacity(0.75),
//                                               ),
//                                             ),
//                                           ],
// >>>>>>> test_branch
                                                    ),
                                                    Text(
                                                      entry.referenceUrl!,
                                                      style:
                                                          kTextStylePoppinsRegular
                                                              .copyWith(
                                                        fontSize: FontSize
                                                            .mantraGita.sp,
                                                        color: kColorFont
                                                            .withOpacity(0.75),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Container(
                                height: screenHeight / 1.3,
                                child: controller.isLoadingData.value
                                    ? const SizedBox.shrink()
                                    : NoDataFoundWidget(
                                        svgImgUrl:
                                            "assets/icons/no_guruji_icon.svg",
                                        title: controller.checkMantrasItem!.value,
                                      ),
                              ),
                        controller.isMantrasNoDataLoading.value
                            ? const SizedBox()
                            : controller.isMantrasLoadingData.value
                                ? Utils().showPaginationLoader(
                                    controller.animation_controller)
                                : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
