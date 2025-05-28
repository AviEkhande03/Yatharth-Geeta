import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/registration/registartion_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/input_textfield.dart';
import '../../widgets/common/t&c_PrivacyText.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/common/text_rosario.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationScreenController = Get.find<RegistrationController>();
    final double height = MediaQuery.of(context).size.height;

    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: height * 0.26,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/authentication/Login.png'),
                      fit: BoxFit.fill),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Navigator.of(context).canPop()
                          ? Positioned(
                              top: 35.h,
                              left: 20.w,
                              child: SizedBox(
                                // color: Colors.red,
                                width: 24.w,
                                height: 24.h,
                                child: SvgPicture.asset(
                                    'assets/icons/back_icon.svg'),
                              ),
                            )
                          : const SizedBox(),
                      Navigator.of(context).canPop()
                          ? Positioned(
                              top: 20.h,
                              left: 0.w,
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  color: kColorTransparent,
                                  width: 60.w,
                                  height: 50.h,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Obx(
                        () => Platform.operatingSystem == 'android'
                            ? Get.find<StartupController>()
                                            .startupData
                                            .first
                                            .data!
                                            .result!
                                            .loginWith!
                                            .skipLoginAndroid ==
                                        true &&
                                    registrationScreenController.isGuestUser ==
                                        false
                                ? Stack(
                                    children: [
                                      Positioned(
                                        top: 35.h,
                                        right: 20.w,
                                        child: Text(
                                          'Skip'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontFamily: 'Poppins-Regular',
                                            decorationColor: kColorWhite,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2.h,
                                            color: kColorWhite,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20.h,
                                        right: 0.w,
                                        child: GestureDetector(
                                          onTap: () {
                                            Utils.setGuestUser(true);
                                            if (Get.isRegistered<
                                                PlayerController>()) {
                                              // Get.delete<PlayerController>();
                                              Get.find<PlayerController>()
                                                  .audioPlayer
                                                  .value
                                                  .pause();
                                              Get.find<PlayerController>()
                                                  .audioPlayer
                                                  .value
                                                  .dispose();
                                            }
                                            Get.offAllNamed(
                                                AppRoute.bottomAppBarScreen);
                                          },
                                          child: Container(
                                            height: 60.h,
                                            width: 70.w,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                            : Get.find<StartupController>()
                                            .startupData
                                            .first
                                            .data!
                                            .result!
                                            .loginWith!
                                            .skipLoginIos ==
                                        true &&
                                    registrationScreenController
                                            .isGuestUser.value ==
                                        false
                                ? Stack(
                                    children: [
                                      Positioned(
                                        top: 35.h,
                                        right: 20.w,
                                        child: Text(
                                          'Skip'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontFamily: 'Poppins-Regular',
                                            decorationColor: kColorWhite,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2.h,
                                            color: kColorWhite,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20.h,
                                        right: 0.w,
                                        child: GestureDetector(
                                          onTap: () {
                                            Utils.setGuestUser(true);
                                            if (Get.isRegistered<
                                                PlayerController>()) {
                                              // Get.delete<PlayerController>();
                                              Get.find<PlayerController>()
                                                  .audioPlayer
                                                  .value
                                                  .pause();
                                              Get.find<PlayerController>()
                                                  .audioPlayer
                                                  .value
                                                  .dispose();
                                            }
                                            Get.offAllNamed(
                                                AppRoute.bottomAppBarScreen);
                                          },
                                          child: Container(
                                            height: 60.h,
                                            width: 70.w,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 48.r,
                                //backgroundColor: Colors.red,
                                child: Image.asset(
                                    'assets/images/authentication/babaji.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 9.h),
                                child: TextRosario(
                                  text: "Yatharth Geeta".tr,
                                  fontSize: FontSize.ygText.sp,
                                  color: kColorWhite2,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36.0.h),
                child: Center(
                  child: TextRosario(
                    text: 'Register'.tr,
                    fontWeight: FontWeight.w400,
                    fontSize: FontSize.headingText.sp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: TextPoppins(
                      text: 'Enter your mobile number to proceed'.tr,
                      fontWeight: FontWeight.w400,
                      fontSize: FontSize.subHeadingText.sp,
                      color: kColorFont.withOpacity(0.75),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0.h, left: 24.w, right: 24.w),
                child: InputFormField(
                  controller: registrationScreenController.phone,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 28.w),
                    child: TextPoppins(
                      text: '+91 |  ',
                      fontSize: FontSize.hintText.sp,
                      fontWeight: FontWeight.w400,
                      color: kColorFont.withOpacity(0.5),
                    ),
                  ),
                  prefixIconBoxConstraints: const BoxConstraints(),
                  // isMobileNumber: true,
                  hintText: 'Enter your mobile number'.tr,
                  leftIconPath: 'assets/icons/phone.svg',
                  keyBoardType: TextInputType.phone,
                  //maxLength: 10,
                ),
              ),
              Obx(
                () => registrationScreenController.phoneValidation?.value != ''
                    ? Padding(
                        padding: EdgeInsets.only(top: 2.0.h, left: 55.w),
                        child: TextPoppins(
                          text: registrationScreenController
                              .phoneValidation!.value,
                          color: kRedColor,
                          fontSize: FontSize.validationMessage.sp,
                        ),
                      )
                    : const SizedBox(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 48.h, left: 24.w, right: 24.w),
                child: GestureDetector(
                  onTap: () {
                    //Get.toNamed(AppRoute.otpVerificationScreen);
                    registrationScreenController.validate(context);
                  },
                  child: CustomButton(
                    btnText: 'Register'.tr,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0.h),
                child: Center(
                  child: RichText(
                      textAlign: TextAlign.start,
                      textWidthBasis: TextWidthBasis.parent,
                      text: TextSpan(
                          text: 'Already a member? '.tr,
                          style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: FontSize.authScreenFontSize16.sp,
                              fontWeight: FontWeight.w400,
                              color: kColorFont.withOpacity(0.75)),
                          children: <InlineSpan>[
                            TextSpan(
                                text: 'Login'.tr,
                                style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: FontSize.authScreenFontSize16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kColorPrimary,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2.h,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (Get.find<StartupController>()
                                            .startupData
                                            .first
                                            .data!
                                            .result!
                                            .loginWith!
                                            .otp ==
                                        true) {
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
                                      Get.toNamed(
                                          AppRoute.loginWithPasswordScreen);
                                    }
                                  })
                          ])),
                ),
              ),
              SizedBox(
                height: 56.h,
              ),
              Container(
                  margin: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/lineLeft.svg',
                        fit: BoxFit.scaleDown,
                        width: 129.w,
                      ),
                      Text(
                        "  Continue With  ",
                        style: kTextStylePoppinsRegular.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/lineRight.svg',
                        width: 130.w,
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 40.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgPicture.asset(
                    'assets/icons/google.svg',
                  ),
                  SizedBox(
                    width: 64.w,
                  ),
                  SvgPicture.asset(
                    'assets/icons/apple.svg',
                    width: 40.w,
                  ),
                ]),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 11.0.h),
          child: const TCAndPrivacyPolicyText(),
        ));
  }
}
