import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/widgets/common/custom_app_bar.dart';
import 'package:yatharthageeta/widgets/home/heading_home_widget.dart';

class BookLibraryScreen extends StatelessWidget {
  const BookLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Books Library',
              ),
              Container(
                color: kColorWhite2,
                height: 24.h,
              ),
              Column(
                children: [
                  for (int i = 0; i < 10; i++) ...[
                    HeadingHomeWidget(
                      svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                      headingTitle: 'Yathart Geeta',
                      viewAllIconVisible: true,
                    ).marginSymmetric(horizontal: 24.w, vertical: 24.h),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < 10; i++) ...[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/authentication/Login.png',
                                      width: 150.w,
                                      height: 200.h,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      "Bhagvad Gita",
                                      style: kTextStylePoppinsMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                    Text(
                                      "Sanskrit",
                                      style: kTextStylePoppinsMedium.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp,
                                          color: kColorPrimary),
                                    ).paddingSymmetric(horizontal: 12.w),
                                  ]).paddingOnly(
                                right: 16.w,
                              ),
                            ]
                          ],
                        ).paddingOnly(left: 24.w) // 24.w
                        ),
                    Container(
                      margin: EdgeInsets.only(top: 24.h),
                      height: 24.h,
                      color: kColorWhite2,
                    )
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
