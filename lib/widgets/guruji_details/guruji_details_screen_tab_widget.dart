import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/guruji_details/guruji_details_controller.dart';

class GurujiDetailsScreenTabWidget extends StatelessWidget {
  GurujiDetailsScreenTabWidget({
    this.title = '',
    this.iconImgUrl = '',
    super.key,
    required this.controller,
  });

  final String title;
  final String iconImgUrl;
  final GurujiDetailsController controller;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        color: kColorTransparent,
        child: Stack(
          children: [
            Container(
              width: screenSize.width / 2,
              height: 70.h,
              // color: Colors.pink,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24.h,
                    width: 24.h,
                    child: Image.asset(
                      iconImgUrl,
                      color: controller.selectedAshramTab.value.tr == title.tr
                          ? kColorPrimary
                          : kColorFont,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    title,
                    style: controller.selectedAshramTab.value.tr == title.tr
                        ? kTextStylePoppinsMedium.copyWith(
                            fontSize: FontSize.gurujiTabActive.sp,
                            color: kColorPrimary,
                          )
                        : kTextStylePoppinsRegular.copyWith(
                            fontSize: FontSize.gurujiTabInactive.sp,
                            color: kColorFont,
                          ),
                  )
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: screenSize.width,
                  // height: 64.h,
                  color: kColorTransparent,
                  child: controller.selectedAshramTab.value.tr == title.tr
                      ? controller.selectedAshramTab.value.tr == 'About'.tr
                          ? Image.asset('assets/images/status_bar_curved.png')
                          : Image.asset(
                              'assets/images/status_bar_curved_right.png')
                      : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
