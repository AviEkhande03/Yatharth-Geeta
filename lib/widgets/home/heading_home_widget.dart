import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class HeadingHomeWidget extends StatelessWidget {
  const HeadingHomeWidget({
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
      crossAxisAlignment: authorName != ""
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign:
                    authorName != '' ? TextAlign.start : TextAlign.center,
                text: TextSpan(
                  text: headingTitle,
                  style: kTextStylePoppinsMedium.copyWith(
                    color: kColorFont,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                  children: <TextSpan>[],
                ),
              ).paddingOnly(right: 8.w),
              authorName != ""
                  ? Text(
                      authorName,
                      maxLines: 1,
                      style: kTextStylePoppinsMedium.copyWith(
                        color: Color(0xff17120B).withOpacity(0.75),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
        // viewAllIconVisible
        //     ? SizedBox(
        //         // color: Colors.amber,
        //         // height: 32.h,
        //         // width: 32.h,
        //         child: SvgPicture.asset(
        //           height: screenWidth >= 600 ? 35.h : 26.h,
        //           width: screenWidth >= 600 ? 35.h : 26.h,
        //           'assets/icons/view_more_icon.svg',
        //         ),
        //       )
        //     : const SizedBox(),
        viewAllIconVisible
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: Color(0xffE39C28),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  "View All".tr,
                  style: kTextStylePoppinsMedium.copyWith(
                    color: Color(0xffE39C28),
                    fontSize: 12.sp,
                  ),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}
