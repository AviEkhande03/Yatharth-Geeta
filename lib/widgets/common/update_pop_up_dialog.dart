import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import '../../routes/app_route.dart';
import 'text_poppins.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';

class PopUpDialog extends StatelessWidget {
  const PopUpDialog(
      {super.key,
      required this.asssetIcon,
      required this.title,
      this.titleColor = kColorFont,
      required this.contentText,
      this.isLanguagePopUp = false});
  final String asssetIcon;
  final String title;
  final Color titleColor;
  final String contentText;
  final bool isLanguagePopUp;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isLanguagePopUp == true) {
          Get.offAllNamed(AppRoute.bottomAppBarScreen);
        }
        return Future(() => true);
      },
      child: Container(
          // width: MediaQuery.of(context).size.width * 0.90,
          // padding:
          //     EdgeInsets.only(top: 24.h, bottom: 36.h, left: 24.w, right: 24.w),
          decoration: BoxDecoration(
              color: kColorWhite,
              boxShadow: [
                BoxShadow(
                    color: kGreenPopUpColor,
                    spreadRadius: -0.5.h,
                    offset: const Offset(0, -2))
              ],
              borderRadius: BorderRadius.circular(16.r)),
          child: Stack(
            children: [
              Container(
                height: 24.h,
                margin: EdgeInsets.only(top: 10.h, right: 10.w),
                // color: Colors.blueAccent,
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      if (isLanguagePopUp == true) {
                        Get.offAllNamed(AppRoute.bottomAppBarScreen);
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/icons/cross.svg',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 36.h, left: 24.w, right: 24.w, bottom: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            asssetIcon,
                            height: 56.w,
                            width: 56.w,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: TextPoppins(
                                text: title.tr,
                                color: titleColor,
                                overflow: TextOverflow.visible,
                                fontSize: FontSize.popUpTitle.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                        child: Wrap(
                          children: [
                            TextPoppins(
                              text: contentText.tr,
                              fontWeight: FontWeight.w400,
                              fontSize: FontSize.popUpText.sp,
                              color: kColorFont.withOpacity(0.75),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
