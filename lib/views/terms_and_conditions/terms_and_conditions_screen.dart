import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/terms_and_conditions/terms_and_conditions_controller.dart';
import '../../widgets/t&c_privacy_policy/heading_title.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart' as size;
import '../../const/text_styles/text_styles.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final termsAndConditionsController = Get.find<TermsAndConditionsController>();

  @override
  void dispose() {
    super.dispose();
    termsAndConditionsController.clearTermsAndConditionsData();
    log('termsAndConditions cleared. termsAndConditions = ${termsAndConditionsController.termsAndConditions}');
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: kColorWhite));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
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
                      'Terms & Conditions'.tr,
                      style: kTextStyleRosarioRegular.copyWith(
                        color: kColorFont,
                        fontSize: size.FontSize.screenTitle.sp,
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
              ),
              const TCAndPrivacyPolicyHeading(name: 'T&C'),
              Obx(
                () => Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
                  color: kColorWhite,
                  margin: EdgeInsets.only(bottom: 27.h),
                  child: Html(
                    data: termsAndConditionsController
                        .termsAndConditions.value!.content!,
                    style: {
                      "p": Style(fontFamily: "Poppins-Regular"),
                      "li": Style(fontFamily: "Poppins-Regular")
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
