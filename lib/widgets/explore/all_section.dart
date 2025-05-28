import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../controllers/ebooks_listing/ebooks_listing_controller.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../models/explore/explore_model.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';
import '../common/no_data_found_widget.dart';
import 'explore_mantra_scrollable_false.dart';
import 'quotes.dart';
import 'mantra_carousel.dart';
import '../home/audiobooks_list_home_widget.dart';
import '../home/heading_home_widget.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../skeletons/explore_all_section_skeleton.dart';

class AllSection extends StatelessWidget {
  const AllSection({Key? key, required this.controller}) : super(key: key);
  final ExploreController controller;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      // homeController.homeCollectionListing.isEmpty &&
      //                 homeController.collectionZeroFlag.value == false
      //             ?
      () => controller.exploreListing.isEmpty &&
              controller.exploreAllCollectionZeroFlag.value == false

          //Show Skeleton Here
          ? RefreshIndicator(
              color: kColorPrimary,
              onRefresh: () async {
                if (!controller.isExpAllRefreshing.value) {
                  controller.isExpAllRefreshing.value = true;
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
                    controller.isExpAllRefreshing.value = false;
                  });
                }
              },
              child: const ExploreAllSectionSkeleton(),
            )
          : LazyLoadScrollView(
              // isLoading:
              //     bottomAppServices.isCollectionLoadingData.value,
              isLoading: controller.isAllCollectionLoadingData.value,
              onEndOfPage: () async {
                if (controller.exploreListing.isNotEmpty) {
                  if (controller.allCollectionCheckRefresh.value == false &&
                      controller.exploreListing.length.toString() !=
                          controller.totalExploreAllItems.value.toString()) {
                    await controller.fetchAll();
                  } else {
                    log(
                      "No more Items to Load alllist : ${controller.exploreListing.length.toString()} totalcollectionlength: ${controller.totalExploreAllItems.value.toString()}",
                    );
                  }
                }
              },

              child: RefreshIndicator(
                color: kColorPrimary,
                onRefresh: () async {
                  if (!controller.isExpAllRefreshing.value) {
                    controller.isExpAllRefreshing.value = true;
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
                      controller.isExpAllRefreshing.value = false;
                    });
                  }
                },
                child: SingleChildScrollView(
                  child: Container(
                    // margin: EdgeInsets.only(top: 25.h),
                    color: kColorWhite,
                    child: Column(
                      children: [
                        controller.exploreAllCollectionZeroFlag.value == false
                            ? Container(
                                color: kColorWhite2,
                                height: 16.h,
                              )
                            : const SizedBox.shrink(),
                        controller.exploreListing.isNotEmpty
                            ? Column(
                                children: controller.exploreListing.map((e) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (e.type == "Book") {
                                            Utils().showLoader();
                                            //Call Ebooklisting ViewAll API here
                                            var homeController =
                                                Get.find<HomeController>();
                                            var ebooksListingController =
                                                Get.find<
                                                    EbooksListingController>();
                                            ebooksListingController.prevScreen
                                                .value = "collection";
                                            ebooksListingController.collectionId
                                                .value = e.id.toString();
                                            homeController.languageModel ??
                                                await homeController
                                                    .getSortData();
                                            ebooksListingController
                                                .initializeFilter();

                                            ebooksListingController
                                                    .booksApiCallType.value =
                                                'fetchBooksExploreViewAllListing';

                                            ebooksListingController
                                                .viewAllListingBookTitle
                                                .value = e.title.toString();

                                            await ebooksListingController
                                                .fetchBooksExploreViewAllListing(
                                              // collectionBookId: e.id.toString(),
                                              token: '',
                                            );

                                            Get.back();

                                            if (!ebooksListingController
                                                .isLoadingData.value) {
                                              Get.toNamed(
                                                AppRoute.ebooksListingScreen,
                                                // arguments: {
                                                //   "viewAllListingBookTitle":
                                                //       e.title!.toString(),
                                                // },
                                              );
                                            }
                                          }
                                          if (e.type == "Satsang") {
                                            Utils().showLoader();
                                            var homeController =
                                                Get.find<HomeController>();
                                            controller.prevScreen.value =
                                                "collection";
                                            controller.collectionId.value =
                                                e.id.toString();
                                            homeController.languageModel ??
                                                await homeController
                                                    .getSortData();
                                            controller.initializeFilter();
                                            controller.audioApiCallType.value =
                                                'fetchAudioExploreViewAllListing';

                                            controller.viewAllListingAudioTitle
                                                .value = e.title.toString();
                                            controller.clearSatsangList();
                                            await controller
                                                .fetchAudioExploreViewAllListing(
                                              token: '',
                                              // collectionAudioId: e.id.toString(),
                                            );
                                            Get.back();
                                            if (!controller
                                                .isSatsangLoadingData.value) {
                                              controller.tabIndex.value = 1;
                                              // Get.toNamed(
                                              //   AppRoute.audioListingScreen,
                                              // arguments: {
                                              //   "viewAllListingAudioTitle":
                                              //       e.title!.toString(),
                                              // },
                                              // );
                                            }
                                          }
                                        },
                                        child: HeadingHomeWidget(
                                                headingTitle: e.title!,
                                                // authorName: e.description!,
                                                svgLeadingIconUrl: controller
                                                                .exploreListing
                                                                .indexOf(e) %
                                                            2 ==
                                                        0
                                                    ? "assets/images/home/shiv_symbol.svg"
                                                    : "assets/images/home/satiya_symbol.svg",
                                                viewAllIconVisible:
                                                    e.type == "Book" ||
                                                        e.type == "Satsang")
                                            .paddingOnly(
                                                left: 24.w,
                                                right: 24.w,
                                                top: 24.h),
                                      ),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      e.type == "Book"
                                          ? !e.isScrollable!
                                              ? ExploreCollectionBookScrollFalseWidget(
                                                  homecollectionResult: e)
                                              : ExploreCollectionBookScrollTrueWidget(
                                                  homecollectionResult: e)
                                          : e.type == "Quote"
                                              ? Quotes(
                                                  quoteList: e.collectionData!,
                                                  scrollDirection:
                                                      e.isScrollable!
                                                          ? Axis.horizontal
                                                          : Axis.vertical,
                                                ).paddingOnly(
                                                  left: 16.w, right: 16.w)
                                              : e.type == "Mantra"
                                                  ? e.isScrollable!
                                                      ? MantraCarousel(
                                                          mantraList:
                                                              e.collectionData!,
                                                        ).paddingOnly(
                                                          left: 24.w,
                                                          right: 24.w)
                                                      : ExploreMantraScrollableFalse(
                                                              mantraList: e
                                                                  .collectionData!)
                                                          .paddingOnly(
                                                              left: 24.w,
                                                              right: 24.w)
                                                  : e.type == "Satsang" &&
                                                          e.isScrollable!
                                                      ? ExploreCollectionAudioScrollTrueWidget(
                                                          homecollectionResult:
                                                              e)
                                                      : e.type == "Satsang" &&
                                                              !e.isScrollable!
                                                          ? AudioBooksListHomeWidget(
                                                              audioBooksList: e
                                                                  .collectionData!,
                                                            ).paddingOnly(
                                                              left: 24.w,
                                                              right: 24.w)
                                                          : const SizedBox(),
                                      // SizedBox(
                                      //   height: 25.h,
                                      // ),
                                      Container(
                                        color: kColorWhite2,
                                        height: 16.h,
                                      ),
                                      // SizedBox(
                                      //   height: 25.h,
                                      // ),
                                    ],
                                  );
                                }).toList(),
                              )
                            : RefreshIndicator(
                                color: kColorPrimary,
                                onRefresh: () async {
                                  if (!controller.isExpAllRefreshing.value) {
                                    controller.isExpAllRefreshing.value = true;
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
                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      controller.isExpAllRefreshing.value =
                                          false;
                                    });
                                  }
                                },
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: screenHeight / 1.3,
                                    child: controller.isLoadingData.value
                                        ? const SizedBox.shrink()
                                        : NoDataFoundWidget(
                                            svgImgUrl:
                                                "assets/icons/no_guruji_icon.svg",
                                            title:
                                                controller.checkAllItem!.value,
                                          ),
                                  ),
                                ),
                              ),
                        controller.isAllCollectionNoDataLoading.value
                            ? const SizedBox()
                            : controller.isAllCollectionLoadingData.value
                                ? Utils().showPaginationLoader(
                                    controller.animation_controller)
