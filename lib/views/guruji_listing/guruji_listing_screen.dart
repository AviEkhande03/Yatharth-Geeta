import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/guruji_details/guruji_details_controller.dart';
import '../../controllers/guruji_listing/guruji_listing_controller.dart';
import '../../models/guruji_listing/guruji_listing_model.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_search_bar_new.dart';
import '../../widgets/common/no_data_found_widget.dart';

class GurujiListingScreen extends StatefulWidget {
  const GurujiListingScreen({super.key});

  @override
  State<GurujiListingScreen> createState() => _GurujiListingScreenState();
}

class _GurujiListingScreenState extends State<GurujiListingScreen> {
  final gurujiListingController = Get.find<GurujiListingController>();

  @override
  void dispose() {
    super.dispose();
    gurujiListingController.clearGurujiListing();
    log('gurujiListing cleared. gurujiListing = ${gurujiListingController.gurujiListing}');
  }

  @override
  Widget build(BuildContext context) {
    // String? viewAllListingGurujiTitle =
    //     Get.arguments["viewAllListingGurujiTitle"];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Obx(
        () => Get.find<BottomAppBarServices>().miniplayerVisible.value
            ? const MiniPlayer()
            : const SizedBox.shrink(),
      ),
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Column(
          children: [
            //App Bar
            Container(
              decoration: BoxDecoration(
                color: kColorWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 15),
                    blurRadius: 20,
                  ),
                ],
                border: Border(
                  bottom: BorderSide(
                    color: kColorPrimaryWithOpacity25,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              top: 12.h,
                              bottom: 12.h,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: 310.w,
                              child: Text(
                                gurujiListingController
                                            .gurujiApiCallType.value ==
                                        'fetchGurujiListing'
                                    ? 'Honourable Guru Ji'.tr
                                    : gurujiListingController
                                        .viewAllListingGurujiTitle.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kTextStyleRosarioRegular.copyWith(
                                  color: kColorFont,
                                  fontSize: FontSize.screenTitle.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 24.w),
                            height: 24.h,
                            width: 24.h,
                            child: SvgPicture.asset('assets/icons/back.svg'),
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
                  Container(
                    height: 28.h,
                  ),

                  //Search Bar
                  Container(
                    margin: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: CustomSearchBarNew(
                      fillColor: kColorWhite,
                      filled: true,
                      filterAvailable: false,
                      controller: gurujiListingController.searchController,
                      onChanged: (p0) {
                        // gurujiListingController.controllerText.value = p0;
                        gurujiListingController.searchController.text = p0;
                        debugPrint("searchQuery.valuep0:$p0");
                      },
                      contentPadding: EdgeInsets.all(16.h),
                      hintText: 'Search...'.tr,
                      hintStyle: kTextStylePoppinsRegular.copyWith(
                        color: kColorFontOpacity25,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),

                  Container(
                    height: 16.h,
                  ),
                ],
              ),
            ),

            //Ebooks List
            Obx(
              () => Expanded(
                child: gurujiListingController.gurujiListing.isNotEmpty
                    ? SingleChildScrollView(
                        child: Container(
                          color: kColorWhite2,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 16.h,
                              ),

                              //Guruji Listing Widget
                              Container(
                                padding:
                                    EdgeInsets.only(top: 24.h, bottom: 24.h),
                                color: kColorWhite,
                                child: GurujiListingWidget(
                                  gurujiList:
                                      gurujiListingController.gurujiListing,
                                ),
                              ),

                              Container(
                                color: kColorWhite,
                                height: 16.h,
                              ),
                            ],
                          ),
                        ),
                      )
                    : gurujiListingController.isLoadingData.value
                        ? const SizedBox.shrink()
                        : NoDataFoundWidget(
                            svgImgUrl: "assets/icons/no_guruji_icon.svg",
                            title: gurujiListingController.checkItem!.value,
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GurujiListingWidget extends StatelessWidget {
  const GurujiListingWidget({
    this.gurujiList = const [],
    super.key,
  });

  final List<Result> gurujiList;

  @override
  Widget build(BuildContext context) {
    // final ebooksDetailsController = Get.put(EbookDetailsController());
    final gurujiDetailsController = Get.find<GurujiDetailsController>();

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              Utils().showLoader();
              await gurujiDetailsController.fetchGurujiDetails(
                  id: gurujiList[index].id.toString());
              Get.back();
              if (gurujiDetailsController.isLoadingData.value == false &&
                  gurujiDetailsController.isDataNotFound.value == false) {
                debugPrint("DAta loaded ...Successfully");
                Get.toNamed(AppRoute.gurujiDetailsScreen);
              }
            },
            child: Container(
              color: kColorTransparent,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
                    // color: Colors.grey,
                    width: screenSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          height: screenWidth >= 600 ? 206.h : 110.h,
                          width: 110.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.h),
                            child: FadeInImage(
                              image: NetworkImage(gurujiList[index].imageUrl!),
                              placeholderFit: BoxFit.scaleDown,
                              placeholder:
                                  const AssetImage("assets/icons/default.png"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/icons/default.png");
                              },
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25.w,
                        ),
                        Expanded(
                          child: Container(
                            height: screenWidth >= 600 ? 222.h : 110.h,
                            // color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gurujiList[index].name!,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize:
                                            FontSize.listingScreenMediaTitle.sp,
                                        color: kColorFont,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 25.w),
            child: Divider(
              height: 1.h,
              color: kColorFont.withOpacity(0.10),
              thickness: 1.h,
            ),
          );
        },
        itemCount: gurujiList.length,
      ),
    );
  }
}
