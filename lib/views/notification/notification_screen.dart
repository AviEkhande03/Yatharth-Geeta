import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/no_data_found_widget.dart';
import '../../widgets/notification/daywise_notification_list.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationScreenController = Get.find<NotificationController>();
    //final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: kColorWhite));
    return WillPopScope(
      onWillPop: () {
        notificationScreenController.clearNotificationList();
        Get.back();
        return Future(() => true);
      },
      child: Container(
        color: kColorWhite,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            // resizeToAvoidBottomInset: false,
            bottomNavigationBar:
                Get.find<BottomAppBarServices>().miniplayerVisible.value
                    ? const MiniPlayer()
                    : const SizedBox.shrink(),
            /*appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Container(
                color: kColorWhite,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left:24.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: SizedBox(
                            width: 24.h,
                            height: 24.h,
                            child: SvgPicture.asset(
                                'assets/icons/back.svg'
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextRosario(
                        text: "Notification".tr,
                        fontSize: 24.sp,
                        color: kColorFont,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),*/
            backgroundColor: kColorWhite2,
            body: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /*Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: kColorWhite,
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: 12.h,
                        bottom: 12.h,
                      ),
                      child: Text(
                        'Notification'.tr,
                        style: kTextStyleRosarioRegular.copyWith(
                          color: kColorFont,
                          fontSize: FontSize.notificationTitle.sp,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 24.w),
                          height: 24.h,
                          width: 24.h,
                          child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset('assets/icons/back.svg')),
                        ),
                      ),
                    ),
                  ],
                )*/
                // CustomAppBar(
                //   title: "Notification".tr,
                // ),
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: kColorWhite,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: 12.h,
                            bottom: 12.h,
                          ),
                          child: Text(
                            'Notification'.tr,
                            style: kTextStyleRosarioRegular.copyWith(
                              color: kColorFont,
                              fontSize: FontSize.screenTitle.sp,
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
                          child: SvgPicture.asset('assets/icons/back.svg'),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            notificationScreenController
                                .clearNotificationList();
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

                Expanded(
                  child: Obx(
                    () => notificationScreenController
                            .notificationList.isNotEmpty
                        ? LazyLoadScrollView(
                            isLoading: notificationScreenController
                                .isLoadingData.value,
                            onEndOfPage: () async {
                              debugPrint(
                                  "notificationScreenController.notificationList.length:${notificationScreenController.notificationList.length}");
                              debugPrint(
                                  "notificationScreenController.showedNotifications.value:${notificationScreenController.showedNotifications.value}");
                              debugPrint(
                                  "notificationScreenController.totalNotifications.value:${notificationScreenController.totalNotifications.value}");
                              if (notificationScreenController
                                      .showedNotifications.value
                                      .toString() !=
                                  notificationScreenController
                                      .totalNotifications.value
                                      .toString()) {
                                debugPrint("fetchNotifications:");
                                await notificationScreenController
                                    .fetchNotifications();
                              } else {
                                log(
                                  "No more Items to Load. notificationlist : ${notificationScreenController.notificationList.length.toString()} totalcollectionlength: ${notificationScreenController.notificationList.toString()}",
                                );
                              }
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Obx(() => DayWiseNotification(
                                              date: Utils().dateToString(
                                                  notificationScreenController
                                                      .notificationList[index]
                                                      .date),
                                              notificationList:
                                                  notificationScreenController
                                                      .notificationList[index]
                                                      .value!));
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 16.h,
                                          );
                                        },
                                        itemCount: notificationScreenController
                                            .notificationList.length),
                                  ),
                                  // notificationScreenController
                                  //         .isNoDataLoading.value
                                  //     ? const SizedBox()
                                  //     :
                                  notificationScreenController
                                          .isLoadingData.value
                                      ? Utils().showPaginationLoader(
                                          notificationScreenController
                                              .animation_controller)
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: screenHeight * 0.87,
                            child:
                                notificationScreenController.isLoadingData.value
                                    ? const SizedBox.shrink()
                                    : NoDataFoundWidget(
                                        title: notificationScreenController
                                            .checkItem!.value,
                                        svgImgUrl:
                                            "assets/icons/no_notification.svg",
                                      ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
