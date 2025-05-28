import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yatharthageeta/const/constants/constants.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({
    this.title = '',
    this.svgImgUrl = '',
    super.key,
  });

  final String title;
  final String svgImgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          svgImgUrl != '' ? SvgPicture.asset(svgImgUrl) : const SizedBox(),
          SizedBox(
            height: 18.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/swastik.svg",height: width >= 600 ? 40.h : 26.h,
                width: width >= 600 ? 40.h : 26.h,),
              SizedBox(
                width: 15.w,
              ),
              Text(
                title,
                style: kTextStyleNotoRegular.copyWith(
                    fontWeight: FontWeight.w500, fontSize: 20.sp),
              ),
              SizedBox(
                width: 15.w,
              ),
              SvgPicture.asset("assets/icons/swastik.svg",height: width >= 600 ? 40.h : 26.h,
                width: width >= 600 ? 40.h : 26.h,),
            ],
          ),
        ],
      ),
    );
  }
}
