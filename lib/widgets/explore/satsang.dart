import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../utils/utils.dart';
import '../common/no_data_found_widget.dart';
import '../common/search_filter.dart';
import '../skeletons/satsang_skeleton.dart';
import 'pravachan_list.dart';

class Satsang extends StatelessWidget {
  const Satsang({Key? key, required this.controller}) : super(key: key);
  final ExploreController controller;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: controller.satsangListing.isNotEmpty
            ? width >= 600
                ? FloatingActionButton.large(
                    backgroundColor: kColorPrimary,
                    splashColor: kColorPrimary,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SearchFilter(
                            tabIndex: 0.obs,
                            languages: controller.languageList,
                            authors: controller.authorsList,
                            sortList: controller.sortList,
                            screen: "Satsang",
                            onTap: controller.audioApiCallType.value ==
                                    "fetchAudioExploreViewAllListing"
                                ? controller.fetchAudioExploreViewAllListing
                                : controller.fetchSatsangFilter),
                        isScrollControlled: true,
                      );
                      // showModalBottomSheet(
                      //     context: context,
                      //     isScrollControlled: true,
                      //     constraints: BoxConstraints(
                      //         minWidth: MediaQuery.of(context).size.width),
                      //     builder: (context) => SearchFilter(
                      //         tabIndex: 0.obs,
                      //         languages: controller.languageList,
                      //         authors: controller.authorsList,
                      //         sortList: controller.sortList,
                      //         screen: "Satsang",
                      //         onTap: controller.audioApiCallType.value ==
                      //                 "fetchAudioExploreViewAllListing"
                      //             ? controller.fetchAudioExploreViewAllListing
                      //             : controller.fetchSatsangFilter));
                    },
                    child: SvgPicture.asset(
                      "assets/icons/filters.svg",
                      width: 35.w,
                      height: 35.h,
                    ),
                  )
                : FloatingActionButton(
                    backgroundColor: kColorPrimary,
                    splashColor: kColorPrimary,
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width),
                          builder: (context) => SearchFilter(
                              tabIndex: 0.obs,
                              languages: controller.languageList,
                              authors: controller.authorsList,
                              sortList: controller.sortList,
                              screen: "Satsang",
                              onTap: controller.audioApiCallType.value ==
                                      "fetchAudioExploreViewAllListing"
                                  ? controller.fetchAudioExploreViewAllListing
                                  : controller.fetchSatsangFilter),
                          isScrollControlled: true);
                      // showModalBottomSheet(
                      //     context: context,
                      //     isScrollControlled: true,
                      //     constraints: BoxConstraints(
                      //         minWidth: MediaQuery.of(context).size.width),
                      //     builder: (context) => SearchFilter(
                      //         tabIndex: 0.obs,
                      //         languages: controller.languageList,
                      //         authors: controller.authorsList,
                      //         sortList: controller.sortList,
                      //         screen: "Satsang",
                      //         onTap: controller.audioApiCallType.value ==
                      //                 "fetchAudioExploreViewAllListing"
                      //             ? controller.fetchAudioExploreViewAllListing
                      //             : controller.fetchSatsangFilter));
                    },
                    child: SvgPicture.asset("assets/icons/filters.svg"),
                  )
            : const SizedBox(),
        body: Obx(
          // homeController.homeCollectionListing.isEmpty &&
          //             homeController.collectionZeroFlag.value == false
          // ?
          () => controller.satsangListing.isEmpty &&
                  controller.satsangCollectionZeroFlag.value == false
              ? RefreshIndicator(
                  color: kColorPrimary,
                  onRefresh: () async {
                    if (!controller.isSatsangRefreshing.value) {
                      controller.isSatsangRefreshing.value = true;

                      controller.checkRefresh.value = true;
                      for (var i in controller.languageList) {
                        i["value"].value = false;
                      }
                      for (var i in controller.authorsList) {
                        i["value"].value = false;
                      }
                      for (var i in controller.sortList) {
                        i["groupValue"].value = "Alphabetically ( A-Z )";
                      }
                      if (controller.tabIndex.value == 0) {
                        controller.clearAllList();
                        await controller.fetchAll();
                      } else if (controller.tabIndex.value == 1) {
                        controller.clearSatsangList();
                        if (controller.audioApiCallType.value ==
                            "fetchAudioExploreViewAllListing") {
                          controller.fetchAudioExploreViewAllListing();
                        } else {
                          controller.fetchSatsang();
                        }
                      } else if (controller.tabIndex.value == 2) {
                        controller.clearMantrasList();
                        controller.fetchMantra();
                      } else if (controller.tabIndex.value == 3) {
                        controller.clearQuotesList();
                        controller.fetchQuotes();
                      }

                      // Set a 0.5-second delay to enable the refresh again
                      Timer(const Duration(milliseconds: 500), () {
                        controller.isSatsangRefreshing.value = false;
                      });
                    }
                  },
                  child: SingleChildScrollView(
                    child: Container(
                        color: kColorWhite,
                        padding: EdgeInsets.only(
                            top: 25.h, bottom: 25.h, left: 25.w, right: 25.w),
                        child: const SatsangSkeletonWidget()),
                  ),
                )
              : LazyLoadScrollView(
                  // isLoading:
                  //     bottomAppServices.isCollectionLoadingData.value,
                  isLoading: controller.isSatsangLoadingData.value,
                  onEndOfPage: () async {
                    if (controller.satsangListing.isNotEmpty) {
                      if (controller.audioApiCallType.value ==
                          "fetchAudioExploreViewAllListing") {
                        if (controller.checkRefresh.value == false &&
                            controller.satsangListing.length.toString() !=
                                controller.totalSatsangItems.value.toString()) {
                          await controller.fetchAudioExploreViewAllListing();
                        } else {
                          log(
                            "No more Items to Load satsanglist : ${controller.satsangListing.length.toString()} totalcollectionlength: ${controller.totalSatsangItems.value.toString()}",
                          );
                        }
                      } else {
                        if (controller.satsangCheckRefresh.value == false &&
                            controller.satsangListing.length.toString() !=
                                controller.totalSatsangItems.value.toString()) {
                          await controller.fetchSatsang();
                        } else {
                          log(
                            "No more Items to Load satsanglist : ${controller.satsangListing.length.toString()} totalcollectionlength: ${controller.totalSatsangItems.value.toString()}",
                          );
                        }
                      }
                    }
                  },

                  child: RefreshIndicator(
                      color: kColorPrimary,
                      onRefresh: () async {
                        if (!controller.isSatsangRefreshing.value) {
                          controller.isSatsangRefreshing.value = true;
                          controller.checkRefresh.value = true;
                          for (var i in controller.languageList) {
                            i["value"].value = false;
                          }
                          for (var i in controller.authorsList) {
                            i["value"].value = false;
                          }
                          for (var i in controller.sortList) {
                            i["groupValue"].value = "Alphabetically ( A-Z )";
                          }
                          if (controller.tabIndex.value == 0) {
                            controller.clearAllList();
                            await controller.fetchAll();
                          } else if (controller.tabIndex.value == 1) {
                            controller.clearSatsangList();
                            if (controller.audioApiCallType.value ==
                                "fetchAudioExploreViewAllListing") {
                              controller.fetchAudioExploreViewAllListing();
                            } else {
                              controller.fetchSatsang();
                            }
                          } else if (controller.tabIndex.value == 2) {
                            controller.clearMantrasList();
                            controller.fetchMantra();
                          } else if (controller.tabIndex.value == 3) {
                            controller.clearQuotesList();
                            controller.fetchQuotes();
                          }

                          // Set a 0.5-second delay to enable the refresh again
                          Timer(const Duration(milliseconds: 500), () {
                            controller.isSatsangRefreshing.value = false;
                          });
                        }
                      },
                      child: SingleChildScrollView(
                          child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.satsangCollectionZeroFlag.value == false
                              ? Container(
                                  color: kColorWhite2,
                                  height: 16.h,
                                )
                              : const SizedBox.shrink(),
                          Container(
                            // height: height + 200,
                            padding: EdgeInsets.only(
                                left: 24.w,
                                right: 24.w,
                                top: 20.h,
                                bottom: 20.h),
                            color: kColorWhite,
                            child: controller.satsangCollectionZeroFlag.value ==
                                    false
                                ? PravachansList(
                                    audioBooksList: controller.satsangListing,
                                  )
                                : Container(
                                    height: screenHeight / 1.38,
                                    child: controller.isLoadingData.value
                                        ? const SizedBox.shrink()
                                        : NoDataFoundWidget(
                                            svgImgUrl:
                                                "assets/icons/no_guruji_icon.svg",
                                            title: controller
                                                .checkSatsangItem!.value,
                                          ),
                                  ),
                          ),
                          // SizedBox(
                          //   height: 24.h,
                          // ),
                          // Container(
                          //   padding: EdgeInsets.only(
                          //       left: 24.w, right: 24.w, top: 20.h, bottom: 20.h),
                          //   color: kColorWhite,
                          //   child: Column(
                          //     children: [
                          //       HeadingHomeWidget(
                          //         svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                          //         headingTitle: 'Pravachanas'.tr,
                          //         authorName: 'Swami Shri Adganand Ji Maharaj'.tr,
                          //       ),
                          //       SizedBox(
                          //         height: 25.h,
                          //       ),
                          //       SizedBox(
                          //           height: 215.h,
                          //           child:
                          //               Pravachans_List(pravachanas: controller.pravachanas)),
                          //     ],
                          //   ),
                          // ),

//               controller.checkRefresh.value = false;
//             },
//             child: SingleChildScrollView(
//               child: Column(
//                 // mainAxisSize: MainAxisSize.max,
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 16.h,
//                     color: kColorWhite2,
//                   ),
//                   Container(
//                     // height: height + 200,
//                     padding: EdgeInsets.only(
//                         left: 24.w, right: 24.w, top: 20.h, bottom: 20.h),
//                     color: kColorWhite,
//                     child: controller.satsangListing.isNotEmpty
//                         ? PravachansList(
//                             audioBooksList: controller.satsangListing,
//                           )
//                         : NoDataFoundWidget(
//                             svgImgUrl: "assets/icons/no_audio.svg",
//                             title: "No Satsang Available".tr,
//                           ),
//                   ),
                          // SizedBox(
                          //   height: 24.h,
                          // ),
                          // Container(
                          //   padding: EdgeInsets.only(
                          //       left: 24.w, right: 24.w, top: 20.h, bottom: 20.h),
                          //   color: kColorWhite,
                          //   child: Column(
                          //     children: [
                          //       HeadingHomeWidget(
                          //         svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                          //         headingTitle: 'Pravachanas'.tr,
                          //         authorName: 'Swami Shri Adganand Ji Maharaj'.tr,
                          //       ),
                          //       SizedBox(
                          //         height: 25.h,
                          //       ),
                          //       SizedBox(
                          //           height: 215.h,
                          //           child:
                          //               Pravachans_List(pravachanas: controller.pravachanas)),
                          //     ],
                          //   ),
                          // ),

                          // Text('data'),
                          controller.isSatsangNoDataLoading.value
                              ? const SizedBox()
                              : controller.isSatsangLoadingData.value
                                  ? Utils().showPaginationLoader(
                                      controller.animation_controller)
                                  : const SizedBox(),
                        ],
                      ))),
                ),
        ));
  }
}
