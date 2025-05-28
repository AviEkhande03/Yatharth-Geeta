import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../common/text_poppins.dart';

class ProfileElement extends StatelessWidget {
  const ProfileElement(
      {super.key,
      required this.itemIcon,
      required this.itemName,
      required this.onTap,
      this.iconColor = kColorPrimary,
      this.textColor = kColorFont,
      this.isToggleEnabled = false,
      this.onToggleChanged,
      this.isToggleOn = false});

  final String itemIcon;
  final String itemName;
  final Color iconColor;
  final Color textColor;
  final bool isToggleEnabled;
  final VoidCallback onTap;
  final void Function(bool)? onToggleChanged;
  final bool? isToggleOn;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.only(top: 11.0.h, left: 8.w, bottom: 11.0.h, right: 8.w),
        //color: Colors.red,
        child: Stack(alignment: AlignmentDirectional.centerEnd, children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                SizedBox(
                  width: 24.h,
                  height: 24.h,
                  child: SvgPicture.asset(
                    itemIcon,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: 16.w),
                TextPoppins(
                  text: itemName,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.profileElements.sp,
                  color: textColor,
                ),
              ],
            ),
          ),
          isToggleEnabled == true
              ? Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 19.h,
                    width: 30.w,
                    // color: Colors.green,
                    child: FlutterSwitch(
                        toggleSize: 10.h,
                        borderRadius: 20.r,
                        inactiveColor: kColorWhite,
                        inactiveSwitchBorder: Border.all(
                          color: kColorFont.withOpacity(0.5),
                          // width: 6.0,
                        ),
                        inactiveToggleColor: kColorFont.withOpacity(0.5),
                        activeColor: kColorPrimary.withOpacity(0.15),
                        activeSwitchBorder: Border.all(color: kColorPrimary),
                        activeToggleColor: kColorPrimary,
                        padding: 2.h,
                        value: isToggleOn!,
                        onToggle: onToggleChanged!),
                  ),
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
