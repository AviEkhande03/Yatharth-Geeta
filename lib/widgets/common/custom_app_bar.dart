import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    this.title = '',
    this.sideIconsUrl = '',
    super.key,
  });

  final String title;
  final String sideIconsUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kColorWhite,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.05),
                //     offset: const Offset(0, 5),
                //     blurRadius: 20,
                //   ),
                // ],
                border: Border(
                  bottom: BorderSide(
                    color: kColorPrimaryWithOpacity25,
                  ),
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 12.h,
                bottom: 12.h,
              ),
              child: sideIconsUrl == ''
                  ? Text(
                      title,
                      style: kTextStyleRosarioRegular.copyWith(
                        color: kColorFont,
                        fontSize: FontSize.screenTitle.sp,
                      ),
                    )
                  : SizedBox(
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: SvgPicture.asset(sideIconsUrl),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Text(
                            title,
                            style: kTextStyleRosarioRegular.copyWith(
                              color: kColorFont,
                              fontSize: FontSize.screenTitle.sp,
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: SvgPicture.asset(sideIconsUrl),
                          ),
                        ],
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
                  child: SvgPicture.asset('assets/icons/back.svg'),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    width: 70.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