// =======
//         child: SingleChildScrollView(
//           child: Container(
//             // margin: EdgeInsets.only(top: 25.h),
//             color: kColorWhite,
//             child: Column(
//               children: [
//                 Container(
//                   color: kColorWhite2,
//                   height: 16.h,
//                 ),
//                 controller.exploreListing.isNotEmpty
//                     ? Column(
//                         children: controller.exploreListing.map((e) {
//                           return Column(
//                             children: [
//                               InkWell(
//                                 onTap: () async {
//                                   if (e.type == "Book") {
//                                     Utils().showLoader();
//                                     //Call Ebooklisting ViewAll API here
//                                     var homeController =
//                                         Get.find<HomeController>();
//                                     var ebooksListingController =
//                                         Get.find<EbooksListingController>();
//                                     ebooksListingController.prevScreen.value =
//                                         "collection";
//                                     ebooksListingController.collectionId.value =
//                                         e.id.toString();
//                                     homeController.languageModel ??
//                                         await homeController.getSortData();
//                                     ebooksListingController.initializeFilter();

//                                     ebooksListingController.booksApiCallType
//                                         .value = 'fetchBooksHomeViewAllListing';

//                                     ebooksListingController
//                                         .viewAllListingBookTitle
//                                         .value = e.title.toString();

