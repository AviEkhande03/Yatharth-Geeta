import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../routes/app_route.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/input_textfield.dart';
import '../../widgets/common/text_poppins.dart';
import '../../controllers/login_with_password/login_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../utils/utils.dart';
import '../../widgets/common/t&c_PrivacyText.dart';
import '../../widgets/common/text_rosario.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginScreenController = Get.find<LoginController>();
    final startUpApiController = Get.find<StartupController>();

    final double height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 234.h,
              height: height * 0.26,
              decoration: const BoxDecoration(
                //color: Colors.red,
                image: DecorationImage(
                    image: AssetImage('assets/images/authentication/Login.png'),
                    fit: BoxFit.fill),
              ),
              child: Stack(children: [
                Obx(
                  () => Platform.operatingSystem == 'android'
                      ? startUpApiController.startupData.first.data!.result!
                                      .loginWith!.skipLoginAndroid ==
                                  true &&
                              loginScreenController.isGuestUser == false
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
                                      decoration: TextDecoration.underline,
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
                      : startUpApiController.startupData.first.data!.result!
                                      .loginWith!.skipLoginIos ==
                                  true &&
                              loginScreenController.isGuestUser.value == false
                          ? Stack(
                              children: [
                                Positioned(
                                  top: 35.h,
                                  right: 20.w,
                                  child: Container(
                                    color: kColorTransparent,
                                    child: Text(
                                      'Skip'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: 'Poppins-Regular',
                                        decorationColor: kColorWhite,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 2.h,
                                        color: kColorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 20.h,
                                  right: 0.w,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Utils.setGuestUser(true);
                                      debugPrint(
                                          "isGuest:${await Utils.isGuestUser()}");
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
                Center(
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
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: 36.0.h),
              child: Center(
                child: TextRosario(
                  text: 'Login'.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: FontSize.headingText.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextPoppins(
                    text: 'Enter your registered number & password to login'.tr,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: kColorFont.withOpacity(0.75),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 48.0.h, left: 24.w, right: 24.w),
              child: InputFormField(
                hintText: 'Enter your mobile number'.tr,
                leftIconPath: 'assets/icons/phone.svg',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 28.w),
                  child: TextPoppins(
                    text: '+91 |  ',
                    fontSize: FontSize.hintText.sp,
                    fontWeight: FontWeight.w400,
                    color: kColorFont.withOpacity(0.5),
                  ),
                ),
                prefixIconBoxConstraints: BoxConstraints(),
                //maxLength: 10,
                keyBoardType: TextInputType.phone,
                controller: loginScreenController.phone,
              ),
            ),
            Obx(
              () => loginScreenController.phoneValidation?.value != ''
                  ? Padding(
                      padding: EdgeInsets.only(top: 2.0.h, left: 55.w),
                      child: TextPoppins(
                        text: loginScreenController.phoneValidation!.value,
                        color: kRedColor,
                        fontSize: FontSize.validationMessage.sp,
                      ),
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0.h, left: 24.w, right: 24.w),
              child: Obx(
                () => InputFormField(
                  hintText: 'Enter Password'.tr,
                  leftIconPath: 'assets/icons/key.svg',
                  controller: loginScreenController.password,
                  suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 13.0.w),
                      child: InkWell(
                          onTap: () {
                            loginScreenController.isPassWordDisabled.value =
                                !loginScreenController.isPassWordDisabled.value;
                          },
                          child: SvgPicture.asset(
                              loginScreenController.isPassWordDisabled.value
                                  ? 'assets/icons/eye-crossed.svg'
                                  : 'assets/icons/eye.svg'))),
                  obscureText: loginScreenController.isPassWordDisabled.value,
                  maxLength: 6,
                ),
              ),
            ),
            Obx(
              () => loginScreenController.passwordValidation?.value != ''
                  ? Padding(
                      padding: EdgeInsets.only(top: 2.0.h, left: 55.w),
                      child: TextPoppins(
                        text: loginScreenController.passwordValidation!.value,
                        color: kRedColor,
                        fontSize: FontSize.validationMessage.sp,
                      ),
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
              child: GestureDetector(
                onTap: () {
                  loginScreenController.validate();
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const BottomAppBarScreen();
                    }),
                  );*/
                },
                child: CustomButton(
                  btnText: 'Login'.tr,
                ),
              ),
            ),
            startUpApiController
                        .startupData.first.data!.result!.loginWith!.otp ==
                    true
                ? Padding(
                    padding:
                        EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset(
                                'assets/icons/left_arrow_line.svg')),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                          child: TextPoppins(
                            text: 'Or'.tr,
                            fontWeight: FontWeight.w400,
                            fontSize: FontSize.buttonText.sp,
                          ),
                        ),
                        Expanded(
                            child: SvgPicture.asset(
                                'assets/icons/right_arrow_line.svg'))
                      ],
                    ),
                  )
                : const SizedBox(),
            startUpApiController
                        .startupData.first.data!.result!.loginWith!.otp ==
                    true
                ? Padding(
                    padding:
                        EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoute.loginWithOTPScreen);
                      },
                      child: CustomButton(
                        btnText: 'Login via OTP'.tr,
                        textColor: kColorPrimary,
                        btnColor: kColorWhite,
                      ),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(top: 24.0.h),
              child: Center(
                child: RichText(
                    textAlign: TextAlign.start,
                    textWidthBasis: TextWidthBasis.parent,
                    text: TextSpan(
                        text: 'Don’t have an account? '.tr,
                        style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: FontSize.authScreenFontSize16.sp,
                            fontWeight: FontWeight.w400,
                            color: kColorFont.withOpacity(0.75)),
                        children: <InlineSpan>[
                          TextSpan(
                              text: 'Register'.tr,
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize: FontSize.authScreenFontSize16.sp,
                                fontWeight: FontWeight.w600,
                                color: kColorPrimary,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Get.toNamed(AppRoute.registrationScreen))
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
      ),
    );
  }
}
