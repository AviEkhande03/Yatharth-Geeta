import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/event_details/event_details_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/event_details/event_details_description_text_widget.dart';
import '../../widgets/home/heading_home_widget.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Event details related dependencies are initialzed here
    final eventDetailsController = Get.find<EventDetailsController>();
    final startUpController = Get.find<StartupController>();

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kColorWhite,
      extendBody: false,
      bottomNavigationBar: Obx(
        //This widget for the audio player (when audio is playing the player shows up else it shows a sized box)
        () => Get.find<BottomAppBarServices>().miniplayerVisible.value
            ? const MiniPlayer()
            : const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //App Bar
            CustomAppBar(
              title: 'Event'.tr,
            ),

            //Event details Screen UI goes below
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: kColorWhite2,
                    child: Column(
                      children: [
                        // Text('data'),
                        Stack(
                          children: [
                            SizedBox(
                              height: 266.h,
                              width: screenSize.width,
                              child: FadeInImage(
                                image: NetworkImage(eventDetailsController
                                    .eventDetails.value!.eventCoverUrl
                                    .toString()),
                                fit: BoxFit.fill,
                                placeholderFit: BoxFit.scaleDown,
                                placeholder: const AssetImage(
                                    "assets/icons/default.png"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/icons/default.png");
                                },
                              ),
                            ),

                            //Rest of the Contents
                            Container(
                              margin: EdgeInsets.only(top: 266.h - 8.h),
                              // height: 1500,
                              width: screenSize.width,
                              decoration: BoxDecoration(
                                color: kColorWhite2,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.h),
                                  topRight: Radius.circular(8.h),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: screenSize.width,
                                    decoration: BoxDecoration(
                                      color: kColorWhite,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.h),
                                        topRight: Radius.circular(8.h),
                                      ),
                                    ),
                                    height: 16.h,
                                  ),
                                  Container(
                                    width: screenSize.width,
                                    color: kColorWhite,
                                    padding: EdgeInsets.only(bottom: 24.h),
                                    child: Column(
                                      children: [
                                        Text(
                                          eventDetailsController
                                              .eventDetails.value!.title
                                              .toString(),
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            color: kColorFont,
                                            fontSize: FontSize
                                                .detailsScreenEventTitle.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Text(
                                          "${'by'.tr} ${eventDetailsController.dummyEventDetail.eventOrganizer}",
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            color: kColorFontOpacity75,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.w),
                                          child: Text(
                                            eventDetailsController.eventDetails
                                                .value!.shortDescription
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: kTextStylePoppinsRegular
                                                .copyWith(
                                              color: kColorBlackWithOpacity75,
                                              fontSize: FontSize
                                                  .detailsScreenEventGuruji.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),

                                  //About Event
                                  Container(
                                    color: kColorWhite,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.w, vertical: 24.h),
                                    child: Column(
                                      children: [
                                        HeadingHomeWidget(
                                          svgLeadingIconUrl:
                                              'assets/images/home/satiya_symbol.svg',
                                          headingTitle: 'About Event'.tr,
                                        ),
                                        SizedBox(
                                          height: 25.h,
                                        ),
                                        EventDetailsDescriptionTextWidget(
                                          description: eventDetailsController
                                              .dummyEventDetail.aboutEvent,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 16.h,
                                  ),

                                  //Date & Timing
                                  Container(
                                    color: kColorWhite,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.w, vertical: 24.h),
                                    child: Column(
                                      children: [
                                        HeadingHomeWidget(
                                          svgLeadingIconUrl:
                                              'assets/images/home/shiv_symbol.svg',
                                          headingTitle: 'Date & Timing'.tr,
                                        ),
                                        SizedBox(
                                          height: 25.h,
                                        ),
                                        Row(
                                          children: [
                                            //Timings Widget
                                            Row(
                                              children: [
                                                Container(
                                                  height: 37.h,
                                                  padding: EdgeInsets.only(
                                                      left: 10.w, right: 10.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200.h),
                                                    color: kColorFontLangaugeTag
                                                        .withOpacity(0.05),
                                                  ),
                                                  // alignment:
                                                  //     Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        height: 19.h,
                                                        width: 19.h,
                                                        child: Image.asset(
                                                            'assets/images/events/time.png'),
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      Text(
                                                        eventDetailsController
                                                            .eventDetails
                                                            .value!
                                                            .startTime!
                                                            .toString(),
                                                        style:
                                                            kTextStylePoppinsMedium
                                                                .copyWith(
                                                          fontSize: FontSize
                                                              .detailsScreenEventTimings
                                                              .sp,
                                                          color:
                                                              kColorFontLangaugeTag,
                                                        ),
                                                      ),
                                                      Text(
                                                        ' to ',
                                                        style:
                                                            kTextStylePoppinsMedium
                                                                .copyWith(
                                                          fontSize: FontSize
                                                              .detailsScreenEventTimings
                                                              .sp,
                                                          color:
                                                              kColorFontLangaugeTag,
                                                        ),
                                                      ),
                                                      Text(
                                                        eventDetailsController
                                                            .eventDetails
                                                            .value!
                                                            .endTime!
                                                            .toString(),
                                                        style:
                                                            kTextStylePoppinsMedium
                                                                .copyWith(
                                                          fontSize: FontSize
                                                              .detailsScreenEventTimings
                                                              .sp,
                                                          color:
                                                              kColorFontLangaugeTag,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Container(
                                                  height: 37.h,
                                                  padding: EdgeInsets.only(
                                                      left: 16.w, right: 16.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200.h),
                                                    color: kColorFontLangaugeTag
                                                        .withOpacity(0.05),
                                                  ),
                                                  // alignment:
                                                  //     Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 19.h,
                                                        width: 19.h,
                                                        child: Image.asset(
                                                            'assets/images/events/calendar.png'),
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      Text(
                                                        eventDetailsController
                                                            .eventDetails
                                                            .value!
                                                            .eventDate
                                                            .toString(),
                                                        style:
                                                            kTextStylePoppinsMedium
                                                                .copyWith(
                                                          fontSize: FontSize
                                                              .detailsScreenEventTimings
                                                              .sp,
                                                          color:
                                                              kColorFontLangaugeTag,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.w, vertical: 24.h),
                                    child: Column(
                                      children: [
                                        HeadingHomeWidget(
                                          svgLeadingIconUrl:
                                              'assets/images/home/satiya_symbol.svg',
                                          headingTitle: eventDetailsController
                                              .eventDetails
                                              .value!
                                              .locationTitle!,
                                        ),
                                        SizedBox(
                                          height: 25.h,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrl(eventDetailsController
                                                .createCoordinatedUrl(
                                                    eventDetailsController
                                                        .eventDetails
                                                        .value!
                                                        .locationLatitude!,
                                                    eventDetailsController
                                                        .eventDetails
                                                        .value!
                                                        .locationLongitude!,
                                                    null));
                                            print(eventDetailsController
                                                .createCoordinatedUrl(
                                                    eventDetailsController
                                                        .eventDetails
                                                        .value!
                                                        .locationLatitude!,
                                                    eventDetailsController
                                                        .eventDetails
                                                        .value!
                                                        .locationLongitude!,
                                                    null));
                                          },
                                          child: SizedBox(
                                              height: 258.h,
                                              width: screenSize.width,
                                              child:
                                                  // Image.asset(
                                                  //   eventDetailsController
                                                  //       .dummyEventDetail
                                                  //       .eventMapImgUrl,
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  FadeInImage(
                                                image: NetworkImage(
                                                    startUpController
                                                        .startupData
                                                        .first
                                                        .data!
                                                        .result!
                                                        .mapImage!
                                                        .toString()),
                                                fit: BoxFit.cover,
                                                placeholderFit:
                                                    BoxFit.scaleDown,
                                                placeholder: AssetImage(
                                                    "assets/icons/default.png"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      "assets/icons/default.png");
                                                },
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 16.h,
                                  ),

                                  //Gallery Goes here
                                  eventDetailsController.eventDetails.value!
                                          .eventImages!.isNotEmpty
                                      ? Container(
                                          color: kColorWhite,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.w, vertical: 24.h),
                                          child: Column(
                                            children: [
                                              HeadingHomeWidget(
                                                svgLeadingIconUrl:
                                                    'assets/images/home/shiv_symbol.svg',
                                                headingTitle: 'Gallery'.tr,
                                              ),

                                              SizedBox(
                                                height: 24.h,
                                              ),

                                              //Gallery Goes here
                                              GestureDetector(
                                                onTap: () {
                                                  print('object');
                                                  Get.toNamed(
                                                      AppRoute.galleryScreen,
                                                      arguments:
                                                          eventDetailsController
                                                              .eventDetails
                                                              .value!
                                                              .eventImages!);
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
                                                          child: FadeInImage(
                                                            image: NetworkImage(
                                                                eventDetailsController
                                                                    .eventDetails
                                                                    .value!
                                                                    .eventImages![0]),
                                                            fit: BoxFit.cover,
                                                            placeholderFit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            placeholder:
                                                                const AssetImage(
                                                                    "assets/icons/default.png"),
                                                            imageErrorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Image.asset(
                                                                  "assets/icons/default.png");
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      for (int i = 1;
                                                          i <
                                                              (eventDetailsController
                                                                          .eventDetails
                                                                          .value!
                                                                          .eventImages!
                                                                          .length >
                                                                      5
                                                                  ? 5
                                                                  : eventDetailsController
                                                                      .eventDetails
                                                                      .value!
                                                                      .eventImages!
                                                                      .length);
                                                          i++) ...[
                                                        if (i <= 3 &&
                                                            i <=
                                                                eventDetailsController
                                                                        .eventDetails
                                                                        .value!
                                                                        .eventImages!
                                                                        .length -
                                                                    2) ...[
                                                          StaggeredGridTile
                                                              .count(
                                                            crossAxisCellCount:
                                                                1,
                                                            mainAxisCellCount:
                                                                1,
                                                            child: FadeInImage(
                                                              image: NetworkImage(
                                                                  eventDetailsController
                                                                      .eventDetails
                                                                      .value!
                                                                      .eventImages![i]),
                                                              fit: BoxFit.fill,
                                                              placeholderFit:
                                                                  BoxFit
                                                                      .scaleDown,
                                                              placeholder:
                                                                  const AssetImage(
                                                                      "assets/icons/default.png"),
                                                              imageErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Image.asset(
                                                                    "assets/icons/default.png");
                                                              },
                                                            ),
                                                          ),
                                                        ] else ...[
                                                          StaggeredGridTile
                                                              .count(
                                                            crossAxisCellCount:
                                                                1,
                                                            mainAxisCellCount:
                                                                1,
                                                            child: Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              children: [
                                                                FadeInImage(
                                                                  image: NetworkImage(
                                                                      eventDetailsController
                                                                          .eventDetails
                                                                          .value!
                                                                          .eventImages![i]),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  placeholderFit:
                                                                      BoxFit
                                                                          .scaleDown,
                                                                  placeholder:
                                                                      const AssetImage(
                                                                          "assets/icons/default.png"),
                                                                  imageErrorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                            "assets/icons/default.png");
                                                                  },
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                          color:
                                                                              Colors.black26),
                                                                  // height: 24.h,
                                                                  // width: 24.h,
                                                                  child: Text(
                                                                    'More',
                                                                    style: kTextStylePoppinsRegular.copyWith(
                                                                        fontSize: FontSize
                                                                            .detailsScreenEventDescMore
                                                                            .sp,
                                                                        color:
                                                                            kColorWhite),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),

                                  SizedBox(
                                    height: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