//                                     await ebooksListingController
//                                         .fetchBooksExploreViewAllListing(
//                                       collectionBookId: e.id.toString(),
//                                       token: '',
//                                     );

//                                     Get.back();

//                                     if (!ebooksListingController
//                                         .isLoadingData.value) {
//                                       Get.toNamed(
//                                         AppRoute.ebooksListingScreen,
//                                         // arguments: {
//                                         //   "viewAllListingBookTitle":
//                                         //       e.title!.toString(),
//                                         // },
//                                       );
//                                     }
//                                   }
//                                   if (e.type == "Satsang") {
//                                     Utils().showLoader();
//                                     var homeController =
//                                         Get.find<HomeController>();
//                                     var audioListingController =
//                                         Get.find<AudioListingController>();
//                                     audioListingController.prevScreen.value =
//                                         "collection";
//                                     audioListingController.collectionId.value =
//                                         e.id.toString();
//                                     homeController.languageModel ??
//                                         await homeController.getSortData();
//                                     audioListingController.initializeFilter();
//                                     audioListingController.audioApiCallType
//                                         .value = 'fetchAudioHomeViewAllListing';

//                                     audioListingController
//                                         .viewAllListingAudioTitle
//                                         .value = e.title.toString();

//                                     await audioListingController
//                                         .fetchAudioExploreViewAllListing(
//                                       token: '',
//                                       collectionAudioId: e.id.toString(),
//                                     );
//                                     Get.back();
//                                     if (!audioListingController
//                                         .isLoadingData.value) {
//                                       Get.toNamed(
//                                         AppRoute.audioListingScreen,
//                                         // arguments: {
//                                         //   "viewAllListingAudioTitle":
//                                         //       e.title!.toString(),
//                                         // },
//                                       );
//                                     }
//                                   }
//                                 },
//                                 child: HeadingHomeWidget(
//                                         headingTitle: e.title!,
//                                         // authorName: e.description!,
//                                         svgLeadingIconUrl: controller
//                                                         .exploreListing
//                                                         .indexOf(e) %
//                                                     2 ==
//                                                 0
//                                             ? "assets/images/home/shiv_symbol.svg"
//                                             : "assets/images/home/satiya_symbol.svg",
//                                         viewAllIconVisible: e.type == "Book" ||
//                                             e.type == "Satsang")
//                                     .paddingOnly(
//                                         left: 24.w, right: 24.w, top: 24.h),
//                               ),
//                               SizedBox(
//                                 height: 25.h,
//                               ),
//                               e.type == "Book"
//                                   ? !e.isScrollable!
//                                       ? ExploreCollectionBookScrollFalseWidget(
//                                           homecollectionResult: e)
//                                       : ExploreCollectionBookScrollTrueWidget(
//                                           homecollectionResult: e)
//                                   : e.type == "Quote"
//                                       ? Quotes(
//                                           quoteList: e.collectionData!,
//                                           scrollDirection: e.isScrollable!
//                                               ? Axis.horizontal
//                                               : Axis.vertical,
//                                         ).paddingOnly(left: 24.w, right: 24.w)
//                                       : e.type == "Mantra"
//                                           ? e.isScrollable!
//                                               ? MantraCarousel(
//                                                   mantraList: e.collectionData!,
//                                                 ).paddingOnly(
//                                                   left: 24.w, right: 24.w)
//                                               : ExploreMantraScrollableFalse(
//                                                       mantraList:
//                                                           e.collectionData!)
//                                                   .paddingOnly(
//                                                       left: 24.w, right: 24.w)
//                                           : e.type == "Satsang" &&
//                                                   e.isScrollable!
//                                               ? ExploreCollectionAudioScrollTrueWidget(
//                                                   homecollectionResult: e)
//                                               : e.type == "Satsang" &&
//                                                       !e.isScrollable!
//                                                   ? AudioBooksListHomeWidget(
//                                                       audioBooksList:
//                                                           e.collectionData!,
//                                                     ).paddingOnly(
//                                                       left: 24.w, right: 24.w)
//                                                   : const SizedBox(),
//                               // SizedBox(
//                               //   height: 25.h,
//                               // ),
//                               Container(
//                                 color: kColorWhite2,
//                                 height: 16.h,
//                               ),
//                               // SizedBox(
//                               //   height: 25.h,
//                               // ),
//                             ],
//                           );
//                         }).toList(),
//                       )
                                // : Container(
                                //     height: screenHeight / 1.4,
                                //     child: NoDataFoundWidget(
                                //       svgImgUrl: "assets/icons/no_guruji_icon.svg",
                                //       title: "Empty for now, wisdom ahead".tr,
                                //     ),
                                //   ),
