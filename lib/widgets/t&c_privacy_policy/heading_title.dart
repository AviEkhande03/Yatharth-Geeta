import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';
import '../common/text_poppins.dart';

import '../../const/font_size/font_size.dart';

class TCAndPrivacyPolicyHeading extends StatelessWidget {
  const TCAndPrivacyPolicyHeading({super.key, required this.name});

  final String name;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      color: kColorWhite,
      height: 130.h,
      child: Stack(
        children: [
          Container(
            height: 103.h,
            color: kColorPrimary,
          ),
          Positioned(
            top: 10.h,
            child: Container(
              width: width,
              alignment: Alignment.center,
              child: Container(
                height: 120.h,
                width: 130.h,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/icons/t&c_and_privacy_policy_bg.png'),
                        fit: BoxFit.fill)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: TextPoppins(
                      text: name,
                      fontSize: FontSize.fontSize16.sp,
                      fontWeight: FontWeight.w700,
                      color: kColorWhite,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
