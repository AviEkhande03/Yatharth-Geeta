import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:android_intent_plus/android_intent.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import '../../controllers/audio_listing/audio_listing_controller.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../controllers/ebooks_listing/ebooks_listing_controller.dart';
import '../../controllers/event_details/event_details_controller.dart';
import '../../controllers/guruji_details/guruji_details_controller.dart';
import '../../controllers/guruji_listing/guruji_listing_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/shlokas_listing/shlokas_listing_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../controllers/video_listing/video_listing_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/user_media_liked_create/service/user_media_liked_create_service.dart';
import '../../services/user_media_played_create/service/user_media_played_create_service.dart';
import '../../utils/utils.dart';
import '../../widgets/common/custom_showcase.dart';
import '../../widgets/home/heading_home_widget.dart';
import 'package:yatharthageeta/models/home_collection/home_collection_listing_model.dart'
    as homecollectionlisting;
import 'package:yatharthageeta/widgets/skeletons/home_screen_skeleton_widget.dart';

import '../../controllers/notification/notification_controller.dart';
import '../../services/network/network_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // final fcmTokenUpdateController = Get.put(FcmTokenUpdateController());
  final bottomAppBarServices = Get.find<BottomAppBarServices>();
  late AnimationController animation_controller;

  @override
  void initState() {
    super.initState();

    //Open app updater if startup mandatory flag flag == true
    checkAppVersion();

    // log("FirebaseCloudMessaging.fcmToken.toString():${FirebaseCloudMessaging.fcmToken.toString()}");
    //Update FCM Token in Backend on Home Screen Init
    // fcmTokenUpdateController.updateFcmTokenApi(
    //     fcmToken: FirebaseCloudMessaging.fcmToken.toString());
    // log("fcmTokenUpdated Details = ${fcmTokenUpdateController.fcmTokenUpdatedlDetails}");
    // log("fcmTokenUpdated accesstoken = ${bottomAppBarServices.token.value}");

    // Get.find<StartupController>().showTutorials.value
    //     ? WidgetsBinding.instance.addPostFrameCallback(
    //         (_) async => ShowCaseWidget.of(context).startShowCase([
    //               bottomAppBarServices.keyOne,
    //               bottomAppBarServices.keyTwo,
    //               bottomAppBarServices.keyThree,
    //               bottomAppBarServices.keyFour,
    //               bottomAppBarServices.keyFive,
    //               bottomAppBarServices.keySix,
    //             ]))
    //     : null;
  }

  @override
  void dispose() {
    animation_controller.dispose();
    super.dispose();
  }

  //This methods checks the flag for the mandatory update
  checkAppVersion() {
    if (Get.find<StartupController>()
            .startupData
            .first
            .data!
            .result!
            .mandatoryUpdate ==
        true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openVersionBottomSheet(context);
      });
    }
  }

  //Bases on the user input this will redirect the user to the play store/app store, whichever link is provided as the redirection URL
  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  //UI for the Bottom Sheet pop up
  void _openVersionBottomSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,

      // clipBehavior: Clip.antiAlias,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: PopScope(
            canPop: false,
            child: GestureDetector(
              onTap: () {
                // do nothing to prevent the background from being tapped
              },
              onVerticalDragDown: (_) {
                // do nothing to prevent the sheet from being dragged down
              },
              child: Container(
                padding: EdgeInsets.all(25.h),
                decoration: const BoxDecoration(
                    color: kColorWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                height: screenHeight / 3.65,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 56.h,
                              width: 56.h,
                              child: Image.asset(
                                  'assets/icons/app_update_icon.png'),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                              'Update Available'.tr,
                              style: kTextStylePoppinsMedium.copyWith(
                                fontSize: 20.sp,
                                color: kColorFont,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 24.h,
                        //   width: 24.h,
                        //   child: SvgPicture.asset("assets/icons/cross.svg"),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      'We recommend you to update the app to enjoy it’s new features'
                          .tr,
                      style: kTextStylePoppinsRegular.copyWith(
                        fontSize: 16.sp,
                        color: kColorFontOpacity75,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (Platform.isAndroid) {
                                // const String appPackageName =
                                //     'com.example.myapp'; // Replace with app package name
                                final String url = Get.find<StartupController>()
                                    .startupData
                                    .first
                                    .data!
                                    .result!
                                    .redirectionUrl
                                    .toString();

                                final AndroidIntent intent = AndroidIntent(
                                  action: 'action_view',
                                  data: url,
                                  // package: 'com.android.vending', // This is the package name of the Play Store app
                                );

                                await intent.launch();
                              } else if (Platform.isIOS) {
                                print(
                                    "urlbh = ${Get.find<StartupController>().startupData.first.data!.result!.redirectionUrl.toString()}");
                                // Navigator.pop(context);
                                final Uri _url = Uri.parse(
                                    Get.find<StartupController>()
                                        .startupData
                                        .first
                                        .data!
                                        .result!
                                        .redirectionUrl
                                        .toString());

                                await _launchUrl(_url);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kColorPrimary,
                                  border: Border.all(
                                      color: kColorPrimary, width: 1.sp),
                                  borderRadius: BorderRadius.circular(200.r)),
                              child: Text(
                                "Update".tr,
                                style: kTextStyleNotoMedium.copyWith(
                                  fontSize: 18.sp,
                                  color: kColorWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 15.h,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //All the dependencies required in home module are initialized here
    final networkService = Get.find<NetworkService>();
    final homeController = Get.find<HomeController>();
    final ebooksListingController = Get.put(EbooksListingController());
    final videoListingController = Get.put(VideoListingController());
    final audioListingController = Get.put(AudioListingController());
    final shlokasListingController = Get.put(ShlokasListingController());
    Get.put(GurujiListingController());
    Get.put(GurujiDetailsController());
    Get.put(EbookDetailsController());
    Get.put(VideoDetailsController());
    Get.put(EventDetailsController());
    Get.put(AudioDetailsController());
    Get.put(NotificationController());

    // Get.lazyPut(() => EbookDetailsController());
    // Get.lazyPut(() => VideoDetailsController());
    Get.lazyPut(() => UserMediaLikedCreateServices());
    Get.lazyPut(() => UserMediaPlayedCreateServices());
    // Get.put(EventsListingController());

    //Used for dynamically getting the screen width/height of the device
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //Pagination loader animation controller initialized
    animation_controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Obx(
          //Based on the network connection it will show the No internet screen
          () => networkService.connectionStatus.value == 0
              ? Utils().noInternetWidget(screenWidth, screenHeight)
              : homeController.homeCollectionListing.isEmpty &&
                      homeController.collectionZeroFlag.value == false

                  //As long as the Home screen data is loading this Skeleton/Shimmer widget is shown
                  ? HomeScreenSkeletonWidget()
                  : Column(
                      children: [
                        //App Bar

                        //This widget highlights the spefic part based on the key it receives
                        CustomShowcase(
                          desc:
                              "Tap or click on this icon to check if you've got any messages or alerts."
                                  .tr,
                          title: "",
                          showKey: Get.find<BottomAppBarServices>().keyTwo,
                          child: Stack(
                            children: [
                              Container(
                                // foregroundDecoration: BoxDecoration(
                                //     gradient: LinearGradient(colors: [Color(0xff955D00)])),
                                decoration: BoxDecoration(
                                  color: kColorWhite,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.black.withOpacity(0.05),
                                  //     offset: const Offset(0, 5),
                                  //     blurRadius: 20,
                                  //   ),
                                  // ],
                                  border: Border(
                                    bottom: BorderSide(
                                      color: kColorPrimaryWithOpacity25,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  top: 20.h,
                                  bottom: 20.h,
                                ),
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(colors: [
                                    Color(0xff955D00),
                                    Color(0xffC18A00)
                                  ]).createShader(
                                    Rect.fromLTWH(
                                        0, 0, bounds.width, bounds.height),
                                  ),
                                  child: SizedBox(
                                      // height: 74.h,
                                      width: 172.w,
                                      child: Image.asset(
                                          'assets/images/app_title.png')),
                                  // child: Text(
                                  //   'Yatharth Geeta'.tr,
                                  //   style: kTextStyleRosarioRegular.copyWith(
                                  //     color: kColorFont,
                                  //     fontSize: FontSize.screenTitle.sp,
                                  //   ),
                                  // ),
                                ),
                              ),

                              //Notification will be shown/hidden based on the notifcation icon flag we get in the startup API
                              Get.find<StartupController>()
                                          .startupData
                                          .first
                                          .data!
                                          .result!
                                          .screens!
                                          .meData!
                                          .extraaTabs!
                                          .notificationIcon ==
                                      true
                                  ? Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 24.w),
                                          height: 24.h,
                                          width: 24.h,
                                          child: InkWell(
                                            //Notication Screen API call and Redirection
                                            onTap: () async {
                                              // Get.toNamed(AppRoute.notificationScreen);
                                              Utils().showLoader();
                                              await Get.find<
                                                      NotificationController>()
                                                  .fetchNotifications();
                                              Get.back();
                                              if (!Get.find<
                                                          NotificationController>()
                                                      .isLoadingData
                                                      .value &&
                                                  !Get.find<
                                                          NotificationController>()
                                                      .isDataNotFound
                                                      .value) {
                                                Get.toNamed(AppRoute
                                                    .notificationScreen);
                                              }
                                            },
                                            child: SvgPicture.asset(
                                                'assets/icons/bell.svg'),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),

                        //HOME DATA UI (3 Major Cases)

                        //Each MAJOR CASE has multiple cases which based on (type, isScroll, display in column) as described below
                        //There are three cases for the Home collection data
                        // 1. 0 collection (home collection API has 0 object)
                        // 2. 1 collection (home collection API has 1 object)
                        // 3. 1+ collection (home collection API has more than 1 objects)

                        //MAJOR CASE 1: Contents for 0 collection (Only the Home Tabs are shown in this case as there is no other data in the home collection API)
                        //This flag is set to true of home collection API has no object
                        homeController.collectionZeroFlag.value == true
                            ? Expanded(
                                child: Container(
                                  color: kColorWhite2,
                                  child: RefreshIndicator(
                                    color: kColorPrimary,
                                    // onRefresh: () async {
                                    //   homeController.checkRefresh.value = true;
                                    //   homeController
                                    //       .clearHomeCollectionListing();
                                    //   await homeController
                                    //       .fetchHomeCollectionListing();
                                    //   homeController.checkRefresh.value = false;
                                    // },

                                    //Pull to Refresh: clears the data and calls the Home collection API, resets the flags
                                    onRefresh: () async {
                                      if (!homeController.isRefreshing.value) {
                                        homeController.isRefreshing.value =
                                            true;
                                        homeController.checkRefresh.value =
                                            true;
                                        homeController
                                            .clearHomeCollectionListing();
                                        await homeController
                                            .fetchHomeCollectionListing();
                                        homeController.checkRefresh.value =
                                            false;

                                        // Set a 0.5-second delay to enable the refresh again
                                        Timer(const Duration(milliseconds: 500),
                                            () {
                                          homeController.isRefreshing.value =
                                              false;
                                        });
                                      }
                                    },
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 15.h,
                                              ),

                                              //Home Tabs are shown here
                                              Container(
                                                color: kColorWhite,
                                                padding: EdgeInsets.only(
                                                  left: 25.w,
                                                  right: 25.w,
                                                  top: 15.h,
                                                  bottom: 15.h,
                                                ),
                                                child: CustomShowcase(
                                                  desc:
                                                      "Tap or click on the tabs to view their related content"
                                                          .tr,
                                                  title: "",
                                                  showKey: Get.find<
                                                          BottomAppBarServices>()
                                                      .keyThree,
                                                  child: Column(
                                                    children: [
                                                      //This builds Two Big Yatharth Geeta Tabs (Books, Audios)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: homeController
                                                            .homeYatharthModelList
                                                            .map((e) =>
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    if (e.title ==
                                                                        "Yatharth Geeta Books"
                                                                            .tr) {
                                                                      Utils()
                                                                          .showLoader();

                                                                      //for checking the debounce api calls and viewall listing titles
                                                                      ebooksListingController
                                                                          .prevScreen
                                                                          .value = "home";

                                                                      ebooksListingController
                                                                          .booksApiCallType
                                                                          .value = 'fetchBooksListing';
                                                                      //Call Ebooklisting API here
                                                                      homeController
                                                                              .languageModel ??
                                                                          await homeController
                                                                              .getSortData();
                                                                      ebooksListingController
                                                                          .initializeFilter();
                                                                      await ebooksListingController.fetchBooksListing(
                                                                          token:
                                                                              '',
                                                                          body: {
                                                                            "category":
                                                                                "yatharth_geeta_books"
                                                                          });

                                                                      // Loading.stop();
                                                                      ebooksListingController
                                                                          .category
                                                                          .value = "yatharth_geeta_books";
                                                                      Get.back();

                                                                      if (!ebooksListingController
                                                                          .isLoadingData
                                                                          .value) {
                                                                        Get.toNamed(
                                                                          AppRoute
                                                                              .ebooksListingScreen,
                                                                          arguments: {
                                                                            "viewAllListingBookTitle":
                                                                                'Books',
                                                                            "category":
                                                                                "yatharth_geeta_books"
                                                                          },
                                                                        );
                                                                      }
                                                                    } else {
                                                                      Utils()
                                                                          .showLoader();
                                                                      audioListingController
                                                                          .prevScreen
                                                                          .value = "home";
                                                                      audioListingController
                                                                          .audioApiCallType
                                                                          .value = 'fetchAudioListing';
                                                                      homeController
                                                                              .languageModel ??
                                                                          await homeController
                                                                              .getSortData();
                                                                      audioListingController
                                                                          .initializeFilter();
                                                                      await audioListingController.fetchAudioListing(
                                                                          token:
                                                                              '',
                                                                          body: {
                                                                            "category":
                                                                                "yatharth_geeta_audios"
                                                                          });
                                                                      audioListingController
                                                                          .category
                                                                          .value = "yatharth_geeta_audios";
                                                                      Get.back();
                                                                      if (!audioListingController
                                                                          .isLoadingData
                                                                          .value) {
                                                                        Get.toNamed(
                                                                          AppRoute
                                                                              .audioListingScreen,
                                                                          arguments: {
                                                                            "viewAllListingAudioTitle":
                                                                                'Audio',
                                                                            "category":
                                                                                "yatharth_geeta_audios"
                                                                          },
                                                                        );
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: screenWidth *
                                                                          0.43,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 14
                                                                              .w,
                                                                          vertical:
                                                                              16.h),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Color(0xffFFFCBE),
                                                                            Color(0xffFFEECB),
                                                                          ],
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.r),
                                                                      ),
                                                                      child: Column(
                                                                          children: [
                                                                            FadeInImage(
                                                                              image: NetworkImage(e.imgUrl),
                                                                              fit: BoxFit.cover,
                                                                              width: 95.w,
                                                                              height: 66.h,
                                                                              placeholderFit: BoxFit.scaleDown,
                                                                              placeholder: AssetImage("assets/icons/default.png"),
                                                                              imageErrorBuilder: (context, error, stackTrace) {
                                                                                return Image.asset(
                                                                                  "assets/icons/default.png",
                                                                                  width: 95.w,
                                                                                  height: 66.h,
                                                                                );
                                                                              },
                                                                            ),
                                                                            Text(e.title,
                                                                                style: kTextStylePoppinsMedium.copyWith(
                                                                                  fontSize: 13.sp,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: kColorFont,
                                                                                )),
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                      ).marginOnly(
                                                        bottom: 8.h,
                                                      ),

                                                      //This build 4 Ashram tabs dynamically(Books, audios, videos, shlokas)
                                                      GridView.builder(
                                                        // scrollDirection: Axis.vertical,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: homeController
                                                            .homeTabsModelList
                                                            .length,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio:
                                                              5 / 1.8,
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 8.h,
                                                          mainAxisSpacing: 8.h,
                                                        ),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return GestureDetector(
                                                            onTap: () async {
                                                              if (homeController
                                                                      .homeTabsModelList[
                                                                          index]
                                                                      .title ==
                                                                  'Geeta Shlokas') {
                                                                Utils()
                                                                    .showLoader();
                                                                homeController
                                                                        .languageModel ??
                                                                    await homeController
                                                                        .getSortData();
                                                                shlokasListingController
                                                                    .initializeFilter();
                                                                log("this is shloka model: " +
                                                                    shlokasListingController
                                                                        .languageList
                                                                        .toString());
                                                                //Call ShlokasChaptersList API here
                                                                await shlokasListingController
                                                                    .fetchShlokasChaptersList(
                                                                  langaugeId: shlokasListingController
                                                                      .groupValueId
                                                                      .value
                                                                      .toString(),
                                                                );
                                                                await shlokasListingController.fetchShlokasListing(
                                                                    langaugeId: shlokasListingController
                                                                        .groupValueId
                                                                        .value
                                                                        .toString(),
                                                                    chapterNumber: shlokasListingController
                                                                            .shlokasChaptersList
                                                                            .isNotEmpty
                                                                        ? shlokasListingController
                                                                            .shlokasChaptersList[0]
                                                                            .toString()
                                                                        : '1');

                                                                Get.back();

                                                                if (!shlokasListingController
                                                                        .isLoadingShlokasChaptersListData
                                                                        .value &&
                                                                    !shlokasListingController
                                                                        .isLoadingShlokasListingData
                                                                        .value) {
                                                                  Get.toNamed(
                                                                      AppRoute
                                                                          .shlokasListingScreen);
                                                                }

                                                                // Get.toNamed(AppRoute.shlokasListingScreen);
                                                              } else if (homeController
                                                                      .homeTabsModelList[
                                                                          index]
                                                                      .title ==
                                                                  'Ashram Audios') {
                                                                Utils()
                                                                    .showLoader();
                                                                audioListingController
                                                                        .prevScreen
                                                                        .value =
                                                                    "home";
                                                                audioListingController
                                                                        .audioApiCallType
                                                                        .value =
                                                                    'fetchAudioListing';
                                                                homeController
                                                                        .languageModel ??
                                                                    await homeController
                                                                        .getSortData();
                                                                audioListingController
                                                                    .initializeFilter();
                                                                await audioListingController
                                                                    .fetchAudioListing(
                                                                  token: '',
                                                                );
                                                                Get.back();
                                                                if (!audioListingController
                                                                    .isLoadingData
                                                                    .value) {
                                                                  Get.toNamed(
                                                                    AppRoute
                                                                        .audioListingScreen,
                                                                    arguments: {
                                                                      "viewAllListingAudioTitle":
                                                                          'Audio',
                                                                    },
                                                                  );
                                                                }
                                                              } else if (homeController
                                                                      .homeTabsModelList[
                                                                          index]
                                                                      .title ==
                                                                  'Satsang Videos') {
                                                                Utils()
                                                                    .showLoader();
                                                                homeController
                                                                        .languageModel ??
                                                                    await homeController
                                                                        .getSortData();
                                                                videoListingController
                                                                    .initializeFilter();

                                                                videoListingController
                                                                        .prevScreen
                                                                        .value =
                                                                    "home";

                                                                videoListingController
                                                                        .videoApiCallType
                                                                        .value =
                                                                    'fetchVideoListing';
                                                                await videoListingController
                                                                    .fetchVideoListing(
                                                                  token: '',
                                                                );
                                                                Get.back();
                                                                if (!videoListingController
                                                                    .isLoadingData
                                                                    .value) {
                                                                  Get.toNamed(
                                                                    AppRoute
                                                                        .videoListingScreen,
                                                                    arguments: {
                                                                      "viewAllListingVideoTitle":
                                                                          'Video',
                                                                    },
                                                                  );
                                                                }
                                                              } else if (homeController
                                                                      .homeTabsModelList[
                                                                          index]
                                                                      .title ==
                                                                  'Ashram Books') {
                                                                Utils()
                                                                    .showLoader();
                                                                ebooksListingController
                                                                        .prevScreen
                                                                        .value =
                                                                    "home";

                                                                ebooksListingController
                                                                        .booksApiCallType
                                                                        .value =
                                                                    'fetchBooksListing';
                                                                //Call Ebooklisting API here
                                                                homeController
                                                                        .languageModel ??
                                                                    await homeController
                                                                        .getSortData();
                                                                ebooksListingController
                                                                    .initializeFilter();
                                                                await ebooksListingController
                                                                    .fetchBooksListing(
                                                                        token:
                                                                            '',
                                                                        body: {
                                                                      "category":
                                                                          "aashram_books"
                                                                    });

                                                                // Loading.stop();
                                                                ebooksListingController
                                                                        .category
                                                                        .value =
                                                                    "aashram_books";
                                                                Get.back();

                                                                if (!ebooksListingController
                                                                    .isLoadingData
                                                                    .value) {
                                                                  Get.toNamed(
                                                                    AppRoute
                                                                        .ebooksListingScreen,
                                                                    arguments: {
                                                                      "viewAllListingBookTitle":
                                                                          'Books',
                                                                      "category":
                                                                          "aashram_books"
                                                                    },
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              // color: Colors.white,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kColorHomeTabsColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.h),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        left: 15
                                                                            .w),
                                                                    child: Text(
                                                                      homeController
                                                                          .homeTabsModelList[
                                                                              index]
                                                                          .title
                                                                          .tr,
                                                                      style: kTextStylePoppinsMedium
                                                                          .copyWith(
                                                                        fontSize:
                                                                            13.5.sp,
                                                                        color:
                                                                            kColorFont,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              8.h),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              8.h),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets
                                                                          .all(4
                                                                              .h),
                                                                      // color: Colors.amber,
                                                                      height:
                                                                          95.h,
                                                                      // width: 85.w,
                                                                      // width: screenSize.width,
                                                                      child:
                                                                          // Image.asset(
                                                                          //   homeController.homeTabsModelList[index].imgUrl,
                                                                          //   fit: BoxFit.cover,
                                                                          // )
                                                                          FadeInImage(
                                                                        image: NetworkImage(homeController
                                                                            .homeTabsModelList[index]
                                                                            .imgUrl),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholderFit:
                                                                            BoxFit.scaleDown,
                                                                        placeholder:
                                                                            AssetImage("assets/icons/default.png"),
                                                                        imageErrorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Image.asset(
                                                                              "assets/icons/default.png");
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                height: screenHeight / 1.4,
                                              ),
                                            ],
                                          ),
                                          // homeController.isNoDataLoading.value
                                          //     ? const SizedBox()
                                          //     : homeController
                                          //             .isCollectionLoadingData
                                          //             .value
                                          //         ? Container(
                                          //             color: kColorWhite,
                                          //             height:
                                          //                 screenHeight * 0.05,
                                          //             child: const Center(
                                          //               child:
                                          //                   CircularProgressIndicator(
                                          //                 color:
                                          //                     kColorPrimary,
                                          //               ),
                                          //             ),
                                          //           )
                                          //         : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )

                            //MAJOR CASE CASE 2: Contents for 1 collection (1 Home collection Object above the Home Tabs is shown in this case as there is only 1 Data Object in the home collection API)
                            //This condition checks if the home collection data length equals 1
                            : homeController.homeCollectionListing.length == 1
                                ? Expanded(
                                    child: Container(
                                      color: kColorWhite2,
                                      child: LazyLoadScrollView(
                                        // isLoading:
                                        //     bottomAppServices.isCollectionLoadingData.value,
                                        isLoading: homeController
                                            .isCollectionLoadingData.value,
                                        onEndOfPage: () async {
                                          if (homeController
                                                      .checkRefresh.value ==
                                                  false &&
                                              homeController
                                                      .homeCollectionListing
                                                      .length
                                                      .toString() !=
                                                  homeController
                                                      .totalHomeCollection.value
                                                      .toString()) {
                                            await homeController
                                                .fetchHomeCollectionListing();
                                          } else {
                                            log(
                                              "No more Items to Load collectionlist : ${homeController.homeCollectionListing.length.toString()} totalcollectionlength: ${homeController.totalHomeCollection.value.toString()}",
                                            );
                                          }
                                        },
                                        child: RefreshIndicator(
                                          color: kColorPrimary,
                                          // onRefresh: () async {
                                          //   homeController.checkRefresh.value =
                                          //       true;
                                          //   homeController
                                          //       .clearHomeCollectionListing();
                                          //   await homeController
                                          //       .fetchHomeCollectionListing();
                                          //   homeController.checkRefresh.value =
                                          //       false;
                                          // },

                                          //Pull to refresh, clears the home collection API data and calls the home collection API
                                          onRefresh: () async {
                                            if (!homeController
                                                .isRefreshing.value) {
                                              homeController
                                                  .isRefreshing.value = true;
                                              homeController
                                                  .checkRefresh.value = true;
                                              homeController
                                                  .clearHomeCollectionListing();
                                              await homeController
                                                  .fetchHomeCollectionListing();
                                              homeController
                                                  .checkRefresh.value = false;

                                              // Set a 0.5-second delay to enable the refresh again
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                homeController
                                                    .isRefreshing.value = false;
                                              });
                                            }
                                          },
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),

                                                    //THERE ARE MULTIPLE CASES WHICH ARE NOTHING BUT THE WIDGETS BASED ON (isSCrollable flag, collection type key)
                                                    //Case 1(type: Single,isScrollable: False), Simple Banner Widget
                                                    homeController
                                                                .homeCollectionListing[
                                                                    0]!
                                                                .type! ==
                                                            'Single'
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionSingleTypeWidget(
                                                                bannerImgUrl: homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .singleCollectionImage
                                                                    .toString(),
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Case 3(type: Multiple,isScrollable: True) : This case builds the Carousel slider widget as it's a multiple type, scrollable true widget
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Multiple') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                true)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionMultipleScrollTrueCarouselWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              // SizedBox(
                                                              //   height: 15.h,
                                                              // ),
                                                              Container(
                                                                color:
                                                                    kColorWhite,
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Case 2(type: Multiple,isScrollable: False) , This case build a widget with an extra parameter i.e. DIC(Display in column), based on the value of the items that has to be shown across the home screen(horizontally)
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Multiple') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                false)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionMultipleScrollFalseWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Case 5 type: Books, Audio, Video, Artist,isScroll: True, DIC(Display in Column)  [Each type has two sub types i.e. isScoll: true, isScroll: false]
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Book') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                true)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionBookScrollTrueWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Book') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                false)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionBookScrollFalseWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    // Video Scroll False
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Video') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                false)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionVideoScrollFalseWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Video Scroll True
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Video') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                true)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionVideoScrollTrueWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    // Artist Scroll False
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Artist') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                false)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionArtistScrollFalseWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Case Artist Scroll True
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Artist') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                true)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionArtistScrollTrueWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Audio Scroll False
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Audio') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                false)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionAudioScrollFalseWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Audio Scroll true
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Audio') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                true)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionAudioScrollTrueWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Shlokas Scroll false
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Shlok') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                false)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionShlokasScrollFalseWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Shlokas Scroll true
                                                    (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .type! ==
                                                                'Shlok') &&
                                                            (homeController
                                                                    .homeCollectionListing[
                                                                        0]!
                                                                    .isScrollable ==
                                                                true)
                                                        ? Column(
                                                            children: [
                                                              HomeCollectionShlokasScrollTrueWidget(
                                                                homecollectionResult:
                                                                    homeController
                                                                        .homeCollectionListing[0]!,
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    //Home Tabs(Home tabs are painted after the 1st collection is shown above it, as this is the case for 1 home collection data object, home tabs details is the same as above)
                                                    Container(
                                                      color: kColorWhite,
                                                      padding: EdgeInsets.only(
                                                        left: 25.w,
                                                        right: 25.w,
                                                        top: 15.h,
                                                        bottom: 15.h,
                                                      ),
                                                      child: CustomShowcase(
                                                        desc:
                                                            "Tap or click on the tabs to view their related content"
                                                                .tr,
                                                        title: "",
                                                        showKey: Get.find<
                                                                BottomAppBarServices>()
                                                            .keyThree,
                                                        child: Column(
                                                          children: [
                                                            GridView.builder(
                                                              // scrollDirection: Axis.vertical,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  homeController
                                                                      .homeTabsModelList
                                                                      .length,
                                                              gridDelegate:
                                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                                childAspectRatio:
                                                                    5 / 1.8,
                                                                crossAxisCount:
                                                                    2,
                                                                crossAxisSpacing:
                                                                    8.h,
                                                                mainAxisSpacing:
                                                                    8.h,
                                                              ),
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    if (homeController
                                                                            .homeTabsModelList[
                                                                                index]
                                                                            .title ==
                                                                        'Shlokas') {
                                                                      Utils()
                                                                          .showLoader();
                                                                      homeController
                                                                              .languageModel ??
                                                                          await homeController
                                                                              .getSortData();
                                                                      shlokasListingController
                                                                          .initializeFilter();
                                                                      //Call ShlokasChaptersList API here
                                                                      await shlokasListingController
                                                                          .fetchShlokasChaptersList(
                                                                        langaugeId: shlokasListingController
                                                                            .groupValueId
                                                                            .value
                                                                            .toString(),
                                                                      );
                                                                      await shlokasListingController.fetchShlokasListing(
                                                                          langaugeId: shlokasListingController
                                                                              .groupValueId
                                                                              .value
                                                                              .toString(),
                                                                          chapterNumber: shlokasListingController.shlokasChaptersList.isNotEmpty
                                                                              ? shlokasListingController.shlokasChaptersList[0].toString()
                                                                              : '1');

                                                                      Get.back();

                                                                      if (!shlokasListingController
                                                                              .isLoadingShlokasChaptersListData
                                                                              .value &&
                                                                          !shlokasListingController
                                                                              .isLoadingShlokasListingData
                                                                              .value) {
                                                                        Get.toNamed(
                                                                            AppRoute.shlokasListingScreen);
                                                                      }

                                                                      // Get.toNamed(AppRoute.shlokasListingScreen);
                                                                    } else if (homeController
                                                                            .homeTabsModelList[
                                                                                index]
                                                                            .title ==
                                                                        'Audios') {
                                                                      Utils()
                                                                          .showLoader();
                                                                      audioListingController
                                                                          .prevScreen
                                                                          .value = "home";
                                                                      audioListingController
                                                                          .audioApiCallType
                                                                          .value = 'fetchAudioListing';
                                                                      homeController
                                                                              .languageModel ??
                                                                          await homeController
                                                                              .getSortData();
                                                                      audioListingController
                                                                          .initializeFilter();
                                                                      await audioListingController
                                                                          .fetchAudioListing(
                                                                        token:
                                                                            '',
                                                                      );
                                                                      audioListingController
                                                                          .viewAllListingAudioTitle
                                                                          .value = "Audio";
                                                                      Get.back();
                                                                      if (!audioListingController
                                                                          .isLoadingData
                                                                          .value) {
                                                                        Get.toNamed(
                                                                          AppRoute
                                                                              .audioListingScreen,
                                                                        );
                                                                      }
                                                                    } else if (homeController
                                                                            .homeTabsModelList[
                                                                                index]
                                                                            .title ==
                                                                        'Videos') {
                                                                      Utils()
                                                                          .showLoader();
                                                                      homeController
                                                                              .languageModel ??
                                                                          await homeController
                                                                              .getSortData();
                                                                      videoListingController
                                                                          .initializeFilter();

                                                                      videoListingController
                                                                          .prevScreen
                                                                          .value = "home";

                                                                      videoListingController
                                                                          .videoApiCallType
                                                                          .value = 'fetchVideoListing';
                                                                      await videoListingController
                                                                          .fetchVideoListing(
                                                                        token:
                                                                            '',
                                                                      );
                                                                      videoListingController
                                                                          .viewAllListingVideoTitle
                                                                          .value = "Video";
                                                                      Get.back();
                                                                      if (!videoListingController
                                                                          .isLoadingData
                                                                          .value) {
                                                                        Get.toNamed(
                                                                          AppRoute
                                                                              .videoListingScreen,
                                                                        );
                                                                      }
                                                                    } else if (homeController
                                                                            .homeTabsModelList[index]
                                                                            .title ==
                                                                        'Books') {
                                                                      Utils()
                                                                          .showLoader();
                                                                      ebooksListingController
                                                                          .prevScreen
                                                                          .value = "home";

                                                                      ebooksListingController
                                                                          .booksApiCallType
                                                                          .value = 'fetchBooksListing';
                                                                      //Call Ebooklisting API here
                                                                      homeController
                                                                              .languageModel ??
                                                                          await homeController
                                                                              .getSortData();
                                                                      ebooksListingController
                                                                          .initializeFilter();
                                                                      await ebooksListingController
                                                                          .fetchBooksListing(
                                                                        token:
                                                                            '',
                                                                      );

                                                                      // Loading.stop();
                                                                      ebooksListingController
                                                                          .viewAllListingBookTitle
                                                                          .value = "Books";
                                                                      Get.back();

                                                                      if (!ebooksListingController
                                                                          .isLoadingData
                                                                          .value) {
                                                                        Get.toNamed(
                                                                          AppRoute
                                                                              .ebooksListingScreen,
                                                                        );
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    // color: Colors.white,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          kColorHomeTabsColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.h),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(left: 15.w),
                                                                          child:
                                                                              Text(
                                                                            homeController.homeTabsModelList[index].title.tr,
                                                                            style:
                                                                                kTextStylePoppinsMedium.copyWith(
                                                                              fontSize: FontSize.tabsTitle.sp,
                                                                              color: kColorFont,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(8.h),
                                                                            bottomRight:
                                                                                Radius.circular(8.h),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.all(4.h),
                                                                            // color: Colors.amber,
                                                                            height:
                                                                                95.h,
                                                                            // width:
                                                                            //     85.w,
                                                                            // width: screenSize.width,
                                                                            child:
                                                                                // Image.asset(
                                                                                //   homeController
                                                                                //       .homeTabsModelList[index]
                                                                                //       .imgUrl,
                                                                                //   fit: BoxFit
                                                                                //       .cover,
                                                                                // )
                                                                                FadeInImage(
                                                                              image: NetworkImage(homeController.homeTabsModelList[index].imgUrl),
                                                                              fit: BoxFit.cover,
                                                                              placeholderFit: BoxFit.scaleDown,
                                                                              placeholder: AssetImage("assets/icons/default.png"),
                                                                              imageErrorBuilder: (context, error, stackTrace) {
                                                                                return Image.asset("assets/icons/default.png");
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height:
                                                          screenHeight / 2.4,
                                                    ),
                                                  ],
                                                ),

                                                //This is the pagination loader, only shown when more data is loaded as the screen is scrolled
                                                homeController
                                                        .isNoDataLoading.value
                                                    ? const SizedBox()
                                                    : homeController
                                                            .isCollectionLoadingData
                                                            .value
                                                        ? Utils()
                                                            .showPaginationLoader(
                                                                animation_controller)
                                                        : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                :

                                //MAJOR CASE CASE 3: Contents for 1+ collection(more than 1) (1 Home collection Object above the Home Tabs is shown and rest of the Objects are shown below the Home Tabs
                                Expanded(
                                    child: Container(
                                      color: kColorWhite2,
                                      child: LazyLoadScrollView(
                                        //Here the API is called based on the data left in the home collection API or not, as the user has reached the end of the page
                                        // isLoading:
                                        //     bottomAppServices.isCollectionLoadingData.value,
                                        isLoading: homeController
                                            .isCollectionLoadingData.value,
                                        onEndOfPage: () async {
                                          if (homeController
                                                      .checkRefresh.value ==
                                                  false &&
                                              homeController
                                                      .homeCollectionListing
                                                      .length
                                                      .toString() !=
                                                  homeController
                                                      .totalHomeCollection.value
                                                      .toString()) {
                                            await homeController
                                                .fetchHomeCollectionListing();
                                          } else {
                                            log(
                                              "No more Items to Load collectionlist : ${homeController.homeCollectionListing.length.toString()} totalcollectionlength: ${homeController.totalHomeCollection.value.toString()}",
                                            );
                                          }
                                        },
                                        child: RefreshIndicator(
                                          color: kColorPrimary,
                                          // onRefresh: () async {
                                          //   homeController.checkRefresh.value =
                                          //       true;
                                          //   homeController
                                          //       .clearHomeCollectionListing();
                                          //   await homeController
                                          //       .fetchHomeCollectionListing();
                                          //   homeController.checkRefresh.value =
                                          //       false;
                                          // },
                                          onRefresh: () async {
                                            if (!homeController
                                                .isRefreshing.value) {
                                              homeController
                                                  .isRefreshing.value = true;
                                              homeController
                                                  .checkRefresh.value = true;
                                              homeController
                                                  .clearHomeCollectionListing();
                                              await homeController
                                                  .fetchHomeCollectionListing();
                                              homeController
                                                  .checkRefresh.value = false;

                                              // Set a 0.5-second delay to enable the refresh again
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                homeController
                                                    .isRefreshing.value = false;
                                              });
                                            }
                                          },
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),

                                                    //Here the home collection is painted and a check is used to paint home tabs at the index 1
                                                    for (int i = 0;
                                                        i <
                                                            homeController
                                                                .homeCollectionListing
                                                                .length;
                                                        i++) ...[
                                                      if (i == 1) ...[
                                                        //Home Tabs(Same as described above)
                                                        Container(
                                                          color: kColorWhite,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 25.w,
                                                            right: 25.w,
                                                            top: 15.h,
                                                            bottom: 15.h,
                                                          ),
                                                          child: CustomShowcase(
                                                            desc:
                                                                "Tap or click on the tabs to view their related content"
                                                                    .tr,
                                                            title: "",
                                                            showKey: Get.find<
                                                                    BottomAppBarServices>()
                                                                .keyThree,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: homeController
                                                                      .homeYatharthModelList
                                                                      .map((e) =>
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              if (e.title == "Yatharth Geeta Books".tr) {
                                                                                Utils().showLoader();
                                                                                ebooksListingController.prevScreen.value = "home";

                                                                                ebooksListingController.booksApiCallType.value = 'fetchBooksListing';
                                                                                //Call Ebooklisting API here
                                                                                homeController.languageModel ?? await homeController.getSortData();
                                                                                ebooksListingController.initializeFilter();
                                                                                await ebooksListingController.fetchBooksListing(token: '', body: {
                                                                                  "category": "yatharth_geeta_books"
                                                                                });

                                                                                // Loading.stop();
                                                                                ebooksListingController.category.value = "yatharth_geeta_books";
                                                                                Get.back();

                                                                                if (!ebooksListingController.isLoadingData.value) {
                                                                                  Get.toNamed(
                                                                                    AppRoute.ebooksListingScreen,
                                                                                    arguments: {
                                                                                      "viewAllListingBookTitle": 'Books',
                                                                                      "category": "yatharth_geeta_books"
                                                                                    },
                                                                                  );
                                                                                }
                                                                              } else {
                                                                                Utils().showLoader();
                                                                                audioListingController.prevScreen.value = "home";
                                                                                audioListingController.audioApiCallType.value = 'fetchAudioListing';
                                                                                homeController.languageModel ?? await homeController.getSortData();
                                                                                audioListingController.initializeFilter();
                                                                                await audioListingController.fetchAudioListing(token: '', body: {
                                                                                  "category": "yatharth_geeta_audios"
                                                                                });
                                                                                audioListingController.category.value = "yatharth_geeta_audios";
                                                                                Get.back();
                                                                                if (!audioListingController.isLoadingData.value) {
                                                                                  Get.toNamed(
                                                                                    AppRoute.audioListingScreen,
                                                                                    arguments: {
                                                                                      "viewAllListingAudioTitle": 'Audio',
                                                                                      "category": "yatharth_geeta_audios"
                                                                                    },
                                                                                  );
                                                                                }
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: screenWidth * 0.43,
                                                                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                                                                              decoration: BoxDecoration(
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    Color(0xffFFFCBE),
                                                                                    Color(0xffFFEECB),
                                                                                  ],
                                                                                  begin: Alignment.topLeft,
                                                                                  end: Alignment.bottomRight,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(8.r),
                                                                              ),
                                                                              child: Column(children: [
                                                                                FadeInImage(
                                                                                  image: NetworkImage(e.imgUrl),
                                                                                  fit: BoxFit.cover,
                                                                                  width: 95.w,
                                                                                  height: 66.h,
                                                                                  placeholderFit: BoxFit.scaleDown,
                                                                                  placeholder: AssetImage("assets/icons/default.png"),
                                                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                                                    return Image.asset(
                                                                                      "assets/icons/default.png",
                                                                                      width: 95.w,
                                                                                      height: 66.h,
                                                                                    );
                                                                                  },
                                                                                ),
                                                                                Text(e.title,
                                                                                    style: kTextStylePoppinsMedium.copyWith(
                                                                                      fontSize: 13.sp,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: kColorFont,
                                                                                    )),
                                                                              ]),
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                                ).marginOnly(
                                                                  bottom: 8.h,
                                                                ),
                                                                GridView
                                                                    .builder(
                                                                  // scrollDirection: Axis.vertical,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  itemCount:
                                                                      homeController
                                                                          .homeTabsModelList
                                                                          .length,
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                    childAspectRatio:
                                                                        5 / 1.8,
                                                                    crossAxisCount:
                                                                        2,
                                                                    crossAxisSpacing:
                                                                        8.h,
                                                                    mainAxisSpacing:
                                                                        8.h,
                                                                  ),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        if (homeController.homeTabsModelList[index].title ==
                                                                            'Geeta Shlokas') {
                                                                          Utils()
                                                                              .showLoader();
                                                                          homeController.languageModel ??
                                                                              await homeController.getSortData();
                                                                          shlokasListingController
                                                                              .initializeFilter();
                                                                          log("this is shloka model: " +
                                                                              shlokasListingController.languageList.toString());
                                                                          await shlokasListingController.fetchChapters(
                                                                              langaugeId: shlokasListingController.groupValueId.value.toString());
                                                                          if (shlokasListingController
                                                                              .chaptersList
                                                                              .isNotEmpty) {
                                                                            await shlokasListingController.fetchAllVerses(
                                                                                chapterId: shlokasListingController.chaptersList.first['id'].toString(),
                                                                                langaugeId: shlokasListingController.groupValueId.value.toString());
                                                                          }
                                                                          //Call ShlokasChaptersList API here
                                                                          // await shlokasListingController
                                                                          //     .fetchShlokasChaptersList(
                                                                          //   langaugeId:
                                                                          //       shlokasListingController.groupValueId.value.toString(),
                                                                          // );
                                                                          // await shlokasListingController.fetchShlokasListing(
                                                                          //     langaugeId: shlokasListingController.groupValueId.value.toString(),
                                                                          //     chapterNumber: shlokasListingController.shlokasChaptersListResult!.isNotEmpty ? shlokasListingController.shlokasChaptersListResult![0].chapterId.toString() : '1');
                                                                          // Utils()
                                                                          //     .showLoader();
                                                                          // homeController.languageModel ??
                                                                          //     await homeController.getSortData();
                                                                          // /*
                                                                          //     *  Phase 2 Api calls Here
                                                                          //     *  --------------------------------
                                                                          //     */
                                                                          // shlokasListingController
                                                                          //     .initializeFilter();
                                                                          // await shlokasListingController.fetchChapters(
                                                                          //     langaugeId: shlokasListingController.languageList.first['id'].toString());
                                                                          // if (shlokasListingController.shlokaChapterModel.value.success ==
                                                                          //     1) {
                                                                          //   if (shlokasListingController.shlokaChapterModel.value.data!.result!.length >
                                                                          //       0) {
                                                                          //     log("Fisrt id of language is ${shlokasListingController.languageList.first['id'].toString()}");
                                                                          //     await shlokasListingController.fetchAllVerses(chapterId: shlokasListingController.shlokaChapterModel.value.data!.result!.first.chapterId.toString(), langaugeId: shlokasListingController.languageList.first['id'].toString());
                                                                          //   }
                                                                          // }
                                                                          // log("this is shloka model: " +
                                                                          //     shlokasListingController.languageList.toString());

                                                                          //Call ShlokasChaptersList API here
                                                                          // await shlokasListingController
                                                                          //     .fetchShlokasChaptersList(
                                                                          //   langaugeId:
                                                                          //       shlokasListingController.groupValueId.value.toString(),
                                                                          // );
                                                                          // await shlokasListingController.fetchShlokasListing(
                                                                          //     langaugeId: shlokasListingController.groupValueId.value.toString(),
                                                                          //     chapterNumber: shlokasListingController.shlokasChaptersList.isNotEmpty ? shlokasListingController.shlokasChaptersList[0].toString() : '1');

                                                                          Get.back();

                                                                          // if (!shlokasListingController.isLoadingShlokasChaptersListData.value &&
                                                                          //     !shlokasListingController.isLoadingShlokasListingData.value) {
                                                                          Get.toNamed(
                                                                              AppRoute.shlokasListingScreen);
                                                                          // }

                                                                          // Get.toNamed(AppRoute.shlokasListingScreen);
                                                                        } else if (homeController.homeTabsModelList[index].title ==
                                                                            'Ashram Audios') {
                                                                          Utils()
                                                                              .showLoader();
                                                                          audioListingController
                                                                              .prevScreen
                                                                              .value = "home";
                                                                          audioListingController
                                                                              .audioApiCallType
                                                                              .value = 'fetchAudioListing';
                                                                          homeController.languageModel ??
                                                                              await homeController.getSortData();
                                                                          audioListingController
                                                                              .initializeFilter();
                                                                          await audioListingController.fetchAudioListing(
                                                                              token: '',
                                                                              body: {
                                                                                "category": "aashram_audios"
                                                                              });
                                                                          audioListingController
                                                                              .category
                                                                              .value = "aashram_audios";
                                                                          Get.back();
                                                                          if (!audioListingController
                                                                              .isLoadingData
                                                                              .value) {
                                                                            Get.toNamed(
                                                                              AppRoute.audioListingScreen,
                                                                              arguments: {
                                                                                "viewAllListingAudioTitle": 'Audio',
                                                                                "category": "aashram_audios"
                                                                              },
                                                                            );
                                                                          }
                                                                        } else if (homeController.homeTabsModelList[index].title ==
                                                                            'Satsang Videos') {
                                                                          Utils()
                                                                              .showLoader();
                                                                          homeController.languageModel ??
                                                                              await homeController.getSortData();
                                                                          videoListingController
                                                                              .initializeFilter();

                                                                          videoListingController
                                                                              .prevScreen
                                                                              .value = "home";

                                                                          videoListingController
                                                                              .videoApiCallType
                                                                              .value = 'fetchVideoListing';
                                                                          await videoListingController
                                                                              .fetchVideoListing(
                                                                            token:
                                                                                '',
                                                                          );
                                                                          Get.back();
                                                                          if (!videoListingController
                                                                              .isLoadingData
                                                                              .value) {
                                                                            Get.toNamed(
                                                                              AppRoute.videoListingScreen,
                                                                              arguments: {
                                                                                "viewAllListingVideoTitle": 'Video',
                                                                              },
                                                                            );
                                                                          }
                                                                        } else if (homeController.homeTabsModelList[index].title ==
                                                                            'Ashram Books') {
                                                                          Utils()
                                                                              .showLoader();
                                                                          ebooksListingController
                                                                              .prevScreen
                                                                              .value = "home";

                                                                          ebooksListingController
                                                                              .booksApiCallType
                                                                              .value = 'fetchBooksListing';
                                                                          //Call Ebooklisting API here
                                                                          homeController.languageModel ??
                                                                              await homeController.getSortData();
                                                                          ebooksListingController
                                                                              .initializeFilter();
                                                                          await ebooksListingController.fetchBooksListing(
                                                                              token: '',
                                                                              body: {
                                                                                "category": "aashram_books"
                                                                              });

                                                                          // Loading.stop();
                                                                          ebooksListingController
                                                                              .category
                                                                              .value = "aashram_books";
                                                                          Get.back();

                                                                          if (!ebooksListingController
                                                                              .isLoadingData
                                                                              .value) {
                                                                            Get.toNamed(
                                                                              AppRoute.ebooksListingScreen,
                                                                              arguments: {
                                                                                "viewAllListingBookTitle": 'Books',
                                                                                "category": "aashram_books"
                                                                              },
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        // color: Colors.white,

                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              kColorHomeTabsColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.h),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                              width: 110.w,
                                                                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                                                                              child: Text(
                                                                                homeController.homeTabsModelList[index].title.tr,
                                                                                style: kTextStylePoppinsMedium.copyWith(
                                                                                  // overflow: TextOverflow.ellipsis,
                                                                                  fontSize: FontSize.tabsTitle.sp,
                                                                                  color: kColorFont,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.only(
                                                                                topRight: Radius.circular(8.h),
                                                                                bottomRight: Radius.circular(8.h),
                                                                              ),
                                                                              child: Container(
                                                                                margin: EdgeInsets.all(4.h),
                                                                                // color: Colors.amber,
                                                                                height: 95.h,
                                                                                // width: 85.w,
                                                                                // width: screenSize.width,
                                                                                child:
                                                                                    //     Image.asset(
                                                                                    //   homeController.homeTabsModelList[index].imgUrl,
                                                                                    //   fit: BoxFit.cover,
                                                                                    // ),
                                                                                    FadeInImage(
                                                                                  image: NetworkImage(homeController.homeTabsModelList[index].imgUrl),
                                                                                  fit: BoxFit.cover,
                                                                                  placeholderFit: BoxFit.scaleDown,
                                                                                  placeholder: AssetImage("assets/icons/default.png"),
                                                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                                                    return Image.asset("assets/icons/default.png");
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          height: 15.h,
                                                        ),
                                                      ],

                                                      //THERE ARE MULTIPLE CASES WHICH ARE NOTHING BUT THE WIDGETS BASED ON (isSCrollable flag, collection type key)
                                                      //Case 1(type: Single,isScrollable: False), Simple Banner Widget
                                                      homeController
                                                                  .homeCollectionListing[
                                                                      i]!
                                                                  .type! ==
                                                              'Single'
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionSingleTypeWidget(
                                                                  bannerImgUrl: homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .singleCollectionImage
                                                                      .toString(),
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Case 3(type: Multiple,isScrollable: True) : This case builds the Carousel slider widget as it's a multiple type, scrollable true widget
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Multiple') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  true)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionMultipleScrollTrueCarouselWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                // SizedBox(
                                                                //   height: 15.h,
                                                                // ),
                                                                Container(
                                                                  color:
                                                                      kColorWhite,
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Case 2(type: Multiple,isScrollable: False) , This case build a widget with an extra parameter i.e. DIC(Display in column), based on the value of the items that has to be shown across the home screen(horizontally)
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Multiple') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  false)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionMultipleScrollFalseWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Case 5 type: Books, Audio, Video, Artist,isScroll: True, DIC(Display in Column)  [Each type has two sub types i.e. isScoll: true, isScroll: false]
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Book') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  true)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionBookScrollTrueWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Book') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  false)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionBookScrollFalseWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      // Video Scroll False
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Video') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  false)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionVideoScrollFalseWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Video Scroll True
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Video') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  true)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionVideoScrollTrueWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      // Artist Scroll False
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Artist') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  false)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionArtistScrollFalseWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Case Artist Scroll True
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Artist') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  true)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionArtistScrollTrueWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Audio SCroll False
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Audio') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  false)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionAudioScrollFalseWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Audio Scroll true
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Audio') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  true)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionAudioScrollTrueWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Shlokas Scroll false
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Shlok') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  false)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionShlokasScrollFalseWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      //Shlokas Scroll true
                                                      (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .type! ==
                                                                  'Shlok') &&
                                                              (homeController
                                                                      .homeCollectionListing[
                                                                          i]!
                                                                      .isScrollable ==
                                                                  true)
                                                          ? Column(
                                                              children: [
                                                                HomeCollectionShlokasScrollTrueWidget(
                                                                  homecollectionResult:
                                                                      homeController
                                                                          .homeCollectionListing[i]!,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ],
                                                ),
                                                homeController
                                                        .isNoDataLoading.value
                                                    ? const SizedBox()
                                                    : homeController
                                                            .isCollectionLoadingData
                                                            .value
                                                        ? Utils()
                                                            .showPaginationLoader(
                                                                animation_controller)
                                                        : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                      ],
                    ),
        ),
      ),
    );
  }
}

//HOME COLLECTION WIDGETS based on : (type, isScroll, Display in Column)

//This widget displays the images in based on display in column(for example: if display in column is 5 then, 5 objects will be painted horzontally based on the screen width, and these objects are not tappable as the collection type is multiple and isScroll is false)
class HomeCollectionMultipleScrollFalseWidget extends StatelessWidget {
  HomeCollectionMultipleScrollFalseWidget({
    required this.homecollectionResult,
    super.key,
  });

  final homeController = Get.find<HomeController>();
  final audioListingController = Get.find<AudioListingController>();
  final videoListingController = Get.find<VideoListingController>();
  final ebooksListingController = Get.find<EbooksListingController>();
  final gurujiListingController = Get.find<GurujiListingController>();

  final homecollectionlisting.Result homecollectionResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorWhite,
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          HeadingHomeWidget(
            svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
            headingTitle: homecollectionResult.title!.toString(),
            authorName: homecollectionResult.description!,
          ),

          SizedBox(
            height: 25.h,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              crossAxisCount: homecollectionResult.displayInColumn!,
              childAspectRatio: 1 / 1.4,
            ),
            itemCount: homecollectionResult
                .collectionData!.length, // Total number of images
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  if (homecollectionResult.collectionData![index].mappedTo ==
                          'Audio' &&
                      homecollectionResult.collectionData![index].isClickable ==
                          Constants.homeMultipleListingClickableTrueBoolFlag) {
                    Utils().showLoader();
                    audioListingController.prevScreen.value =
                        "homeCollectionMultipleType";

                    audioListingController.viewAllListingAudioTitle.value =
                        'Audio'.tr;

                    audioListingController.collectionId.value =
                        homecollectionResult.collectionData![index].id
                            .toString();
                    audioListingController.collectionType.value =
                        homecollectionResult.type.toString();
                    homeController.languageModel ??
                        await homeController.getSortData();
                    audioListingController.initializeFilter();

                    audioListingController.audioApiCallType.value =
                        'fetchAudiosHomeMultipleListing';

                    await audioListingController.fetchAudiosHomeMultipleListing(
                      token: '',
                      // id: homecollectionResult.collectionData![index].id
                      //     .toString(),
                      // type: homecollectionResult.type.toString(),
                    );
                    Get.back();
                    if (!audioListingController.isLoadingData.value) {
                      Get.toNamed(
                        AppRoute.audioListingScreen,
                        // arguments: {
                        //   "viewAllListingAudioTitle": "Audio",
                        // },
                      );
                    }
                  } else if (homecollectionResult
                              .collectionData![index].mappedTo ==
                          'Video' &&
                      homecollectionResult.collectionData![index].isClickable ==
                          Constants.homeMultipleListingClickableTrueBoolFlag) {
                    Utils().showLoader();

                    videoListingController.prevScreen.value =
                        "homeCollectionMultipleType";
                    videoListingController.collectionId.value =
                        homecollectionResult.collectionData![index].id
                            .toString();
                    videoListingController.collectionType.value =
                        homecollectionResult.type.toString();

                    homeController.languageModel ??
                        await homeController.getSortData();
                    videoListingController.initializeFilter();

                    videoListingController.videoApiCallType.value =
                        'fetchVideosHomeMultipleListing';

                    videoListingController.viewAllListingVideoTitle.value =
                        'Video'.tr;
                    await videoListingController.fetchVideosHomeMultipleListing(
                      token: '',
                      // id: homecollectionResult.collectionData![index].id
                      //     .toString(),
                      // type: homecollectionResult.type.toString(),
                    );
                    Get.back();
                    if (!videoListingController.isLoadingData.value) {
                      Get.toNamed(
                        AppRoute.videoListingScreen,
                        // arguments: {
                        //   "viewAllListingVideoTitle": "Video",
                        // },
                      );
                    }
                  } else if (homecollectionResult
                              .collectionData![index].mappedTo ==
                          'Book' &&
                      homecollectionResult.collectionData![index].isClickable ==
                          Constants.homeMultipleListingClickableTrueBoolFlag) {
                    Utils().showLoader();

                    ebooksListingController.prevScreen.value =
                        "homeCollectionMultipleType";
                    ebooksListingController.collectionId.value =
                        homecollectionResult.collectionData![index].id
                            .toString();
                    ebooksListingController.collectionType.value =
                        homecollectionResult.type.toString();

                    homeController.languageModel ??
                        await homeController.getSortData();
                    ebooksListingController.initializeFilter();

                    ebooksListingController.booksApiCallType.value =
                        'fetchBooksHomeMultipleListing';

                    ebooksListingController.viewAllListingBookTitle.value =
                        'Books'.tr;

                    await ebooksListingController.fetchBooksHomeMultipleListing(
                      token: '',
                      // id: homecollectionResult.collectionData![index].id
                      //     .toString(),
                      // type: homecollectionResult.type.toString(),
                    );

                    Get.back();

                    if (!ebooksListingController.isLoadingData.value) {
                      Get.toNamed(
                        AppRoute.ebooksListingScreen,
                        // arguments: {
                        //   "viewAllListingBookTitle": "Books",
                        // },
                      );
                    }
                  } else if (homecollectionResult
                              .collectionData![index].mappedTo ==
                          'Artist' &&
                      homecollectionResult.collectionData![index].isClickable ==
                          Constants.homeMultipleListingClickableTrueBoolFlag) {
                    Utils().showLoader();

                    gurujiListingController.prevScreen.value =
                        "homeCollectionMultipleType";
                    gurujiListingController.collectionId.value =
                        homecollectionResult.collectionData![index].id
                            .toString();
                    gurujiListingController.collectionType.value = "Multiple";

                    gurujiListingController.gurujiApiCallType.value =
                        'fetchGurujiHomeMultipleListing';

                    gurujiListingController.viewAllListingGurujiTitle.value =
                        'Honourable Guru Ji'.tr;
                    await gurujiListingController
                        .fetchGurujiHomeMultipleListing(
                      token: '',
                      id: homecollectionResult.collectionData![index].id
                          .toString(),
                      type: homecollectionResult.type.toString(),
                    );

                    Get.back();

                    if (!gurujiListingController.isLoadingData.value) {
                      Get.toNamed(
                        AppRoute.gurujiListingScreen,
                        arguments: {
                          "viewAllListingGurujiTitle": "Honourable Guru Ji",
                        },
                      );
                    }
                  }
                },
                child: Container(
                  // color: Colors.pink,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.h),
                    child: FadeInImage(
                      image: NetworkImage(homecollectionResult
                          .collectionData![index].multipleCollectionImage
                          .toString()),
                      fit: BoxFit.fill,
                      placeholderFit: BoxFit.scaleDown,
                      placeholder: const AssetImage("assets/icons/default.png"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/icons/default.png");
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//This widget paints the Banner which is not tappable as the collection type is single and isScroll is false
class HomeCollectionSingleTypeWidget extends StatelessWidget {
  const HomeCollectionSingleTypeWidget({required this.bannerImgUrl, super.key});

  final String bannerImgUrl;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // decoration: BoxDecoration(
      //   // color: kColorTransparent,
      //   borderRadius: BorderRadius.circular(4.h),
      //   image: DecorationImage(
      //     image: NetworkImage(
      //       bannerImgUrl,
      //     ),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      child: FadeInImage(
        image: NetworkImage(bannerImgUrl),
        fit: BoxFit.fill,
        placeholderFit: BoxFit.scaleDown,
        placeholder: const AssetImage("assets/icons/default.png"),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset("assets/icons/default.png");
        },
      ),
      margin: EdgeInsets.only(
        left: 25.w,
        right: 25.w,
      ),
      width: screenWidth.w,
      height: screenWidth >= 600 ? 250.h : 200.h,
      // child: CachedNetworkImage(imageUrl:
      // bannerImgUrl,
      // fit: BoxFit.fill,
      // ),
    );
  }
}

//This stateful widget paints the objects in a carousel slider, as the isScroll is true and collection type is multiple, this widgets holds objects that can be tapped
class HomeCollectionMultipleScrollTrueCarouselWidget extends StatefulWidget {
  final homecollectionlisting.Result homecollectionResult;

  const HomeCollectionMultipleScrollTrueCarouselWidget(
      {Key? key, required this.homecollectionResult})
      : super(key: key);

  @override
  HomeCollectionMultipleScrollTrueCarouselWidgetState createState() =>
      HomeCollectionMultipleScrollTrueCarouselWidgetState();
}

//Holds the state
class HomeCollectionMultipleScrollTrueCarouselWidgetState
    extends State<HomeCollectionMultipleScrollTrueCarouselWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final homeController = Get.find<HomeController>();
  final audioListingController = Get.find<AudioListingController>();
  final videoListingController = Get.find<VideoListingController>();
  final ebooksListingController = Get.find<EbooksListingController>();
  final gurujiListingController = Get.find<GurujiListingController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    List<String?> imageUrls = widget.homecollectionResult.collectionData!
        .where((data) => data.multipleCollectionImage != '')
        .map((data) => data.multipleCollectionImage)
        .toList();

    return Container(
      color: kColorWhite,
      // padding: EdgeInsets.only(bottom: 25.h),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 7.3,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              enlargeFactor: 0.2,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: imageUrls
                .asMap()
                .entries
                .map(
                  (entry) => Center(
                    child: Container(
                      child: _currentIndex == entry.key
                          ? GestureDetector(
                              onTap: () async {
                                log("Multiple image tapped = ${widget.homecollectionResult.collectionData![_currentIndex].id}");

                                if (widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .mappedTo ==
                                        'Audio' &&
                                    widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .isClickable ==
                                        Constants
                                            .homeMultipleListingClickableTrueBoolFlag) {
                                  Utils().showLoader();

                                  audioListingController.prevScreen.value =
                                      "homeCollectionMultipleType";
                                  audioListingController.collectionId.value =
                                      widget.homecollectionResult
                                          .collectionData![_currentIndex].id
                                          .toString();
                                  audioListingController.collectionType.value =
                                      widget.homecollectionResult.type
                                          .toString();
                                  homeController.languageModel ??
                                      await homeController.getSortData();
                                  audioListingController.initializeFilter();

                                  audioListingController.audioApiCallType
                                      .value = 'fetchAudiosHomeMultipleListing';

                                  audioListingController
                                      .viewAllListingAudioTitle
                                      .value = 'Audio'.tr;

                                  await audioListingController
                                      .fetchAudiosHomeMultipleListing(
                                    token: '',
                                    // id: widget.homecollectionResult
                                    //     .collectionData![_currentIndex].id
                                    //     .toString(),
                                    // type: widget.homecollectionResult.type
                                    //     .toString(),
                                  );
                                  Get.back();
                                  if (!audioListingController
                                      .isLoadingData.value) {
                                    Get.toNamed(
                                      AppRoute.audioListingScreen,
                                      // arguments: {
                                      //   "viewAllListingAudioTitle": "Audio",
                                      // },
                                    );
                                  }
                                } else if (widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .mappedTo ==
                                        'Video' &&
                                    widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .isClickable ==
                                        Constants
                                            .homeMultipleListingClickableTrueBoolFlag) {
                                  Utils().showLoader();

                                  videoListingController.prevScreen.value =
                                      "homeCollectionMultipleType";
                                  videoListingController.collectionId.value =
                                      widget.homecollectionResult
                                          .collectionData![_currentIndex].id
                                          .toString();
                                  videoListingController.collectionType.value =
                                      widget.homecollectionResult.type
                                          .toString();

                                  homeController.languageModel ??
                                      await homeController.getSortData();
                                  videoListingController.initializeFilter();

                                  videoListingController.videoApiCallType
                                      .value = 'fetchVideosHomeMultipleListing';

                                  videoListingController
                                      .viewAllListingVideoTitle
                                      .value = 'Video'.tr;
                                  await videoListingController
                                      .fetchVideosHomeMultipleListing(
                                    token: '',
                                    // id: widget.homecollectionResult
                                    //     .collectionData![_currentIndex].id
                                    //     .toString(),
                                    // type: widget.homecollectionResult.type
                                    //     .toString(),
                                  );
                                  Get.back();
                                  if (!videoListingController
                                      .isLoadingData.value) {
                                    Get.toNamed(
                                      AppRoute.videoListingScreen,
                                      // arguments: {
                                      //   "viewAllListingVideoTitle": "Video",
                                      // },
                                    );
                                  }
                                } else if (widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .mappedTo ==
                                        'Book' &&
                                    widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .isClickable ==
                                        Constants
                                            .homeMultipleListingClickableTrueBoolFlag) {
                                  Utils().showLoader();

                                  ebooksListingController.prevScreen.value =
                                      "homeCollectionMultipleType";

                                  ebooksListingController
                                      .viewAllListingBookTitle
                                      .value = 'Books'.tr;
                                  ebooksListingController.collectionId.value =
                                      widget.homecollectionResult
                                          .collectionData![_currentIndex].id
                                          .toString();
                                  ebooksListingController.collectionType.value =
                                      widget.homecollectionResult.type
                                          .toString();

                                  homeController.languageModel ??
                                      await homeController.getSortData();
                                  ebooksListingController.initializeFilter();

                                  ebooksListingController.booksApiCallType
                                      .value = 'fetchBooksHomeMultipleListing';
                                  await ebooksListingController
                                      .fetchBooksHomeMultipleListing(
                                    token: '',
                                    // id: widget.homecollectionResult
                                    //     .collectionData![_currentIndex].id
                                    //     .toString(),
                                    // type: widget.homecollectionResult.type
                                    //     .toString(),
                                  );

                                  Get.back();

                                  if (!ebooksListingController
                                      .isLoadingData.value) {
                                    Get.toNamed(
                                      AppRoute.ebooksListingScreen,
                                      arguments: {
                                        "viewAllListingBookTitle": "Books",
                                      },
                                    );
                                  }
                                } else if (widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .mappedTo ==
                                        'Artist' &&
                                    widget
                                            .homecollectionResult
                                            .collectionData![_currentIndex]
                                            .isClickable ==
                                        Constants
                                            .homeMultipleListingClickableTrueBoolFlag) {
                                  Utils().showLoader();

                                  gurujiListingController.prevScreen.value =
                                      "homeCollectionMultipleType";

                                  gurujiListingController
                                      .viewAllListingGurujiTitle
                                      .value = "Honourable Guru Ji".tr;

                                  gurujiListingController.collectionId.value =
                                      widget.homecollectionResult
                                          .collectionData![_currentIndex].id
                                          .toString();
                                  gurujiListingController.collectionType.value =
                                      widget.homecollectionResult.type
                                          .toString();

                                  gurujiListingController.gurujiApiCallType
                                      .value = 'fetchGurujiHomeMultipleListing';

                                  await gurujiListingController
                                      .fetchGurujiHomeMultipleListing(
                                    token: '',
                                    id: widget.homecollectionResult
                                        .collectionData![_currentIndex].id
                                        .toString(),
                                    type: widget.homecollectionResult.type
                                        .toString(),
                                  );

                                  Get.back();

                                  if (!gurujiListingController
                                      .isLoadingData.value) {
                                    Get.toNamed(
                                      AppRoute.gurujiListingScreen,
                                      // arguments: {
                                      //   "viewAllListingGurujiTitle":
                                      //       "Honourable Guru Ji",
                                      // },
                                    );
                                  }
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.h),
                                child: Container(
                                  width: screenWidth,
                                  color: kColorWhite,
                                  child: FadeInImage(
                                    image: NetworkImage(entry.value!),
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
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: Container(
                                width: screenWidth,
                                color: kColorWhite,
                                child: FadeInImage(
                                  image: NetworkImage(entry.value!),
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
                            ),
                    ),
                  ),
                )
                .toList(),
          ),
          Container(
            margin: EdgeInsets.only(left: 24.w, top: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: imageUrls.asMap().entries.map((entry) {
                int index = entry.key;
                return _currentIndex == index
                    ? Container(
                        width: 12.h,
                        height: 12.h,
                        margin: const EdgeInsets.symmetric(
                          // vertical: 5.h,
                          horizontal: 2.0,
                        ),
                        decoration: const BoxDecoration(
                          color: kColorPrimary,
                          shape: BoxShape.circle,
                        ))
                    : Container(
                        width: 8.h,
                        height: 8.h,
                        margin: const EdgeInsets.symmetric(
                          // vertical: 5.h,
                          horizontal: 2.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kColorCarouselUnselected,
                        ),
                      );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

//This widget paints the books object in multiple rows(type: book, isScroll: false, and it uses display in column to display the said number of objects across the screen width, since the scroll is false, the objects are painted in multiple rows)
class HomeCollectionBookScrollFalseWidget extends StatelessWidget {
  HomeCollectionBookScrollFalseWidget({
    required this.homecollectionResult,
    super.key,
  }) {
    // Ensure the controller is initialized before accessing it
    if (!Get.isRegistered<EbookDetailsController>()) {
      Get.put(EbookDetailsController());
    }
  }

  final ebooksDetailsController = Get.find<EbookDetailsController>();
  final ebooksListingController = Get.find<EbooksListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  final int dic = 4;
  final bool isScroll = false;

  //Static For Now
  final bool viewAllIconVisible = true;

  //For Tablet Views Need to test out
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: kColorWhite,
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          GestureDetector(
            onTap: () async {
              if (viewAllIconVisible) {
                //Call the ViewAll API here
                log('Call the view all api here');

                Utils().showLoader();
                //Call Ebooklisting ViewAll API here
                ebooksListingController.prevScreen.value = "homeCollection";
                ebooksListingController.collectionId.value =
                    homecollectionResult.id.toString();
                homeController.languageModel ??
                    await homeController.getSortData();
                ebooksListingController.initializeFilter();

                ebooksListingController.booksApiCallType.value =
                    'fetchBooksHomeViewAllListing';

                ebooksListingController.viewAllListingBookTitle.value =
                    homecollectionResult.title.toString();

                await ebooksListingController.fetchBooksHomeViewAllListing(
                  // collectionBookId: homecollectionResult.id.toString(),
                  token: '',
                );

                Get.back();

                if (!ebooksListingController.isLoadingData.value) {
                  Get.toNamed(
                    AppRoute.ebooksListingScreen,
                    arguments: {
                      "viewAllListingBookTitle":
                          homecollectionResult.title!.toString(),
                    },
                  );
                }
              } else {
                log('ViewAll Flag is not Available');
              }
            },
            child: Container(
              color: kColorTransparent,
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description.toString(),
                // authorName: 'Swami Shri Adganand Ji Maharaj',
              ),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          homecollectionResult.displayInColumn == 4
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 2,
                  ),
                  itemCount: homecollectionResult
                      .collectionData!.length, // Total number of images
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await homeBookDetailsApiCall(
                            bookId: homecollectionResult
                                .collectionData![index].id
                                .toString(),
                            type: homecollectionResult.type.toString(),
                            token: '');
                      },
                      child: Column(
                        children: [
                          Container(
                            // color: Colors.red,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: SizedBox(
                                width: 150.w,
                                height: 125.h,
                                child: FadeInImage(
                                  image: NetworkImage(homecollectionResult
                                      .collectionData![index].coverImageUrl
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
                              // child: CachedNetworkImage(imageUrl:
                              //   homecollectionResult
                              //       .collectionData![index].multipleCollectionImage
                              //       .toString(),
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),

                          //Book Title
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              homecollectionResult.collectionData![index].name
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: kTextStylePoppinsMedium.copyWith(
                                fontSize: FontSize.mediaTitle.sp,
                                color: kColorFont,
                              ),
                            ),
                          ),

                          //Language Tag
                          Row(
                            children: [
                              Container(
                                // height: 18.h,
                                padding:
                                    EdgeInsets.only(left: 12.w, right: 12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.h),
                                  color:
                                      kColorFontLangaugeTag.withOpacity(0.05),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      homecollectionResult
                                          .collectionData![index].mediaLanguage
                                          .toString(),
                                      style: kTextStylePoppinsRegular.copyWith(
                                        fontSize: FontSize.mediaLanguageTags.sp,
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
                    );
                  },
                )
              : homecollectionResult.displayInColumn == 3
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 2.2,
                      ),
                      itemCount: homecollectionResult
                          .collectionData!.length, // Total number of images
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await homeBookDetailsApiCall(
                                bookId: homecollectionResult
                                    .collectionData![index].id
                                    .toString(),
                                type: homecollectionResult.type.toString(),
                                token: '');
                          },
                          child: Column(
                            children: [
                              Container(
                                // color: Colors.red,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.h),
                                  child: SizedBox(
                                    width: 150.w,
                                    height: 170.h,
                                    child: FadeInImage(
                                      image: NetworkImage(homecollectionResult
                                          .collectionData![index].coverImageUrl
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
                                  // child: CachedNetworkImage(imageUrl:
                                  //   homecollectionResult
                                  //       .collectionData![index].multipleCollectionImage
                                  //       .toString(),
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              //Book Title
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  homecollectionResult
                                      .collectionData![index].name
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: kTextStylePoppinsMedium.copyWith(
                                    fontSize: FontSize.mediaTitle.sp,
                                    color: kColorFont,
                                  ),
                                ),
                              ),

                              //Language Tag
                              Row(
                                children: [
                                  Container(
                                    // height: 18.h,
                                    padding: EdgeInsets.only(
                                        left: 12.w, right: 12.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.h),
                                      color: kColorFontLangaugeTag
                                          .withOpacity(0.05),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          homecollectionResult
                                              .collectionData![index]
                                              .mediaLanguage
                                              .toString(),
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            fontSize:
                                                FontSize.mediaLanguageTags.sp,
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
                        );
                      },
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 15.w,
                            mainAxisSpacing: 15.h,
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.85,
                          ),
                          itemCount: homecollectionResult
                              .collectionData!.length, // Total number of images
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await homeBookDetailsApiCall(
                                    bookId: homecollectionResult
                                        .collectionData![index].id
                                        .toString(),
                                    type: homecollectionResult.type.toString(),
                                    token: '');
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.h),
                                    child: SizedBox(
                                      width: 280.w,
                                      height: 245.h,
                                      child: FadeInImage(
                                        image: NetworkImage(homecollectionResult
                                            .collectionData![index]
                                            .coverImageUrl
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
                                    // child: CachedNetworkImage(imageUrl:
                                    //   homecollectionResult
                                    //       .collectionData![index].multipleCollectionImage
                                    //       .toString(),
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  //Book Title
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      homecollectionResult
                                          .collectionData![index].name
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize: FontSize.mediaTitle.sp,
                                        color: kColorFont,
                                      ),
                                    ),
                                  ),

                                  //Language Tag
                                  Row(
                                    children: [
                                      Container(
                                        // height: 18.h,
                                        padding: EdgeInsets.only(
                                            left: 12.w, right: 12.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          color: kColorFontLangaugeTag
                                              .withOpacity(0.05),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .mediaLanguage
                                                  .toString(),
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                fontSize: FontSize
                                                    .mediaLanguageTags.sp,
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
                            );
                          },
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 15.w,
                                mainAxisSpacing: 15.h,
                                crossAxisCount: 1,
                                childAspectRatio: 1 / 1.65,
                              ),
                              itemCount: homecollectionResult.collectionData!
                                  .length, // Total number of images
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await homeBookDetailsApiCall(
                                        bookId: homecollectionResult
                                            .collectionData![index].id
                                            .toString(),
                                        type: homecollectionResult.type
                                            .toString(),
                                        token: '');
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        // color: Colors.red,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          child: SizedBox(
                                            width: 410.w,
                                            height: 570.h,
                                            child: FadeInImage(
                                              image: NetworkImage(
                                                  homecollectionResult
                                                      .collectionData![index]
                                                      .coverImageUrl
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
                                          // child: CachedNetworkImage(imageUrl:
                                          //   homecollectionResult
                                          //       .collectionData![index].multipleCollectionImage
                                          //       .toString(),
                                          //   fit: BoxFit.fill,
                                          // ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      //Book Title
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          homecollectionResult
                                              .collectionData![index].name
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style:
                                              kTextStylePoppinsMedium.copyWith(
                                            fontSize: FontSize.mediaTitle.sp,
                                            color: kColorFont,
                                          ),
                                        ),
                                      ),

                                      //Language Tag
                                      Row(
                                        children: [
                                          Container(
                                            // height: 18.h,
                                            padding: EdgeInsets.only(
                                                left: 12.w, right: 12.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                              color: kColorFontLangaugeTag
                                                  .withOpacity(0.05),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  homecollectionResult
                                                      .collectionData![index]
                                                      .mediaLanguage
                                                      .toString(),
                                                  style:
                                                      kTextStylePoppinsRegular
                                                          .copyWith(
                                                    fontSize: FontSize
                                                        .mediaLanguageTags.sp,
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
                                );
                              },
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeBookDetailsApiCall(
      {required String bookId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      log("Ebookdetails home called");
      Utils().showLoader();

      //Call Ebookhomedetails API here
      await ebooksDetailsController.fetchEbookHomeCollectionDetails(
        token: token,
        bookId: bookId,
        type: type,
      );

      Get.back();

      if (!ebooksDetailsController.isLoadingData.value) {
        Get.toNamed(AppRoute.ebookDetailsScreen);
      } else {
        Utils.customToast("Something went wrong", kRedColor,
            kRedColor.withOpacity(0.2), "error");
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This widget paints the books object in a single row(type: book, isScroll: true, and it uses display in column to display the said number of objects across the screen width, since the scroll is true, the objects are painted in a single row)
class HomeCollectionBookScrollTrueWidget extends StatelessWidget {
  HomeCollectionBookScrollTrueWidget({
    required this.homecollectionResult,
    super.key,
  });

  final ebooksDetailsController = Get.find<EbookDetailsController>();
  final ebooksListingController = Get.find<EbooksListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  final int dic = 1;

  //Static For Now
  final bool viewAllIconVisible = true;

  //For Tablet Views Need to test out

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // alignment: Alignment.centerLeft,
      color: kColorWhite,
      child: Column(
        children: [
          //Heading
          GestureDetector(
            onTap: () async {
              //  Utils().showLoader();
              //             //Call Ebooklisting ViewAll API here
              //             var homeController = Get.find<HomeController>();
              //             var ebooksListingController =
              //                 Get.find<EbooksListingController>();
              // ebooksListingController.prevScreen.value =
              //     "collection";
              // ebooksListingController.collectionId.value =
              //     e.id.toString();
              //             homeController.languageModel ??
              //                 await homeController.getSortData();
              //             ebooksListingController.initializeFilter();
              //             await ebooksListingController
              //                 .fetchBooksExploreViewAllListing(
              //               collectionBookId: e.id.toString(),
              //               token: '',
              //             );

              //             Get.back();

              //             if (!ebooksListingController.isLoadingData.value) {
              //               Get.toNamed(AppRoute.ebooksListingScreen);
              //             }
              if (viewAllIconVisible) {
                //Call the ViewAll API here
                log('Call the view all api here');

                Utils().showLoader();
                //Call Ebooklisting ViewAll API here
                ebooksListingController.prevScreen.value = "homeCollection";
                ebooksListingController.collectionId.value =
                    homecollectionResult.id.toString();
                homeController.languageModel ??
                    await homeController.getSortData();
                ebooksListingController.initializeFilter();

                ebooksListingController.booksApiCallType.value =
                    'fetchBooksHomeViewAllListing';

                ebooksListingController.viewAllListingBookTitle.value =
                    homecollectionResult.title.toString();

                await ebooksListingController.fetchBooksHomeViewAllListing(
                  // collectionBookId: homecollectionResult.id.toString(),
                  token: '',
                );

                Get.back();

                if (!ebooksListingController.isLoadingData.value) {
                  Get.toNamed(
                    AppRoute.ebooksListingScreen,
                    arguments: {
                      "viewAllListingBookTitle":
                          homecollectionResult.title!.toString(),
                    },
                  );
                }
              } else {
                log('ViewAll Flag is not Available');
              }
            },
            child: Container(
              // color: kColorTransparent,
              color: kColorTransparent,
              padding: EdgeInsets.only(
                  top: 25.h, left: 25.w, right: 25.w, bottom: 5.h),
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/satiya_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description!.toString(),
                // authorName: 'Swami Shri Adganand Ji Maharaj',
              ),
            ),
          ),

          // SizedBox(
          //   height: 25.h,
          // ),

          homecollectionResult.displayInColumn == 4
              ? Container(
                  alignment: Alignment.centerLeft,
                  height: screenWidth >= 600 ? 320.h : 245.h,
                  // color: Colors.blue,

                  // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                  margin: EdgeInsets.only(
                    top: 15.h,
                    bottom: 15.h,
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    // physics: const BouncingScrollPhysics(),

                    itemCount: homecollectionResult
                        .collectionData!.length, // Total number of images
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await homeBookDetailsApiCall(
                              bookId: homecollectionResult
                                  .collectionData![index].id
                                  .toString(),
                              type: homecollectionResult.type.toString(),
                              token: '');
                        },
                        child: Container(
                          // color: Colors.yellow,
                          child: AspectRatio(
                            aspectRatio: 1.2 / 3.2,
                            child: Column(
                              children: [
                                Container(
                                  // color: Colors.red,
                                  child: //Cover Image
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(4.h),
                                    child: SizedBox(
                                      width: 150.w,
                                      height: 125.h,
                                      child: FadeInImage(
                                        image: NetworkImage(homecollectionResult
                                            .collectionData![index]
                                            .coverImageUrl
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
                                  ),
                                ),

                                SizedBox(
                                  height: 5.h,
                                ),

                                //Book Title
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    homecollectionResult
                                        .collectionData![index].name
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: kTextStylePoppinsMedium.copyWith(
                                      fontSize: FontSize.mediaTitle.sp,
                                      color: kColorFont,
                                    ),
                                  ),
                                ),

                                //Language Tag
                                Row(
                                  children: [
                                    Container(
                                      // height: 18.h,
                                      padding: EdgeInsets.only(
                                          left: 12.w, right: 12.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                        color: kColorFontLangaugeTag
                                            .withOpacity(0.05),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            homecollectionResult
                                                .collectionData![index]
                                                .mediaLanguage
                                                .toString(),
                                            style: kTextStylePoppinsRegular
                                                .copyWith(
                                              fontSize:
                                                  FontSize.mediaLanguageTags.sp,
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
                        ),
                      );
                    },

                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 15.w,
                      );
                    },
                  ),
                )
              : homecollectionResult.displayInColumn == 3
                  ? Container(
                      alignment: Alignment.centerLeft,

                      height: screenWidth >= 600 ? 320.h : 256.h,
                      // color: Colors.blue,
                      // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                      margin: EdgeInsets.only(
                        top: 15.h,
                        bottom: 15.h,
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 25.w, right: 25.w),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // physics: const BouncingScrollPhysics(),

                        itemCount: homecollectionResult
                            .collectionData!.length, // Total number of images
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await homeBookDetailsApiCall(
                                  bookId: homecollectionResult
                                      .collectionData![index].id
                                      .toString(),
                                  type: homecollectionResult.type.toString(),
                                  token: '');
                            },
                            child: AspectRatio(
                              aspectRatio: 1.2 / 2.4,

                              // aspectRatio: 1 / 2.21, //DIC value: 3
                              // aspectRatio: 1 / 1.875, //DIC value: 2
                              // aspectRatio: 1 / 1.875, //DIC value: 1

                              child: Column(
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    child: //Cover Image
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(4.h),
                                      child: SizedBox(
                                        width: 150.w,
                                        height: 170.h,
                                        child: FadeInImage(
                                          image: NetworkImage(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .coverImageUrl
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
                                    ),
                                  ),

                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  //Book Title
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      homecollectionResult
                                          .collectionData![index].name
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize: FontSize.mediaTitle.sp,
                                        color: kColorFont,
                                      ),
                                    ),
                                  ),

                                  //Language Tag
                                  Row(
                                    children: [
                                      Container(
                                        // height: 18.h,
                                        padding: EdgeInsets.only(
                                            left: 12.w, right: 12.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          color: kColorFontLangaugeTag
                                              .withOpacity(0.05),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .mediaLanguage
                                                  .toString(),
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                fontSize: FontSize
                                                    .mediaLanguageTags.sp,
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
                          );
                        },

                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 15.w,
                          );
                        },
                      ),
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? Container(
                          alignment: Alignment.centerLeft,

                          height: screenWidth >= 600 ? 320.h : 330.h,
                          // color: Colors.blue,
                          // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                          margin: EdgeInsets.only(
                            top: 15.h,
                            bottom: 15.h,
                          ),
                          child: ListView.separated(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            // physics: const BouncingScrollPhysics(),

                            itemCount: homecollectionResult.collectionData!
                                .length, // Total number of images
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await homeBookDetailsApiCall(
                                      bookId: homecollectionResult
                                          .collectionData![index].id
                                          .toString(),
                                      type:
                                          homecollectionResult.type.toString(),
                                      token: '');
                                },
                                child: Container(
                                  // color: Colors.yellow,
                                  child: AspectRatio(
                                    aspectRatio: 1.2 / 1.97,

                                    // aspectRatio: 1 / 2.21, //DIC value: 3
                                    // aspectRatio: 1 / 1.875, //DIC value: 2
                                    // aspectRatio: 1 / 1.875, //DIC value: 1

                                    child: Column(
                                      children: [
                                        Container(
                                          // color: Colors.red,
                                          child: //Cover Image
                                              ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.h),
                                            child: SizedBox(
                                              width: 280.w,
                                              height: 245.h,
                                              child: FadeInImage(
                                                image: NetworkImage(
                                                    homecollectionResult
                                                        .collectionData![index]
                                                        .coverImageUrl
                                                        .toString()),
                                                fit: BoxFit.fill,
                                                placeholderFit:
                                                    BoxFit.scaleDown,
                                                placeholder: const AssetImage(
                                                    "assets/icons/default.png"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      "assets/icons/default.png");
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 5.h,
                                        ),

                                        //Book Title
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            homecollectionResult
                                                .collectionData![index].name
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: kTextStylePoppinsMedium
                                                .copyWith(
                                              fontSize: FontSize.mediaTitle.sp,
                                              color: kColorFont,
                                            ),
                                          ),
                                        ),

                                        //Language Tag
                                        Row(
                                          children: [
                                            Container(
                                              // height: 18.h,
                                              padding: EdgeInsets.only(
                                                  left: 12.w, right: 12.w),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4.h),
                                                color: kColorFontLangaugeTag
                                                    .withOpacity(0.05),
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    homecollectionResult
                                                        .collectionData![index]
                                                        .mediaLanguage
                                                        .toString(),
                                                    style:
                                                        kTextStylePoppinsRegular
                                                            .copyWith(
                                                      fontSize: FontSize
                                                          .mediaLanguageTags.sp,
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
                                  ),
                                ),
                              );
                            },

                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 15.w,
                              );
                            },
                          ),
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? Container(
                              alignment: Alignment.centerLeft,

                              height: screenWidth >= 600 ? 320.h : 630.h,
                              // color: Colors.blue,
                              // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                              margin: EdgeInsets.only(
                                top: 15.h,
                                bottom: 15.h,
                              ),
                              child: ListView.separated(
                                padding:
                                    EdgeInsets.only(left: 25.w, right: 25.w),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                // physics: const BouncingScrollPhysics(),

                                itemCount: homecollectionResult.collectionData!
                                    .length, // Total number of images
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await homeBookDetailsApiCall(
                                          bookId: homecollectionResult
                                              .collectionData![index].id
                                              .toString(),
                                          type: homecollectionResult.type
                                              .toString(),
                                          token: '');
                                    },
                                    child: Container(
                                      // color: Colors.yellow,
                                      child: AspectRatio(
                                        aspectRatio: 1.2 / 1.86,

                                        // aspectRatio: 1 / 2.21, //DIC value: 3
                                        // aspectRatio: 1 / 1.875, //DIC value: 2
                                        // aspectRatio: 1 / 1.875, //DIC value: 1

                                        child: Column(
                                          children: [
                                            Container(
                                              // color: Colors.red,
                                              child: //Cover Image
                                                  ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.h),
                                                child: SizedBox(
                                                  width: 410.w,
                                                  height: 570.h,
                                                  child: FadeInImage(
                                                    image: NetworkImage(
                                                        homecollectionResult
                                                            .collectionData![
                                                                index]
                                                            .coverImageUrl
                                                            .toString()),
                                                    fit: BoxFit.fill,
                                                    placeholderFit:
                                                        BoxFit.scaleDown,
                                                    placeholder: const AssetImage(
                                                        "assets/icons/default.png"),
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                          "assets/icons/default.png");
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              height: 5.h,
                                            ),

                                            //Book Title
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                homecollectionResult
                                                    .collectionData![index].name
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: kTextStylePoppinsMedium
                                                    .copyWith(
                                                  fontSize:
                                                      FontSize.mediaTitle.sp,
                                                  color: kColorFont,
                                                ),
                                              ),
                                            ),

                                            //Language Tag
                                            Row(
                                              children: [
                                                Container(
                                                  // height: 18.h,
                                                  padding: EdgeInsets.only(
                                                      left: 12.w, right: 12.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.h),
                                                    color: kColorFontLangaugeTag
                                                        .withOpacity(0.05),
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        homecollectionResult
                                                            .collectionData![
                                                                index]
                                                            .mediaLanguage
                                                            .toString(),
                                                        style:
                                                            kTextStylePoppinsRegular
                                                                .copyWith(
                                                          fontSize: FontSize
                                                              .mediaLanguageTags
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
                                      ),
                                    ),
                                  );
                                },

                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 15.w,
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeBookDetailsApiCall(
      {required String bookId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      log("Ebookdetails home called");
      Utils().showLoader();

      //Call Ebookhomedetails API here
      await ebooksDetailsController.fetchEbookHomeCollectionDetails(
        token: token,
        bookId: bookId,
        type: type,
      );

      Get.back();

      if (!ebooksDetailsController.isLoadingData.value) {
        Get.toNamed(AppRoute.ebookDetailsScreen);
      } else {
        Utils.customToast("Something went wrong", kRedColor,
            kRedColor.withOpacity(0.2), "error");
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This widget paints the videos object in multiple rows(type: video, isScroll: false, and it uses display in column to display the said number of objects across the screen width, since the scroll is false, the objects are painted in multiple rows)
class HomeCollectionVideoScrollFalseWidget extends StatelessWidget {
  HomeCollectionVideoScrollFalseWidget(
      {required this.homecollectionResult, super.key});

  final videoDetailsController = Get.find<VideoDetailsController>();
  final videoListingController = Get.find<VideoListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  final int dic = 4;

  //Static For Now
  final bool viewAllIconVisible = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: kColorWhite,
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          GestureDetector(
            onTap: () async {
              Utils().showLoader();
              videoListingController.prevScreen.value = "homeCollection";
              videoListingController.collectionId.value =
                  homecollectionResult.id.toString();
              homeController.languageModel ??
                  await homeController.getSortData();
              videoListingController.initializeFilter();

              videoListingController.videoApiCallType.value =
                  'fetchVideoHomeViewAllListing';

              videoListingController.viewAllListingVideoTitle.value =
                  homecollectionResult.title.toString();

              await videoListingController.fetchVideoHomeViewAllListing(
                token: '',
                // collectionVideoId: homecollectionResult.id.toString(),
              );
              Get.back();
              if (!videoListingController.isLoadingData.value) {
                Get.toNamed(
                  AppRoute.videoListingScreen,
                  arguments: {
                    "viewAllListingVideoTitle":
                        homecollectionResult.title!.toString(),
                  },
                );
              }
            },
            child: Container(
              color: kColorTransparent,
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description!.toString(),
                // authorName: 'Swami Shri Adganand Ji Maharaj',
              ),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          homecollectionResult.displayInColumn == 4
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 1.65,
                  ),
                  itemCount: homecollectionResult
                      .collectionData!.length, // Total number of images
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await homeVideoDetailsApiCall(
                            videoId: homecollectionResult
                                .collectionData![index].id
                                .toString(),
                            type: homecollectionResult.type.toString(),
                            token: '');
                      },
                      child: Container(
                        child: Stack(
                          children: [
                            SizedBox(
                              width: screenWidth >= 600 ? 200.w : 200.w,
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.purple,
                                    width: 200.w,
                                    height: screenWidth >= 600 ? 80.h : 60.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.h),
                                      child: FadeInImage(
                                        image: NetworkImage(homecollectionResult
                                            .collectionData![index]
                                            .coverImageUrl
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
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Text(
                                    homecollectionResult
                                        .collectionData![index].title
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: kTextStylePoppinsMedium.copyWith(
                                      fontSize: screenWidth >= 600
                                          ? FontSize.mediaTitle.sp - 5
                                          : FontSize.mediaTitle.sp - 2,
                                      color: kColorFont,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),

                                  //Language Tag
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 5.w, right: 5.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          color: kColorFontLangaugeTag
                                              .withOpacity(0.05),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            fontSize:
                                                FontSize.mediaLanguageTags.sp,
                                            color: kColorFontLangaugeTag,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: screenWidth >= 600 ? 100.h : 68.h,
                              right: 8.w,
                              child: SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: Image.asset(
                                    'assets/images/home/video_icon.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : homecollectionResult.displayInColumn == 3
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        crossAxisCount: 3,
                        childAspectRatio:
                            screenWidth >= 600 ? 1 / 1.3 : 1 / 1.45,
                      ),
                      itemCount: homecollectionResult
                          .collectionData!.length, // Total number of images
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await homeVideoDetailsApiCall(
                                videoId: homecollectionResult
                                    .collectionData![index].id
                                    .toString(),
                                type: homecollectionResult.type.toString(),
                                token: '');
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: screenWidth >= 600 ? 200.w : 200.w,
                                  // color: Colors.red,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200.w,
                                        height:
                                            screenWidth >= 600 ? 100.h : 90.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          child: FadeInImage(
                                            image: NetworkImage(
                                                homecollectionResult
                                                    .collectionData![index]
                                                    .coverImageUrl
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
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Text(
                                        homecollectionResult
                                            .collectionData![index].title
                                            .toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStylePoppinsMedium.copyWith(
                                          fontSize: screenWidth >= 600
                                              ? FontSize.mediaTitle.sp - 5
                                              : FontSize.mediaTitle.sp - 1,
                                          color: kColorFont,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),

                                      //Language Tag
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 12.w, right: 12.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                              color: kColorFontLangaugeTag
                                                  .withOpacity(0.05),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                fontSize: screenWidth >= 600
                                                    ? FontSize.mediaLanguageTags
                                                            .sp -
                                                        11.5
                                                    : FontSize.mediaLanguageTags
                                                            .sp -
                                                        1.5,
                                                color: kColorFontLangaugeTag,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: screenWidth >= 600 ? 95.h : 72.h,
                                  right: 8.w,
                                  child: SizedBox(
                                    height: 26.h,
                                    width: 26.h,
                                    child: Image.asset(
                                        'assets/images/home/video_icon.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 15.w,
                            mainAxisSpacing: 15.h,
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.1,
                          ),
                          itemCount: homecollectionResult
                              .collectionData!.length, // Total number of images
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await homeVideoDetailsApiCall(
                                    videoId: homecollectionResult
                                        .collectionData![index].id
                                        .toString(),
                                    type: homecollectionResult.type.toString(),
                                    token: '');
                              },
                              child: Container(
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: screenWidth >= 600 ? 200.w : 200.w,
                                      // color: Colors.red,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200.w,
                                            height: screenWidth >= 600
                                                ? 150.h
                                                : 125.h,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                              child: FadeInImage(
                                                image: NetworkImage(
                                                    homecollectionResult
                                                        .collectionData![index]
                                                        .coverImageUrl
                                                        .toString()),
                                                fit: BoxFit.fill,
                                                placeholderFit:
                                                    BoxFit.scaleDown,
                                                placeholder: const AssetImage(
                                                    "assets/icons/default.png"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      "assets/icons/default.png");
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenWidth >= 600
                                                ? 18.h
                                                : 12.h,
                                          ),
                                          Text(
                                            homecollectionResult
                                                .collectionData![index].title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: kTextStylePoppinsMedium
                                                .copyWith(
                                              fontSize: FontSize.mediaTitle.sp,
                                              color: kColorFont,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),

                                          //Language Tag
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 12.w, right: 12.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.h),
                                                  color: kColorFontLangaugeTag
                                                      .withOpacity(0.05),
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                                  style:
                                                      kTextStylePoppinsRegular
                                                          .copyWith(
                                                    fontSize: screenWidth >= 600
                                                        ? FontSize
                                                                .mediaLanguageTags
                                                                .sp -
                                                            3
                                                        : FontSize
                                                            .mediaLanguageTags
                                                            .sp,
                                                    color:
                                                        kColorFontLangaugeTag,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: screenWidth >= 600 ? 112.h : 59.h,
                                      right: 8.w,
                                      child: SizedBox(
                                        height: 32.h,
                                        width: 32.h,
                                        child: Image.asset(
                                            'assets/images/home/video_icon.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? Container(
                              // color: Colors.green,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 15.w,
                                  mainAxisSpacing: 15.h,
                                  crossAxisCount: 1,
                                  childAspectRatio: 1 / 0.93,
                                ),
                                itemCount: homecollectionResult.collectionData!
                                    .length, // Total number of images
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await homeVideoDetailsApiCall(
                                          videoId: homecollectionResult
                                              .collectionData![index].id
                                              .toString(),
                                          type: homecollectionResult.type
                                              .toString(),
                                          token: '');
                                    },
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: screenWidth >= 600
                                                ? screenWidth.w
                                                : screenWidth.w,
                                            // color: Colors.red,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  // width: 200.w,
                                                  height: screenWidth >= 600
                                                      ? 406.h
                                                      : 285.h,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.h),
                                                    child: FadeInImage(
                                                      image: NetworkImage(
                                                          homecollectionResult
                                                              .collectionData![
                                                                  index]
                                                              .coverImageUrl
                                                              .toString()),
                                                      fit: BoxFit.fill,
                                                      placeholderFit:
                                                          BoxFit.scaleDown,
                                                      placeholder: const AssetImage(
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
                                                SizedBox(
                                                  height: 12.h,
                                                ),
                                                Text(
                                                  homecollectionResult
                                                      .collectionData![index]
                                                      .title
                                                      .toString(),
                                                  maxLines: screenWidth >= 600
                                                      ? 1
                                                      : 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kTextStylePoppinsMedium
                                                      .copyWith(
                                                    fontSize:
                                                        FontSize.mediaTitle.sp,
                                                    color: kColorFont,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),

                                                //Language Tag
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12.w,
                                                          right: 12.w),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.h),
                                                        color:
                                                            kColorFontLangaugeTag
                                                                .withOpacity(
                                                                    0.05),
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                                        style:
                                                            kTextStylePoppinsRegular
                                                                .copyWith(
                                                          fontSize: FontSize
                                                              .mediaLanguageTags
                                                              .sp,
                                                          color:
                                                              kColorFontLangaugeTag,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: screenWidth >= 600
                                                ? 68.h
                                                : 50.h,
                                            right: 8.w,
                                            child: SizedBox(
                                              height: 32.h,
                                              width: 32.h,
                                              child: Image.asset(
                                                  'assets/images/home/video_icon.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeVideoDetailsApiCall(
      {required String videoId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      log("Videodetails home called");
      Utils().showLoader();

      //Call VideoDetailshomedetails API here
      await videoDetailsController.fetchVideoHomeCollectionDetails(
        token: token,
        videoId: videoId,
        type: type,
      );

      Get.back();

      if (!videoDetailsController.isLoadingData.value) {
        Get.toNamed(AppRoute.videoDetailsScreen);
      } else {
        Utils.customToast("Something went wrong", kRedColor,
            kRedColor.withOpacity(0.2), "error");
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This widget paints the videos object in a single row(type: video, isScroll: true, and it uses display in column to display the said number of objects across the screen width, since the scroll is true, the objects are painted in a single row)
class HomeCollectionVideoScrollTrueWidget extends StatelessWidget {
  HomeCollectionVideoScrollTrueWidget(
      {required this.homecollectionResult, super.key});

  final videoDetailsController = Get.find<VideoDetailsController>();
  final videoListingController = Get.find<VideoListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  final int dic = 1;

  //Static For Now
  final bool viewAllIconVisible = true;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: kColorWhite,
      padding: EdgeInsets.only(bottom: 25.h),
      child: Column(
        children: [
          //Heading
          GestureDetector(
            onTap: () async {
              Utils().showLoader();
              videoListingController.prevScreen.value = "homeCollection";
              videoListingController.collectionId.value =
                  homecollectionResult.id.toString();
              homeController.languageModel ??
                  await homeController.getSortData();
              videoListingController.initializeFilter();

              videoListingController.videoApiCallType.value =
                  'fetchVideoHomeViewAllListing';

              videoListingController.viewAllListingVideoTitle.value =
                  homecollectionResult.title.toString();

              await videoListingController.fetchVideoHomeViewAllListing(
                token: '',
                // collectionVideoId: homecollectionResult.id.toString(),
              );
              Get.back();
              if (!videoListingController.isLoadingData.value) {
                Get.toNamed(
                  AppRoute.videoListingScreen,
                  arguments: {
                    "viewAllListingVideoTitle":
                        homecollectionResult.title!.toString(),
                  },
                );
              }
            },
            child: Container(
              color: kColorTransparent,
              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h),
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description!.toString(),
                // authorName: 'Swami Shri Adganand Ji Maharaj',
              ),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          homecollectionResult.displayInColumn == 4
              ? Container(
                  alignment: Alignment.centerLeft,
                  height: screenWidth >= 600 ? 220.h : 185.h,
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await homeVideoDetailsApiCall(
                              videoId: homecollectionResult
                                  .collectionData![index].id
                                  .toString(),
                              type: homecollectionResult.type.toString(),
                              token: '');
                        },
                        child: Container(
                          child: Stack(
                            children: [
                              SizedBox(
                                width: screenWidth >= 600
                                    ? 160.w
                                    : screenWidth / 4 - 18.w,
                                // color: Colors.red,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200.w,
                                      height: 70.h,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                        child: FadeInImage(
                                          image: NetworkImage(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .coverImageUrl
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
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      homecollectionResult
                                          .collectionData![index].title
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize: FontSize.mediaTitle.sp,
                                        color: kColorFont,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),

                                    //Language Tag
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 5.w, right: 5.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.h),
                                            color: kColorFontLangaugeTag
                                                .withOpacity(0.05),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                            style: kTextStylePoppinsRegular
                                                .copyWith(
                                              fontSize: width >= 600
                                                  ? FontSize.mediaLanguageTags
                                                          .sp -
                                                      6.5
                                                  : FontSize.mediaLanguageTags
                                                          .sp -
                                                      1.5,
                                              color: kColorFontLangaugeTag,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: screenWidth >= 600 ? 110.h : 103.h,
                                right: 8.w,
                                child: SizedBox(
                                  height: 26.h,
                                  width: 26.h,
                                  child: Image.asset(
                                      'assets/images/home/video_icon.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 16.w,
                      );
                    },
                    itemCount: homecollectionResult.collectionData!.length,
                  ),
                )
              : homecollectionResult.displayInColumn == 3
                  ? Container(
                      alignment: Alignment.centerLeft,
                      height: screenWidth >= 600 ? 220.h : 185.h,
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 25.w, right: 25.w),
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await homeVideoDetailsApiCall(
                                  videoId: homecollectionResult
                                      .collectionData![index].id
                                      .toString(),
                                  type: homecollectionResult.type.toString(),
                                  token: '');
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: screenWidth >= 600
                                        ? 160.w
                                        : (screenWidth / 3) - 19.w,
                                    // color: Colors.red,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200.w,
                                          height: 90.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.h),
                                            child: FadeInImage(
                                              image: NetworkImage(
                                                  homecollectionResult
                                                      .collectionData![index]
                                                      .coverImageUrl
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
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          homecollectionResult
                                              .collectionData![index].title
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style:
                                              kTextStylePoppinsMedium.copyWith(
                                            fontSize: FontSize.mediaTitle.sp,
                                            color: kColorFont,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),

                                        //Language Tag
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 12.w, right: 12.w),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4.h),
                                                color: kColorFontLangaugeTag
                                                    .withOpacity(0.05),
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                                style: kTextStylePoppinsRegular
                                                    .copyWith(
                                                  fontSize: width >= 600
                                                      ? FontSize
                                                              .mediaLanguageTags
                                                              .sp -
                                                          6.5
                                                      : FontSize
                                                              .mediaLanguageTags
                                                              .sp -
                                                          1.5,
                                                  color: kColorFontLangaugeTag,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: screenWidth >= 600 ? 110.h : 85.h,
                                    right: 8.w,
                                    child: SizedBox(
                                      height: 26.h,
                                      width: 26.h,
                                      child: Image.asset(
                                          'assets/images/home/video_icon.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 16.w,
                          );
                        },
                        itemCount: homecollectionResult.collectionData!.length,
                      ),
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? Container(
                          alignment: Alignment.centerLeft,
                          height: screenWidth >= 600 ? 250.h : 210.h,
                          child: ListView.separated(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await homeVideoDetailsApiCall(
                                      videoId: homecollectionResult
                                          .collectionData![index].id
                                          .toString(),
                                      type:
                                          homecollectionResult.type.toString(),
                                      token: '');
                                },
                                child: Container(
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width:
                                            screenWidth >= 600 ? 160.w : 195.w,
                                        // color: Colors.red,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 200.w,
                                              height: 125.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.h),
                                                child: FadeInImage(
                                                  image: NetworkImage(
                                                      homecollectionResult
                                                          .collectionData![
                                                              index]
                                                          .coverImageUrl
                                                          .toString()),
                                                  fit: BoxFit.fill,
                                                  placeholderFit:
                                                      BoxFit.scaleDown,
                                                  placeholder: const AssetImage(
                                                      "assets/icons/default.png"),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                        "assets/icons/default.png");
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            Text(
                                              homecollectionResult
                                                  .collectionData![index].title
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStylePoppinsMedium
                                                  .copyWith(
                                                fontSize:
                                                    FontSize.mediaTitle.sp,
                                                color: kColorFont,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),

                                            //Language Tag
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 12.w, right: 12.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.h),
                                                    color: kColorFontLangaugeTag
                                                        .withOpacity(0.05),
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                                    style:
                                                        kTextStylePoppinsRegular
                                                            .copyWith(
                                                      fontSize: width >= 600
                                                          ? FontSize
                                                                  .mediaLanguageTags
                                                                  .sp -
                                                              6.5
                                                          : FontSize
                                                                  .mediaLanguageTags
                                                                  .sp -
                                                              1.5.sp,
                                                      color:
                                                          kColorFontLangaugeTag,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom:
                                            screenWidth >= 600 ? 110.h : 70.h,
                                        right: 8.w,
                                        child: SizedBox(
                                          height: 32.h,
                                          width: 32.h,
                                          child: Image.asset(
                                              'assets/images/home/video_icon.png'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 16.w,
                              );
                            },
                            itemCount:
                                homecollectionResult.collectionData!.length,
                          ),
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? Container(
                              alignment: Alignment.centerLeft,
                              height: screenWidth >= 600 ? 250.h : 310.h,
                              child: ListView.separated(
                                padding:
                                    EdgeInsets.only(left: 25.w, right: 25.w),
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await homeVideoDetailsApiCall(
                                          videoId: homecollectionResult
                                              .collectionData![index].id
                                              .toString(),
                                          type: homecollectionResult.type
                                              .toString(),
                                          token: '');
                                    },
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: screenWidth >= 600
                                                ? 160.w
                                                : 405.w,
                                            // color: Colors.yellow,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: screenWidth >= 600
                                                      ? 160.w
                                                      : 405.w,
                                                  height: 250.h,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.h),
                                                    child: FadeInImage(
                                                      image: NetworkImage(
                                                          homecollectionResult
                                                              .collectionData![
                                                                  index]
                                                              .coverImageUrl
                                                              .toString()),
                                                      fit: BoxFit.fill,
                                                      placeholderFit:
                                                          BoxFit.scaleDown,
                                                      placeholder: const AssetImage(
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
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Text(
                                                  homecollectionResult
                                                      .collectionData![index]
                                                      .title
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: kTextStylePoppinsMedium
                                                      .copyWith(
                                                    fontSize:
                                                        FontSize.mediaTitle.sp,
                                                    color: kColorFont,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),

                                                //Language Tag
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12.w,
                                                          right: 12.w),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.h),
                                                        color:
                                                            kColorFontLangaugeTag
                                                                .withOpacity(
                                                                    0.05),
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                                        style:
                                                            kTextStylePoppinsRegular
                                                                .copyWith(
                                                          fontSize: width >= 600
                                                              ? FontSize
                                                                      .mediaLanguageTags
                                                                      .sp -
                                                                  6.5
                                                              : FontSize
                                                                      .mediaLanguageTags
                                                                      .sp -
                                                                  1.5,
                                                          color:
                                                              kColorFontLangaugeTag,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: screenWidth >= 600
                                                ? 110.h
                                                : 45.h,
                                            right: 8.w,
                                            child: SizedBox(
                                              height: 32.h,
                                              width: 32.h,
                                              child: Image.asset(
                                                  'assets/images/home/video_icon.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 16.w,
                                  );
                                },
                                itemCount:
                                    homecollectionResult.collectionData!.length,
                              ),
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeVideoDetailsApiCall(
      {required String videoId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      log("Videodetails home called");
      Utils().showLoader();

      //Call VideoDetailshomedetails API here
      await videoDetailsController.fetchVideoHomeCollectionDetails(
        token: token,
        videoId: videoId,
        type: type,
      );

      Get.back();

      if (!videoDetailsController.isLoadingData.value) {
        Get.toNamed(AppRoute.videoDetailsScreen);
      } else {
        Utils.customToast("Something went wrong", kRedColor,
            kRedColor.withOpacity(0.2), "error");
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This widget paints the artist/guruji object in multiple rows(type: artist, isScroll: false, and it uses display in column to display the said number of objects across the screen width, since the scroll is false, the objects are painted in multiple rows)
class HomeCollectionArtistScrollFalseWidget extends StatelessWidget {
  HomeCollectionArtistScrollFalseWidget(
      {required this.homecollectionResult, super.key});

  final gurujiDetailsController = Get.find<GurujiDetailsController>();
  final gurujiListingController = Get.find<GurujiListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  final int dic = 1;
  final bool isScroll = false;

  //Static For Now
  final bool viewAllIconVisible = true;

  //For Tablet Views Need to test out
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: kColorWhite,
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          GestureDetector(
            onTap: () async {
              if (viewAllIconVisible) {
                //Call the ViewAll API here
                log('Call the view all api here');

                Utils().showLoader();
                gurujiListingController.prevScreen.value = "homeCollection";

                gurujiListingController.collectionId.value =
                    homecollectionResult.id.toString();

                gurujiListingController.gurujiApiCallType.value =
                    'fetchGurujiHomeViewAllListing';

                gurujiListingController.viewAllListingGurujiTitle.value =
                    homecollectionResult.title.toString();

                await gurujiListingController.fetchGurujiHomeViewAllListing(
                  collectionArtsitId: homecollectionResult.id.toString(),
                  token: '',
                );

                Get.back();

                if (!gurujiListingController.isLoadingData.value) {
                  Get.toNamed(
                    AppRoute.gurujiListingScreen,
                    arguments: {
                      "viewAllListingGurujiTitle":
                          homecollectionResult.title!.toString(),
                    },
                  );
                }
              } else {
                log('ViewAll Flag is not Available');
              }
            },
            child: Container(
              color: kColorTransparent,
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/satiya_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description!.toString(),
                // authorName: 'Swami Shri Adganand Ji Maharaj',
              ),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          homecollectionResult.displayInColumn == 4
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 2,
                  ),
                  itemCount: homecollectionResult
                      .collectionData!.length, // Total number of images
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await homeGurujiDetailsApiCall(
                            artistId: homecollectionResult
                                .collectionData![index].id
                                .toString(),
                            type: homecollectionResult.type.toString(),
                            token: '');
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 179.w,
                            height: 110.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.h),
                                topRight: Radius.circular(16.h),
                                bottomRight: Radius.circular(16.h),
                              ),
                              child: FadeInImage(
                                image: NetworkImage(homecollectionResult
                                    .collectionData![index].imageUrl
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
                          ),
                          SizedBox(
                            height: 5.h,
                          ),

                          //Artist Name
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              homecollectionResult.collectionData![index].name
                                  .toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: kTextStyleRosarioMedium.copyWith(
                                fontSize:
                                    FontSize.honourableGurujisTitle.sp - 6,
                                color: kColorGurujisNameHome,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : homecollectionResult.displayInColumn == 3
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 1.9,
                      ),
                      itemCount: homecollectionResult
                          .collectionData!.length, // Total number of images
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await homeGurujiDetailsApiCall(
                                artistId: homecollectionResult
                                    .collectionData![index].id
                                    .toString(),
                                type: homecollectionResult.type.toString(),
                                token: '');
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                width: 150.w,
                                height: 160.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.h),
                                    topRight: Radius.circular(16.h),
                                    bottomRight: Radius.circular(16.h),
                                  ),
                                  child: FadeInImage(
                                    image: NetworkImage(homecollectionResult
                                        .collectionData![index].imageUrl
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
                              ),
                              SizedBox(
                                height: 5.h,
                              ),

                              //Artist Name
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  homecollectionResult
                                      .collectionData![index].name
                                      .toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyleRosarioMedium.copyWith(
                                    fontSize:
                                        FontSize.honourableGurujisTitle.sp -
                                            5.sp,
                                    color: kColorGurujisNameHome,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? Container(
                          // color: Colors.red,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 15.w,
                              mainAxisSpacing: 15.h,
                              crossAxisCount: 2,
                              childAspectRatio:
                                  screenWidth >= 600 ? 1 / 1.48 : 1 / 1.75,
                            ),
                            itemCount: homecollectionResult.collectionData!
                                .length, // Total number of images
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await homeGurujiDetailsApiCall(
                                      artistId: homecollectionResult
                                          .collectionData![index].id
                                          .toString(),
                                      type:
                                          homecollectionResult.type.toString(),
                                      token: '');
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 280.w,
                                      height:
                                          screenWidth >= 600 ? 285.h : 245.h,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(26.h),
                                          topRight: Radius.circular(26.h),
                                          bottomRight: Radius.circular(26.h),
                                        ),
                                        child: FadeInImage(
                                          image: NetworkImage(
                                              homecollectionResult
                                                  .collectionData![index]
                                                  .imageUrl
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
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),

                                    //Artist Name
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        homecollectionResult
                                            .collectionData![index].name
                                            .toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStyleRosarioMedium.copyWith(
                                          fontSize: FontSize
                                              .honourableGurujisTitle.sp,
                                          color: kColorGurujisNameHome,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 15.w,
                                mainAxisSpacing: 15.h,
                                crossAxisCount: 1,
                                childAspectRatio: 1 / 1.65,
                              ),
                              itemCount: homecollectionResult.collectionData!
                                  .length, // Total number of images
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await homeGurujiDetailsApiCall(
                                        artistId: homecollectionResult
                                            .collectionData![index].id
                                            .toString(),
                                        type: homecollectionResult.type
                                            .toString(),
                                        token: '');
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 410.w,
                                        height: 570.h,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(56.h),
                                            topRight: Radius.circular(56.h),
                                            bottomRight: Radius.circular(56.h),
                                          ),
                                          child: FadeInImage(
                                            image: NetworkImage(
                                                homecollectionResult
                                                    .collectionData![index]
                                                    .imageUrl
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
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      //Artist Name
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          homecollectionResult
                                              .collectionData![index].name
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              kTextStyleRosarioMedium.copyWith(
                                            fontSize: FontSize
                                                    .honourableGurujisTitle.sp +
                                                2.sp,
                                            color: kColorGurujisNameHome,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeGurujiDetailsApiCall(
      {required String artistId, required String type, String? token}) async {
    log("guruji type = $type");
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      Utils().showLoader();
      await gurujiDetailsController.fetchGurujiHomeDetails(
          artistId: artistId, type: type, token: token);
      Get.back();
      if (gurujiDetailsController.isLoadingData.value == false &&
          gurujiDetailsController.isDataNotFound.value == false) {
        debugPrint("DAta loaded ...Successfully");
        Get.toNamed(AppRoute.gurujiDetailsScreen);
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This widget paints the artist/guruji object in a single row(type: artist, isScroll: true, and it uses display in column to display the said number of objects across the screen width, since the scroll is true, the objects are painted in a single row)
class HomeCollectionArtistScrollTrueWidget extends StatelessWidget {
  HomeCollectionArtistScrollTrueWidget(
      {required this.homecollectionResult, super.key});

  final gurujiDetailsController = Get.find<GurujiDetailsController>();
  final gurujiListingController = Get.find<GurujiListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  final int dic = 1;
  //Static For Now
  final bool viewAllIconVisible = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: kColorWhite,
      padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          GestureDetector(
            onTap: () async {
              if (viewAllIconVisible) {
                //Call the ViewAll API here
                log('Call the view all api here');

                Utils().showLoader();
                gurujiListingController.prevScreen.value = "homeCollection";

                gurujiListingController.collectionId.value =
                    homecollectionResult.id.toString();

                gurujiListingController.gurujiApiCallType.value =
                    'fetchGurujiHomeViewAllListing';

                gurujiListingController.viewAllListingGurujiTitle.value =
                    homecollectionResult.title.toString();

                await gurujiListingController.fetchGurujiHomeViewAllListing(
                  collectionArtsitId: homecollectionResult.id.toString(),
                  token: '',
                );

                Get.back();

                if (!gurujiListingController.isLoadingData.value) {
                  Get.toNamed(
                    AppRoute.gurujiListingScreen,
                    arguments: {
                      "viewAllListingGurujiTitle":
                          homecollectionResult.title!.toString(),
                    },
                  );
                }
              } else {
                log('ViewAll Flag is not Available');
              }
            },
            child: Container(
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              color: kColorTransparent,
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/satiya_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description!.toString(),
                // authorName: 'Swami Shri Adganand Ji Maharaj',
              ),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          homecollectionResult.displayInColumn == 4
              ? Container(
                  alignment: Alignment.centerLeft,
                  // color: Colors.yellow,
                  height: screenWidth >= 600 ? 240.h : 170.h,
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: 25.w,
                      right: 25.w,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await homeGurujiDetailsApiCall(
                              artistId: homecollectionResult
                                  .collectionData![index].id
                                  .toString(),
                              type: homecollectionResult.type.toString(),
                              token: '');
                        },
                        child: SizedBox(
                          width: screenWidth / 4 - 25.w,
                          // color: Colors.grey,
                          child: Column(
                            children: [
                              SizedBox(
                                width: screenWidth / 4 - 25.w,
                                height: screenWidth >= 600 ? 140.h : 110.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.h),
                                    topRight: Radius.circular(16.h),
                                    bottomRight: Radius.circular(16.h),
                                  ),
                                  child: FadeInImage(
                                    image: NetworkImage(homecollectionResult
                                        .collectionData![index].imageUrl
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
                              ),
                              SizedBox(
                                height: 5.h,
                              ),

                              //Artist Name
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  homecollectionResult
                                      .collectionData![index].name
                                      .toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyleRosarioMedium.copyWith(
                                    fontSize:
                                        FontSize.honourableGurujisTitle.sp - 4,
                                    color: kColorGurujisNameHome,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 24.w,
                      );
                    },
                    itemCount: homecollectionResult.collectionData!.length,
                  ),
                )
              : homecollectionResult.displayInColumn == 3
                  ? Container(
                      alignment: Alignment.centerLeft,
                      // color: Colors.yellow,
                      height: screenWidth > 600 ? 330.h : 200.h,
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                          left: 25.w,
                          right: 25.w,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await homeGurujiDetailsApiCall(
                                  artistId: homecollectionResult
                                      .collectionData![index].id
                                      .toString(),
                                  type: homecollectionResult.type.toString(),
                                  token: '');
                            },
                            child: SizedBox(
                              width: screenWidth / 3 - 25.w,
                              // color: Colors.green,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: screenWidth / 3 - 25.w,
                                    height: 160.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.h),
                                        topRight: Radius.circular(24.h),
                                        bottomRight: Radius.circular(24.h),
                                      ),
                                      child: FadeInImage(
                                        image: NetworkImage(homecollectionResult
                                            .collectionData![index].imageUrl
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
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  //Artist Name
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      homecollectionResult
                                          .collectionData![index].name
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyleRosarioMedium.copyWith(
                                        fontSize:
                                            FontSize.honourableGurujisTitle.sp -
                                                5.sp,
                                        color: kColorGurujisNameHome,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 24.w,
                          );
                        },
                        itemCount: homecollectionResult.collectionData!.length,
                      ),
                    )
                  : homecollectionResult.displayInColumn == 2
                      ? Container(
                          alignment: Alignment.centerLeft,
                          // color: Colors.yellow,
                          height: screenWidth > 600 ? 330.h : 290.h,
                          child: ListView.separated(
                            padding: EdgeInsets.only(
                              left: 25.w,
                              right: 25.w,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await homeGurujiDetailsApiCall(
                                      artistId: homecollectionResult
                                          .collectionData![index].id
                                          .toString(),
                                      type:
                                          homecollectionResult.type.toString(),
                                      token: '');
                                },
                                child: SizedBox(
                                  width: 179.w,
                                  // color: Colors.red,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 179.w,
                                        height: 220.h,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(24.h),
                                            topRight: Radius.circular(24.h),
                                            bottomRight: Radius.circular(24.h),
                                          ),
                                          child: FadeInImage(
                                            image: NetworkImage(
                                                homecollectionResult
                                                    .collectionData![index]
                                                    .imageUrl
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
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Text(
                                              homecollectionResult
                                                  .collectionData![index].name
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: kTextStyleRosarioMedium
                                                  .copyWith(
                                                      fontSize: FontSize
                                                          .honourableGurujisTitle
                                                          .sp,
                                                      color:
                                                          kColorGurujisNameHome),
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
                              return SizedBox(
                                width: 24.w,
                              );
                            },
                            itemCount:
                                homecollectionResult.collectionData!.length,
                          ),
                        )
                      : homecollectionResult.displayInColumn == 1
                          ? Container(
                              alignment: Alignment.centerLeft,
                              // color: Colors.yellow,
                              height: screenWidth > 600 ? 330.h : 610.h,
                              child: ListView.separated(
                                padding: EdgeInsets.only(
                                  left: 25.w,
                                  right: 25.w,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await homeGurujiDetailsApiCall(
                                          artistId: homecollectionResult
                                              .collectionData![index].id
                                              .toString(),
                                          type: homecollectionResult.type
                                              .toString(),
                                          token: '');
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: screenWidth - 25.w,
                                      // height: 550.h,
                                      // color: Colors.red,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenWidth - 25.w,
                                            height: 570.h,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(56.h),
                                                topRight: Radius.circular(56.h),
                                                bottomRight:
                                                    Radius.circular(56.h),
                                              ),
                                              child: FadeInImage(
                                                image: NetworkImage(
                                                    homecollectionResult
                                                        .collectionData![index]
                                                        .imageUrl
                                                        .toString()),
                                                fit: BoxFit.fill,
                                                placeholderFit:
                                                    BoxFit.scaleDown,
                                                placeholder: const AssetImage(
                                                    "assets/icons/default.png"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      "assets/icons/default.png");
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          //Artist Name
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              homecollectionResult
                                                  .collectionData![index].name
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStyleRosarioMedium
                                                  .copyWith(
                                                fontSize: FontSize
                                                        .honourableGurujisTitle
                                                        .sp +
                                                    2.sp,
                                                color: kColorGurujisNameHome,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 25.w,
                                  );
                                },
                                itemCount:
                                    homecollectionResult.collectionData!.length,
                              ),
                            )
                          : const SizedBox(),
        ],
      ),
    );
  }

  homeGurujiDetailsApiCall(
      {required String artistId, required String type, String? token}) async {
    log("guruji type = $type");
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      Utils().showLoader();
      await gurujiDetailsController.fetchGurujiHomeDetails(
          artistId: artistId, type: type, token: token);
      Get.back();
      if (gurujiDetailsController.isLoadingData.value == false &&
          gurujiDetailsController.isDataNotFound.value == false) {
        debugPrint("DAta loaded ...Successfully");
        Get.toNamed(AppRoute.gurujiDetailsScreen);
      } else {
        Utils.customToast("Something went wrong", kRedColor,
            kRedColor.withOpacity(0.2), "error");
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This is the heading widget for the guruji title
class ArtistHeadingHomeWidget extends StatelessWidget {
  const ArtistHeadingHomeWidget({
    this.svgLeadingIconUrl = '',
    this.headingTitle = '',
    this.authorName = '',
    super.key,
  });

  final String svgLeadingIconUrl;
  final String headingTitle;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: kColorWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Heading Gurujis
          SizedBox(
            height: screenWidth >= 600 ? 40.h : 26.h,
            width: screenWidth >= 600 ? 40.h : 26.h,
            child: SvgPicture.asset(
              'assets/images/home/satiya_symbol.svg',
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Text(
            headingTitle,
            style: kTextStylePoppinsMedium.copyWith(
              color: kColorFont,
              fontSize: FontSize.headingsTitle.sp + 3.sp,
            ),
          ),
          SizedBox(
            width: 16.w,
          ),

          SizedBox(
            height: screenWidth >= 600 ? 40.h : 26.h,
            width: screenWidth >= 600 ? 40.h : 26.h,
            child: SvgPicture.asset(
              'assets/images/home/satiya_symbol.svg',
            ),
          ),
        ],
      ),
    );
  }
}

//This widget paints the audio object in multiple rows(type: audio, isScroll: false, and it uses display in column to display the said number of objects across the screen width, since the scroll is false, the objects are painted in multiple rows)
class HomeCollectionAudioScrollFalseWidget extends StatelessWidget {
  HomeCollectionAudioScrollFalseWidget(
      {required this.homecollectionResult, super.key});

  final audioDetailsController = Get.find<AudioDetailsController>();
  final audioListingController = Get.find<AudioListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  //Static For Now
  final bool viewAllIconVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      color: kColorWhite,
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          //Heading
          GestureDetector(
            onTap: () async {
              Utils().showLoader();
              audioListingController.prevScreen.value = "homeCollection";
              audioListingController.collectionId.value =
                  homecollectionResult.id.toString();
              homeController.languageModel ??
                  await homeController.getSortData();
              audioListingController.initializeFilter();

              audioListingController.audioApiCallType.value =
                  'fetchAudioHomeViewAllListing';

              audioListingController.viewAllListingAudioTitle.value =
                  homecollectionResult.title.toString();

              await audioListingController.fetchAudioHomeViewAllListing(
                token: '',
              );
              Get.back();
              if (!audioListingController.isLoadingData.value) {
                Get.toNamed(
                  AppRoute.audioListingScreen,
                  arguments: {
                    "viewAllListingAudioTitle":
                        homecollectionResult.title!.toString(),
                  },
                );
              }
            },
            child: Container(
              color: kColorTransparent,
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description!.toString(),
              ),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  await homeAudioDetailsApiCall(
                      audioId: homecollectionResult.collectionData![index].id
                          .toString(),
                      type: homecollectionResult.type.toString(),
                      token: '');
                },
                child: Container(
                  color: kColorTransparent,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.r)),
                                child: SizedBox(
                                  height: 50.h,
                                  width: 50.h,
                                  child: FadeInImage(
                                    image: NetworkImage(
                                      homecollectionResult
                                          .collectionData![index]
                                          .audioCoverImageUrl
                                          .toString(),
                                    ),
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
                                  // child: CachedNetworkImage(imageUrl:
                                  //   homecollectionResult
                                  //       .collectionData![index].audioCoverImageUrl
                                  //       .toString(),
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Container(
                                // color: Colors.red,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        homecollectionResult
                                            .collectionData![index].title
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStylePoppinsMedium.copyWith(
                                          fontSize: FontSize.mediaTitle.sp,
                                          color: kColorBlack,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),

                                    //Language and Duration Tag
                                    Container(
                                      // height: 18.h,
                                      padding: EdgeInsets.only(
                                          left: 12.w, right: 12.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                        color: kColorFontLangaugeTag
                                            .withOpacity(0.05),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            '${homecollectionResult.collectionData![index].mediaLanguage.toString()}',
                                            style: kTextStylePoppinsRegular
                                                .copyWith(
                                              fontSize:
                                                  FontSize.mediaLanguageTags.sp,
                                              color: kColorFontLangaugeTag,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20.w),
                                height: 24.h,
                                width: 24.h,
                                child: Image.asset(
                                  'assets/images/home/music.png',
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),

                      // Container(
                      //   margin: EdgeInsets.only(left: 50.w),
                      //   child: Divider(
                      //     height: 1.h,
                      //     color: kColorFont.withOpacity(0.15),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                margin: EdgeInsets.only(left: 50.w),
                child: Divider(
                  height: 1.h,
                  color: kColorFont.withOpacity(0.15),
                ),
              );
              // return SizedBox(
              //   height: 10.h,
              // );
            },
            itemCount: homecollectionResult.collectionData!.length,
          ),
        ],
      ),
    );
  }

  homeAudioDetailsApiCall(
      {required String audioId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      log("AudioDeails home called");
      Utils().showLoader();

      //Call Audiohomedetails API here
      await audioDetailsController.fetchAudioHomeCollectionDetails(
        token: token,
        audioId: audioId,
        type: type,
      );

      Get.back();

      if (!audioDetailsController.isLoadingData.value) {
        Get.toNamed(AppRoute.audioDetailsScreen);
      } else {
        Utils.customToast("Something went wrong", kRedColor,
            kRedColor.withOpacity(0.2), "error");
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This widget paints the audio object in a single row(type: audio, isScroll: true, and it uses display in column to display the said number of objects across the screen width, since the scroll is true, the objects are painted in a single row)
class HomeCollectionAudioScrollTrueWidget extends StatelessWidget {
  HomeCollectionAudioScrollTrueWidget(
      {required this.homecollectionResult, super.key});

  final audioDetailsController = Get.find<AudioDetailsController>();
  final audioListingController = Get.find<AudioListingController>();
  final homeController = Get.find<HomeController>();
  final homecollectionlisting.Result homecollectionResult;

  //Static For Now
  final bool viewAllIconVisible = true;

  @override
  Widget build(BuildContext context) {
    // return SizedBox();
    return Container(
      color: kColorWhite,
      padding: EdgeInsets.only(top: 25.h, bottom: 35.h),
      child: Column(
        children: [
          //Heading
          //Heading
          GestureDetector(
            onTap: () async {
              Utils().showLoader();
              audioListingController.prevScreen.value = "homeCollection";
              audioListingController.collectionId.value =
                  homecollectionResult.id.toString();
              homeController.languageModel ??
                  await homeController.getSortData();
              audioListingController.initializeFilter();

              audioListingController.audioApiCallType.value =
                  'fetchAudioHomeViewAllListing';

              audioListingController.viewAllListingAudioTitle.value =
                  homecollectionResult.title.toString();

              await audioListingController.fetchAudioHomeViewAllListing(
                token: '',
              );
              Get.back();
              if (!audioListingController.isLoadingData.value) {
                Get.toNamed(
                  AppRoute.audioListingScreen,
                  arguments: {
                    "viewAllListingAudioTitle":
                        homecollectionResult.title!.toString(),
                  },
                );
              }
            },
            child: Container(
              color: kColorTransparent,
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              child: HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
                headingTitle: homecollectionResult.title!.toString(),
                viewAllIconVisible: viewAllIconVisible,
                authorName: homecollectionResult.description!.toString(),
                // authorName: 'Swami Shri Adganand Ji Maharaj',
              ),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          SizedBox(
              // color: Colors.green,
              height: width >= 600 ? 240.h : 206.h,
              child: ListView.separated(
                padding: EdgeInsets.only(left: 25.w, right: 25.w),
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await homeAudioDetailsApiCall(
                          audioId: homecollectionResult
                              .collectionData![index].id
                              .toString(),
                          type: homecollectionResult.type.toString(),
                          token: '');
                    },
                    child: Container(
                      // color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 138.h,
                            width: 125.w,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                Container(
                                  width: 125.w,
                                  height: 125.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    // image: DecorationImage(
                                    //   image: NetworkImage(
                                    //     image: ,
                                    //   ),
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                  child: FadeInImage(
                                    image: NetworkImage(homecollectionResult
                                        .collectionData![index]
                                        .audioCoverImageUrl
                                        .toString()),
                                    fit: BoxFit.contain,
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
                                Container(
                                    // width: 125.w,
                                    alignment: Alignment.bottomCenter,
                                    child: SvgPicture.asset(
                                        "assets/icons/music.svg"))
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 125.w,
                            child: Text(
                              homecollectionResult.collectionData![index].title
                                  .toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: kTextStylePoppinsMedium.copyWith(
                                fontSize: FontSize.mediaTitle.sp,
                                overflow: TextOverflow.ellipsis,
                                color: kColorFont,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 9.h,
                          // ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              // height: 18.h,
                              padding: EdgeInsets.only(left: 12.w, right: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.h),
                                color: kColorFontLangaugeTag.withOpacity(0.05),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    homecollectionResult
                                        .collectionData![index].mediaLanguage
                                        .toString(),
                                    style: kTextStylePoppinsRegular.copyWith(
                                      fontSize: FontSize.mediaLanguageTags.sp,
                                      color: kColorFontLangaugeTag,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    width: 16.w,
                  );
                },
                itemCount: homecollectionResult.collectionData!.length,
              )),
        ],
      ),
    );
  }

  homeAudioDetailsApiCall(
      {required String audioId, required String type, String? token}) async {
    // Get.toNamed(AppRoute.ebookDetailsScreen);
    if (homecollectionResult.isClickable ==
        Constants.homeMediaDetailsClickableTrueFlag) {
      log("AudioDeails home called");
      Utils().showLoader();

      //Call Audiohomedetails API here
      await audioDetailsController.fetchAudioHomeCollectionDetails(
        token: token,
        audioId: audioId,
        type: type,
      );

      Get.back();

      if (!audioDetailsController.isLoadingData.value) {
        Get.toNamed(AppRoute.audioDetailsScreen);
      } else {
        Utils.customToast("Something went wrong", kRedColor,
            kRedColor.withOpacity(0.2), "error");
      }
    } else {
      log("isClickable flag is 0");
    }
  }
}

//This widget paints the shloka in single rows(type: shloka, isScroll: true, and it does use display in column, since the scroll is false, the objects are painted in a single row)
class HomeCollectionShlokasScrollTrueWidget extends StatelessWidget {
  const HomeCollectionShlokasScrollTrueWidget(
      {required this.homecollectionResult, super.key});

  final homecollectionlisting.Result homecollectionResult;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return // //Heading
        Container(
      color: kColorWhite,
      padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 25.w,
              right: 25.w,
            ),
            child: HeadingHomeWidget(
              svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
              headingTitle: homecollectionResult.title.toString(),
              authorName: homecollectionResult.description!.toString(),
            ),
          ),
          SizedBox(
            height: 25.h,
          ),

          // Text('Sholkas goes here'),
          SizedBox(
            // color: Colors.red,
            height: screenWidth >= 600 ? 420.h : 350.h,
            child: ListView.separated(
                padding: EdgeInsets.only(left: 25.w, right: 25.w),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // return Container(
                  //   height: 100,
                  //   width: 100,
                  //   color: Colors.red,
                  // );
                  return Stack(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(left: 25.w, right: 25.w),
                        width: screenWidth - 25.w,
                        color: Utils.getColorByIndex(index),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              "अध्याय -${homecollectionResult.collectionData![index].versesNumber.toString()}",
                              style: kTextStylePoppinsRegular.copyWith(
                                fontSize: 16.sp,
                                color: kColorShlokasTitle,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              homecollectionResult
                                  .collectionData![index].versesName
                                  .toString(),
                              style: kTextStylePoppinsRegular.copyWith(
                                fontSize: 16.sp,
                                color: kColorBlack,
                              ),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Text(
                                homecollectionResult
                                    .collectionData![index].mainShlok
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize: 16.sp,
                                  color: kColorFont,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            SizedBox(
                              // padding:
                              //     EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 1.h,
                                    color: kColorFont,
                                  ),
                                  SizedBox(width: 14.w),
                                  Text(
                                    'Shloka Meaning'.tr,
                                    style: kTextStyleNiconneRegular.copyWith(
                                      fontSize: 18.sp,
                                      color: kColorFont,
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  Container(
                                    width: 100.w,
                                    height: 1.h,
                                    color: kColorFont,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 24.h,
                            ),

                            //Meaning
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Text(
                                homecollectionResult
                                    .collectionData![index].explanationShlok
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: screenWidth >= 600 ? 2 : 3,
                                style: kTextStyleNotoRegular.copyWith(
                                  color: kColorShlokasMeaning.withOpacity(0.75),
                                  fontSize: 16.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(
                              height: 25.h,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 95.w,
                        top: 5.h,
                        child: SizedBox(
                          height: 65.h,
                          width: 65.h,
                          child: Image.asset(
                            'assets/images/home/letter_image.png',
                            opacity: const AlwaysStoppedAnimation(0.75),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 15.w,
                  );
                },
                itemCount: homecollectionResult.collectionData!.length),
          )
        ],
      ),
    );
  }
}

//This widget paints the shloka object in a muliple row(type: shloka, isScroll: true, and it doesnt uses display, since the scroll is false, the objects are painted in a mupliple row)
class HomeCollectionShlokasScrollFalseWidget extends StatelessWidget {
  const HomeCollectionShlokasScrollFalseWidget(
      {required this.homecollectionResult, super.key});

  final homecollectionlisting.Result homecollectionResult;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return // //Heading
        Container(
      color: kColorWhite,
      padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25.w, right: 25.w),
            child: HeadingHomeWidget(
              svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
              headingTitle: homecollectionResult.title.toString(),
              authorName: homecollectionResult.description!.toString(),
            ),
          ),
          SizedBox(
            height: 25.h,
          ),

          // Text('Sholkas goes here'),
          ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // return Container(
                //   height: 100,
                //   width: 100,
                //   color: Colors.red,
                // );
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 25.w, right: 25.w),
                      width: screenWidth,
                      color: Utils.getColorByIndex(index),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "अध्याय -${homecollectionResult.collectionData![index].versesNumber.toString()}",
                            style: kTextStylePoppinsRegular.copyWith(
                              fontSize: 16.sp,
                              color: kColorShlokasTitle,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Text(
                              homecollectionResult
                                  .collectionData![index].versesName
                                  .toString(),
                              style: kTextStylePoppinsRegular.copyWith(
                                fontSize: 16.sp,
                                color: kColorBlack,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Text(
                              homecollectionResult
                                  .collectionData![index].mainShlok
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: kTextStylePoppinsRegular.copyWith(
                                fontSize: 16.sp,
                                color: kColorFont,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          SizedBox(
                            // padding:
                            //     EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 1.h,
                                  color: kColorFont,
                                ),
                                SizedBox(width: 14.w),
                                Text(
                                  'Shloka Meaning'.tr,
                                  style: kTextStyleNiconneRegular.copyWith(
                                    fontSize: 18.sp,
                                    color: kColorFont,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Container(
                                  width: 100.w,
                                  height: 1.h,
                                  color: kColorFont,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 24.h,
                          ),

                          //Meaning
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Text(
                              homecollectionResult
                                  .collectionData![index].explanationShlok
                                  .toString(),
                              style: kTextStyleNotoRegular.copyWith(
                                color: kColorShlokasMeaning.withOpacity(0.75),
                                fontSize: 16.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(
                            height: 25.h,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 95.w,
                      top: 5.h,
                      child: SizedBox(
                        height: 65.h,
                        width: 65.h,
                        child: Image.asset(
                          'assets/images/home/letter_image.png',
                          opacity: const AlwaysStoppedAnimation(0.75),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 16.h,
                );
              },
              itemCount: homecollectionResult.collectionData!.length)
        ],
      ),
    );
  }
}

// class HomeCollectionBookScrollTrueWidget extends StatelessWidget {
//   const HomeCollectionBookScrollTrueWidget({
//     required this.homecollectionResult,
//     super.key,
//   });

//   final homecollectionlisting.Result homecollectionResult;

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return AspectRatio(
//       aspectRatio: 1 / 0.8, // DIC value: 3
//       // aspectRatio: 1 / 1, //DIC value: 2

//       child: Container(
//         width: screenWidth,
//         color: kColorWhite,
//         padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
//         margin: EdgeInsets.only(
//           top: 15.h,
//           bottom: 15.h,
//         ),
//         child: ListView.separated(
//           padding: EdgeInsets.only(left: 25.w, right: 25.w),
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           // physics: const BouncingScrollPhysics(),

//           itemCount: homecollectionResult
//               .collectionData!.length, // Total number of images
//           itemBuilder: (context, index) {
//             return Container(
//               // color: Colors.yellow,
//               child: AspectRatio(
//                 aspectRatio: 1 / 2.21, //DIC value: 3
//                 // aspectRatio: 1 / 1.875, //DIC value: 2
//                 // aspectRatio: 1 / 1.875, //DIC value: 1

//                 child: Column(
//                   children: [
//                     Container(
//                       color: Colors.red,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(4.h),
//                         child: AspectRatio(
//                           aspectRatio: 1 / 1.38, //DIC value: 3
//                           // aspectRatio: 1 / 1.38, //DIC value: 2
//                           child: CachedNetworkImage(imageUrl:
//                             homecollectionResult
//                                 .collectionData![index].coverImageUrl
//                                 .toString(),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(
//                       height: 5.h,
//                     ),

//                     //Book Title
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         homecollectionResult.collectionData![index].name
//                             .toString(),
//                         style: kTextStylePoppinsMedium.copyWith(
//                           fontSize: FontSize.mediaTitle.sp,
//                           color: kColorFont,
//                         ),
//                       ),
//                     ),

//                     //Language Tag
//                     Row(
//                       children: [
//                         Container(
//                           // height: 18.h,
//                           padding: EdgeInsets.only(left: 12.w, right: 12.w),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(4.h),
//                             color: kColorFontLangaugeTag.withOpacity(0.05),
//                           ),
//                           alignment: Alignment.centerLeft,
//                           child: Row(
//                             children: [
//                               Text(
//                                 homecollectionResult
//                                     .collectionData![index].mediaLanguage
//                                     .toString(),
//                                 style: kTextStylePoppinsRegular.copyWith(
//                                   fontSize: FontSize.mediaLanguageTags.sp,
//                                   color: kColorFontLangaugeTag,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },

//           separatorBuilder: (context, index) {
//             return SizedBox(
//               width: 15.w,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

//Case 1(Single, False), Banner
//Case 2(Multiple, False) , DIC
//Case 3(Multiple, True), Carousel
//Case 4 Books, Audio, Video, Artist, False, DIC
//Case 5 Books, Audio, Video, Artist, True, DIC

// void _causeError() {
//   throw Exception('This is a test error for Crashlytics.');
// }

//OLD HOME STATIC DATA

// HomeCollectionBookScrollFalseWidget(
//   homecollectionResult:
//       homeController.homeCollectionListing[5]!,
// ),
// SizedBox(
//   height: 15.h,
// ),
// //Carousel Slider
// const CarouselSliderHomeScreen(),

// Container(
//   color: kColorWhite,
//   height: 24.h,
// ),

// //Home Tabs
// Container(
//   color: Colors.white,
//   padding: EdgeInsets.only(
//       left: 25.w,
//       right: 25.w,
//       top: 10.h,
//       bottom: 15.h),
//   child: CustomShowcase(
//     desc:
//         "Tap or click on the tabs to view their related content",
//     title: "",
//     showKey:
//         Get.find<BottomAppBarServices>().keyThree,
//     child: GridView.builder(
//       // scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       physics:
//           const NeverScrollableScrollPhysics(),
//       itemCount:
//           HomeTabsModel.homeTabsModelList.length,
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(
//         childAspectRatio: 5 / 1.8,
//         crossAxisCount: 2,
//         crossAxisSpacing: 8.h,
//         mainAxisSpacing: 8.h,
//       ),
//       itemBuilder:
//           (BuildContext context, int index) {
//         return GestureDetector(
//           onTap: () async {
//             if (HomeTabsModel
//                     .homeTabsModelList[index]
//                     .title ==
//                 'Shlokas') {
//               Utils().showLoader();

//               //Call ShlokasChaptersList API here
//               await shlokasListingController
//                   .fetchShlokasChaptersList(
//                 langaugeId: '1',
//               );
//               await shlokasListingController
//                   .fetchShlokasListing(
//                       langaugeId: '1',
//                       chapterNumber: shlokasListingController
//                               .shlokasChaptersList
//                               .isNotEmpty
//                           ? shlokasListingController
//                               .shlokasChaptersList[
//                                   0]
//                               .toString()
//                           : '1');

//               Get.back();

//               if (!shlokasListingController
//                       .isLoadingShlokasChaptersListData
//                       .value &&
//                   !shlokasListingController
//                       .isLoadingShlokasListingData
//                       .value) {
//                 Get.toNamed(AppRoute
//                     .shlokasListingScreen);
//               }

//               // Get.toNamed(AppRoute.shlokasListingScreen);
//             } else if (HomeTabsModel
//                     .homeTabsModelList[index]
//                     .title ==
//                 'Audios') {
//               Utils().showLoader();
//               homeController.languageModel ??
//                   await homeController
//                       .getSortData();
//               audioListingController
//                   .initializeFilter();
//               await audioListingController
//                   .fetchAudioListing(
//                       token: '', ctx: context);
//               Get.back();
//               if (!audioListingController
//                   .isLoadingData.value) {
//                 Get.toNamed(
//                     AppRoute.audioListingScreen);
//               }
//             } else if (HomeTabsModel
//                     .homeTabsModelList[index]
//                     .title ==
//                 'Videos') {
//               Utils().showLoader();
//               homeController.languageModel ??
//                   await homeController
//                       .getSortData();
//               videoListingController
//                   .initializeFilter();
//               await videoListingController
//                   .fetchVideoListing(
//                       token: '', ctx: context);
//               Get.back();
//               if (!videoListingController
//                   .isLoadingData.value) {
//                 Get.toNamed(
//                     AppRoute.videoListingScreen);
//               }
//             } else if (HomeTabsModel
//                     .homeTabsModelList[index]
//                     .title ==
//                 'Books') {
//               Utils().showLoader();
//               // Loading(Utils.loaderImage()).start(context);

//               //Call Ebooklisting API here
//               await ebooksListingController
//                   .fetchBooksListing(
//                 token: '',
//                 ctx: context,
//               );

//               // Loading.stop();

//               Get.back();

//               if (!ebooksListingController
//                   .isLoadingData.value) {
//                 Get.toNamed(
//                     AppRoute.ebooksListingScreen);
//               }
//             }
//           },
//           child: Container(
//             // color: Colors.white,
//             decoration: BoxDecoration(
//               color: kColorHomeTabsColor,
//               borderRadius:
//                   BorderRadius.circular(8.h),
//             ),
//             child: Row(
//               mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding:
//                       EdgeInsets.only(left: 15.w),
//                   child: Text(
//                     HomeTabsModel
//                         .homeTabsModelList[index]
//                         .title
//                         .tr,
//                     style: kTextStylePoppinsMedium
//                         .copyWith(
//                       fontSize:
//                           FontSize.tabsTitle.sp,
//                       color: kColorFont,
//                     ),
//                   ),
//                 ),
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topRight:
//                         Radius.circular(8.h),
//                     bottomRight:
//                         Radius.circular(8.h),
//                   ),
//                   child: Container(
//                     margin: EdgeInsets.all(4.h),
//                     // color: Colors.amber,
//                     // height: 95.h,
//                     // width: 85.w,
//                     // width: screenSize.width,
//                     child: Image.asset(
//                       HomeTabsModel
//                           .homeTabsModelList[
//                               index]
//                           .imgUrl,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   ),
// ),

// SizedBox(
//   height: 15.h,
// ),

// //Books Section 1
// Container(
//   // key: Get.find<BottomAppBarController>().keyThree,
//   color: kColorWhite,
//   padding: EdgeInsets.only(
//       left: 25.w,
//       right: 25.w,
//       top: 25.h,
//       bottom: 25.h),
//   child: Column(
//     children: [
// //Heading
// const HeadingHomeWidget(
//   svgLeadingIconUrl:
//       'assets/images/home/shiv_symbol.svg',
//   headingTitle: 'Bhagwad Gita',
//   authorName:
//       'Swami Shri Adganand Ji Maharaj',
// ),

//       SizedBox(
//         height: 25.h,
//       ),

//       //Books List
//       SizedBox(
//         height:
// screenWidth >= 600 ? 320.h : 251.h,
//         child: EbooksListHomeWidget(
//           ebookslist: EbooksModel.ebooksList1,
//         ),
//       ),
//     ],
//   ),
// ),

// SizedBox(
//   height: 15.h,
// ),

// //Books Section 2
// Container(
//   color: kColorWhite,
//   padding: EdgeInsets.only(
//       left: 25.w,
//       right: 25.w,
//       top: 25.h,
//       bottom: 25.h),
//   child: Column(
//     children: [
//       //Heading
//       const HeadingHomeWidget(
//         svgLeadingIconUrl:
//             'assets/images/home/satiya_symbol.svg',
//         headingTitle: 'Top Books',
//         authorName:
//             'Swami Shri Adganand Ji Maharaj',
//       ),
//       SizedBox(
//         height: 25.h,
//       ),

//       //Books List
//       SizedBox(
//         height:
//             screenWidth >= 600 ? 320.h : 251.h,
//         child: EbooksListHomeWidget(
//           ebookslist: EbooksModel.ebooksList2,
//         ),
//       ),
//     ],
//   ),
// ),

// SizedBox(
//   height: 15.h,
// ),

// //AudioBooks Section 2
// Container(
//   color: kColorWhite,
//   padding: EdgeInsets.only(
//       left: 25.w,
//       right: 25.w,
//       top: 25.h,
//       bottom: 25.h),
//   child: Column(
//     children: [
//       //Heading
//       const HeadingHomeWidget(
//         svgLeadingIconUrl:
//             'assets/images/home/shiv_symbol.svg',
//         headingTitle: 'Top Satsangs',
//         authorName:
//             'Swami Shri Adganand Ji Maharaj',
//       ),
//       SizedBox(
//         height: 25.h,
//       ),

//AudioBooks List
// AudioBooksListHomeWidget(
//   audioBooksList:
//       AudioBooksModel.audioBooksModelList1,
// ),
//     ],
//   ),
// ),

// SizedBox(
//   height: 15.h,
// ),

// //Videos Section
// Container(
//   color: kColorWhite,
//   padding:
//       EdgeInsets.only(top: 25.h, bottom: 25.h),
//   child: Column(
//     children: [
//       //Heading
//       Container(
//         margin: EdgeInsets.only(
//             left: 25.w, right: 25.w),
//         child: const HeadingHomeWidget(
//           svgLeadingIconUrl:
//               'assets/images/home/satiya_symbol.svg',
//           headingTitle: 'Top Videos',
//           authorName:
//               'Swami Shri Adganand Ji Maharaj',
//         ),
//       ),
//       SizedBox(
//         height: 25.h,
//       ),

//       //Videos List
// VideosListHomeWidget(
//   videosList: VideosModel.videosModelList1,
// ),
//     ],
//   ),
// ),

// SizedBox(
//   height: 15.h,
// ),

// //Shlokas Goes here
// //Heading
// Container(
//   color: kColorWhite,
//   padding: EdgeInsets.only(
//     top: 25.h,
//   ),
//   child: Column(
//     children: [
//       Container(
//         margin: EdgeInsets.only(
//             left: 25.w, right: 25.w),
//         child: const HeadingHomeWidget(
//           svgLeadingIconUrl:
//               'assets/images/home/shiv_symbol.svg',
//           headingTitle:
//               'Shlokas to better your day',
//         ),
//       ),
//       SizedBox(
//         height: 15.h,
//       ),

//       // Text('Sholkas goes here'),
//       const ShlokasCarouselSlider(),
//     ],
//   ),
// ),

// SizedBox(
//   height: 15.h,
// ),

// //Books Section 3
// Container(
//   color: kColorWhite,
//   padding: EdgeInsets.only(
//       left: 25.w,
//       right: 25.w,
//       top: 25.h,
//       bottom: 25.h),
//   child: Column(
//     children: [
//       //Heading
//       const HeadingHomeWidget(
//         svgLeadingIconUrl:
//             'assets/images/home/satiya_symbol.svg',
//         headingTitle: 'Top Articles',
//         authorName:
//             'Swami Shri Adganand Ji Maharaj',
//       ),

//       SizedBox(
//         height: 25.h,
//       ),

//       //Books List
//       SizedBox(
//         height:
//             screenWidth >= 600 ? 320.h : 251.h,
// child: EbooksListHomeWidget(
//   ebookslist: EbooksModel.ebooksList1,
// ),
//       ),
//     ],
//   ),
// ),

// //Banner
// Container(
//   padding: EdgeInsets.only(
//       left: 25.w,
//       right: 25.w,
//       top: 16.h,
//       bottom: 16.h),
//   child: Image.asset(
//       'assets/images/home/banner.png'),
// ),

// Container(
//   padding:
//       EdgeInsets.only(top: 25.h, bottom: 25.h),
//   color: kColorWhite,
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       //Heading Gurujis
//       SizedBox(
//         height: screenWidth >= 600 ? 40.h : 26.h,
//         width: screenWidth >= 600 ? 40.h : 26.h,
//         child: SvgPicture.asset(
//           'assets/images/home/satiya_symbol.svg',
//         ),
//       ),
//       SizedBox(
//         width: 16.w,
//       ),
//       Text(
//         'Honourable Guru Ji'.tr,
//         style: kTextStylePoppinsMedium.copyWith(
//           fontSize: FontSize.headingsTitle.sp,
//           color: kColorFont,
//         ),
//       ),
//       SizedBox(
//         width: 16.w,
//       ),

//       SizedBox(
//         height: screenWidth >= 600 ? 40.h : 26.h,
//         width: screenWidth >= 600 ? 40.h : 26.h,
//         child: SvgPicture.asset(
//           'assets/images/home/satiya_symbol.svg',
//         ),
//       ),
//     ],
//   ),
// ),

// // SizedBox(
// //   height: 22.h,
// // ),

// CustomShowcase(
//   desc:
//       "Tap or click on to view some valuable information of our Honourable Guru Ji",
//   title: "",
//   showKey:
//       Get.find<BottomAppBarServices>().keyFour,
//   child: Container(
//     color: kColorWhite,
//     height: screenWidth > 600 ? 330.h : 305.h,
//     child: ListView.separated(
//       padding: EdgeInsets.only(
//         left: 25.w,
//         right: 25.w,
//       ),
//       shrinkWrap: true,
//       scrollDirection: Axis.horizontal,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () async {
// Utils().showLoader();
// await gurujiDetailsController
//     .fetchGurujiDetails(1);
// Get.back();
// if (gurujiDetailsController
//             .isLoadingData.value ==
//         false &&
//     gurujiDetailsController
//             .isDataNotFound.value ==
//         false) {
//   debugPrint(
//       "DAta loaded ...Successfully");
//   Get.toNamed(
//       AppRoute.gurujiDetailsScreen);
// }
// },
//           child: Container(
//             width: 179.w,
//             // color: Colors.red,
//             child: Column(
//               children: [
// SizedBox(
//   width: 179.w,
//   height: 220.h,
//   child: ClipRRect(
//     borderRadius:
//         BorderRadius.only(
//       topLeft:
//           Radius.circular(24.h),
//       topRight:
//           Radius.circular(24.h),
//       bottomRight:
//           Radius.circular(24.h),
//     ),
//     child: Image.asset(
//       GurujisModel
//           .gurujisModelList[index]
//           .gurujiImgUrl,
//       fit: BoxFit.fill,
//     ),
//   ),
// ),
//                 SizedBox(
//                   height: 16.h,
//                 ),
//                 Flexible(
//                   child: Column(
//                     children: [
//       Text(
//         GurujisModel
//             .gurujisModelList[
//                 index]
//             .title,
//         style: kTextStyleRosarioMedium
//             .copyWith(
//                 fontSize: FontSize
//                     .honourableGurujisTitle
//                     .sp,
//                 color:
//                     kColorGurujisNameHome),
//       ),
//     ],
//   ),
// ),
//               ],
//             ),
//           ),
//         );
//       },
//       separatorBuilder: (context, index) {
//         return SizedBox(
//           width: 24.w,
//         );
//       },
//       itemCount:
//           GurujisModel.gurujisModelList.length,
//     ),
//   ),
// ),

// Container(
//   color: kColorWhite,
//   height: 36.h,
// ),

// SizedBox(
//   height: 15.h,
// ),

//API Data goes here

// //Case 1(Single, False), Banner
// HomeCollectionSingleTypeWidget(
//   bannerImgUrl: homeController
//       .homeCollectionListing[0]!
//       .singleCollectionImage
//       .toString(),
// ),

// //Case 3(Multiple, True), Carousel
// HomeCollectionMultipleCarouselWidget(
//   homecollectionResult:
//       homeController.homeCollectionListing[4]!,
// ),

// //Case 2(Multiple, False) , DIC
// const HomeCollectionMultipleScrollFalseWidget(),

// //Case 5 Books, Audio, Video, Artist, True, DIC
// const HomeCollectionScrollTrueWidget()
