import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/text_styles/text_styles.dart';

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: kColorTransparent,
      child: Stack(
        children: [
          Container(
            height: screenWidth >= 600 ? 360.h : 328.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 5),
                  color: kColorBlackWithOpacity75.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
              color: kColorWhite,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.h),
                    topRight: Radius.circular(8.h),
                  ),
                  child: Container(
                    height: 100.h,
                    width: screenSize.width,
                    child: Image.asset(
                      'assets/images/events/eventbg1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Event Name
                      Text(
                        'Guru Purnima Event',
                        style: kTextStylePoppinsRegular.copyWith(
                          color: kColorFont,
                          fontSize: 16.sp,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      //Event Guruji
                      Text(
                        "Swami Adgadanand Maharaj",
                        style: kTextStylePoppinsRegular.copyWith(
                          color: kColorFontOpacity75,
                          fontSize: 12.sp,
                        ),
                      ),

                      SizedBox(
                        height: 16.h,
                      ),

                      //Event Timings and stuff
                      Row(
                        children: [
                          Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: kColorFontLangaugeTag.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(100.h),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 14.h,
                                  width: 14.h,
                                  child: Image.asset(
                                      'assets/images/events/time.png'),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  '7 am - 10 am',
                                  style: kTextStylePoppinsRegular.copyWith(
                                      color: kColorFontLangaugeTag,
                                      fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: kColorFontLangaugeTag.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(100.h),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 14.h,
                                  width: 14.h,
                                  child: Image.asset(
                                      'assets/images/events/calendar.png'),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  '20th August 2023',
                                  style: kTextStylePoppinsRegular.copyWith(
                                      color: kColorFontLangaugeTag,
                                      fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: kColorFontLangaugeTag.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(100.h),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 14.h,
                                  width: 14.h,
                                  child: Image.asset(
                                      'assets/images/events/mandir_icon.png'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 15.h,
                      ),

                      Text(
                        Constants.eventDummyDesc,
                        style: kTextStylePoppinsRegular.copyWith(
                          fontSize: 12.sp,
                          color: kColorFontOpacity75,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 76.h,
            left: 16.w,
            child: SizedBox(
              height: 48.h,
              width: 48.h,
              child: Image.asset(
                'assets/images/events/event_guruji.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
