import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart' as size;
import '../../const/text_styles/text_styles.dart';
import '../../controllers/privacy_policy/privacy_policy_controller.dart';
import '../../widgets/t&c_privacy_policy/heading_title.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final privacyPolicyController = Get.find<PrivacyPolicyController>();

  @override
  void dispose() {
    super.dispose();
    privacyPolicyController.clearPrivacyPolicyData();
    log('privacyPolicy cleared. termsAndConditions = ${privacyPolicyController.privacyPolicy}');
  }

  @override
  Widget build(BuildContext context) {
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
                      'Privacy Policy'.tr,
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
              const TCAndPrivacyPolicyHeading(name: 'Policy'),
              Obx(
                () => Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
                    color: kColorWhite,
                    margin: EdgeInsets.only(bottom: 27.h),
                    child: Html(
                      data:
                          privacyPolicyController.privacyPolicy.value!.content!,
                      style: {
                        "p": Style(fontFamily: "Poppins-Regular"),
                        "li": Style(fontFamily: "Poppins-Regular")
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
