import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';
import 'text_poppins.dart';

import '../../const/font_size/font_size.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.btnText,
      this.btnColor = kColorPrimary,
      this.textColor = kColorWhite,
      this.borderColor = kColorPrimary,
      this.isStretchable = true});
  final String btnText;
  final Color btnColor;
  final Color borderColor;
  final Color textColor;
  //Field added to check whether the button will be completely stretchable or not
  final bool isStretchable;

  @override
  Widget build(BuildContext context) {
    return Container(
      //if isStretchable then no horizontal padding else both horizontal and vertical padding
      padding: isStretchable
          ? EdgeInsets.symmetric(vertical: 16.h)
          : EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
      decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(color: borderColor, width: 1.w)),
      child: isStretchable
          ? Center(
              child: TextPoppins(
                text: btnText,
                color: textColor,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
                fontSize: FontSize.buttonText.sp,
              ),
            )
          : TextPoppins(
              text: btnText,
              color: textColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
              fontSize: FontSize.buttonText.sp,
            ),
    );
  }
}
