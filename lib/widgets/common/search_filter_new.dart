import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/const/font_size/font_size.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import 'package:yatharthageeta/controllers/audio_listing/audio_listing_controller.dart';
import 'package:yatharthageeta/controllers/ebooks_listing/ebooks_listing_controller.dart';
import 'package:yatharthageeta/controllers/explore/explore_controller.dart';
import 'package:yatharthageeta/controllers/video_listing/video_listing_controller.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import 'package:yatharthageeta/utils/utils.dart';
import 'package:yatharthageeta/widgets/common/text_poppins.dart';
import 'package:yatharthageeta/widgets/common/text_rosario.dart';

class SearchFilterNew extends StatelessWidget {
  const SearchFilterNew({super.key});

  @override
  Widget build(BuildContext context) {
    // getting all the display lists in argument using dependency injection
    var data = Get.arguments as Map<String, dynamic>;
    // variable for maintaining the tabs
    var tabIndex = 0.obs;
    // if the screen is invoked from home collections we need id and type of collection
    var collectionId = "";
    var collectionType = "";
    // initializing the filters
    var languages = data['language'] as List<Map<dynamic, dynamic>>;
    var authors = data['authors'] as List<Map<dynamic, dynamic>>;
    var sortList = data['sortList'] as List<dynamic>;
    var typeList;
    // initializing the onTap function
    var onTap = data['onTap'] as Function;
    // maintaining the boolean values for collections
    var isCollection = false;
    var isMultiCollection = false;
    // if the dcreen is audio
    if (data['screen'] == "audio") {
      // checking the prev screen value to determine if its a collection or not
      isCollection =
          Get.find<AudioListingController>().prevScreen.value == "collection" ||
              Get.find<AudioListingController>().prevScreen.value ==
                  "homeCollection";
      // checking the prev screen value to determine if its a multiple collection or not
      isMultiCollection = Get.find<AudioListingController>().prevScreen.value ==
          "homeCollectionMultipleType";

      // if its collection then setting the collection id and type
      if (isCollection) {
        collectionId = Get.find<AudioListingController>().collectionId.value;
        collectionType =
            Get.find<AudioListingController>().collectionType.value;
      }

      // if its multiple collection then setting the collection id and type
      if (isMultiCollection) {
        collectionId = Get.find<AudioListingController>().collectionId.value;
        collectionType =
            Get.find<AudioListingController>().collectionType.value;
      }
    }
    // done same for book screen
    else if (data['screen'] == 'book') {
      isCollection = Get.find<EbooksListingController>().prevScreen.value ==
              "collection" ||
          Get.find<EbooksListingController>().prevScreen.value ==
              "homeCollection";

      isMultiCollection =
          Get.find<EbooksListingController>().prevScreen.value ==
              "homeCollectionMultipleType";

      if (isCollection) {
        collectionId = Get.find<EbooksListingController>().collectionId.value;
        collectionType =
            Get.find<EbooksListingController>().collectionType.value;
      }
      if (isMultiCollection) {
        collectionId = Get.find<EbooksListingController>().collectionId.value;
        collectionType =
            Get.find<EbooksListingController>().collectionType.value;
      }
    }
    // done same for video screen
    else {
      // video has a extra filter for types so initalizing that
      typeList = data['typeList'] as List<Map<dynamic, dynamic>>;
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
    final networkService = Get.find<NetworkService>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Obx(
      () => networkService.connectionStatus.value == 0
          ? Utils().noInternetWidget(screenWidth, screenHeight)
          : SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                bottomNavigationBar: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  decoration: BoxDecoration(
                      color: kColorWhite,
                      border:
                          Border.all(color: Color(0xffF5E2C2), width: 1.sp)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Get.back();
                          Utils().showLoader();
                          Map<String, String> body = {};
                          // clearing the filters and audio list on tap
                          if (data['screen'] == 'audio') {
                            Get.find<AudioListingController>().clearFilters();
                            Get.find<AudioListingController>()
                                .clearAudiosList();
                            log("In Audio" + body.toString());
                          } else if (data['screen'] == 'video') {
                            Get.find<VideoListingController>().clearFilters();
                            Get.find<VideoListingController>()
                                .clearVideosList();
                            log("In Video" + body.toString());
                          } else if (data['screen'] == 'book') {
                            Get.find<EbooksListingController>().clearFilters();
                            Get.find<EbooksListingController>()
                                .clearEbooksList();
                            log("In Book" + body.toString());
                          } else {
                            Get.find<ExploreController>().clearFilters();
                            Get.find<ExploreController>().clearSatsangList();
                            log("In Satsang" + body.toString());
                          }
                          // getting the filter body
                          log(Get.find<AudioListingController>()
                              .returnFilterBody()
                              .toString());
                          if (isCollection) {
                            body["id"] = collectionId;
                          } else if (isMultiCollection) {
                            body["id"] = collectionId;
                            body["type"] = collectionType;
                          }
                          // performing the api call to change the listing
                          print("this is the audio body : $body");
                          await onTap(body: body, token: '');
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.w),
                              border: Border.all(
                                  color: kColorPrimary, width: 1.sp)),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 60.w),
                          child: Text(
                            "Reset".tr,
                            style: kTextStylePoppinsRegular.copyWith(
                                fontSize: 15.sp, color: kColorPrimary),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.back();
                          Utils().showLoader();
                          Map<String, String> body = {};
                          if (data['screen'] == 'audio') {
                            body = Get.find<AudioListingController>()
                                .returnFilterBody();
                            Get.find<AudioListingController>()
                                .clearAudiosList();
                            log("In Audio" + body.toString());
                          } else if (data['screen'] == 'video') {
                            body = Get.find<VideoListingController>()
                                .returnFilterBody();
                            Get.find<VideoListingController>()
                                .clearVideosList();
                            log("In Video" + body.toString());
                          } else if (data['screen'] == 'book') {
                            body = Get.find<EbooksListingController>()
                                .returnFilter();
                            Get.find<EbooksListingController>()
                                .clearEbooksList();
                            log("In Book" + body.toString());
                          } else {
                            body = Get.find<ExploreController>()
                                .returnFilterBody();
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.w),
                              color: kColorPrimary,
                              border: Border.all(
                                  color: kColorPrimary, width: 1.sp)),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 60.w),
                          child: Text(
                            "Apply".tr,
                            style: kTextStylePoppinsRegular.copyWith(
                                fontSize: 16.sp, color: kColorWhite),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                appBar: PreferredSize(
                    preferredSize: Size(MediaQuery.sizeOf(context).width, 80),
                    child: Container(
                        decoration: BoxDecoration(
                          color: kColorWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 20.sp,
                            ),
                          ],
                          border: Border(
                            bottom: BorderSide(
                              color: kColorPrimaryWithOpacity25,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    // Container(
                                    //   alignment: Alignment.center,
                                    //   padding: EdgeInsets.only(
                                    //     top: 12.h,
                                    //     bottom: 12.h,
                                    //   ),
                                    //   child: Text(
                                    //     'Audio'.tr,
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        top: 12.h,
                                        bottom: 24.h,
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 310.w,
                                        child: Text(
                                          "Filter".tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              kTextStyleRosarioRegular.copyWith(
                                            color: kColorFont,
                                            fontSize: FontSize.screenTitle.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned.fill(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 24.w),
                                      height: 24.h,
                                      width: 24.h,
                                      child: SvgPicture.asset(
                                          'assets/icons/back.svg'),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        height: 50.h,
                                        width: 70.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))),
                body: Container(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                  ),
                  color: kColorWhite,
                  margin: EdgeInsets.only(top: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Obx(
                              () => DefaultTabController(
                                length: 3,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => tabIndex.value = 0,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 142.w,
                                            decoration: BoxDecoration(
                                              color: kColorWhite,
                                              border: tabIndex.value != 0
                                                  ? Border(
                                                      bottom: BorderSide(
                                                          color: kColorWhite2,
                                                          width: 4.sp))
                                                  : Border(),
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 19.h,
                                                bottom: 19.h,
                                                left: 12.w),
                                            child: Text(
                                              "Language".tr,
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                color: tabIndex.value == 0
                                                    ? kColorPrimary
                                                    : kColorFont,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                              visible: tabIndex.value == 0,
                                              child: Image.asset(
                                                "assets/icons/indicator.png",
                                                fit: BoxFit.fitHeight,
                                              ))
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => tabIndex.value = 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 142.w,
                                            decoration: BoxDecoration(
                                              color: kColorWhite,
                                              border: tabIndex.value != 1
                                                  ? Border(
                                                      bottom: BorderSide(
                                                          color: kColorWhite2,
                                                          width: 4.sp))
                                                  : Border(),
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 19.h,
                                                bottom: 19.h,
                                                left: 12.w),
                                            child: Text(
                                              "Author".tr,
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                color: tabIndex.value == 1
                                                    ? kColorPrimary
                                                    : kColorFont,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                              visible: tabIndex.value == 1,
                                              child: Image.asset(
                                                "assets/icons/indicator.png",
                                                fit: BoxFit.fitHeight,
                                              ))
                                        ],
                                      ),
                                    ),
                                    data['screen'] == 'video'
                                        ? GestureDetector(
                                            onTap: () => tabIndex.value = 2,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 142.w,
                                                  decoration: BoxDecoration(
                                                    color: kColorWhite,
                                                    border: tabIndex.value != 2
                                                        ? Border(
                                                            bottom: BorderSide(
                                                                color:
                                                                    kColorWhite2,
                                                                width: 4.sp))
                                                        : Border(),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 19.h,
                                                      bottom: 19.h,
                                                      left: 12.w),
                                                  child: Text(
                                                    "Type".tr,
                                                    style:
                                                        kTextStylePoppinsRegular
                                                            .copyWith(
                                                      color: tabIndex.value == 2
                                                          ? kColorPrimary
                                                          : kColorFont,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                    visible:
                                                        tabIndex.value == 2,
                                                    child: Image.asset(
                                                      "assets/icons/indicator.png",
                                                      fit: BoxFit.fitHeight,
                                                    ))
                                              ],
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    GestureDetector(
                                      onTap: () => tabIndex.value = 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 142.w,
                                            decoration: BoxDecoration(
                                              color: kColorWhite,
                                              border: tabIndex.value != 3
                                                  ? Border(
                                                      bottom: BorderSide(
                                                          color: kColorWhite2,
                                                          width: 4.sp))
                                                  : Border(),
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 19.h,
                                                bottom: 19.h,
                                                left: 12.w),
                                            child: Text(
                                              "Sort".tr,
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                color: tabIndex.value == 3
                                                    ? kColorPrimary
                                                    : kColorFont,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: tabIndex.value == 3,
                                            child: Image.asset(
                                              "assets/icons/indicator.png",
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 4.w,
                        color: kColorWhite2,
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Obx(
                              () => tabIndex.value == 0
                                  ? languageFilter(languages)
                                  : tabIndex.value == 1
                                      ? authorFilter(authors)
                                      : tabIndex.value == 2
                                          ? typeFilter(typeList)
                                          : sortFilter(sortList),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget languageFilter(List languages) {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: ListView(
        // itemCount: languages.length,
        // shrinkWrap: true,
        // itemBuilder: (context, index) {
        //   return
        // },
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: languages
            .map((e) => Obx(
                  () => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: kColorPrimary,
                      // contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Text(
                        e["title"],
                        style: kTextStylePoppinsRegular.copyWith(
                          color: e["value"].value ? kColorPrimary : kColorFont,
                          fontSize: FontSize.searchFilterContent.sp,
                          fontWeight: e["value"].value
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                      value: e["value"].value,
                      onChanged: (val) {
                        e["value"].value = val!;
                      }),
                ))
            .toList(),
      ),
    );
  }

  Widget authorFilter(authors) {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        itemCount: authors.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Obx(
            () => CheckboxListTile(
                visualDensity: const VisualDensity(vertical: -4),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: kColorPrimary,
                title: Text(
                  authors[index]["title"],
                  style: kTextStylePoppinsRegular.copyWith(
                    color: authors[index]["value"].value
                        ? kColorPrimary
                        : kColorFont,
                    fontSize: FontSize.searchFilterContent.sp,
                    fontWeight: authors[index]["value"].value
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
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
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortList.length,
      itemBuilder: (context, index) {
        return Obx(
          () => RadioListTile(
              visualDensity: const VisualDensity(vertical: -4),
              groupValue: sortList[index]["groupValue"].value,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: kColorPrimary,
              title: Text(
                sortList[index]["title"],
                style: kTextStylePoppinsRegular.copyWith(
                  color: sortList[index]["value"] ==
                          sortList[index]["groupValue"].value
                      ? kColorPrimary
                      : kColorFont,
                  fontSize: FontSize.searchFilterContent.sp,
                  fontWeight: sortList[index]["value"] ==
                          sortList[index]["groupValue"].value
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
              value: sortList[index]["value"],
              onChanged: (val) {
                sortList[index]["groupValue"].value = val;
              }),
        );
      },
    );
  }

  Widget typeFilter(typeList) {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: typeList.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => CheckboxListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: kColorPrimary,
                      title: TextPoppins(
                        text: typeList[index]["title"],
                        color: typeList[index]["value"].value
                            ? kColorPrimary
                            : kColorFont,
                        fontSize: FontSize.searchFilterContent.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      value: typeList[index]["value"].value,
                      onChanged: (val) {
                        typeList[index]["value"].value = val!;
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
