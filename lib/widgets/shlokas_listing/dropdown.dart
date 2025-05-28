import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';

class DropDown extends StatelessWidget {
  const DropDown(
      {super.key,
      required this.text,
      required this.color,
      required this.textSize});
  final String text;
  final Color color;
  final int textSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xffFFFCBE),
        //     Color(0xffFFEECB),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: kColorPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                // textAlign: TextAlign.center,
                style: kTextStylePoppinsMedium.copyWith(
                    color: color,
                    fontSize: textSize.sp,
                    fontWeight: FontWeight.w500)),
          ),
          SvgPicture.asset(
            'assets/icons/arrow-down.svg',
            color: color,
          ),
        ],
      ),
    );
  }
}
