import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';

class InputFormField extends StatelessWidget {
  const InputFormField(
      {super.key,
      required this.hintText,
      required this.leftIconPath,
      this.suffixIcon,
      this.obscureText = false,
      this.enabled = true,
      this.maxLength,
      this.validator,
      this.controller,
      this.keyBoardType = TextInputType.name,
      this.initialValue,
      this.prefixIconBoxConstraints,
      this.prefixIcon});
  final String hintText;
  final String leftIconPath;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final Widget? suffixIcon;
  final String? initialValue;
  final TextInputType keyBoardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconBoxConstraints;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Padding(
          padding: width >= 600
              ? EdgeInsets.only(left: 21.w)
              : EdgeInsets.only(left: 28.w),
          child: TextFormField(
            initialValue: initialValue,
            validator: validator,
            obscureText: obscureText,
            maxLength: maxLength,
            controller: controller,
            cursorWidth: 1.w,
            enabled: enabled,
            keyboardType: keyBoardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  top: 18.h, bottom: 18.h, left: 28.w, right: 10.w),
              isDense: true,
              filled: true,
              counterText: "",
              fillColor: kColorInputFormField,
              hintText: hintText,
              hintStyle: TextStyle(color: kColorFont.withOpacity(0.5)),
              prefixIcon: prefixIcon,
              /*isMobileNumber == true
                  ? TextPoppins(
                      text: '+91 | ',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: kColorFont.withOpacity(0.5),
                    )
                  : SizedBox(),*/
              prefixIconConstraints: prefixIconBoxConstraints,
              suffixIcon: suffixIcon,
              suffixIconConstraints:
                  BoxConstraints(minWidth: 50.h, minHeight: 30.h),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                      width: 1.5.w, color: kColorPrimary.withOpacity(0.25))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                      width: 1.5.w, color: kColorPrimary.withOpacity(0.25))),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                      width: 1.5.w, color: kColorPrimary.withOpacity(0.25))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                      width: 1.5.w, color: kColorPrimary.withOpacity(0.25))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                      width: 1.5.w, color: kColorPrimary.withOpacity(0.25))),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                      width: 1.5.w, color: kColorPrimary.withOpacity(0.25))),
            ),
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontWeight: FontWeight.w400,
              fontSize: FontSize.hintText.sp,
            ),
          ),
        ),
        Positioned(
            top: 1.h,
            bottom: 1.h,
            child: CircleAvatar(
              radius: 26.r,
              backgroundColor: kColorSecondary,
              child: SizedBox(
                width: 26.w,
                height: 26.w,
                child: SvgPicture.asset(
                  leftIconPath,
                  color: kColorWhite,
                ),
              ),
            ))
      ],
    );
  }
}
