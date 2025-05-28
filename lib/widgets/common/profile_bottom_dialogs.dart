import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import '../../const/colors/colors.dart';
import '../../controllers/delete_account/delete_account_controller.dart';
import '../../controllers/logout/logout_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../routes/app_route.dart';
import 'text_poppins.dart';
import '../../const/font_size/font_size.dart';
import '../../utils/utils.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog(
      {super.key,
      required this.asssetIcon,
      required this.title,
      this.titleColor = kColorFont,
      required this.contentText,
      required this.btn1Text,
      required this.btn2Text});
  final String asssetIcon;
  final String title;
  final Color titleColor;
  final String contentText;
  final String btn1Text;
  final String btn2Text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding:
            EdgeInsets.only(top: 24.h, bottom: 48.h, left: 24.w, right: 24.w),
        decoration: BoxDecoration(
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
                color: kColorPrimary,
                spreadRadius: -0.5.h,
                offset: const Offset(0, -2.4))
          ],
          // border: Border.fromBorderSide(BorderSide(color: kColorPrimary,width: 2.h,strokeAlign: BorderSide.strokeAlignInside)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
        ),
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        SvgPicture.asset(asssetIcon),
                        SizedBox(
                          width: 16.w,
                        ),
                        TextPoppins(
                            text: title.tr,
                            color: titleColor,
                            fontSize: FontSize.dialogTitle.sp,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/cross.svg',
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                child: TextPoppins(
                  text: contentText.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: FontSize.dialogText.sp,
                  color: kColorFont.withOpacity(0.75),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      //Loading(Utils.loaderImage()).start(Get.context!);
                      Get.back();
                      Utils().showLoader();
                      Utils.deleteToken();
                      Utils.deleteCurrentLocale();
                      Utils.deleteNotificationStatus();
                      Get.find<StartupController>().showTutorials.value = false;
                      if (btn1Text.tr == "Logout".tr) {
                        await Get.find<LogOutController>().logOutUser();
                      } else if (btn1Text.tr == "Delete".tr) {
                        await Get.find<DeleteAccountController>()
                            .deleteUserAccount();
                      } else if (btn1Text.tr == "Login".tr) {
                        // Get.toNamed(AppRoute.loginWithOTPScreen);

                        Get.back();

                        if (Get.find<StartupController>()
                                .startupData
                                .first
                                .data!
                                .result!
                                .loginWith!
                                .otp ==
                            true) {
                          if (Get.isRegistered<PlayerController>()) {
                            // Get.delete<PlayerController>();
                            Get.find<PlayerController>()
                                .audioPlayer
                                .value
                                .pause();
                          }
                          Get.toNamed(AppRoute.loginWithOTPScreen);
                        } else if (Get.find<StartupController>()
                                    .startupData
                                    .first
                                    .data!
                                    .result!
                                    .loginWith!
                                    .otp ==
                                false &&
                            Get.find<StartupController>()
                                    .startupData
                                    .first
                                    .data!
                                    .result!
                                    .loginWith!
                                    .password ==
                                true) {
                          if (Get.isRegistered<PlayerController>()) {
                            // Get.delete<PlayerController>();
                            Get.find<PlayerController>()
                                .audioPlayer
                                .value
                                .pause();
                          }
                          Get.toNamed(AppRoute.loginWithPasswordScreen);
                        }
                      }
                      if (btn1Text.tr != "Login".tr) {
                        Get.back();
                      }
                      // Loading.stop();
                    },
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                          color: kColorPrimary,
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(color: kColorPrimary, width: 1.w)),
                      child: Center(
                        child: TextPoppins(
                          text: btn1Text.tr,
                          color: kColorWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: FontSize.dialogBtnText.sp,
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 24.w),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                          color: kColorWhite,
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(color: kColorPrimary, width: 1.w)),
                      child: Center(
                        child: TextPoppins(
                          text: btn2Text.tr,
                          color: kColorPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: FontSize.dialogBtnText.sp,
                        ),
                      ),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