//                 controller.isAllCollectionNoDataLoading.value
//                     ? const SizedBox()
//                     : controller.isAllCollectionLoadingData.value
//                         ? Container(
//                             color: kColorWhite,
//                             height: screenHeight * 0.05,
//                             child: const Center(
//                               child: CircularProgressIndicator(
//                                 color: kColorPrimary,
//                                     ),
//                                   )
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

class ExploreCollectionBookScrollFalseWidget extends StatelessWidget {
  ExploreCollectionBookScrollFalseWidget({
    required this.homecollectionResult,
    super.key,
  });

  final ebooksDetailsController = Get.find<EbookDetailsController>();

  final Result homecollectionResult;

  final int dic = 4;
  final bool isScroll = false;

  //For Tablet Views Need to test out

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: kColorWhite,
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          homecollectionResult.displayInColumn == 4
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 2.3,
                  ),
                  itemCount: homecollectionResult
                      .collectionData!.length, // Total number of images
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await homeBookDetailsApiCall(
                            bookId: homecollectionResult
                                .collectionData![index].id
                                .toString(),
                            type: homecollectionResult.type.toString(),
                            token: '');
                      },
                      child: Column(
                        children: [
                          Container(
                            // color: Colors.red,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: Container(
                                width: screenWidth >= 600 ? 300.w : 150.w,
                                height: screenWidth >= 600 ? 200.h : 125.h,
                                child: FadeInImage(
                                  image: NetworkImage(homecollectionResult
                                      .collectionData![index].coverImageUrl
                                      .toString()),
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
                              // child: CachedNetworkImage(imageUrl:
                              //   homecollectionResult
                              //       .collectionData![index].multipleCollectionImage
                              //       .toString(),
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),

                          //Book Title
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              homecollectionResult.collectionData![index].name
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: kTextStylePoppinsMedium.copyWith(
                                fontSize: FontSize.mediaTitle.sp,
                                color: kColorFont,
                              ),
                            ),
                          ),

                          //Language Tag
                          Row(
                            children: [
                              Container(
                                // height: 18.h,
                                padding:
                                    EdgeInsets.only(left: 12.w, right: 12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.h),
                                  color:
                                      kColorFontLangaugeTag.withOpacity(0.05),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      homecollectionResult
                                          .collectionData![index].mediaLanguage
                                          .toString(),
                                      style: kTextStylePoppinsRegular.copyWith(
                                        fontSize: FontSize.mediaLanguageTags.sp,
                                        color: kColorFontLangaugeTag,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : homecollectionResult.displayInColumn == 3
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 2.13,
                      ),
                      itemCount: homecollectionResult
                          .collectionData!.length, // Total number of images
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await homeBookDetailsApiCall(
                                bookId: homecollectionResult
                                    .collectionData![index].id
                                    .toString(),
                                type: homecollectionResult.type.toString(),
                                token: '');
                          },
                          child: Column(
                            children: [
                              Container(
                                // color: Colors.red,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.h),
                                  child: Container(
                                    width: screenWidth >= 600 ? 300.w : 150.w,
                                    height: screenWidth >= 600 ? 220.h : 170.h,
                                    child: FadeInImage(
                                      image: NetworkImage(homecollectionResult
                                          .collectionData![index].coverImageUrl
                                          .toString()),
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
                                  // child: CachedNetworkImage(imageUrl:
                                  //   homecollectionResult
                                  //       .collectionData![index].multipleCollectionImage
                                  //       .toString(),
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              //Book Title
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  homecollectionResult
                                      .collectionData![index].name
                                      .toString(),
                                  style: kTextStylePoppinsMedium.copyWith(
                                    fontSize: FontSize.mediaTitle.sp,
                                    color: kColorFont,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                              ),

                              //Language Tag
                              Row(
                                children: [
                                  Container(
                                    // height: 18.h,
                                    padding: EdgeInsets.only(
                                        left: 12.w, right: 12.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.h),
                                      color: kColorFontLangaugeTag
                                          .withOpacity(0.05),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          homecollectionResult
                                              .collectionData![index]
                                              .mediaLanguage
                                              .toString(),
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            fontSize:
                                                FontSize.mediaLanguageTags.sp,
                                            color: kColorFontLangaugeTag,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 15.w,
                            mainAxisSpacing: 15.h,
                            crossAxisCount: 2,
                            childAspectRatio:
                                screenWidth > 600 ? 1 / 1.5 : 1 / 1.8,
                          ),
                          itemCount: homecollectionResult
                              .collectionData!.length, // Total number of images
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await homeBookDetailsApiCall(
                                    bookId: homecollectionResult
                                        .collectionData![index].id
                                        .toString(),
                                    type: homecollectionResult.type.toString(),
                                    token: '');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.h),
                                      child: Container(
                                        width:
                                            screenWidth >= 600 ? 380.w : 280.w,
                                        height:
                                            screenWidth >= 600 ? 290.h : 245.h,
                                        child: FadeInImage(
                                          image: NetworkImage(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .coverImageUrl
                                                  .toString()),
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
                                      // child: CachedNetworkImage(imageUrl:
                                      //   homecollectionResult
                                      //       .collectionData![index].multipleCollectionImage
                                      //       .toString(),
                                      //   fit: BoxFit.fill,
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  //Book Title
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      homecollectionResult
                                          .collectionData![index].name
                                          .toString(),
                                      style: kTextStylePoppinsMedium.copyWith(
                                          fontSize: FontSize.mediaTitle.sp,
                                          color: kColorFont,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 2,
                                    ),
                                  ),

                                  //Language Tag
                                  Row(
                                    children: [
                                      Container(
                                        // height: 18.h,
                                        padding: EdgeInsets.only(
                                            left: 12.w, right: 12.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          color: kColorFontLangaugeTag
                                              .withOpacity(0.05),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .mediaLanguage
                                                  .toString(),
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                fontSize: FontSize
                                                    .mediaLanguageTags.sp,
                                                color: kColorFontLangaugeTag,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 15.w,
                                mainAxisSpacing: 15.h,
                                crossAxisCount: 1,
                                childAspectRatio:
                                    screenWidth > 600 ? 1 / 1.5 : 1 / 1.75,
                              ),
                              itemCount: homecollectionResult.collectionData!
                                  .length, // Total number of images
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await homeBookDetailsApiCall(
                                        bookId: homecollectionResult
                                            .collectionData![index].id
                                            .toString(),
                                        type: homecollectionResult.type
                                            .toString(),
                                        token: '');
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                        child: Container(
                                          width:
                                              screenWidth > 600 ? 410.w : 410.w,
                                          height:
                                              screenWidth > 600 ? 500.w : 570.h,
                                          child: FadeInImage(
                                            image: NetworkImage(
                                                homecollectionResult
                                                    .collectionData![index]
                                                    .coverImageUrl
                                                    .toString()),
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
                                        // child: CachedNetworkImage(imageUrl:
                                        //   homecollectionResult
                                        //       .collectionData![index].multipleCollectionImage
                                        //       .toString(),
                                        //   fit: BoxFit.fill,
                                        // ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      //Book Title
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          homecollectionResult
                                              .collectionData![index].name
                                              .toString(),
                                          style:
                                              kTextStylePoppinsMedium.copyWith(
                                                  fontSize:
                                                      FontSize.mediaTitle.sp,
                                                  color: kColorFont,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                          maxLines: 2,
                                        ),
                                      ),

                                      //Language Tag
                                      Row(
                                        children: [
                                          Container(
                                            // height: 18.h,
                                            padding: EdgeInsets.only(
                                                left: 12.w, right: 12.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                              color: kColorFontLangaugeTag
                                                  .withOpacity(0.05),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  homecollectionResult
                                                      .collectionData![index]
                                                      .mediaLanguage
                                                      .toString(),
                                                  style:
                                                      kTextStylePoppinsRegular
                                                          .copyWith(
                                                    fontSize: FontSize
                                                        .mediaLanguageTags.sp,
                                                    color:
                                                        kColorFontLangaugeTag,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeBookDetailsApiCall(
      {required String bookId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);

    log("Ebookdetails home called");
    Utils().showLoader();

    //Call Ebookhomedetails API here
    await ebooksDetailsController.fetchEbookHomeCollectionDetails(
      token: token,
      bookId: bookId,
      type: type,
    );

    Get.back();

    if (!ebooksDetailsController.isLoadingData.value) {
      Get.toNamed(AppRoute.ebookDetailsScreen);
    } else {
      Utils.customToast("Something went wrong", kRedColor,
          kRedColor.withOpacity(0.2), "error");
    }
  }
}

class ExploreCollectionBookScrollTrueWidget extends StatelessWidget {
  ExploreCollectionBookScrollTrueWidget({
    required this.homecollectionResult,
    super.key,
  });

  final ebooksDetailsController = Get.find<EbookDetailsController>();

  final Result homecollectionResult;

  final int dic = 1;

  //For Tablet Views Need to test out

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // alignment: Alignment.centerLeft,
      color: kColorWhite,
      child: Column(
        children: [
          //Heading

          // SizedBox(
          //   height: 25.h,
          // ),

          homecollectionResult.displayInColumn == 4
              ? Container(
                  alignment: Alignment.centerLeft,
                  height: screenWidth >= 600 ? 255.h : 210.h,
                  // color: Colors.blue,
                  // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                  margin: EdgeInsets.only(
                    top: 15.h,
                    bottom: 15.h,
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    // physics: const BouncingScrollPhysics(),

                    itemCount: homecollectionResult
                        .collectionData!.length, // Total number of images
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await homeBookDetailsApiCall(
                              bookId: homecollectionResult
                                  .collectionData![index].id
                                  .toString(),
                              type: homecollectionResult.type.toString(),
                              token: '');
                        },
                        child: AspectRatio(
                          aspectRatio: 1.5 / 3.4,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.h),
                                child: SizedBox(
                                  width: 150.w,
                                  height: 125.h,
                                  child: FadeInImage(
                                    image: NetworkImage(homecollectionResult
                                        .collectionData![index].coverImageUrl
                                        .toString()),
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

                              SizedBox(
                                height: 5.h,
                              ),

                              //Book Title
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  homecollectionResult
                                      .collectionData![index].name
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: kTextStylePoppinsMedium.copyWith(
                                    fontSize: FontSize.mediaTitle.sp,
                                    color: kColorFont,
                                  ),
                                ),
                              ),

                              //Language Tag
                              Row(
                                children: [
                                  Container(
                                    // height: 18.h,
                                    padding: EdgeInsets.only(
                                        left: 12.w, right: 12.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.h),
                                      color: kColorFontLangaugeTag
                                          .withOpacity(0.05),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          homecollectionResult
                                              .collectionData![index]
                                              .mediaLanguage
                                              .toString(),
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            fontSize:
                                                FontSize.mediaLanguageTags.sp,
                                            color: kColorFontLangaugeTag,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },

                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 15.w,
                      );
                    },
                  ),
                )
              : homecollectionResult.displayInColumn == 3
                  ? Container(
                      alignment: Alignment.centerLeft,

                      height: screenWidth >= 600 ? 280.h : 256.h,
                      // color: Colors.blue,
                      // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                      margin: EdgeInsets.only(
                        top: 15.h,
                        bottom: 15.h,
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 25.w, right: 25.w),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // physics: const BouncingScrollPhysics(),

                        itemCount: homecollectionResult
                            .collectionData!.length, // Total number of images
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await homeBookDetailsApiCall(
                                  bookId: homecollectionResult
                                      .collectionData![index].id
                                      .toString(),
                                  type: homecollectionResult.type.toString(),
                                  token: '');
                            },
                            child: AspectRatio(
                              aspectRatio: 1.2 / 2.4,

                              // aspectRatio: 1 / 2.21, //DIC value: 3
                              // aspectRatio: 1 / 1.875, //DIC value: 2
                              // aspectRatio: 1 / 1.875, //DIC value: 1

                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.h),
                                    child: SizedBox(
                                      width: 150.w,
                                      height: 170.h,
                                      child: FadeInImage(
                                        image: NetworkImage(homecollectionResult
                                            .collectionData![index]
                                            .coverImageUrl
                                            .toString()),
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

                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  //Book Title
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      homecollectionResult
                                          .collectionData![index].name
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize: FontSize.mediaTitle.sp,
                                        color: kColorFont,
                                      ),
                                    ),
                                  ),

                                  //Language Tag
                                  Row(
                                    children: [
                                      Container(
                                        // height: 18.h,
                                        padding: EdgeInsets.only(
                                            left: 12.w, right: 12.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          color: kColorFontLangaugeTag
                                              .withOpacity(0.05),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .mediaLanguage
                                                  .toString(),
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                fontSize: FontSize
                                                    .mediaLanguageTags.sp,
                                                color: kColorFontLangaugeTag,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },

                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 15.w,
                          );
                        },
                      ),
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? Container(
                          alignment: Alignment.centerLeft,
                          height: screenWidth >= 600 ? 350.h : 330.h,
                          // color: Colors.blue,
                          // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                          margin: EdgeInsets.only(
                            top: 15.h,
                            bottom: 15.h,
                          ),
                          child: ListView.separated(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            // physics: const BouncingScrollPhysics(),

                            itemCount: homecollectionResult.collectionData!
                                .length, // Total number of images
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await homeBookDetailsApiCall(
                                      bookId: homecollectionResult
                                          .collectionData![index].id
                                          .toString(),
                                      type:
                                          homecollectionResult.type.toString(),
                                      token: '');
                                },
                                child: AspectRatio(
                                  aspectRatio: 1.2 / 1.97,

                                  // aspectRatio: 1 / 2.21, //DIC value: 3
                                  // aspectRatio: 1 / 1.875, //DIC value: 2
                                  // aspectRatio: 1 / 1.875, //DIC value: 1

                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                        child: SizedBox(
                                          width: 280.w,
                                          height: 245.h,
                                          child: FadeInImage(
                                            image: NetworkImage(
                                                homecollectionResult
                                                    .collectionData![index]
                                                    .coverImageUrl
                                                    .toString()),
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

                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      //Book Title
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          homecollectionResult
                                              .collectionData![index].name
                                              .toString(),
                                          style:
                                              kTextStylePoppinsMedium.copyWith(
                                            fontSize: FontSize.mediaTitle.sp,
                                            color: kColorFont,
                                          ),
                                        ),
                                      ),

                                      //Language Tag
                                      Row(
                                        children: [
                                          Container(
                                            // height: 18.h,
                                            padding: EdgeInsets.only(
                                                left: 12.w, right: 12.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                              color: kColorFontLangaugeTag
                                                  .withOpacity(0.05),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  homecollectionResult
                                                      .collectionData![index]
                                                      .mediaLanguage
                                                      .toString(),
                                                  style:
                                                      kTextStylePoppinsRegular
                                                          .copyWith(
                                                    fontSize: FontSize
                                                        .mediaLanguageTags.sp,
                                                    color:
                                                        kColorFontLangaugeTag,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },

                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 15.w,
                              );
                            },
                          ),
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? Container(
                              alignment: Alignment.centerLeft,

                              height: screenWidth >= 600 ? 670.h : 630.h,
                              // color: Colors.blue,
                              // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                              margin: EdgeInsets.only(
                                top: 15.h,
                                bottom: 15.h,
                              ),
                              child: ListView.separated(
                                padding:
                                    EdgeInsets.only(left: 25.w, right: 25.w),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                // physics: const BouncingScrollPhysics(),

                                itemCount: homecollectionResult.collectionData!
                                    .length, // Total number of images
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await homeBookDetailsApiCall(
                                          bookId: homecollectionResult
                                              .collectionData![index].id
                                              .toString(),
                                          type: homecollectionResult.type
                                              .toString(),
                                          token: '');
                                    },
                                    child: AspectRatio(
                                      aspectRatio: 1.2 / 1.86,

                                      // aspectRatio: 1 / 2.21, //DIC value: 3
                                      // aspectRatio: 1 / 1.875, //DIC value: 2
                                      // aspectRatio: 1 / 1.875, //DIC value: 1

                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.h),
                                            child: SizedBox(
                                              width: 410.w,
                                              height: 570.h,
                                              child: FadeInImage(
                                                image: NetworkImage(
                                                    homecollectionResult
                                                        .collectionData![index]
                                                        .coverImageUrl
                                                        .toString()),
                                                fit: BoxFit.fill,
                                                placeholderFit:
                                                    BoxFit.scaleDown,
                                                placeholder: const AssetImage(
                                                    "assets/icons/default.png"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      "assets/icons/default.png");
                                                },
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            height: 5.h,
                                          ),

                                          //Book Title
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              homecollectionResult
                                                  .collectionData![index].name
                                                  .toString(),
                                              style: kTextStylePoppinsMedium
                                                  .copyWith(
                                                fontSize:
                                                    FontSize.mediaTitle.sp,
                                                color: kColorFont,
                                              ),
                                            ),
                                          ),

                                          //Language Tag
                                          Row(
                                            children: [
                                              Container(
                                                // height: 18.h,
                                                padding: EdgeInsets.only(
                                                    left: 12.w, right: 12.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.h),
                                                  color: kColorFontLangaugeTag
                                                      .withOpacity(0.05),
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      homecollectionResult
                                                          .collectionData![
                                                              index]
                                                          .mediaLanguage
                                                          .toString(),
                                                      style:
                                                          kTextStylePoppinsRegular
                                                              .copyWith(
                                                        fontSize: FontSize
                                                            .mediaLanguageTags
                                                            .sp,
                                                        color:
                                                            kColorFontLangaugeTag,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },

                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 15.w,
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeBookDetailsApiCall(
      {required String bookId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);

    log("Ebookdetails home called");
    Utils().showLoader();

    //Call Ebookhomedetails API here
    await ebooksDetailsController.fetchEbookHomeCollectionDetails(
      token: token,
      bookId: bookId,
      type: type,
    );

    Get.back();

    if (!ebooksDetailsController.isLoadingData.value) {
      Get.toNamed(AppRoute.ebookDetailsScreen);
    } else {
      Utils.customToast("Something went wrong", kRedColor,
          kRedColor.withOpacity(0.2), "error");
    }
  }
}

class ExploreCollectionAudioScrollTrueWidget extends StatelessWidget {
  ExploreCollectionAudioScrollTrueWidget(
      {required this.homecollectionResult, super.key});

  final audioDetailsController = Get.find<AudioDetailsController>();

  final Result homecollectionResult;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // return SizedBox();
    return Container(
      // color: Colors.blue,
      padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          // homecollectionResult.displayInColumn == 3
          //     ?
          SizedBox(
              height: homecollectionResult.displayInColumn == 3
                  ? screenWidth >= 600
                      ? 250.h
                      : 220.h
                  : homecollectionResult.displayInColumn == 2
                      ? screenWidth >= 600
                          ? 320.h
                          : 290.h
                      : homecollectionResult.displayInColumn == 1
                          ? screenWidth >= 600
                              ? 500.h
                              : 470.h
                          : screenWidth >= 600
                              ? 200.h
                              : 170.h,
              child: ListView.separated(
                padding: EdgeInsets.only(left: 25.w, right: 25.w),
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      var controller = Get.put(PlayerController());
                      Utils().showLoader();
                      controller.singleAudio.value = true;
                      controller.isShloka.value = false;
                      controller.shlokaCheck(
                          shlokaValue: false,
                          hasPrevious: false,
                          hasNext: false,
                          hasCurrent: false);
                      controller.playlist = ConcatenatingAudioSource(children: [
                        AudioSource.uri(
                            Uri.parse(
                              homecollectionResult
                                  .collectionData![index].audioFileUrl!,
                            ),
                            tag: MediaItem(
                                id: "1",
                                title: homecollectionResult
                                    .collectionData![index].title!,
                                displaySubtitle: "Verse 1",
                                displayTitle: homecollectionResult
                                    .collectionData![index].authorName!,
                                extras: {
                                  "lyrics": "",
                                  "type": "Audio",
                                  "file": homecollectionResult
                                      .collectionData![index].audioFileUrl!,
                                },
                                artist: homecollectionResult
                                    .collectionData![index].authorName!,
                                artUri: Uri.parse(homecollectionResult
                                    .collectionData![index]
                                    .audioCoverImageUrl!),
                                duration: Duration(
                                    seconds: homecollectionResult
                                        .collectionData![index].duration!)))
                      ]);
                      await controller.audioPlayer.value
                          .setAudioSource(controller.playlist);
                      await controller.audioPlayer.value
                          .setLoopMode(LoopMode.off);
                      controller.loopMode.value = 0;
                      Get.back();
                      Get.toNamed(AppRoute.audioPlayerScreen);
                      homecollectionResult.collectionData![index].audioFileUrl!;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: homecollectionResult.displayInColumn == 3
                              ? 145.h
                              : homecollectionResult.displayInColumn == 2
                                  ? 220.h
                                  : homecollectionResult.displayInColumn == 1
                                      ? 400.h
                                      : 100.h,
                          width: homecollectionResult.displayInColumn == 3
                              ? 125.w
                              : homecollectionResult.displayInColumn == 2
                                  ? 200.w
                                  : homecollectionResult.displayInColumn == 1
                                      ? 380.w
                                      : 90.w,
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              SizedBox(
                                width: homecollectionResult.displayInColumn == 3
                                    ? 125.w
                                    : homecollectionResult.displayInColumn == 2
                                        ? 200.w
                                        : homecollectionResult
                                                    .displayInColumn ==
                                                1
                                            ? 380.w
                                            : 90.w,
                                height: homecollectionResult.displayInColumn ==
                                        3
                                    ? 125.h
                                    : homecollectionResult.displayInColumn == 2
                                        ? 200.h
                                        : homecollectionResult
                                                    .displayInColumn ==
                                                1
                                            ? 380.h
                                            : 90.h,
                                child: FadeInImage(
                                  image: NetworkImage(homecollectionResult
                                      .collectionData![index].audioCoverImageUrl
                                      .toString()),
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
                              Container(
                                  // width: 125.w,
                                  alignment: Alignment.bottomCenter,
                                  child: SvgPicture.asset(
                                    "assets/icons/music.svg",
                                    width:
                                        homecollectionResult.displayInColumn ==
                                                4
                                            ? 30.w
                                            : 35.w,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: homecollectionResult.displayInColumn == 4
                              ? 60.w
                              : 125.w,
                          child: Text(
                            homecollectionResult.collectionData![index].title
                                .toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: kTextStylePoppinsMedium.copyWith(
                              fontSize: FontSize.mediaTitle.sp,
                              overflow: TextOverflow.ellipsis,
                              color: kColorFont,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 9.h,
                        // ),
                        Container(
                            // height: 18.h,
                            padding: EdgeInsets.only(left: 12.w, right: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.h),
                              color: kColorFontLangaugeTag.withOpacity(0.05),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  homecollectionResult
                                      .collectionData![index].mediaLanguage
                                      .toString(),
                                  style: kTextStylePoppinsRegular.copyWith(
                                    fontSize: FontSize.mediaLanguageTags.sp,
                                    color: kColorFontLangaugeTag,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    width:
                        homecollectionResult.displayInColumn == 4 ? 10.w : 16.w,
                  );
                },
                itemCount: homecollectionResult.collectionData!.length,
              ))
        ],
      ),
    );
  }
}
