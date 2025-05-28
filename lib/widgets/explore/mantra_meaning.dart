import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class MantraMeaning extends StatelessWidget {
  const MantraMeaning({super.key, required this.mantra, required this.meaning});
  final String mantra, meaning;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        clipBehavior: Clip.hardEdge,
        height: 470.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset("assets/icons/mantra_top_left.svg"),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset("assets/icons/mantra_top_right.svg"),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset("assets/icons/mantra_bottom_left.svg"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset("assets/icons/mantra_bottom_right.svg"),
            ),
            Container(
              padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 50.h),
              child: SingleChildScrollView(
                child: SizedBox(
                  // height: 500.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Mantra Meaning".tr,
                        style: kTextStyleRosarioRegular.copyWith(
                            fontSize: 24.sp, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 36.h,
                      ),
                      Text(
                        mantra,
                        style: kTextStylePoppinsMedium.copyWith(
                            fontSize: FontSize.mantra.sp,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Transform.rotate(
                              angle: pi / 4,
                              child: Icon(
                                Icons.square,
                                size: 10.sp,
                                color: kColorPrimaryWithOpacity25,
                              )),
                          Expanded(
                            child: Container(
                              color: kColorPrimaryWithOpacity25,
                              height: 1.sp,
                            ),
                          ),
                          Text(
                            "  Meaning  ".tr,
                            style: kTextStylePoppinsRegular.copyWith(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: kColorPrimary),
                          ),
                          Expanded(
                            child: Container(
                              color: kColorPrimaryWithOpacity25,
                              height: 1.sp,
                            ),
                          ),
                          Transform.rotate(
                              angle: pi / 4,
                              child: Icon(
                                Icons.square,
                                size: 10.sp,
                                color: kColorPrimaryWithOpacity25,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                        meaning,
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 7,
                        style: kTextStylePoppinsRegular.copyWith(
                            fontSize: FontSize.mantra.sp,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
