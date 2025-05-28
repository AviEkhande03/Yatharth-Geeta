import 'dart:developer';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/services/firebase/dynamic_link_service.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import '../../controllers/events_listing/events_listing_controller.dart';
import '../../controllers/explore/explore_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/logout/logout_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../views/events/events_screen.dart';
import '../../views/explore/explore_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/profile/profile_screen.dart';
import '../../controllers/fcm_token_update/fcm_token_update_controller.dart';
import '../../utils/utils.dart';
import '../firebase/firebase_cloud_messaging.dart';

class BottomAppBarServices extends GetxService {
  RxString token = ''.obs;
  var miniplayerVisible = false.obs;
  RxBool isInitialized = false.obs;
  RxBool isCustomSearchBarNewDisposed = false.obs;
  RxBool isUiStateBuild = false.obs;
  final networkService = Get.find<NetworkService>();

  @override
  void onInit() async {
    super.onInit();

    // Get.put(FcmTokenUpdateController());
    // await getAccessToken();
    // await Get.find<FcmTokenUpdateController>().updateFcmTokenApi(
    //     fcmToken: FirebaseCloudMessaging.fcmToken.toString());
    // await getAccessToken();
    // Get.put(HomeController());
    // Get.put(EventsListingController());
    // Get.put(ExploreController());
    // Get.put(ProfileController());
    // Get.put(LogOutController());
    // log("FirebaseCloudMessaging.fcmToken.toString():${FirebaseCloudMessaging.fcmToken.toString()}");
    //
    // isInitialized.value = true;

    //Firstly getting the token
    await getAccessToken();
    //We put FcmTokenUpdateController to update fcm token in backend
    Get.put(FcmTokenUpdateController());
    log("FirebaseCloudMessaging.fcmToken.toString():${FirebaseCloudMessaging.fcmToken.toString()}");
    //Calling the updateFcmTokenApi method for updating token to backend
    await Get.find<FcmTokenUpdateController>().updateFcmTokenApi(
        fcmToken: FirebaseCloudMessaging.fcmToken.toString());

    //As there is possibility that the access token might change if success code is 3 ,so reading the access token again to update the access token
    await getAccessToken();

    //Putting out the controllers as they will be accessed later
    Get.put(HomeController());
    Get.put(PlayerController());
    Get.put(EventsListingController());
    Get.put(ExploreController());
    Get.put(ProfileController());
    Get.put(LogOutController());

    //A flag to maintain a check that loader disappears only after all the controllers are initializes
    //As one controller inside it initializes too many controllers so some times before all controllers are initialized screen gets loaded and we were getting controller not found hence did this.
    isInitialized.value = true;

    //After tapping a notification, this method is called and thereby excuting the logic written inside this method.
    FirebaseCloudMessaging().setupInteractedMessage();
    DynamicLinkService dynamicLinkService = DynamicLinkService.instance;
    // final PendingDynamicLinkData? initialLink =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // debugPrint("Initial Link ${initialLink?.link.toString()}");
    // if (initialLink != null) {
    //   debugPrint("Did Come Here");
    //   dynamicLinkService.handleDynamicLink();
    // }
    dynamicLinkService.handleDynamicLink();
  }

  // vaibhav 01/04/25
  // ensure bottomservice initialized 
  Future<void> ensureInitialized() async {
    // If not already initialized, wait for initialization
    if (!isInitialized.value) {
      // Wait a maximum of 5 seconds for initialization
      for (int i = 0; i < 50; i++) {
        if (isInitialized.value) break;
        await Future.delayed(Duration(milliseconds: 100));
      }
    }

    // Force update UI state flag
    isUiStateBuild.value = true;
  }

  //variable to track which index of list is currently visible
  var selectedIndex = 0.obs;
  final List<Widget> widgetOptions = [
    const HomeScreen(),
    const ExploreScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];
  final GlobalKey keyOne = GlobalKey();
  final GlobalKey keyTwo = GlobalKey();
  final GlobalKey keyThree = GlobalKey();
  final GlobalKey keyFour = GlobalKey();
  final GlobalKey keyFive = GlobalKey();
  final GlobalKey keySix = GlobalKey();
  List<TutorialItem> items = [];
  // void initItems() {
  //   items.addAll({
  //     TutorialItem(
  //       globalKey: keyOne,
  //       color: Colors.black.withOpacity(0.6),
  //       borderRadius: const Radius.circular(15.0),
  //       shapeFocus: ShapeFocus.roundedSquare,
  //       child: const TutorialItemContent(
  //         title: 'Increment button',
  //         content: 'This is the increment button',
  //       ),
  //     ),
  //     TutorialItem(
  //       globalKey: keyTwo,
  //       shapeFocus: ShapeFocus.square,
  //       borderRadius: const Radius.circular(15.0),
  //       child: const TutorialItemContent(
  //         title: 'Counter text',
  //         content: 'This is the text that displays the status of the counter',
  //       ),
  //     ),
  //     TutorialItem(
  //       globalKey: keyThree,
  //       color: Colors.black.withOpacity(0.6),
  //       shapeFocus: ShapeFocus.oval,
  //       child: const TutorialItemContent(
  //         title: 'Avatar',
  //         content: 'This is the avatar that displays something',
  //       ),
  //     ),
  //   });
  // }

  //Method that gets called when an item is tapped in bottom app bar
  void onItemTapped(
    int index,
  ) {
    selectedIndex.value = index;

    //Hardcoded just for events
    if (selectedIndex.value == 2) {
      callEventListing();
    }
  }

  //Method for getting access token
  getAccessToken() async {
    token.value = await Utils.getToken();
    debugPrint('bottom screen token--->${token.value.toString()}');
  }

  callEventListing() async {
    Get.find<EventsListingController>().clearEventsList();
    log("event listing cleared");
    await Get.find<EventsListingController>().fetchEventsListing();
    Get.find<EventsListingController>().isLoadingForStart.value = false;
  }
}
