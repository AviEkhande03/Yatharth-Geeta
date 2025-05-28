import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../utils/utils.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/common/text_rosario.dart';
import '../../widgets/explore/all_section.dart';
import '../../widgets/explore/quotes_section.dart';
import '../../widgets/explore/mantra_section.dart';
import '../../widgets/explore/satsang.dart';
import '../../services/network/network_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ExploreController controller = Get.put(ExploreController());
  final networkService = Get.find<NetworkService>();

  @override
  void dispose() {
    super.dispose();
    //This function just sets the tab value to default nothing else
    controller.clearExploreData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Obx(
          () => networkService.connectionStatus.value == 0
              ? Utils().noInternetWidget(screenWidth, screenHeight)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Column(
                        children: [
                          Container(
                            color: kColorWhite,
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 20.h, bottom: 36.h),
                            child: Center(
                              child: TextRosario(
                                text: "Explore".tr,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          Obx(
                            () => Container(
                              // margin: EdgeInsets.only(bottom: 24.h),
                              height: 45.h,
                              decoration:
                                  const BoxDecoration(color: kColorWhite),
                              child: ListView(
                                // shrinkWrap: true,
                                padding:
                                    EdgeInsets.only(left: 16.w, right: 16.w),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.tabIndex.value = 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          left: 16.w,
                                          right: 16.w,
                                          top: screenWidth >= 600 ? 6.h : 8.h,
                                          bottom:
                                              screenWidth >= 600 ? 6.h : 8.h),
                                      decoration: BoxDecoration(
                                          color: controller.tabIndex.value == 0
                                              ? kColorPrimary
                                              : kColorWhite2,
                                          borderRadius:
                                              BorderRadius.circular(20.r)),
                                      child: TextPoppins(
                                        text: "All".tr,
                                        fontSize: FontSize
                                            .detailsScreenMediaSubHeadings.sp,
                                        fontWeight: FontWeight.w500,
                                        color: controller.tabIndex.value == 0
                                            ? kColorWhite
                                            : kColorBlack,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Get.find<StartupController>()
                                          .startupData
                                          .first
                                          .data!
                                          .result!
                                          .screens!
                                          .explore!
                                          .satsang!
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Utils().showLoader();
                                                Get.find<HomeController>()
                                                        .languageModel ??
                                                    await Get.find<
                                                            HomeController>()
                                                        .getSortData();
                                                controller.initializeFilter();
                                                for (var i in controller
                                                    .languageList) {
                                                  i["value"].value = false;
                                                }
                                                for (var i
                                                    in controller.authorsList) {
                                                  i["value"].value = false;
                                                }
                                                for (var i
                                                    in controller.sortList) {
                                                  i["groupValue"].value =
                                                      "Alphabetically ( A-Z )";
                                                }
                                                controller.clearSatsangList();
                                                controller.audioApiCallType
                                                    .value = "";
                                                controller
                                                        .satsangListing.isEmpty
                                                    ? await controller
                                                        .fetchSatsang()
                                                    : null;
                                                controller.tabIndex.value = 1;
                                                Get.back();
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    left: 16.w,
                                                    right: 16.w,
                                                    top: screenWidth >= 600
                                                        ? 4.h
                                                        : 8.h,
                                                    bottom: screenWidth >= 600
                                                        ? 4.h
                                                        : 8.h),
                                                decoration: BoxDecoration(
                                                    color: controller.tabIndex
                                                                .value ==
                                                            1
                                                        ? kColorPrimary
                                                        : kColorWhite2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r)),
                                                child: TextPoppins(
                                                  text: "Satsang".tr,
                                                  color: controller
                                                              .tabIndex.value ==
                                                          1
                                                      ? kColorWhite
                                                      : kColorBlack,
                                                  fontSize: FontSize
                                                      .detailsScreenMediaSubHeadings
                                                      .sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  Get.find<StartupController>()
                                          .startupData
                                          .first
                                          .data!
                                          .result!
                                          .screens!
                                          .explore!
                                          .mantras!
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Utils().showLoader();
                                                controller.mantraListing.isEmpty
                                                    ? await controller
                                                        .fetchMantra()
                                                    : null;
                                                controller.tabIndex.value = 2;
                                                Get.back();
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    left: 16.w,
                                                    right: 16.w,
                                                    top: screenWidth >= 600
                                                        ? 6.h
                                                        : 8.h,
                                                    bottom: screenWidth >= 600
                                                        ? 6.h
                                                        : 8.h),
                                                decoration: BoxDecoration(
                                                    color: controller.tabIndex
                                                                .value ==
                                                            2
                                                        ? kColorPrimary
                                                        : kColorWhite2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r)),
                                                child: TextPoppins(
                                                  text: "Gita Shlok".tr,
                                                  color: controller
                                                              .tabIndex.value ==
                                                          2
                                                      ? kColorWhite
                                                      : kColorBlack,
                                                  fontSize: FontSize
                                                      .detailsScreenMediaSubHeadings
                                                      .sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  Get.find<StartupController>()
                                          .startupData
                                          .first
                                          .data!
                                          .result!
                                          .screens!
                                          .explore!
                                          .quotes!
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Utils().showLoader();
                                                controller.quotesListing.isEmpty
                                                    ? await controller
                                                        .fetchQuotes()
                                                    : null;
                                                controller.tabIndex.value = 3;
                                                Get.back();
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    left: 16.w,
                                                    right: 16.w,
                                                    top: screenWidth >= 600
                                                        ? 6.h
                                                        : 8.h,
                                                    bottom: screenWidth >= 600
                                                        ? 6.h
                                                        : 8.h),
                                                decoration: BoxDecoration(
                                                    color: controller.tabIndex
                                                                .value ==
                                                            3
                                                        ? kColorPrimary
                                                        : kColorWhite2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r)),
                                                child: TextPoppins(
                                                  text: "Quotes".tr,
                                                  color: controller
                                                              .tabIndex.value ==
                                                          3
                                                      ? kColorWhite
                                                      : kColorBlack,
                                                  fontSize: FontSize
                                                      .detailsScreenMediaSubHeadings
                                                      .sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 16.h,
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                boxShadow: [
                                  BoxShadow(
                                      color: kColorBlackWithOpacity25,
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      blurStyle: BlurStyle.outer,
                                      offset: Offset(0, 5.h)),
                                ],
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.r),
                                    bottomRight: Radius.circular(16.r))),
                          )
                          // Container(
                          //     color: kColorWhite,
                          //     padding: EdgeInsets.only(right: 24.w, bottom: 20.h),
                          //     child: Obx(
                          //       () => TabBar(
                          //           // indicatorSize: TabBarIndicatorSize.label,
                          //           indicator: BoxDecoration(color: Colors.transparent),
                          //           labelPadding: EdgeInsets.only(left: 16.w),
                          //           isScrollable: true,
                          //           controller: controller.controller,
                          //           onTap: (value) {
                          //             controller.tabIndex.value = value;
                          //           },
                          //           tabs: [

                          //           ]),
                          //     )),
                        ],
                      ),
                      // Expanded(
                      //   child: TabBarView(
                      //       physics: NeverScrollableScrollPhysics(),
                      //       controller: controller.controller,
                      //       children: [
                      //         AllSection(),
                      //         Pravachanas(),
                      //         MantraSection(),
                      //         ShlokaSection(),
                      //         GreetingsSection(),
                      //       ]),
                      // )
                      Obx(
                        () => Expanded(
                          child: controller.tabIndex.value == 0
                              ? AllSection(
                                  controller: controller,
                                )
                              : controller.tabIndex.value == 1
                                  ? Satsang(controller: controller)
                                  : controller.tabIndex.value == 2
                                      ? MantraSection(controller: controller)
                                      : QuotesSection(controller: controller),
                        ),
                      )
                    ]),
        ),
      ),
    );
  }
}
