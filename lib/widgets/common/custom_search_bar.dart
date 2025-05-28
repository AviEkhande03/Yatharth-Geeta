import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
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
      this.prefixIcon,
      this.suffixIcon,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.textInputType = TextInputType.text,
      this.prefixIconConstraints,
      this.contentPadding,
      this.radius = 16.0,
      this.maxLines,
      this.initialValue,
      this.textAlignVertical,
      required this.filterAvailable,
      this.filterBottomSheet});

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool filterAvailable;
  final Widget? filterBottomSheet;
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
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsets? contentPadding;
  final double radius;
  final int? maxLines;
  final String? initialValue;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      textAlignVertical: textAlignVertical,
      onSaved: onSaved,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        contentPadding: contentPadding,
        errorStyle: errorStyle,
        errorMaxLines: errorMaxLines,
        prefixIconConstraints: prefixIconConstraints,
        prefixIcon: SizedBox(
          width: 30.w,
          height: 30.h,
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/search.svg",
            ),
          ),
        ),
        suffixIcon: SizedBox(
          width: 70.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: filterAvailable,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return filterBottomSheet!;
                      },
                      // filterBottomSheet!,
                      isScrollControlled: true,
                      useSafeArea: false,

                      // backgroundColor: Colors.red,
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/icons/filter.svg",
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              SvgPicture.asset(
                "assets/icons/mic.svg",
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
            borderSide: const BorderSide(color: Color(0xffC5C4C2), width: 1.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          borderSide: const BorderSide(color: Color(0xffC5C4C2), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          borderSide: const BorderSide(color: Color(0xffC5C4C2), width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          borderSide: const BorderSide(color: Color(0xffC5C4C2), width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
        ),
      ),
    );
  }
}
