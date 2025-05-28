import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../services/language/language_service.dart';
import '../common/text_poppins.dart';

class LanguageCardWidget extends StatelessWidget {
  LanguageCardWidget({
    this.isDefault = false,
    this.nativeText = '',
    this.title = '',
    this.bgImgUrl = '',
    this.langaugeCode = '',
    this.selectedLocale = '',
    super.key,
  });

  final String bgImgUrl;
  final String title;
  final String nativeText;
  final String langaugeCode;
  final String selectedLocale;
  final bool isDefault;

  final langaugeService = Get.find<LangaugeService>();

  @override
  Widget build(BuildContext context) {
    debugPrint("languageCode:$langaugeCode");
    debugPrint("Selected Locale:$selectedLocale");
    return GestureDetector(
      onTap: () {
        langaugeService.selectedLocale.value = langaugeCode;
      },
      child: Container(
        height: 125.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          image: DecorationImage(image: AssetImage(bgImgUrl), fit: BoxFit.fill),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: title == 'English'
                    ? Row(
                        children: [
                          TextPoppins(
                            text: title,
                            fontSize: FontSize.languageText.sp,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                            color: kColorWhite2,
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextPoppins(
                            text: nativeText,
                            fontSize: FontSize.languageText.sp,
                            fontWeight: FontWeight.w600,
                            color: kColorWhite2,
                          ),
                          TextPoppins(
                            text: title,
                            fontSize: FontSize.languageText.sp,
                            fontWeight: FontWeight.w600,
                            color: kColorWhite2,
                          )
                        ],
                      ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: langaugeCode == selectedLocale
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/images/language/check_circle.svg',
                        width: 24.h,
                        height: 24.h,
                      ),
                    )
                  : const SizedBox(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: isDefault
                  ? Container(
                      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.h),
                          color: kColorWhite.withOpacity(0.15)),
                      child: TextPoppins(
                        text: 'Default',
                        color: kColorWhite2,
                        fontSize: FontSize.authScreenFontSize12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
