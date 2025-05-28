import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/controllers/shlokas_listing/shlokas_listing_controller.dart';
import 'package:yatharthageeta/utils/utils.dart';

class LanguageFilterShlok extends StatelessWidget {
  final RxInt tabIndex;
  final List<Map> languages;

  const LanguageFilterShlok(
      {super.key, required this.tabIndex, required this.languages});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
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
                    margin: EdgeInsets.only(bottom: 16.h, left: 30.w),
                    alignment: Alignment.center,
                    child: Text(
                      "Language".tr,
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
                          languages[index]['title'],
                          textAlign: TextAlign.center,
                          style: kTextStylePoppinsMedium.copyWith(
                              fontSize: 16.sp,
                              color: languages[index]["title"] ==
                                      languages[index]["groupValue"].value
                                  ? kColorPrimary
                                  : kColorFont),
                        )),
                    onTap: () async {
                      Utils().showLoader();
                      languages[index]["groupValue"].value =
                          languages[index]["title"];
                      final controller = Get.find<ShlokasListingController>();
                      controller.groupValueId.value = languages[index]["id"];
                      await controller.fetchChapters(
                          langaugeId: languages[index]["id"].toString());
                      if (controller.shlokaChapterModel.value.success == 1) {
                        if (controller
                                .shlokaChapterModel.value.data!.result!.length >
                            0) {
                          await controller.fetchAllVerses(
                              chapterId: controller.shlokaChapterModel.value
                                  .data!.result!.first.chapterId
                                  .toString(),
                              langaugeId: languages[index]["id"].toString());
                        } else {
                          log("Here");
                          controller.shlokaChapterModel.value.data!.result!
                              .clear();
                          controller.verseList.clear();
                        }
                      }
                      Get.back();
                      controller.initializeChapters();
                      controller.initializeVerse();
                      if (controller.chaptersList.isEmpty) {
                        controller.verseList.clear();
                      }
                      Get.back();
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
