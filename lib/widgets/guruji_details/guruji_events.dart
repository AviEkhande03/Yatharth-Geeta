import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../const/colors/colors.dart';
import '../../controllers/guruji_details/guruji_details_controller.dart';
import '../common/no_data_found_widget.dart';
import '../events/event_card_widget_new.dart';
import '../home/heading_home_widget.dart';

class GurujiEvents extends StatelessWidget {
  final GurujiDetailsController gurujiEventsListingController;
  const GurujiEvents({
    super.key,
    required this.gurujiEventsListingController,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(
      () => gurujiEventsListingController.gurujiEvents.first.data!.result!
                  .pastEvents!.list!.isNotEmpty ||
              gurujiEventsListingController.gurujiEvents.first.data!.result!
                  .upcomingEvents!.list!.isNotEmpty
          ? LazyLoadScrollView(
              //isLoading: gurujiEventsListingController.isEventsLoadingData.value,
              onEndOfPage: () async {
                // debugPrint("Total Length:${gurujiEventsListingController.totalPastEvents.value}");
                // debugPrint("PastEvents Length:${gurujiEventsListingController.pastEventsList.length}");
                // if (gurujiEventsListingController.pastEventsList.length
                //     .toString() !=
                //     gurujiEventsListingController.totalPastEvents.value
                //         .toString()) {
                //   debugPrint("API called...");
                //   //debugPrint("PastEvents Length:${gurujiEventsListingController.pastEventsList.length}");
                //   await gurujiEventsListingController.fetchGurujiEvents(gurujiEventsListingController.gurujiDetails.first.data!.result!.artist!.id!);
                // } else {
                //   log(
                //     "No more Items to Load. notificationlist : ${gurujiEventsListingController.pastEventsList.length.toString()} totalcollectionlength: ${gurujiEventsListingController.totalPastEvents.value.toString()}",
                //   );
                // }
              },
              child: SingleChildScrollView(
                child: Container(
                  color: kColorWhite2,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),

                      //Upcoming Events
                      gurujiEventsListingController.gurujiEvents.first.data!
                              .result!.upcomingEvents!.list!.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.only(
                                top: 25.h,
                                bottom: 25.h,
                              ),
                              color: kColorWhite,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 25.w,
                                      right: 25.w,
                                    ),
                                    child: HeadingHomeWidget(
                                        headingTitle: 'Upcoming Events'.tr,
                                        svgLeadingIconUrl:
                                            'assets/images/home/satiya_symbol.svg'),
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return EventCardWidgetNew(
                                            eventId: gurujiEventsListingController
                                                .gurujiEvents
                                                .first
                                                .data!
                                                .result!
                                                .upcomingEvents!
                                                .list![index]
                                                .id
                                                .toString(),
                                            bgImgUrl: gurujiEventsListingController
                                                .gurujiEvents
                                                .first
                                                .data!
                                                .result!
                                                .upcomingEvents!
                                                .list![index]
                                                .eventCoverUrl
                                                .toString(),
                                            eventName: gurujiEventsListingController
                                                .gurujiEvents
                                                .first
                                                .data!
                                                .result!
                                                .upcomingEvents!
                                                .list![index]
                                                .title
                                                .toString(),
                                            eventArtist: gurujiEventsListingController
                                                .gurujiDetails
                                                .first
                                                .data!
                                                .result!
                                                .artist!
                                                .name!,
                                            artistImageUrl: gurujiEventsListingController
                                                .gurujiEvents
                                                .first
                                                .data!
                                                .result!
                                                .upcomingEvents!
                                                .list![index]
                                                .artistImage
                                                .toString(),
                                            startTime: gurujiEventsListingController.gurujiEvents.first.data!.result!.upcomingEvents!.list![index].startTime.toString(),
                                            eventDate: gurujiEventsListingController.gurujiEvents.first.data!.result!.upcomingEvents!.list![index].eventDate.toString(),
                                            shortDesc: gurujiEventsListingController.gurujiEvents.first.data!.result!.upcomingEvents!.list![index].shortDescription.toString());
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 25.h,
                                        );
                                      },
                                      itemCount: gurujiEventsListingController
                                          .gurujiEvents
                                          .first
                                          .data!
                                          .result!
                                          .upcomingEvents!
                                          .list!
                                          .length),
                                ],
                              ),
                            )
                          : const SizedBox(),

                      //Past Events
                      gurujiEventsListingController.pastEventsList.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.only(
                                top: 25.h,
                                bottom: 25.h,
                              ),
                              color: kColorWhite,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 25.w,
                                      right: 25.w,
                                    ),
                                    child: HeadingHomeWidget(
                                        headingTitle:
                                            'Current and Past Events'.tr,
                                        svgLeadingIconUrl:
                                            'assets/images/home/shiv_symbol.svg'),
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: EventCardWidgetNew(
                                              eventId: gurujiEventsListingController
                                                  .pastEventsList[index].id
                                                  .toString(),
                                              bgImgUrl: gurujiEventsListingController
                                                  .pastEventsList[index]
                                                  .eventCoverUrl
                                                  .toString(),
                                              eventName:
                                                  gurujiEventsListingController
                                                      .pastEventsList[index]
                                                      .title
                                                      .toString(),
                                              eventArtist:
                                                  gurujiEventsListingController
                                                      .gurujiDetails
                                                      .first
                                                      .data!
                                                      .result!
                                                      .artist!
                                                      .name!,
                                              artistImageUrl:
                                                  gurujiEventsListingController
                                                      .pastEventsList[index]
                                                      .artistImage
                                                      .toString(),
                                              startTime: gurujiEventsListingController.pastEventsList[index].startTime.toString(),
                                              eventDate: gurujiEventsListingController.pastEventsList[index].eventDate.toString(),
                                              shortDesc: gurujiEventsListingController.pastEventsList[index].shortDescription.toString()),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 25.h,
                                        );
                                      },
                                      itemCount: gurujiEventsListingController
                                          .pastEventsList.length),
                                ],
                              ),
                            )
                          : const SizedBox(),

                      // Column(
                      //   children: [
                      //     const HeadingHomeWidget(
                      //         headingTitle: 'Upcoming Events',
                      //         svgLeadingIconUrl:
                      //             'assets/images/home/satiya_symbol.svg'),
                      //     SizedBox(
                      //       height: 25.h,
                      //     ),
                      //     ListView.separated(
                      //         shrinkWrap: true,
                      //         physics: const NeverScrollableScrollPhysics(),
                      //         itemBuilder: (context, index) {
                      //           return EventCardWidgetNew(
                      //               eventsController: eventsController,
                      //               screenSize: screenSize);
                      //         },
                      //         separatorBuilder: (context, index) {
                      //           return SizedBox(
                      //             height: 16.h,
                      //           );
                      //         },
                      //         itemCount: eventsController
                      //             .dummyyEventsList[outerIndex]
                      //             .eventsList
                      //             .length),
                      //   ],
                      // ),

                      //Pagination Flow
                      // gurujiEventsListingController.isNoDataLoading.value
                      //     ? const SizedBox()
                      //     : gurujiEventsListingController.isEventsLoadingData.value
                      //     ? Container(
                      //   color: kColorWhite,
                      //   height: screenHeight * 0.05,
                      //   child: const Center(
                      //     child: CircularProgressIndicator(
                      //       color: kColorPrimary,
                      //     ),
                      //   ),
                      // )
                      //     : const SizedBox(),
                      SizedBox(
                        height: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
            )
          /*LazyLoadScrollView(
            isLoading: gurujiEventsListingController.isEventsLoadingData.value,
            onEndOfPage: () async{
              if (gurujiEventsListingController.pastEventsList.length
                  .toString() !=
                  gurujiEventsListingController.totalPastEvents.value
                      .toString()) {
                await gurujiEventsListingController.fetchGurujiEvents(gurujiEventsListingController.gurujiDetails.first.data!.result!.artist!.id!);
              } else {
                log(
                  "No more Items to Load. notificationlist : ${gurujiEventsListingController.pastEventsList.length.toString()} totalcollectionlength: ${gurujiEventsListingController.totalPastEvents.value.toString()}",
                );
              }
            },
            child: SingleChildScrollView(
              child: Container(
                color: kColorWhite2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),

                    //Upcoming Events
                    gurujiEventsListingController
                        .gurujiEvents
                        .first
                        .data!
                        .result!
                        .upcomingEvents!
                        .list!
                        .isNotEmpty
                        ? Container(
                      padding: EdgeInsets.only(
                        top: 25.h,
                        bottom: 25.h,
                      ),
                      color: kColorWhite,
                      child: Column(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.only(
                              left: 25.w,
                              right: 25.w,
                            ),
                            child: HeadingHomeWidget(
                                headingTitle:
                                'Upcoming Events'
                                    .tr,
                                svgLeadingIconUrl:
                                'assets/images/home/satiya_symbol.svg'),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          ListView.separated(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) {
                                return EventCardWidgetNew(
                                  eventId: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .id
                                      .toString(),
                                  bgImgUrl: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .eventCoverUrl
                                      .toString(),
                                  eventName: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .title
                                      .toString(),
                                  eventArtist: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .artistName
                                      .toString(),
                                  artistImageUrl: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .artistImage
                                      .toString(),
                                  startTime: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .startTime
                                      .toString(),
                                  eventDate: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .eventDate
                                      .toString(),
                                  shortDesc: gurujiEventsListingController
                                      .gurujiEvents
                                      .first
                                      .data!
                                      .result!
                                      .upcomingEvents!
                                      .list![index]
                                      .shortDescription
                                      .toString(),
                                );
                              },
                              separatorBuilder:
                                  (context, index) {
                                return SizedBox(
                                  height: 25.h,
                                );
                              },
                              itemCount:
                              gurujiEventsListingController
                                  .gurujiEvents
                                  .first
                                  .data!
                                  .result!
                                  .upcomingEvents!
                                  .list!
                                  .length),
                        ],
                      ),
                    )
                        : const SizedBox(),

                    //Past Events
                    gurujiEventsListingController
                        .pastEventsList
                        .isNotEmpty
                        ? Container(
                      padding: EdgeInsets.only(
                        top: 25.h,
                        bottom: 25.h,
                      ),
                      color: kColorWhite,
                      child: Column(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.only(
                              left: 25.w,
                              right: 25.w,
                            ),
                            child: HeadingHomeWidget(
                                headingTitle:
                                'Current and Past Events'
                                    .tr,
                                svgLeadingIconUrl:
                                'assets/images/home/shiv_symbol.svg'),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          ListView.separated(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child:
                                  EventCardWidgetNew(
                                    eventId: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .id
                                        .toString(),
                                    bgImgUrl: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .eventCoverUrl
                                        .toString(),
                                    eventName: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .title
                                        .toString(),
                                    eventArtist: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .artistName
                                        .toString(),
                                    artistImageUrl: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .artistImage
                                        .toString(),
                                    startTime: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .startTime
                                        .toString(),
                                    eventDate: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .eventDate
                                        .toString(),
                                    shortDesc: gurujiEventsListingController
                                        .pastEventsList[
                                    index]
                                        .shortDescription
                                        .toString(),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (context, index) {
                                return SizedBox(
                                  height: 25.h,
                                );
                              },
                              itemCount:
                              gurujiEventsListingController
                                  .pastEventsList
                                  .length),
                        ],
                      ),
                    )
                        : const SizedBox(),

                    gurujiEventsListingController.isNoDataLoading.value
                        ? const SizedBox()
                        : gurujiEventsListingController.isEventsLoadingData.value
                        ? Container(
                      color: kColorWhite,
                      height: screenHeight * 0.05,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: kColorPrimary,
                        ),
                      ),
                    )
                        : const SizedBox(),

                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              ),
            ),
          )*/
          : Container(
              height: screenHeight * 0.45,
              child:  gurujiEventsListingController
                  .isLoadingData.value
                  ? const SizedBox.shrink()
                  :NoDataFoundWidget(
                svgImgUrl: "assets/icons/no_events.svg",
                title: gurujiEventsListingController.checkItem!.value,
              ),
            ),
    );
  }
}
