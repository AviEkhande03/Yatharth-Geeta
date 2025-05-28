import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shimmer/shimmer.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/events_listing/events_listing_controller.dart';
import '../../widgets/common/custom_search_bar_new.dart';
import '../../widgets/common/no_data_found_widget.dart';
import '../../widgets/home/heading_home_widget.dart';
import '../../services/network/network_service.dart';
import '../../utils/utils.dart';
import '../../widgets/events/event_card_widget_new.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //All the event listing dependencies are initialized here
    // final eventsListingController = Get.put(EventsListingController());
    final eventsListingController = Get.find<EventsListingController>();
    final networkService = Get.find<NetworkService>();

    //For getting the dynamic screen height/width for the device
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Obx(
          //No internet widget is shown is the network connection is not available i.e. connectionStatus flag is 0
          () => networkService.connectionStatus.value == 0
              ? Utils().noInternetWidget(screenWidth, screenHeight)
              : Column(
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
                                    child: Text(
                                      'Events'.tr,
                                      style: kTextStyleRosarioRegular.copyWith(
                                        color: kColorFont,
                                        fontSize: FontSize.screenTitle.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 28.h,
                          ),

                          //Search Bar
                          Container(
                            margin: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: CustomSearchBarNew(
                              controller:
                                  eventsListingController.searchController,
                              fillColor: kColorWhite,
                              filled: true,
                              filterAvailable: false,
                              onChanged: (p0) {
                                eventsListingController.searchController.text =
                                    p0;
                                debugPrint("searchQuery.valuep0:$p0");
                              },
                              contentPadding: EdgeInsets.all(16.h),
                              hintText: 'Search...'.tr,
                              hintStyle: kTextStylePoppinsRegular.copyWith(
                                color: kColorFontOpacity25,
                                fontSize: FontSize.searchBarHint.sp,
                              ),
                            ),
                          ),

                          Container(
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),

                    Obx(
                      () => (eventsListingController.isLoadingData.value ==
                                      true &&
                                  eventsListingController
                                          .isLoadingForStart.value ==
                                      true) ||
                              (eventsListingController.pastEventsList.isEmpty &&
                                  eventsListingController
                                          .eventsListingCollectionZeroFlag
                                          .value ==
                                      false)

                          //Add skeleton here
                          //When the event listing data is loading, skeleton/shommer widget is shown
                          ? Expanded(child: const SkeletonEventsListingScreen())
                          : Expanded(
                              child: Obx(
                                //Pagination API call happens based on the conditions that are satisfied below(when the user reaches at the bottom of the screen)
                                //This section shows the events if there is some data in the event listing
                                () => eventsListingController.eventsListing !=
                                                null &&
                                            eventsListingController
                                                .eventsListing
                                                .value!
                                                .pastEvents!
                                                .list!
                                                .isNotEmpty ||
                                        eventsListingController
                                                .eventsListing
                                                .value!
                                                .upcomingEvents!
                                                .list!
                                                .isNotEmpty &&
                                            (eventsListingController
                                                    .eventsListingCollectionZeroFlag
                                                    .value ==
                                                true)
                                    ? LazyLoadScrollView(
                                        //API call is made when the user reaches the end of the screen
                                        isLoading: eventsListingController
                                            .isLoadingData.value,
                                        onEndOfPage: () async {
                                          if (eventsListingController
                                                  .pastEventsList.length
                                                  .toString() !=
                                              eventsListingController
                                                  .totalPastEvents.value
                                                  .toString()) {
                                            //debugPrint("fetchNotifications:");
                                            await eventsListingController
                                                .fetchEventsListing();
                                          } else {
                                            log(
                                              "No more Items to Load. notificationlist : ${eventsListingController.pastEventsList.length.toString()} totalcollectionlength: ${eventsListingController.totalPastEvents.value.toString()}",
                                            );
                                          }
                                        },

                                        //Pull to refersh clears the event listing state and resets the flags , and then making an API call again
                                        child: RefreshIndicator(
                                          color: kColorPrimary,
                                          onRefresh: () async {
                                            if (!eventsListingController
                                                .isEventsListingRefreshing
                                                .value) {
                                              eventsListingController
                                                  .isEventsListingRefreshing
                                                  .value = true;

                                              eventsListingController
                                                  .checkRefresh.value = true;
                                              eventsListingController
                                                  .clearEventsList();
                                              await eventsListingController
                                                  .fetchEventsListing();
                                              eventsListingController
                                                  .checkRefresh.value = false;

                                              // Set a 0.5-second delay to enable the refresh again
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                eventsListingController
                                                    .isEventsListingRefreshing
                                                    .value = false;
                                              });
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

                                                  //TWO SECTIONS ARE THE: Upcoming events, Past events

                                                  //Upcoming Events
                                                  eventsListingController
                                                          .eventsListing
                                                          .value!
                                                          .upcomingEvents!
                                                          .list!
                                                          .isNotEmpty
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 25.h,
                                                            bottom: 25.h,
                                                          ),
                                                          color: kColorWhite,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
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
                                                              ListView
                                                                  .separated(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        //Event card widget
                                                                        return EventCardWidgetNew(
                                                                          eventId: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .id
                                                                              .toString(),
                                                                          bgImgUrl: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .eventCoverUrl
                                                                              .toString(),
                                                                          eventName: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .title
                                                                              .toString(),
                                                                          eventArtist: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .artistName
                                                                              .toString(),
                                                                          artistImageUrl: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .artistImage
                                                                              .toString(),
                                                                          startTime: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .startTime
                                                                              .toString(),
                                                                          eventDate: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .eventDate
                                                                              .toString(),
                                                                          shortDesc: eventsListingController
                                                                              .eventsListing
                                                                              .value!
                                                                              .upcomingEvents!
                                                                              .list![index]
                                                                              .shortDescription
                                                                              .toString(),
                                                                        );
                                                                      },
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return SizedBox(
                                                                          height:
                                                                              25.h,
                                                                        );
                                                                      },
                                                                      itemCount: eventsListingController
                                                                          .eventsListing
                                                                          .value!
                                                                          .upcomingEvents!
                                                                          .list!
                                                                          .length),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox(),

                                                  SizedBox(
                                                    height: 24.h,
                                                  ),

                                                  //Past Events
                                                  eventsListingController
                                                          .pastEventsList
                                                          .isNotEmpty
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 25.h,
                                                            bottom: 25.h,
                                                          ),
                                                          color: kColorWhite,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
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
                                                              ListView
                                                                  .separated(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              EventCardWidgetNew(
                                                                            eventId:
                                                                                eventsListingController.pastEventsList[index].id.toString(),
                                                                            bgImgUrl:
                                                                                eventsListingController.pastEventsList[index].eventCoverUrl.toString(),
                                                                            eventName:
                                                                                eventsListingController.pastEventsList[index].title.toString(),
                                                                            eventArtist:
                                                                                eventsListingController.pastEventsList[index].artistName.toString(),
                                                                            artistImageUrl:
                                                                                eventsListingController.pastEventsList[index].artistImage.toString(),
                                                                            startTime:
                                                                                eventsListingController.pastEventsList[index].startTime.toString(),
                                                                            eventDate:
                                                                                eventsListingController.pastEventsList[index].eventDate.toString(),
                                                                            shortDesc:
                                                                                eventsListingController.pastEventsList[index].shortDescription.toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return SizedBox(
                                                                          height:
                                                                              25.h,
                                                                        );
                                                                      },
                                                                      itemCount: eventsListingController
                                                                          .pastEventsList
                                                                          .length),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox(),

                                                  eventsListingController
                                                          .isNoDataLoading.value
                                                      ? const SizedBox()
                                                      : eventsListingController
                                                              .isLoadingData
                                                              .value
                                                          ? Utils().showPaginationLoader(
                                                              eventsListingController
                                                                  .animation_controller)
                                                          : const SizedBox(),

                                                  // SizedBox(
                                                  //   height: 16.h,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: kColorPrimary,
                                        onRefresh: () async {
                                          // eventsListingController
                                          //     .checkRefresh.value = true;
                                          // eventsListingController.clearEventsList();
                                          // await eventsListingController
                                          //     .fetchEventsListing();
                                          // eventsListingController
                                          //     .checkRefresh.value = false;
                                          if (!eventsListingController
                                              .isEventsListingRefreshing
                                              .value) {
                                            eventsListingController
                                                .isEventsListingRefreshing
                                                .value = true;

                                            eventsListingController
                                                .checkRefresh.value = true;
                                            eventsListingController
                                                .clearEventsList();
                                            await eventsListingController
                                                .fetchEventsListing();
                                            eventsListingController
                                                .checkRefresh.value = false;

                                            // Set a 0.5-second delay to enable the refresh again
                                            Timer(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              eventsListingController
                                                  .isEventsListingRefreshing
                                                  .value = false;
                                            });
                                          }
                                        },
                                        child: SingleChildScrollView(
                                          child: Container(
                                            height: screenHeight * 0.75,
                                            child: eventsListingController
                                                    .isLoadingData.value
                                                ? const SizedBox.shrink()
                                                : NoDataFoundWidget(
                                                    svgImgUrl:
                                                        "assets/icons/no_events.svg",
                                                    title:
                                                        eventsListingController
                                                            .checkItem!.value,
                                                  ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

//This is the skeleton/shimmer widget which is shown when the event listing data is being loaded(happens when the screen loads up , pull to refresh happens)
class SkeletonEventsListingScreen extends StatelessWidget {
  const SkeletonEventsListingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final eventsListingController = Get.find<EventsListingController>();

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: kColorPrimary,
            onRefresh: () async {
              // eventsListingController.checkRefresh.value = true;
              // eventsListingController.clearEventsList();
              // await eventsListingController.fetchEventsListing();
              // eventsListingController.checkRefresh.value = false;
              if (!eventsListingController.isEventsListingRefreshing.value) {
                eventsListingController.isEventsListingRefreshing.value = true;

                eventsListingController.checkRefresh.value = true;
                eventsListingController.clearEventsList();
                await eventsListingController.fetchEventsListing();
                eventsListingController.checkRefresh.value = false;

                // Set a 0.5-second delay to enable the refresh again
                Timer(const Duration(milliseconds: 500), () {
                  eventsListingController.isEventsListingRefreshing.value =
                      false;
                });
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

                    //Shimmer List
                    Container(
                      padding: EdgeInsets.only(
                        top: 25.h,
                        bottom: 25.h,
                      ),
                      color: kColorWhite,
                      child: Column(
                        children: [
                          // Container(
                          //     padding: EdgeInsets.only(
                          //       left: 25.w,
                          //       right: 25.w,
                          //     ),
                          //     child: Shimmer.fromColors(
                          //       baseColor: Colors.grey.shade300,
                          //       highlightColor: Colors.grey.shade100,
                          //       child: Container(
                          //         height: 50.h,
                          //         // width: 100,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(4.h),
                          //           color: Colors.grey.shade300,
                          //         ),
                          //       ),
                          //     )),
                          // SizedBox(
                          //   height: 25.h,
                          // ),
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.h),
                                  ),
                                  //  height:
                                  //         screenWidth >= 600 ? 360.h : 310.h,

                                  //  boxShadow: [
                                  //         BoxShadow(
                                  //           offset: Offset(0, 5),
                                  //           color: kColorBlackWithOpacity75
                                  //               .withOpacity(0.1),
                                  //           blurRadius: 4,
                                  //         ),
                                  //       ],
                                  margin:
                                      EdgeInsets.only(left: 25.w, right: 25.w),
                                  child: Stack(
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          height: screenWidth >= 600
                                              ? 360.h
                                              : 310.h,
                                          decoration: BoxDecoration(
                                            // color: Colors.blue,
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 5),
                                                color: kColorBlackWithOpacity75
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8.h),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.h),
                                                  topRight:
                                                      Radius.circular(8.h),
                                                ),
                                                child: Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.shade300,
                                                  highlightColor:
                                                      Colors.grey.shade100,
                                                  child: Container(
                                                    height: 100.h,
                                                    // width: 100,
                                                    decoration: BoxDecoration(
                                                      // borderRadius:
                                                      //     BorderRadius.circular(
                                                      //         4.h),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.h),
                                                        topRight:
                                                            Radius.circular(
                                                                4.h),
                                                      ),
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.h,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    // color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(8.h),
                                                  bottomLeft:
                                                      Radius.circular(8.h),
                                                )),
                                                // color: Colors.red,
                                                padding:
                                                    EdgeInsets.only(left: 16.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //Event Name
                                                    // Text(
                                                    //   'Guru Purnima Event',
                                                    //   style:
                                                    //       kTextStylePoppinsRegular
                                                    //           .copyWith(
                                                    //     color: kColorFont,
                                                    //     fontSize: 16.sp,
                                                    //   ),
                                                    // ),

                                                    SizedBox(height: 8.h),

                                                    //Event Guruji
                                                    // Text(
                                                    //   "Swami Adgadanand Maharaj",
                                                    //   style:
                                                    //       kTextStylePoppinsRegular
                                                    //           .copyWith(
                                                    //     color: kColorFontOpacity75,
                                                    //     fontSize: 12.sp,
                                                    //   ),
                                                    // ),

                                                    SizedBox(
                                                      height: 16.h,
                                                    ),

                                                    //Event Timings and stuff
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 30.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kColorFontLangaugeTag
                                                                    .withOpacity(
                                                                        0.10),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.h),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // SizedBox(
                                                              //   height: 14.h,
                                                              //   width: 14.h,
                                                              //   child: Image.asset(
                                                              //       'assets/images/events/time.png'),
                                                              // ),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              SizedBox(
                                                                height: 30.h,
                                                                width: 40.w,
                                                                // child: Text(
                                                                //   '7 am - 10 am',
                                                                //   style: kTextStylePoppinsRegular
                                                                //       .copyWith(
                                                                //     color:
                                                                //         kColorFontLangaugeTag,
                                                                //     fontSize:
                                                                //         12.sp,
                                                                //   ),
                                                                // ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        Container(
                                                          height: 30.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kColorFontLangaugeTag
                                                                    .withOpacity(
                                                                        0.10),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.h),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // SizedBox(
                                                              //   height: 14.h,
                                                              //   width: 14.h,
                                                              //   child: Image.asset(
                                                              //       'assets/images/events/calendar.png'),
                                                              // ),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              SizedBox(
                                                                width: 110.w,
                                                                height: 30.h,
                                                                // child: Text(
                                                                //   '20th August 2023',
                                                                //   style: kTextStylePoppinsRegular.copyWith(
                                                                //       color:
                                                                //           kColorFontLangaugeTag,
                                                                //       fontSize:
                                                                //           12.sp),
                                                                // ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        Container(
                                                          height: 30.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kColorFontLangaugeTag
                                                                    .withOpacity(
                                                                        0.10),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.h),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 14.h,
                                                                width: 14.h,
                                                                // child: Image.asset(
                                                                //     'assets/images/events/mandir_icon.png'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 15.h,
                                                    ),

                                                    // Text(
                                                    //   Constants.eventDummyDesc,
                                                    //   style:
                                                    //       kTextStylePoppinsRegular
                                                    //           .copyWith(
                                                    //     fontSize: 12.sp,
                                                    //     color:
                                                    //         kColorFontOpacity75,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 76.h,
                                        left: 16.w,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(
                                            height: 48.h,
                                            width: 48.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 25.h,
                                );
                              },
                              itemCount: 3),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
