import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/controllers/shlokas_listing/shlokas_listing_controller.dart';
import 'package:yatharthageeta/utils/utils.dart';

class VerseFilter extends StatelessWidget {
  final RxInt tabIndex;
  final List languages;

  const VerseFilter({
    super.key,
    required this.tabIndex,
    required this.languages,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 490.h,
      decoration: BoxDecoration(
        color: kColorWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 24.h, right: 34.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h, left: 40.w),
                    alignment: Alignment.center,
                    child: Text(
                      "Verses".tr,
                      style: kTextStylePoppinsBold.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(
                    "assets/icons/cross.svg",
                    height: 24.w,
                    width: 24.w,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    visualDensity: VisualDensity(vertical: -4),
                    title: Obx(() => Text(
                          "${"Verse".tr}  ${languages[index]['title']}",
                          textAlign: TextAlign.center,
                          style: languages[index]["title"] ==
                                  languages[index]["groupValue"].value
                              ? kTextStylePoppinsSemiBold.copyWith(
                                  fontSize: 16.sp, color: kColorPrimary)
                              : kTextStylePoppinsRegular.copyWith(
                                  fontSize: 16.sp, color: kColorFont),
                        )),
                    onTap: () async {
                      final controller = Get.find<ShlokasListingController>();
                      var playerController = Get.find<PlayerController>();
                      languages[index]["groupValue"].value =
                          languages[index]["title"];
                      controller.verseGroupValue.value =
                          languages[index]["value"].value;
                      log("Verse Group Value Dropdown ${controller.verseGroupValue}");
                      Utils().showLoader();

                      // int backForth =
                      //     playerController.audioPlayer.value.currentIndex! -
                      //         controller.verseList.indexWhere((verse) =>
                      //             verse["value"] == controller.verseGroupValue);
                      // while (backForth != 0) {
                      //   if (backForth > 0) {
                      //     await playerController.audioPlayer.value
                      //         .seekToPrevious();
                      //     backForth--;
                      //   } else {
                      //     await playerController.audioPlayer.value.seekToNext();
                      //     backForth++;
                      //   }
                      // }
                      if (controller.startupService.startupData.first.data!
                          .result!.shlokas_language_ids!
                          .contains(controller.groupValueId.value)) {
                        playerController.chapterName.value =
                            "${"Verse".tr} ${languages[index]['title']}";
                        await playerController.audioPlayer.value.seek(
                            Duration.zero,
                            index: controller.verseList.indexWhere((verse) =>
                                verse["value"] == controller.verseGroupValue));
                      }
                      Get.back();
                      Get.back();
                      await controller.scrollController.animateTo(0,
                          duration: Duration(
                            seconds: 1,
                          ),
                          curve: Curves.linear);
                    },
                  );
                },
                itemCount: languages.length),
          )
        ],
      ),
    );
  }
}
