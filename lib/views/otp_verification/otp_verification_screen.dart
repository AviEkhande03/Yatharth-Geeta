import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controllers/otp_verification/otp_verification_controller.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/common/text_rosario.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpVerificationController = Get.find<OtpVerificationController>();
    final double height = MediaQuery.of(context).size.height;

    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
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
                    Positioned(
                      top: 35.h,
                      left: 20.w,
                      child: SizedBox(
                        // color: Colors.red,
                        width: 24.w,
                        height: 24.h,
                        child: SvgPicture.asset('assets/icons/back_icon.svg'),
                      ),
                    ),
                    Positioned(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 36.0.h),
                  child: Center(
                    child: TextRosario(
                      text: 'OTP Verification'.tr,
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
                        text: 'Enter the OTP sent to the registered number'.tr,
                        fontWeight: FontWeight.w400,
                        fontSize: FontSize.subHeadingText.sp,
                        color: kColorFont.withOpacity(0.75),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(top: 30.h, left: 24.w, right: 34.w),
                    child: Center(
                      child: PinCodeTextField(
                        showCursor: false,
                        appContext: context,
                        length: 6,
                        autoDisposeControllers: false,
                        keyboardType: TextInputType.number,
                        controller: otpVerificationController.otpCode,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.circle,
                            borderRadius: BorderRadius.circular(6.r),
                            fieldHeight: 55.w,
                            fieldWidth: 55.w,
                            activeFillColor: kColorPrimary.withOpacity(0.15),
                            activeColor: Colors.transparent,
                            activeBorderWidth: 0.0,
                            inactiveBorderWidth: 0.0,
                            inactiveColor: Colors.transparent,
                            inactiveFillColor: Colors.grey.shade200,
                            selectedFillColor: kColorWhite,
                            selectedBorderWidth: 2.w,
                            selectedColor: kColorPrimary),
                        enableActiveFill: true,
                        textStyle: TextStyle(
                            fontSize: FontSize.otpText.sp,
                            color: kColorFont,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins-Regular'),
                      ),
                    )),
                Obx(
                  () => otpVerificationController.otpValidation?.value != ''
                      ? Padding(
                          padding: EdgeInsets.only(top: 2.0.h, left: 30.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextPoppins(
                              text: otpVerificationController
                                  .otpValidation!.value,
                              color: kRedColor,
                              fontSize: FontSize.validationMessage.sp,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Obx(() => Padding(
                      padding:
                          EdgeInsets.only(top: 17.h, left: 24.w, right: 24.w),
                      child: TextPoppins(
                        text:
                            '${otpVerificationController.remainingMinutes.toString().padLeft(2, '0')} : ${otpVerificationController.remainingSeconds.toString().padLeft(2, '0')}',
                        fontWeight: FontWeight.w400,
                        fontSize: FontSize.timerText.sp,
                        color: kColorFont.withOpacity(0.75),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 48.h, left: 24.w, right: 29.w),
                  child: GestureDetector(
                    onTap: () {
                      otpVerificationController.validateWithOTP();
                    },
                    child: CustomButton(
                      btnText: 'Proceed'.tr,
                    ),
                  ),
                ),
                Obx(() => otpVerificationController.isResendVisible.value
                    ? Padding(
                        padding: EdgeInsets.only(top: 24.0.h),
                        child: Center(
                          child: RichText(
                              textAlign: TextAlign.start,
                              textWidthBasis: TextWidthBasis.parent,
                              text: TextSpan(
                                  text: "Didn't receive the OTP? ".tr,
                                  style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                      fontSize:
                                          FontSize.authScreenFontSize16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: kColorFont.withOpacity(0.75)),
                                  children: <InlineSpan>[
                                    TextSpan(
                                        text: 'Resend'.tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontSize:
                                              FontSize.authScreenFontSize16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: kColorPrimary,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2.h,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              otpVerificationController
                                                  .resendOTP())
                                  ])),
                        ),
                      )
                    : const SizedBox()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
