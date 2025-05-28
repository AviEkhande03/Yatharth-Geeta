import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';

class CustomTextfieldWidget extends StatelessWidget {
  const CustomTextfieldWidget(
      {super.key,
      this.controller,
      this.onChanged,
      this.validator,
      this.onSaved,
      this.labelText,
      this.hintText,
      this.style,
      this.labelStyle,
      this.hintStyle,
      this.errorStyle,
      this.errorMaxLines,
      this.isPassword = false,
      this.prefixIcon,
      this.suffixIcon,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.textInputType = TextInputType.text,
      this.prefixIconConstraints,
      this.contentPadding =
          const EdgeInsets.only(left: 16, top: 12, bottom: 12),
      this.radius = 8.0,
      this.maxLines,
      this.initialValue,
      this.textAlignVertical});

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final String? labelText;
  final String? hintText;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final int? errorMaxLines;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsets contentPadding;
  final double radius;
  final int? maxLines;
  final String? initialValue;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 42.h,
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        onChanged: onChanged,
        onSaved: onSaved,
        onEditingComplete: onEditingComplete,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        style: style,
        obscureText: isPassword,
        cursorWidth: 1.w,
        // expands: true,
        keyboardType: textInputType,
        maxLines: maxLines,
        textAlignVertical: textAlignVertical,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle,
          isDense: true,
          errorStyle: errorStyle,
          errorMaxLines: errorMaxLines,
          filled: true,
          fillColor: const Color(0xffFCFCFC),
          hintText: hintText,
          prefixIconConstraints: prefixIconConstraints,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: contentPadding,
          hintStyle: hintStyle,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide:
                  BorderSide(color: kColorPrimaryWithOpacity25, width: 1.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide:
                BorderSide(color: kColorPrimaryWithOpacity25, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide:
                BorderSide(color: kColorPrimaryWithOpacity25, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide:
                BorderSide(color: kColorPrimaryWithOpacity25, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide:
                BorderSide(color: kColorPrimaryWithOpacity25, width: 1.0),
          ),
        ),
      ),
    );
  }
}
