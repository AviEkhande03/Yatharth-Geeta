import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/shlokas_listing/shlokas_listing_controller.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import 'text_poppins.dart';
import 'text_rosario.dart';

class LanguageFilter extends StatelessWidget {
  const LanguageFilter(
      {Key? key, required this.tabIndex, required this.languages})
      : super(key: key);
  final RxInt tabIndex;
  final List<Map> languages;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Container(
        decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        height: 380.h,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 36.h, left: 28.w, right: 28.w),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                    child: TextRosario(
                      text: "Language".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: FontSize.searchFilterHeading.sp,
                    ),
                  )),
                  InkWell(
                      onTap: () => Get.back(),
                      child: SizedBox(
                          child: SvgPicture.asset("assets/icons/cross.svg")))
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(child: languageFilter(languages)),
          ],
        ),
      ),
    );
  }

  Widget languageFilter(languages) {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Obx(
            () => RadioListTile(
              visualDensity: const VisualDensity(vertical: -4),
              groupValue: languages[index]["groupValue"].value,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: kColorPrimary,
              title: TextPoppins(
                text: languages[index]["title"],
                textAlign: TextAlign.center,
                color: languages[index]["value"] ==
                        languages[index]["groupValue"].value
                    ? kColorPrimary
                    : kColorFont,
                fontSize: FontSize.searchFilterContent.sp,
                fontWeight: FontWeight.w500,
              ),
              value: languages[index]["value"],
              onChanged: (val) async {
                Get.back();
                Get.find<ShlokasListingController>().clearShlokasListsData();
                languages[index]["groupValue"].value = val.toString();
                Map<String, String> body = {};
                Utils().showLoader();
                var id = languages.fold(
                    0,
                    (previousValue, element) =>
                        element["value"] == element["groupValue"].value
                            ? element["id"]
                            : 31);
                for (var element in languages) {
                  if (element["value"] == element["groupValue"].value) {
                    // body["chapter_number"] =
                    //     Get.find<ShlokasListingController>()
                    //         .selectedChapter
                    //         .value
                    //         .toString();
                    // body["language_id"] = element["id"].toString();
                    Get.find<ShlokasListingController>().groupValueId.value =
                        element["id"];
                    // body["order_by"] = element["order_by"];
                    // body["sort_by"] = element["sort_by"];
                  }
                }
                await Get.find<ShlokasListingController>()
                    .fetchShlokasChaptersList(
                        langaugeId: Get.find<ShlokasListingController>()
                            .groupValueId
                            .value
                            .toString());
                await Get.find<ShlokasListingController>().fetchShlokasListing(
                    langaugeId: Get.find<ShlokasListingController>()
                        .groupValueId
                        .value
                        .toString(),
                    chapterNumber: Get.find<ShlokasListingController>()
                            .shlokasChaptersList
                            .isNotEmpty
                        ? Get.find<ShlokasListingController>()
                            .shlokasChaptersList[0]
                            .toString()
                        : '1',
                    token: Get.find<BottomAppBarServices>().token.value);
                // print(body);
                Get.back();
              },
            ),
          );
        },
        itemCount: languages.length,
      ),
    );
  }
}
