import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/constants/constants.dart';
import '../../controllers/privacy_policy/privacy_policy_controller.dart';
import '../../controllers/terms_and_conditions/terms_and_conditions_controller.dart';
import '../../utils/utils.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../routes/app_route.dart';

class TCAndPrivacyPolicyText extends StatelessWidget {
  const TCAndPrivacyPolicyText({super.key});

  @override
  Widget build(BuildContext context) {
    final privacyPolicyController = Get.find<PrivacyPolicyController>();
    final termsAndConditionsController =
        Get.find<TermsAndConditionsController>();
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0.h),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'By signing up you agree to our '.tr,
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: FontSize.authScreenFontSize11.sp,
                  fontWeight: FontWeight.w400,
                  color: kColorFont.withOpacity(0.75)),
              children: <InlineSpan>[
                TextSpan(
                    text: 'Terms & Conditions'.tr,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: FontSize.authScreenFontSize12.sp,
                      fontWeight: FontWeight.w500,
                      color: kColorPrimary,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Utils().showLoader();

                        //Call API here
                        await termsAndConditionsController
                            .fetchTermsAndConditions(
                                token: '',
                                ctx: context,
                                type: Constants.typeTermsAndConditions);

                        Get.back();

                        if (!termsAndConditionsController.isLoadingData.value) {
                          Get.toNamed(AppRoute.termsAndConditionsScreen);
                        }
                      },
                    children: [
                      TextSpan(
                          text: ' and '.tr,
                          style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: FontSize.authScreenFontSize11.sp,
                              fontWeight: FontWeight.w400,
                              color: kColorFont.withOpacity(0.75),
                              decoration: TextDecoration.none),
                          children: [
                            TextSpan(
                              text: 'Privacy Policy'.tr,
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize: FontSize.authScreenFontSize12.sp,
                                fontWeight: FontWeight.w500,
                                color: kColorPrimary,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Utils().showLoader();

                                  //Call API here
                                  await privacyPolicyController
                                      .fetchPrivacyPolicy(
                                          token: '',
                                          ctx: context,
                                          type: Constants.typePrivacyPolicy);

                                  Get.back();

                                  if (!privacyPolicyController
                                      .isLoadingData.value) {
                                    Get.toNamed(AppRoute.privacyPolicyScreen);
                                  }
                                },
                            ),
                          ])
                    ]),
              ])),
    );
  }
}
