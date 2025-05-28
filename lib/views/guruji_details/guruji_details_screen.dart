import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/services/network/network_service.dart';

import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/guruji_details/guruji_details_controller.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/guruji_details/guruji_about.dart';
import '../../widgets/guruji_details/guruji_details_screen_tab_widget.dart';
import '../../widgets/guruji_details/guruji_events.dart';

class GurujiDetailsScreen extends StatefulWidget {
  const GurujiDetailsScreen({Key? key}) : super(key: key);

  @override
  State<GurujiDetailsScreen> createState() => _GurujiDetailsScreenState();
}

class _GurujiDetailsScreenState extends State<GurujiDetailsScreen> {
  GurujiDetailsController controller = Get.find<GurujiDetailsController>();
  final scrollController = new ScrollController();
  @override
  void dispose() {
    super.dispose();
    controller.clearGurujiDetails();
  }

  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // GurujiDetailsController controller = Get.put(GurujiDetailsController());
    return Obx(
      () => networkService.connectionStatus.value == 0
          ? Utils().noInternetWidget(screenWidth, screenHeight)
          : WillPopScope(
              onWillPop: () {
                // Get.delete<GurujiDetailsController>();
                return Future.value(true);
              },
              child: Container(
                color: kColorWhite,
                child: SafeArea(
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    bottomNavigationBar: Obx(
                      () => Get.find<BottomAppBarServices>()
                              .miniplayerVisible
                              .value
                          ? const MiniPlayer()
                          : const SizedBox.shrink(),
                    ),
                    backgroundColor: kColorWhite,
                    body: Column(
                      children: [
                        CustomAppBar(
                          sideIconsUrl: 'assets/images/home/satiya_symbol.svg',
                          title: 'Guru Ji'.tr,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                Stack(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 115.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: Image.asset(
                                            "assets/icons/guruji_bg.png",
                                          ).image,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width,
                                      margin: EdgeInsets.only(top: 110.h),
                                      padding: EdgeInsets.only(top: 66.h),
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.r),
                                          topRight: Radius.circular(8.r),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            // width: width,
                                            padding: EdgeInsets.only(
                                                left: 24.w,
                                                right: 24.w,
                                                bottom: 24.h),
                                            child: Column(children: [
                                              TextPoppins(
                                                text: controller
                                                    .gurujiDetails
                                                    .first
                                                    .data!
                                                    .result!
                                                    .artist!
                                                    .name!,
                                                textAlign: TextAlign.center,
                                                fontSize: FontSize
                                                    .detailsScreenEventTitle.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                height: 16.h,
                                              ),
                                              TextPoppins(
                                                text: controller
                                                    .gurujiDetails
                                                    .first
                                                    .data!
                                                    .result!
                                                    .artist!
                                                    .title!,
                                                fontSize: FontSize
                                                    .detailsScreenEventGuruji
                                                    .sp,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlackWithOpacity75,
                                                textAlign: TextAlign.center,
                                              ),
                                            ]),
                                          ),
                                          Container(
                                            height: 16.h,
                                            color: kColorWhite2,
                                          ),
                                          Container(
                                            color: kColorWhite2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: kColorWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          200.r)),
                                              width: width,
                                              height: 64.h,
                                              // color: Colors.grey,
                                              child: Row(
                                                children: [
                                                  //About Tab
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .selectedAshramTab
                                                          .value = 'About'.tr;
                                                    },
                                                    child:
                                                        GurujiDetailsScreenTabWidget(
                                                      controller: controller,
                                                      title: 'About'.tr,
                                                      iconImgUrl:
                                                          'assets/icons/mandir_inactive.png',
                                                    ),
                                                  ),

                                                  //Contact Tab
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Utils().showLoader();
                                                      controller.gurujiEvents
                                                              .isEmpty
                                                          ? await controller
                                                              .fetchGurujiEvents(
                                                                  controller
                                                                      .gurujiDetails
                                                                      .first
                                                                      .data!
                                                                      .result!
                                                                      .artist!
                                                                      .id!)
                                                          : null;
                                                      controller
                                                          .selectedAshramTab
                                                          .value = 'Events'.tr;
                                                      Get.back();
                                                    },
                                                    child:
                                                        GurujiDetailsScreenTabWidget(
                                                      controller: controller,
                                                      title: 'Events'.tr,
                                                      iconImgUrl:
                                                          'assets/icons/events_inactive.png',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 16.h,
                                            color: kColorWhite2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,

                                      // left: 0,
                                      // right: 0,
                                      child: Container(
                                        height: 100.h,
                                        width: 100.w,

                                        // alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 55.h),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // color: Colors.red,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              controller
                                                  .gurujiDetails
                                                  .first
                                                  .data!
                                                  .result!
                                                  .artist!
                                                  .imageUrl!,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Obx(
                                  () => controller.selectedAshramTab.value.tr ==
                                          'About'.tr
                                      ? GurujiAbout(
                                          controller: controller,
                                          scrollController: scrollController,
                                        )
                                      : GurujiEvents(
                                          gurujiEventsListingController:
                                              controller),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
