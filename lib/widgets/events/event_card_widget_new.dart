import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/event_details/event_details_controller.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';

class EventCardWidgetNew extends StatelessWidget {
  const EventCardWidgetNew({
    super.key,
    // required this.eventsController,
    // required this.screenSize,
    required this.bgImgUrl,
    required this.eventName,
    required this.eventArtist,
    required this.startTime,
    required this.eventDate,
    required this.eventId,
    required this.shortDesc,
    required this.artistImageUrl,
  });

  // final EventsListingController eventsController;
  // final Size screenSize;

  final String bgImgUrl;
  final String eventName;
  final String eventArtist;
  final String startTime;
  final String eventDate;
  final String shortDesc;
  final String eventId;
  final String artistImageUrl;

  @override
  Widget build(BuildContext context) {
    final eventDetailsController = Get.put(EventDetailsController());
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // color: Colors.red,
      margin: EdgeInsets.only(
        left: 25.w,
        right: 25.w,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              // Get.toNamed(AppRoute.ebookDetailsScreen);
              Utils().showLoader();

              //Call Ebooklisting API here
              await eventDetailsController.fetchEventDetails(
                  token: '', ctx: context, eventId: eventId);

              Get.back();

              if (!eventDetailsController.isLoadingData.value) {
                Get.toNamed(AppRoute.eventDetailsScreen);
              }
            },
            child: Container(
              color: kColorTransparent,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 15.h),
                    // height: screenWidth >= 600 ? 365.h : 328.h,
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
                          child: SizedBox(
                            height: 100.h,
                            width: screenWidth,
                            child: FadeInImage(
                              image: NetworkImage(bgImgUrl),
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.scaleDown,
                              placeholder:
                                  AssetImage("assets/icons/default.png"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/icons/default.png");
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.w,right: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Event Name
                              Text(
                                eventName,
                                style: kTextStylePoppinsRegular.copyWith(
                                  color: kColorFont,
                                  fontSize: FontSize.listingScreenEventTitle.sp,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              //Event Guruji
                              Text(
                                "${'by'.tr} $eventArtist",
                                style: kTextStylePoppinsRegular.copyWith(
                                  color: kColorFontOpacity75,
                                  fontSize:
                                      FontSize.listingScreenEventGuruji.sp,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14.w),
                                    decoration: BoxDecoration(
                                      color: kColorFontLangaugeTag
                                          .withOpacity(0.10),
                                      borderRadius:
                                          BorderRadius.circular(100.h),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 15.h,
                                          width: 15.h,
                                          child: Image.asset(
                                              'assets/images/events/time.png'),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          startTime,
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                                  color: kColorFontLangaugeTag,
                                                  fontSize: FontSize
                                                      .listingScreenEventTimings
                                                      .sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),

                                  Container(
                                    height: 30.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14.w),
                                    decoration: BoxDecoration(
                                      color: kColorFontLangaugeTag
                                          .withOpacity(0.10),
                                      borderRadius:
                                          BorderRadius.circular(100.h),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 15.h,
                                          width: 15.h,
                                          child: Image.asset(
                                              'assets/images/events/calendar.png'),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          eventDate,
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                                  color: kColorFontLangaugeTag,
                                                  fontSize: FontSize
                                                      .listingScreenEventTimings
                                                      .sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),

                                  Container(
                                    height: 30.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14.w),
                                    decoration: BoxDecoration(
                                      color: kColorFontLangaugeTag
                                          .withOpacity(0.10),
                                      borderRadius:
                                          BorderRadius.circular(100.h),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 15.h,
                                          width: 15.h,
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
                                shortDesc,
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize: FontSize.listingScreenEventDesc.sp,
                                  // overflow: TextOverflow.ellipsis,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: Container(
                        height: 48.h,
                        width: 48.h,

                        child: FadeInImage(
                          image: NetworkImage(artistImageUrl),
                          fit: BoxFit.fill,
                          placeholderFit: BoxFit.fill,
                          placeholder: AssetImage("assets/icons/default.png"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset("assets/icons/default.png");
                          },
                        ),
                        // child: CachedNetworkImage(imageUrl:
                        //   artistImageUrl,
                        // ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 76.h,
                  //   left: 16.w,
                  //   child: SizedBox(
                  //     height: 48.h,
                  //     width: 48.h,
                  //     child:
                  //     Image.asset('assets/images/events/event_guruji.png'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
