import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class GurujiHindiHeadingWidget extends StatelessWidget {
  const GurujiHindiHeadingWidget({
    this.svgLeadingIconUrl = '',
    this.headingTitle = '',
    this.authorName = '',
    this.viewAllIconVisible = false,
    super.key,
  });

  final String svgLeadingIconUrl;
  final String headingTitle;
  final String authorName;
  final bool viewAllIconVisible;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        svgLeadingIconUrl != ''
            ? SizedBox(
            height: screenWidth >= 600 ? 40.h : 26.h,
            width: screenWidth >= 600 ? 40.h : 26.h,
            child: SvgPicture.asset(svgLeadingIconUrl))
            : const SizedBox(),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '“$authorName”',
                  style: kTextStylePoppinsMedium.copyWith(
                    color: kColorFont,
                    fontSize: FontSize.headingsTitle.sp,
                  ),
                  children: <TextSpan>[
                    authorName != ''
                        ? TextSpan(
                      text: ' by '.tr,
                      style: kTextStylePoppinsMedium.copyWith(
                        color: kColorFont,
                        fontSize: FontSize.headingsTitle.sp,
                      ),
                    )
                        : const TextSpan(text: ''),
                    authorName != ''
                        ? TextSpan(
                      text: headingTitle,
                      style: kTextStylePoppinsMedium.copyWith(
                        color: kColorFont,
                        fontSize: FontSize.headingsTitle.sp,
                      ),
                    )
                        : const TextSpan(text: ''),
                  ],
                ),
              ),
            ],
          ),
        ),
        viewAllIconVisible
            ? SizedBox(
          // color: Colors.amber,
          // height: 32.h,
          // width: 32.h,
          child: SvgPicture.asset(
            height: screenWidth >= 600 ? 35.h : 26.h,
            width: screenWidth >= 600 ? 35.h : 26.h,
            'assets/icons/view_more_icon.svg',
          ),
        )
            : const SizedBox(),
      ],
    );
  }
}
