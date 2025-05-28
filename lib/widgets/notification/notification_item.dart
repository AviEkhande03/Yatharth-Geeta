import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../const/colors/colors.dart';

import '../../const/font_size/font_size.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.iconPath,
    required this.titleText,
    required this.subText,
  });
  final String iconPath;
  final String titleText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorWhite,
      child: Padding(
        padding:
            EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h, bottom: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20.w,
              backgroundColor: kColorPrimary,
              child: SvgPicture.asset(iconPath),
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: RichText(
                  textAlign: TextAlign.start,
                  textWidthBasis: TextWidthBasis.parent,
                  text: TextSpan(
                      text: titleText,
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: FontSize.notificationTextSize.sp,
                          fontWeight: FontWeight.w600,
                          color: kColorFont),
                      children: <InlineSpan>[
                        TextSpan(
                          text: subText,
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: FontSize.notificationTextSize.sp,
                            fontWeight: FontWeight.w400,
                            color: kColorFont,
                          ),
                        )
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
