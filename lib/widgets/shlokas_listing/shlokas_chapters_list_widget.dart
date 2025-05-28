import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/shlokas_listing/shlokas_listing_controller.dart';
import '../../utils/utils.dart';

class ShlokasChaptersListWidget extends StatelessWidget {
  const ShlokasChaptersListWidget({
    this.sholokasChaptersList = const [],
    super.key,
  });

  final dynamic sholokasChaptersList;

  @override
  Widget build(BuildContext context) {
    final shlokasListingController = Get.find<ShlokasListingController>();
    debugPrint("sholokasChaptersList in build:$sholokasChaptersList");
    return sholokasChaptersList != []
        ? ListView.separated(
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  shlokasListingController.clearShlokasListsData();
                  log('Selected chapter = ${sholokasChaptersList[index].toString()}');

                  shlokasListingController.selectedChapter.value =
                      sholokasChaptersList[index].toString();

                  //Clearing the shlokas listing
                  shlokasListingController.shlokasListing.clear();

                  Utils().showLoader();

                  await shlokasListingController.fetchShlokasListing(
                      langaugeId: shlokasListingController.groupValueId.value
                          .toString(),
                      chapterNumber: shlokasListingController
                          .selectedChapter.value
                          .toString());

                  Get.back();

                  // shlokasListingController
                  //     .fetchShlokasList(sholokasChaptersList[index]);

                  log(shlokasListingController.shlokasChaptersList.toString());
                },
                child: Obx(
                  () => Container(
                    alignment: Alignment.center,
                    // height: 34.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.h),
                      color: shlokasListingController.selectedChapter.value !=
                              sholokasChaptersList[index].toString()
                          ? kColorPrimary.withOpacity(0.15)
                          : kColorPrimary,
                    ),
                    child: Text(
                      sholokasChaptersList[index] == "" ||
                              sholokasChaptersList[index] < 1 ||
                              sholokasChaptersList[index] > 999
                          ? "Chapter"
                          : "${"Chapter".tr} ${sholokasChaptersList[index].toString()}",
                      style: kTextStylePoppinsRegular.copyWith(
                        color: shlokasListingController.selectedChapter.value !=
                                sholokasChaptersList[index].toString()
                            ? kColorPrimary
                            : kColorWhite,
                        fontSize: FontSize.shlokasChapterButton.sp,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 16.w,
              );
            },
            itemCount: sholokasChaptersList.length,
          )
        : const SizedBox();
  }
}
