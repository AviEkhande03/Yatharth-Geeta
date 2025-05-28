import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:yatharthageeta/controllers/event_details/event_details_controller.dart';
import '../../const/colors/colors.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import '../../controllers/audio_listing/audio_listing_controller.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../controllers/ebooks_listing/ebooks_listing_controller.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../controllers/guruji_details/guruji_details_controller.dart';
import '../../controllers/guruji_listing/guruji_listing_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../controllers/video_listing/video_listing_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../common/text_poppins.dart';
import 'notification_item.dart';
import '../../const/font_size/font_size.dart';
import '../../models/notification/notification_model.dart' as notification;
import '../../utils/utils.dart';

class DayWiseNotification extends StatelessWidget {
  const DayWiseNotification(
      {super.key, required this.date, required this.notificationList});

  final String date;
  final List<notification.Value> notificationList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 24.w),
            child: TextPoppins(
              text: date,
              color: kColorFont,
              fontWeight: FontWeight.w500,
              fontSize: FontSize.notificationDateSize.sp,
            ),
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Utils().showLoader();
                    debugPrint(
                        "notificationList[index].notificationType: ${notificationList[index].notificationType}");
                    if (notificationList[index].notificationType == "Audio") {
                      // debugPrint("In Audio");
                      var controller = Get.find<AudioDetailsController>();
                      controller.prevRoute.value = Get.currentRoute;
                      await controller.fetchAudioDetails(
                          audioId: notificationList[index].selectedId!);
                      if (!controller.isLoadingData.value) {
                        Get.back();
                        Get.toNamed(AppRoute.audioDetailsScreen);
                      } else {
                        Utils.customToast("Something went wrong", kRedColor,
                            kRedColor.withOpacity(0.2), "error");
                      }
                    } else if (notificationList[index].notificationType ==
                        "Video") {
                      // debugPrint("In Video");
                      var controller = Get.find<VideoDetailsController>();
                      controller.prevRoute.value = Get.currentRoute;
                      await controller.fetchVideoDetails(
                          videoId: notificationList[index].selectedId!,
                          isNext: false);
                      if (!controller.isLoadingData.value) {
                        Get.back();
                        Get.toNamed(AppRoute.videoDetailsScreen);
                      } else {
                        Utils.customToast("Something went wrong", kRedColor,
                            kRedColor.withOpacity(0.2), "error");
                      }
                    } else if (notificationList[index].notificationType ==
                        "Book") {
                      // debugPrint("In BOok");
                      var controller = Get.find<EbookDetailsController>();
                      controller.prevRoute.value = Get.currentRoute;
                      await controller.fetchBookDetails(
                          bookId: notificationList[index].selectedId!);
                      if (!controller.isLoadingData.value) {
                        Get.back();
                        Get.toNamed(AppRoute.ebookDetailsScreen);
                      } else {
                        Utils.customToast("Something went wrong", kRedColor,
                            kRedColor.withOpacity(0.2), "error");
                      }
                    } else if (notificationList[index].notificationType ==
                        "Artist") {
                      await Get.find<GurujiDetailsController>()
                          .fetchGurujiDetails(
                              id: notificationList[index]
                                  .selectedId!
                                  .toString());
                      Get.back();
                      if (Get.find<GurujiDetailsController>()
                                  .isLoadingData
                                  .value ==
                              false &&
                          Get.find<GurujiDetailsController>()
                                  .isDataNotFound
                                  .value ==
                              false) {
                        debugPrint("DAta loaded ...Successfully");
                        Get.toNamed(AppRoute.gurujiDetailsScreen);
                      }
                    } else if (notificationList[index].notificationType ==
                        "Satsang") {
                      while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
                        Get.back();
                      }
                      Get.find<BottomAppBarServices>().onItemTapped(1);
                      var controller = Get.find<ExploreController>();
                      controller.satsangListing.isEmpty
                          ? await controller.fetchSatsang()
                          : null;
                      controller.tabIndex.value = 1;
                      Get.back();
                    } else if (notificationList[index].notificationType ==
                        "Quote") {
                      while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
                        Get.back();
                      }
                      Get.find<BottomAppBarServices>().onItemTapped(1);
                      var controller = Get.find<ExploreController>();
                      controller.quotesListing.isEmpty
                          ? await controller.fetchQuotes()
                          : null;
                      controller.tabIndex.value = 3;
                      Get.back();
                    } else if (notificationList[index].notificationType ==
                        "Event") {
                      var controller = Get.find<EventDetailsController>();
                      await controller.fetchEventDetails(
                          eventId:
                              notificationList[index].selectedId.toString());
                      if (!controller.isLoadingData.value) {
                        Get.back();
                        Get.toNamed(AppRoute.eventDetailsScreen);
                      }
                    } else if (notificationList[index].notificationType ==
                        "Mantra") {
                      while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
                        Get.back();
                      }
                      Get.find<BottomAppBarServices>().onItemTapped(1);
                      var controller = Get.find<ExploreController>();
                      controller.mantraListing.isEmpty
                          ? await controller.fetchMantra()
                          : null;
                      controller.tabIndex.value = 2;
                      Get.back();
                    } else if (notificationList[index].notificationType ==
                        "HomeCollection") {
                      // while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
                      //   Get.back();
                      // }
                      // Get.find<BottomAppBarServices>().onItemTapped(0);

                      final homeController = Get.find<HomeController>();
                      if (notificationList[index].collectionType == 'Book') {
                        var ebooksListingController =
                            Get.find<EbooksListingController>();
                        ebooksListingController.prevScreen.value =
                            "homeCollection";
                        ebooksListingController.collectionId.value =
                            notificationList[index].selectedId.toString();
                        homeController.languageModel ??
                            await homeController.getSortData();
                        ebooksListingController.initializeFilter();

                        ebooksListingController.booksApiCallType.value =
                            'fetchBooksHomeViewAllListing';

                        ebooksListingController.viewAllListingBookTitle.value =
                            notificationList[index].collectionTitle.toString();

                        await ebooksListingController
                            .fetchBooksHomeViewAllListing(
                          // collectionBookId: homecollectionResult.id.toString(),
                          token: '',
                        );

                        Get.back();

                        if (!ebooksListingController.isLoadingData.value) {
                          Get.toNamed(
                            AppRoute.ebooksListingScreen,
                            arguments: {
                              "viewAllListingBookTitle": notificationList[index]
                                  .collectionTitle
                                  .toString(),
                            },
                          );
                        }
                      }
                      if (notificationList[index].collectionType == 'Video') {
                        Utils().showLoader();
                        var videoListingController =
                            Get.find<VideoListingController>();
                        videoListingController.prevScreen.value =
                            "homeCollection";
                        videoListingController.collectionId.value =
                            notificationList[index].selectedId.toString();
                        homeController.languageModel ??
                            await homeController.getSortData();
                        videoListingController.initializeFilter();

                        videoListingController.videoApiCallType.value =
                            'fetchVideoHomeViewAllListing';

                        videoListingController.viewAllListingVideoTitle.value =
                            notificationList[index].collectionTitle.toString();

                        await videoListingController
                            .fetchVideoHomeViewAllListing(
                          token: '',
                          // collectionVideoId: homecollectionResult.id.toString(),
                        );
                        Get.back();
                        if (!videoListingController.isLoadingData.value) {
                          Get.toNamed(
                            AppRoute.videoListingScreen,
                            arguments: {
                              "viewAllListingVideoTitle":
                                  notificationList[index]
                                      .collectionTitle
                                      .toString(),
                            },
                          );
                        }
                      }
                      if (notificationList[index].collectionType == 'Artist') {
                        Utils().showLoader();
                        var gurujiListingController =
                            Get.find<GurujiListingController>();
                        gurujiListingController.prevScreen.value =
                            "homeCollection";

                        gurujiListingController.collectionId.value =
                            notificationList[index].selectedId.toString();

                        gurujiListingController.gurujiApiCallType.value =
                            'fetchGurujiHomeViewAllListing';

                        gurujiListingController
                                .viewAllListingGurujiTitle.value =
                            notificationList[index].collectionTitle.toString();

                        await gurujiListingController
                            .fetchGurujiHomeViewAllListing(
                          collectionArtsitId:
                              notificationList[index].selectedId.toString(),
                          token: '',
                        );

                        Get.back();

                        if (!gurujiListingController.isLoadingData.value) {
                          Get.toNamed(
                            AppRoute.gurujiListingScreen,
                            arguments: {
                              "viewAllListingGurujiTitle":
                                  notificationList[index]
                                      .collectionTitle!
                                      .toString(),
                            },
                          );
                        }
                      }
                      if (notificationList[index].collectionType == 'Audio') {
                        var audioListingController =
                            Get.find<AudioListingController>();
                        Utils().showLoader();
                        audioListingController.prevScreen.value =
                            "homeCollection";
                        audioListingController.collectionId.value =
                            notificationList[index].selectedId.toString();
                        homeController.languageModel ??
                            await homeController.getSortData();
                        audioListingController.initializeFilter();

                        audioListingController.audioApiCallType.value =
                            'fetchAudioHomeViewAllListing';

                        audioListingController.viewAllListingAudioTitle.value =
                            notificationList[index].collectionTitle.toString();

                        await audioListingController
                            .fetchAudioHomeViewAllListing(
                          token: '',
                        );
                        Get.back();
                        if (!audioListingController.isLoadingData.value) {
                          Get.toNamed(
                            AppRoute.audioListingScreen,
                            arguments: {
                              "viewAllListingAudioTitle":
                                  notificationList[index]
                                      .collectionTitle
                                      .toString(),
                            },
                          );
                        }
                      }
                    } else if (notificationList[index].notificationType ==
                        "ExploreCollection") {
                      // while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
                      //   Get.back();
                      // }
                      // Get.find<BottomAppBarServices>().onItemTapped(1);
                      if (notificationList[index].collectionType == 'Book') {
                        var homeController = Get.find<HomeController>();
                        var ebooksListingController =
                            Get.find<EbooksListingController>();
                        ebooksListingController.prevScreen.value = "collection";
                        ebooksListingController.collectionId.value =
                            notificationList[index].selectedId.toString();
                        homeController.languageModel ??
                            await homeController.getSortData();
                        ebooksListingController.initializeFilter();

                        ebooksListingController.booksApiCallType.value =
                            'fetchBooksExploreViewAllListing';

                        ebooksListingController.viewAllListingBookTitle.value =
                            notificationList[index].collectionTitle.toString();

                        await ebooksListingController
                            .fetchBooksExploreViewAllListing(
                          // collectionBookId: e.id.toString(),
                          token: '',
                        );

                        Get.back();

                        if (!ebooksListingController.isLoadingData.value) {
                          Get.toNamed(
                            AppRoute.ebooksListingScreen,
                            // arguments: {
                            //   "viewAllListingBookTitle":
                            //       e.title!.toString(),
                            // },
                          );
                        }
                      }
                      if (notificationList[index].collectionType == 'Satsang') {
                        var controller = Get.find<ExploreController>();
                        var homeController = Get.find<HomeController>();
                        controller.prevScreen.value = "collection";
                        controller.collectionId.value =
                            notificationList[index].selectedId.toString();
                        homeController.languageModel ??
                            await homeController.getSortData();
                        controller.initializeFilter();
                        controller.audioApiCallType.value =
                            'fetchAudioExploreViewAllListing';

                        controller.viewAllListingAudioTitle.value =
                            notificationList[index].collectionTitle.toString();
                        controller.clearSatsangList();
                        await controller.fetchAudioExploreViewAllListing(
                          token: '',
                          // collectionAudioId: e.id.toString(),
                        );
                        Get.back();
                        if (!controller.isSatsangLoadingData.value) {
                          controller.tabIndex.value = 1;
                          // Get.toNamed(
                          //   AppRoute.audioListingScreen,
                          // arguments: {
                          //   "viewAllListingAudioTitle":
                          //       e.title!.toString(),
                          // },
                          // );
                        }
                      }
                    }
                  },
                  child: NotificationItem(
                      iconPath: Utils().getAssetIconFromType(
                          notificationList[index].notificationType!),
                      titleText: notificationList[index].title!,
                      subText: ""),
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Divider(
                    height: 1.h,
                    color: kNotificationDividerColor,
                  ),
                );
              },
              itemCount: notificationList.length)
        ],
      ),
    );
  }
}
