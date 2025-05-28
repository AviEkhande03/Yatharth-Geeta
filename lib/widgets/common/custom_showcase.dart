import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../const/text_styles/text_styles.dart';

class CustomShowcase extends StatelessWidget {
  const CustomShowcase(
      {Key? key,
      required this.child,
      required this.desc,
      required this.showKey,
      required this.title})
      : super(key: key);
  final Widget child;
  final String desc;
  final GlobalKey showKey;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Showcase(
      description: desc,
      key: showKey,
      // title: title,
      tooltipBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r)),
      showArrow: false,
      targetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      // targetBorderRadius: BorderRadius.only(topLeft: Radius.circular(16.r)),
      // targetShapeBorder: BeveledRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   topLeft: Radius.circular(16.r),
      // )),
      // showArrow: true,
      tooltipPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 15.w),
      descTextStyle:
          kTextStyleInterSemiBold.copyWith(fontWeight: FontWeight.w500),
      titleTextStyle: kTextStyleRosarioRegular.copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w600),
      child: child,
    );
  }
}
