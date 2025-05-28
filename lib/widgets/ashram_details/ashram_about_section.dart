import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/text_styles/text_styles.dart';
import '../../routes/app_route.dart';
import 'dos_donts_bullet_text.dart';
import '../event_details/event_details_description_text_widget.dart';
import '../events/event_card_widget.dart';
import '../home/heading_home_widget.dart';

class AshramAboutSection extends StatelessWidget {
  const AshramAboutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Ashram Brief
        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/satiya_symbol.svg',
                headingTitle: 'Brief'.tr,
              ),
              SizedBox(
                height: 25.h,
              ),
              EventDetailsDescriptionTextWidget(
                description: Constants.eventDummyAbout,
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                headingTitle: 'Days & Timings'.tr,
              ),
              SizedBox(
                height: 25.h,
              ),

              //Timings Tag
              Row(
                children: [
                  Container(
                    height: 37.h,
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.h),
                      color: kColorFontLangaugeTag.withOpacity(0.05),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: Image.asset('assets/images/events/time.png'),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          '7 am to 10 am | 2 pm to 9 pm',
                          style: kTextStylePoppinsMedium.copyWith(
                            fontSize: 14.sp,
                            color: kColorFontLangaugeTag,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 16.h,
              ),

              //Calendar Tag
              Row(
                children: [
                  Container(
                    height: 37.h,
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.h),
                      color: kColorFontLangaugeTag.withOpacity(0.05),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: Image.asset(
                              'assets/images/ashram_details/calendar_closed.png'),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'Closed on Monday & Saturday',
                          style: kTextStylePoppinsMedium.copyWith(
                            fontSize: 14.sp,
                            color: kColorFontLangaugeTag,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(
          height: 16.h,
        ),

        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/icons/dosdonts.svg',
                headingTitle: "Do’s & Don’ts".tr,
              ),

              SizedBox(
                height: 16.h,
              ),

              //Do's
              Row(
                children: [
                  SizedBox(
                    height: 16.h,
                    width: 16.h,
                    child: SvgPicture.asset('assets/icons/dos_icon.svg'),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "Do’s".tr,
                    style: kTextStylePoppinsMedium.copyWith(
                        fontSize: 14.sp, color: kColorFont),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),

              //Dos
              Padding(
                padding: EdgeInsets.only(left: 8.w, top: 8.h),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const DosDontsBulletText(
                      text: "Lorem ipsum dolor sit amet,consectet adipiscing.",
                    );
                  },
                  itemCount: 5,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),

              //Dont's
              Row(
                children: [
                  SizedBox(
                    height: 16.h,
                    width: 16.h,
                    child: SvgPicture.asset('assets/icons/donts_icon.svg'),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "Dont’s".tr,
                    style: kTextStylePoppinsMedium.copyWith(
                        fontSize: 14.sp, color: kColorFont),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),

              //Don'ts
              Padding(
                padding: EdgeInsets.only(left: 8.w, top: 8.h),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const DosDontsBulletText(
                      text: "Lorem ipsum dolor sit amet,consectet adipiscing.",
                    );
                  },
                  itemCount: 5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16.h,
        ),

        //Gallery Goes here
        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                headingTitle: 'Gallery'.tr,
              ),

              SizedBox(
                height: 24.h,
              ),

              //Gallery Goes here
              GestureDetector(
                onTap: () {
                  print('object');
                  Get.toNamed(AppRoute.galleryScreen);
                },
                child: Container(
                  child: StaggeredGrid.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.h,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: Container(
                          // height: 100,
                          // color: Colors.red,
                          child: Image.asset(
                            'assets/images/ashram_details/img1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Image.asset(
                          'assets/images/ashram_details/img2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Image.asset(
                          'assets/images/ashram_details/img3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Image.asset(
                          'assets/images/ashram_details/img4.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // StaggeredGridTile.count(
                      //   crossAxisCellCount: 1,
                      //   mainAxisCellCount: 1,
                      //   child: Image.asset(
                      //     'assets/images/ashram_details/img5.png',
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/ashram_details/img5.png',
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child: SvgPicture.asset(
                                  'assets/images/ashram_details/plus.svg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 16.h,
        ),

        //Upcoming Events in Ashram
        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/satiya_symbol.svg',
                headingTitle: 'Upcoming Events in Ashram'.tr,
              ),

              SizedBox(
                height: 24.h,
              ),

              //Event Card Widget
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.eventDetailsScreen);
                    },
                    child: const EventCardWidget(),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 16.h,
                  );
                },
                itemCount: 1,
              ),
            ],
          ),
        ),

        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }
}
