import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/controllers/otp_verification/otp_verification_controller.dart';
import '../../controllers/login_with_OTP/login_with_otp_controller.dart';
import '../../routes/app_route.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../utils/utils.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/input_textfield.dart';
import '../../widgets/common/t&c_PrivacyText.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/common/text_rosario.dart';

class LoginWithOtpScreen extends StatelessWidget {
  LoginWithOtpScreen({super.key});

  final otpVerificationController = Get.put(OtpVerificationController());

  @override
  Widget build(BuildContext context) {
    final loginWithOTPScreenController = Get.find<LoginWithOTPController>();

    final startUpApiController = Get.find<StartupController>();

    final double height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    debugPrint("previousRoute:${Get.previousRoute}");
    debugPrint(
        "Navigator.of(context).canPop():${Navigator.of(context).canPop()}");
    debugPrint(
        "loginWithOTPScreenController.isGuestUser${loginWithOTPScreenController.isGuestUser}");
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
                    image: AssetImage('assets/images/authentication/Login.png'),
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
                          ? startUpApiController.startupData.first.data!.result!
                                          .loginWith!.skipLoginAndroid ==
                                      true &&
                                  loginWithOTPScreenController
                                          .isGuestUser.value ==
                                      false
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
                                            decoration:
                                                TextDecoration.underline,
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
                              : const SizedBox()
                          : startUpApiController.startupData.first.data!.result!
                                          .loginWith!.skipLoginIos ==
                                      true &&
                                  loginWithOTPScreenController
                                          .isGuestUser.value ==
                                      false
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
                                            decoration:
                                                TextDecoration.underline,
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
                    Align(
                      alignment: Alignment.center,
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
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 36.0.h),
              child: Center(
                child: TextRosario(
                  text: 'Join us'.tr,
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
            Obx(
              () => Padding(
                padding: EdgeInsets.only(top: 24.0.h, left: 24.w, right: 24.w),
                child: InputFormField(
                  hintText: 'Enter your mobile number'.tr,
                  leftIconPath: 'assets/icons/phone.svg',
                  // prefixIcon: Text(" |"),
                  prefixIcon: SizedBox(
                    // width: 60.w,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                countryListTheme: CountryListThemeData(
                                  flagSize: 25,
                                  backgroundColor: Colors.white,
                                  textStyle: kTextStylePoppinsMedium.copyWith(
                                    color: kColorFont,
                                  ),
                                  bottomSheetHeight:
                                      700, // Optional. Country list modal height
                                  //Optional. Sets the border radius for the bottomsheet.
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  //Optional. Styles the search field.
                                  inputDecoration: InputDecoration(
                                    labelText: 'Search',
                                    contentPadding: EdgeInsets.zero,
                                    labelStyle: kTextStylePoppinsRegular
                                        .copyWith(color: kColorFont),
                                    hintText: 'Start typing to search',
                                    hintStyle: kTextStylePoppinsRegular
                                        .copyWith(color: kColorFont),
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8C98A8)
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ),
                                onSelect: (Country country) {
                                  loginWithOTPScreenController.countryCode
                                      .value = "+" + country.phoneCode;
                                  loginWithOTPScreenController.phone.text = '';
                                  print(
                                      "country.countryCode:${country.countryCode}");
                                  if (Get.find<StartupController>()
                                      .country_phone_lengths
                                      .containsKey(country.countryCode)) {
                                    loginWithOTPScreenController.phoneLength
                                        .value = Get.find<StartupController>()
                                            .country_phone_lengths[
                                        '${country.countryCode}']!;
                                  }
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 29.0.w),
                                  child: SvgPicture.asset(
                                      width: 10.w,
                                      height: 10.w,
                                      'assets/icons/orange_dropdown.svg'),
                                ),
                                // CountryCodePicker(
                                //     showFlag: false,
                                //     showDropDownButton: true,
                                //     onChanged: (value) {
                                //       loginWithOTPScreenController.countryCode.value =
                                //           value.dialCode.toString();
                                //       //debugPrint("value.dialCode.toString():${value.dialCode.toString()}");
                                //     },
                                //     // countryList: CountryDialCodes().countryDialCodes,
                                //     builder: (p0) {
                                //       return Padding(
                                //           padding: EdgeInsets.only(left: 7.w),
                                //           child: Text(
                                //             "${p0!.dialCode}",
                                //             style: kTextStylePoppinsMedium.copyWith(
                                //                 color: kColorPrimary),
                                //           ));
                                //     },
                                //     padding: EdgeInsets.zero,
                                //     initialSelection: "IN",
                                //     showFlagDialog: true,
                                //     // flagWidth: 0,
                                //     // showCountryOnly: true,
                                //     textStyle: kTextStylePoppinsMedium.copyWith(
                                //       color: kColorPrimary,
                                //     )),
                                Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: Obx(
                                    () => Text(
                                      loginWithOTPScreenController
                                          .countryCode.value,
                                      style: kTextStylePoppinsMedium.copyWith(
                                          color: kColorPrimary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextPoppins(
                            text: '  |  ',
                            fontSize: FontSize.hintText.sp,
                            fontWeight: FontWeight.w400,
                            color: kColorPrimary,
                          ),
                        ]),
                  ),
                  prefixIconBoxConstraints: const BoxConstraints(),
                  controller: loginWithOTPScreenController.phone,
                  maxLength: loginWithOTPScreenController.phoneLength.value,
                  keyBoardType: TextInputType.phone,
                ),
              ),
            ),
            Obx(
              () => loginWithOTPScreenController.phoneValidation?.value != ''
                  ? Padding(
                      padding: EdgeInsets.only(top: 2.0.h, left: 55.w),
                      child: TextPoppins(
                        text:
                            loginWithOTPScreenController.phoneValidation!.value,
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
                  loginWithOTPScreenController.validate(context);
                  //
                },
                child: CustomButton(
                  btnText: 'Login'.tr,
                ),
              ),
            ),
            startUpApiController
                        .startupData.first.data!.result!.loginWith!.password ==
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
                        .startupData.first.data!.result!.loginWith!.password ==
                    true
                ? Padding(
                    padding:
                        EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoute.loginWithPasswordScreen);
                      },
                      child: CustomButton(
                        btnText: 'Login via Password'.tr,
                        textColor: kColorPrimary,
                        btnColor: kColorWhite,
                      ),
                    ),
                  )
                : const SizedBox(),
            // Padding(
            //   padding: EdgeInsets.only(top: 24.0.h),
            //   child: Center(
            //     child: RichText(
            //         textAlign: TextAlign.start,
            //         textWidthBasis: TextWidthBasis.parent,
            //         text: TextSpan(
            //             text: 'Don’t have an account? '.tr,
            //             style: TextStyle(
            //                 fontFamily: 'Poppins-Regular',
            //                 fontSize: FontSize.authScreenFontSize16.sp,
            //                 fontWeight: FontWeight.w400,
            //                 color: kColorFont.withOpacity(0.75)),
            //             children: <InlineSpan>[
            //               TextSpan(
            //                   text: 'Register'.tr,
            //                   style: TextStyle(
            //                     fontFamily: 'Poppins-Regular',
            //                     fontSize: FontSize.authScreenFontSize16.sp,
            //                     fontWeight: FontWeight.w600,
            //                     color: kColorPrimary,
            //                     decoration: TextDecoration.underline,
            //                     decorationThickness: 2.h,
            //                   ),
            //                   recognizer: TapGestureRecognizer()
            //                     ..onTap = () =>
            //                         Get.toNamed(AppRoute.registrationScreen))
            //             ])),
            //   ),
            // ),
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
                      width: 125.w,
                    ),
                    Text(
                      "  ${"Continue With".tr}  ",
                      style: kTextStylePoppinsRegular.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/lineRight.svg',
                      width: 125.w,
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 40.h),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                startUpApiController
                        .startupData.first.data!.result!.loginWith!.google!
                    ? GestureDetector(
                        onTap: () async {
                          var user = await loginWithOTPScreenController
                              .signInWithGoogle();
                          if (user != null) {
                            if (user.user!.emailVerified) {
                              await loginWithOTPScreenController.socialLogin(
                                  user.user!.email!,
                                  'google',
                                  loginWithOTPScreenController.uid,
                                  loginWithOTPScreenController.displayName);
                            } else {
                              Utils.customToast('Please Try Again!!', kRedColor,
                                  kRedColor.withOpacity(0.2), "Error");
                            }
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/icons/google.svg',
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  width: Platform.isIOS ? 64.w : 0,
                ),
                Platform.isIOS
                    ? startUpApiController
                            .startupData.first.data!.result!.loginWith!.apple!
                        ? GestureDetector(
                            onTap: () async {
                              var credentials =
                                  await loginWithOTPScreenController
                                      .signInWithApple();
                              if (credentials.authorizationCode != '' &&
                                  credentials.userIdentifier != null) {
                                Utils().showLoader();
                                var email = '';
                                var displayName = '';
                                if (credentials.email != null) {
                                  email = credentials.email!;
                                  displayName = credentials.givenName! +
                                      " " +
                                      credentials.familyName!;
                                } else if (credentials.givenName != null &&
                                    credentials.familyName != null) {
                                  email = credentials.givenName! +
                                      credentials.familyName! +
                                      "@noapple.com";
                                  displayName = credentials.givenName! +
                                      " " +
                                      credentials.familyName!;
                                } else {
                                  email = '';
                                  displayName = '';
                                }
                                // print("credentials.authorizationCode:${credentials.authorizationCode}");
                                // print("credentials.identityToken:${credentials.identityToken}");
                                // print("credentials.userIdentifier:${credentials.userIdentifier}");
                                await loginWithOTPScreenController.socialLogin(
                                    email,
                                    'apple',
                                    credentials.userIdentifier!,
                                    displayName);
                              } else {
                                Utils.customToast(
                                    'Please Try Again!!',
                                    kRedColor,
                                    kRedColor.withOpacity(0.2),
                                    "Error");
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/icons/apple.svg',
                              width: 40.w,
                            ),
                          )
                        : SizedBox.shrink()
                    : SizedBox.shrink(),
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
