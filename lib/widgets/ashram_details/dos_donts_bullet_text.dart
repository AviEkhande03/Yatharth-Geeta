import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';

class DosDontsBulletText extends StatelessWidget {
  const DosDontsBulletText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      // color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 9.h),
            width: 3.h,
            height: 3.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: kColorFontOpacity75),
          ),
          SizedBox(
            width: screenSize.width * 0.01315,
          ),
          Flexible(
            child: Text(
              ' $text',
              style: kTextStylePoppinsRegular.copyWith(
                  color: kColorFontOpacity75, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
