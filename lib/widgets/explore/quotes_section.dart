import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../const/colors/colors.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../utils/utils.dart';
import '../common/no_data_found_widget.dart';
import 'download_dialog.dart';
import '../skeletons/quotes_skeleton.dart';

class QuotesSection extends StatelessWidget {
  const QuotesSection({Key? key, required this.controller}) : super(key: key);
  final ExploreController controller;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => controller.quotesListing.isEmpty &&
              controller.quotesCollectionZeroFlag.value == false
          ? RefreshIndicator(
              color: kColorPrimary,
              onRefresh: () async {
                if (!controller.isQuotesRefreshing.value) {
                  controller.isQuotesRefreshing.value = true;

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
                    controller.isQuotesRefreshing.value = false;
                  });
                }
              },
              child: SingleChildScrollView(child: QuotesSkeletonWidget()))
          : LazyLoadScrollView(
              // isLoading:
              //     bottomAppServices.isCollectionLoadingData.value,
              isLoading: controller.isQuotesLoadingData.value,
              onEndOfPage: () async {
                if (controller.quotesListing.isNotEmpty) {
                  if (controller.quotesCheckRefresh.value == false &&
                      controller.quotesListing.length.toString() !=
                          controller.totalQuotesItems.value.toString()) {
                    await controller.fetchQuotes();
                  } else {
                    log(
                      "No more Items to Load quoteslist : ${controller.quotesListing.length.toString()} totalcollectionlength: ${controller.totalQuotesItems.value.toString()}",
                    );
                  }
                }
              },

              child: RefreshIndicator(
                color: kColorPrimary,
                onRefresh: () async {
                  if (!controller.isQuotesRefreshing.value) {
                    controller.isQuotesRefreshing.value = true;

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
                      controller.isQuotesRefreshing.value = false;
                    });
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      controller.quotesCollectionZeroFlag.value == false
                          ? Container(
                              color: kColorWhite2,
                              height: 16.h,
                            )
                          : SizedBox.shrink(),
                      controller.quotesCollectionZeroFlag.value == false
                          ? Container(
                              // margin: EdgeInsets.only(top: 25.h),
                              padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  top: 20.h,
                                  bottom: 20.h),
                              color: kColorWhite,
                              child: Column(
                                children: Get.find<ExploreController>()
                                    .quotesListing
                                    .map((e) => Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Get.toNamed(AppRoute.ebookDetailsScreen);
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                //   return EbookDetailsScreen();
                                                // }));
                                              },
                                              child: Stack(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                clipBehavior: Clip.hardEdge,
                                                alignment: Alignment.center,
                                                children: [
                                                  //Cover Image
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(4.h),
                                                    child: SizedBox(
                                                      // width: 382.w,
                                                      // height: 497.h,
                                                      child: Center(
                                                        child: FadeInImage(
                                                          image: NetworkImage(e.quoteImageUrl!),
                                                          fit: BoxFit.fill,
                                                          placeholderFit: BoxFit.fitWidth,
                                                          alignment: Alignment.center,
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
                                                  Positioned(
                                                    // alignment: Alignment.bottomRight,
                                                    bottom: 10.h,
                                                    left: 10.w,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        // controller.downloadAndShareImage(
                                                        //     e.quoteImageUrl!);
                                                        downloadAndShareImage(
                                                            e.quoteImageUrl!,
                                                            context);
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: SvgPicture.asset(
                                                            height:
                                                                screenWidth >=
                                                                        600
                                                                    ? 30.h
                                                                    : 26.h,
                                                            width:
                                                                screenWidth >=
                                                                        600
                                                                    ? 30.h
                                                                    : 26.h,
                                                            "assets/images/home/whatsapp_logo.svg"),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24.h,
                                            )
                                          ],
                                        ))
                                    .toList(),
                              ),
                              // child: Column(children: [
                              //   for (int i = 0; i < EbooksModel.ebooksList3.length; i++) ...[
                              //     if (i + 1 == EbooksModel.ebooksList3.length) ...[
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         children: [
                              //           Stack(
                              //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             // crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               //Cover Image
                              //               ClipRRect(
                              //                 borderRadius: BorderRadius.circular(4.h),
                              //                 child: Container(
                              //                   width: 185.w,
                              //                   child: Image.asset(
                              //                     EbooksModel.ebooksList3[i].bookCoverImgUrl,
                              //                     // fit: BoxFit.fitWidth,
                              //                   ),
                              //                 ),
                              //               ),
                              //               Positioned(
                              //                 // alignment: Alignment.bottomRight,
                              //                 bottom: 10.h,
                              //                 right: 10.w,
                              //                 child: SvgPicture.asset(
                              //                     "assets/images/home/whatsapp_logo.svg"),
                              //               )
                              //             ],
                              //           ),
                              //         ],
                              //       )
                              //     ] else ...[
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Stack(
                              //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             // crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               //Cover Image
                              //               ClipRRect(
                              //                 borderRadius: BorderRadius.circular(4.h),
                              //                 child: Container(
                              //                   width: 185.w,
                              //                   child: Image.asset(
                              //                     EbooksModel.ebooksList3[i].bookCoverImgUrl,
                              //                     // fit: BoxFit.fitWidth,
                              //                   ),
                              //                 ),
                              //               ),
                              //               Positioned(
                              //                 // alignment: Alignment.bottomRight,
                              //                 bottom: 10.h,
                              //                 right: 10.w,
                              //                 child: SvgPicture.asset(
                              //                     "assets/images/home/whatsapp_logo.svg"),
                              //               )
                              //             ],
                              //           ),
                              //           Stack(
                              //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             // crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               //Cover Image
                              //               ClipRRect(
                              //                 borderRadius: BorderRadius.circular(4.h),
                              //                 child: Container(
                              //                   width: 185.w,
                              //                   child: Image.asset(
                              //                     EbooksModel.ebooksList3[i + 1].bookCoverImgUrl,
                              //                     // fit: BoxFit.fitWidth,
                              //                   ),
                              //                 ),
                              //               ),
                              //               Positioned(
                              //                 // alignment: Alignment.bottomRight,
                              //                 bottom: 10.h,
                              //                 right: 10.w,
                              //                 child: SvgPicture.asset(
                              //                     "assets/images/home/whatsapp_logo.svg"),
                              //               )
                              //             ],
                              //           ),
                              //         ],
                              //       )
                              //     ],
                              //     SizedBox(
                              //       height: 16.h,
                              //     )
                              //   ]
                              // ]),
                            )
                          : Container(
                              height: screenHeight / 1.3,
                              child: controller.isLoadingData.value
                                  ? const SizedBox.shrink()
                                  : NoDataFoundWidget(
                                      svgImgUrl:
                                          "assets/icons/no_guruji_icon.svg",
                                      title: controller.checkQuotesItem!.value,
                                    ),
                            ),
                      controller.isQuotesNoDataLoading.value
                          ? const SizedBox()
                          : controller.isQuotesLoadingData.value
                              ? Utils().showPaginationLoader(
                                  controller.animation_controller)
                              : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
