import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_listing/audio_listing_controller.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../controllers/video_listing/video_listing_controller.dart';
import '../../utils/utils.dart';
import 'text_poppins.dart';
import 'text_rosario.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    Key? key,
    required this.tabIndex,
    required this.languages,
    required this.authors,
    required this.sortList,
    required this.screen,
    required this.onTap,
  }) : super(key: key);
  final RxInt tabIndex;
  final List<Map> languages;
  final List authors;
  final String screen;
  final List sortList;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    var collectionId = "";
    var collectionType = "";
    var isCollection = false;
    var isMultiCollection = false;
    if (screen == "audio") {
      isCollection =
          Get.find<AudioListingController>().prevScreen.value == "collection" ||
              Get.find<AudioListingController>().prevScreen.value ==
                  "homeCollection";

      isMultiCollection = Get.find<AudioListingController>().prevScreen.value ==
          "homeCollectionMultipleType";

      if (isCollection) {
        collectionId = Get.find<AudioListingController>().collectionId.value;
        collectionType =
            Get.find<AudioListingController>().collectionType.value;
      }
      if (isMultiCollection) {
        collectionId = Get.find<AudioListingController>().collectionId.value;
        collectionType =
            Get.find<AudioListingController>().collectionType.value;
      }
    } else {
      isCollection =
          Get.find<VideoListingController>().prevScreen.value == "collection" ||
              Get.find<VideoListingController>().prevScreen.value ==
                  "homeCollection";
      isMultiCollection = Get.find<VideoListingController>().prevScreen.value ==
          "homeCollectionMultipleType";
      if (isCollection) {
        collectionId = Get.find<VideoListingController>().collectionId.value;
      }
      if (isMultiCollection) {
        collectionId = Get.find<VideoListingController>().collectionId.value;
        collectionType =
            Get.find<VideoListingController>().collectionType.value;
      }
    }
    return DefaultTabController(
      length: 3,
      child: Container(
        // margin: EdgeInsets.all(100),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        height: 450.h,
        width: width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 14.h, left: 28.w, right: 28.w),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                    child: TextRosario(
                      text: "Filter".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: FontSize.searchFilterHeading.sp,
                    ),
                  )),
                  InkWell(
                      onTap: () => Get.back(),
                      child: SvgPicture.asset("assets/icons/cross.svg"))
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // direction: Axis.horizontal,
                // controller: tabController,
                // labelColor: kColorPrimary,
                // // indicatorColor: kColorSecondary,
                // // indicator: UnderlineTabIndicator(
                // //   borderSide: BorderSide(color: secondaryColor, width: 1.5),
                // // ),
                // indicator: BoxDecoration(
                //     image: DecorationImage(
                //         alignment: Alignment.bottomCenter,
                //         image: AssetImage("assets/icons/indicator.png"))),
                // indicatorSize: TabBarIndicatorSize.tab,
                children: [
                  InkWell(
                    onTap: () => tabIndex.value = 0,
                    child: Obx(
                      () => Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      vertical: BorderSide(
                                          color: kColorBlackWithOpacity25,
                                          width: 0.5))),
                              height: 50.h,
                              width: width * 0.34,
                              child: Center(
                                child: Text(
                                  "Language".tr,
                                  style: TextStyle(
                                      fontSize: FontSize
                                          .searchFilterSectionHeading.sp,
                                      color: tabIndex.value == 0
                                          ? kColorPrimary
                                          : kColorFont,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins"),
                                ),
                              )),
                          Visibility(
                              visible: tabIndex.value == 0,
                              child: Image.asset(
                                "assets/icons/indicator.png",
                                fit: BoxFit.fitHeight,
                                width: width * 0.34,
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => tabIndex.value = 1,
                    child: Obx(
                      () => Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      vertical: BorderSide(
                                          color: kColorBlackWithOpacity25,
                                          width: 0.5))),
                              height: 50.h,
                              width: width * 0.33,
                              child: Center(
                                child: Text(
                                  "Author".tr,
                                  style: TextStyle(
                                      fontSize: FontSize
                                          .searchFilterSectionHeading.sp,
                                      color: tabIndex.value == 1
                                          ? kColorPrimary
                                          : kColorFont,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins"),
                                ),
                              )),
                          Visibility(
                              visible: tabIndex.value == 1,
                              child: Image.asset(
                                "assets/icons/indicator.png",
                                fit: BoxFit.fitHeight,
                                width: width * 0.33,
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => tabIndex.value = 2,
                    child: Container(
                      width: width * 0.33,
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  color: kColorBlackWithOpacity25,
                                  width: 0.5))),
                      child: Obx(
                        () => Column(
                          children: [
                            SizedBox(
                                height: 50.h,
                                width: width * 0.33,
                                child: Center(
                                  child: Text(
                                    "Sort".tr,
                                    style: TextStyle(
                                        fontSize: FontSize
                                            .searchFilterSectionHeading.sp,
                                        color: tabIndex.value == 2
                                            ? kColorPrimary
                                            : kColorFont,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins"),
                                  ),
                                )),
                            Visibility(
                                visible: tabIndex.value == 2,
                                child: Image.asset(
                                  "assets/icons/indicator.png",
                                  fit: BoxFit.fitHeight,
                                  width: width * 0.33,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Expanded(
                child: tabIndex.value == 0
                    ? languageFilter(languages)
                    : tabIndex.value == 1
                        ? authorFilter(authors)
                        : sortFilter(sortList),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 24.w, right: 24.w, top: 24.h, bottom: 24.h),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      Get.back();
                      Utils().showLoader();
                      Map<String, String> body = {};
                      if (screen == 'audio') {
                        Get.find<AudioListingController>().clearFilters();
                        Get.find<AudioListingController>().clearAudiosList();
                        log("In Audio" + body.toString());
                      } else if (screen == 'video') {
                        Get.find<VideoListingController>().clearFilters();
                        Get.find<VideoListingController>().clearVideosList();
                        log("In Video" + body.toString());
                      } else {
                        Get.find<ExploreController>().clearFilters();
                        Get.find<ExploreController>().clearSatsangList();
                        log("In Satsang" + body.toString());
                      }

                      log(Get.find<AudioListingController>()
                          .returnFilterBody()
                          .toString());
                      if (isCollection) {
                        body["id"] = collectionId;
                      } else if (isMultiCollection) {
                        body["id"] = collectionId;
                        body["type"] = collectionType;
                      }

                      print("this is the audio body : $body");
                      await onTap(body: body, token: '');
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kColorWhite,
                          border: Border.all(color: kColorPrimary, width: 1.sp),
                          borderRadius: BorderRadius.circular(200.r)),
                      child: Text(
                        "Reset".tr,
                        style: kTextStylePoppinsRegular.copyWith(
                            color: kColorPrimary,
                            fontSize: FontSize.searchFilterButtons.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 24.w,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      Get.back();
                      Utils().showLoader();
                      Map<String, String> body = {};
                      if (screen == 'audio') {
                        body = Get.find<AudioListingController>()
                            .returnFilterBody();
                        Get.find<AudioListingController>().clearAudiosList();
                        log("In Audio" + body.toString());
                      } else if (screen == 'video') {
                        body = Get.find<VideoListingController>()
                            .returnFilterBody();
                        Get.find<VideoListingController>().clearVideosList();
                        log("In Video" + body.toString());
                      } else {
                        body = Get.find<ExploreController>().returnFilterBody();
                        Get.find<ExploreController>().clearSatsangList();
                        log("In Satsang" + body.toString());
                      }

                      log(Get.find<AudioListingController>()
                          .returnFilterBody()
                          .toString());
                      if (isCollection) {
                        body["id"] = collectionId;
                      } else if (isMultiCollection) {
                        body["id"] = collectionId;
                        body["type"] = collectionType;
                      }

                      print("this is the audio body : $body");
                      await onTap(body: body, token: '');
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kColorPrimary,
                          border: Border.all(color: kColorPrimary, width: 1.sp),
                          borderRadius: BorderRadius.circular(200.r)),
                      child: Text(
                        "Apply".tr,
                        style: kTextStylePoppinsRegular.copyWith(
                            color: kColorWhite,
                            fontSize: FontSize.searchFilterButtons.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget languageFilter(languages) {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Obx(
            () => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: kColorPrimary,
                // contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(vertical: -4),
                title: TextPoppins(
                  text: languages[index]["title"],
                  color: languages[index]["value"].value
                      ? kColorPrimary
                      : kColorFont,
                  fontSize: FontSize.searchFilterContent.sp,
                  fontWeight: FontWeight.w500,
                ),
                value: languages[index]["value"].value,
                onChanged: (val) {
                  languages[index]["value"].value = val!;
                }),
          );
        },
      ),
    );
  }

  Widget authorFilter(authors) {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        itemCount: authors.length,
        itemBuilder: (context, index) {
          return Obx(
            () => CheckboxListTile(
                visualDensity: const VisualDensity(vertical: -4),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: kColorPrimary,
                title: TextPoppins(
                  text: authors[index]["title"],
                  color: authors[index]["value"].value
                      ? kColorPrimary
                      : kColorFont,
                  fontSize: FontSize.searchFilterContent.sp,
                  fontWeight: FontWeight.w500,
                ),
                value: authors[index]["value"].value,
                onChanged: (val) {
                  authors[index]["value"].value = val!;
                }),
          );
        },
      ),
    );
  }

  Widget sortFilter(sortList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Obx(
          () => RadioListTile(
              visualDensity: const VisualDensity(vertical: -4),
              groupValue: sortList[index]["groupValue"].value,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: kColorPrimary,
              title: TextPoppins(
                text: sortList[index]["title"],
                color: sortList[index]["value"] ==
                        sortList[index]["groupValue"].value
                    ? kColorPrimary
                    : kColorFont,
                fontSize: FontSize.searchFilterContent.sp,
                fontWeight: FontWeight.w500,
              ),
              value: sortList[index]["value"],
              onChanged: (val) {
                sortList[index]["groupValue"].value = val;
              }),
        );
      },
      itemCount: sortList.length,
    );
  }
}
