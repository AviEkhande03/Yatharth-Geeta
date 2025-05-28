import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/audio_details/audio_details_controller.dart';
import 'package:yatharthageeta/controllers/audio_listing/audio_listing_controller.dart';
import 'package:yatharthageeta/controllers/ebook_details/ebook_details_controller.dart';
import 'package:yatharthageeta/controllers/ebooks_listing/ebooks_listing_controller.dart';
import 'package:yatharthageeta/controllers/event_details/event_details_controller.dart';
import 'package:yatharthageeta/controllers/explore/explore_controller.dart';
import 'package:yatharthageeta/controllers/guruji_details/guruji_details_controller.dart';
import 'package:yatharthageeta/controllers/guruji_listing/guruji_listing_controller.dart';
import 'package:yatharthageeta/controllers/home/home_controller.dart';
import 'package:yatharthageeta/controllers/startup/startup_controller.dart';
import 'package:yatharthageeta/controllers/video_details/video_details_controller.dart';
import 'package:yatharthageeta/controllers/video_listing/video_listing_controller.dart';
import 'package:yatharthageeta/routes/app_route.dart';
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:yatharthageeta/utils/utils.dart';

class FirebaseCloudMessaging {
  // It is assumed that all messages contain a data field with the key 'type'
  //setupInteractedMessage is the method used for terminated state redirection and other actions(as defined inside the method) when the user taps on the notification
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  //Handle Terminated messages here
  void _handleMessage(RemoteMessage message) async {
    var data = message.data;

    var id = data['selected_id'];
    var type = data['type'];
    var collType = data['collection_type'];
    var collTitle = data['collection_title'];

    log("NOTIFICATION TAPPED FROM TERMINATED. id: $id,type: $type");

    /////////////////////////VIBHOR//////////////////////
    //Terinated redirection code
    if (Get.isRegistered<BottomAppBarServices>()) {
      if (type.toString() == 'Book') {
        log("Redirecting to book details screen");
        Utils().showLoader();

        Get.find<EbookDetailsController>().prevRoute.value = Get.currentRoute;
        await Get.find<EbookDetailsController>()
            .fetchBookDetails(token: '', bookId: int.parse(id));

        Get.back();

        if (!Get.find<EbookDetailsController>().isLoadingData.value) {
          Get.toNamed(AppRoute.ebookDetailsScreen);
        }
      }

      if (type.toString() == 'Audio') {
        log("Redirecting to book details screen");
        var detailsController = Get.put(AudioDetailsController());
        Utils().showLoader();
        detailsController.prevRoute.value = Get.currentRoute;
        await detailsController.fetchAudioDetails(
            audioId: int.parse(id), token: '');
        Get.back();
        if (!detailsController.isLoadingData.value) {
          Get.toNamed(AppRoute.audioDetailsScreen);
        }
      }

      if (type.toString() == 'Video') {
        var videoDetailsController = Get.find<VideoDetailsController>();
        Utils().showLoader();
        videoDetailsController.prevRoute.value = Get.currentRoute;
        await videoDetailsController.fetchVideoDetails(
            videoId: int.parse(id), isNext: false, token: '');
        Get.back();
        if (!videoDetailsController.isLoadingData.value) {
          Get.toNamed(AppRoute.videoDetailsScreen);
        }
      }

      if (type.toString() == 'Artist') {
        Utils().showLoader();
        await Get.find<GurujiDetailsController>()
            .fetchGurujiDetails(id: id.toString());
        Get.back();
        if (Get.find<GurujiDetailsController>().isLoadingData.value == false &&
            Get.find<GurujiDetailsController>().isDataNotFound.value == false) {
          debugPrint("DAta loaded ...Successfully");
          Get.toNamed(AppRoute.gurujiDetailsScreen);
        }
      }
      if (type.toString() == 'HomeCollection') {
        log("Comes here");
        while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
          Get.back();
        }
        Get.find<BottomAppBarServices>().onItemTapped(0);
        log("$id yeh kya data aaraha h yrr");

        final homeController = Get.find<HomeController>();
        if (collType == 'Book') {
          Utils().showLoader();
          //Call Ebooklisting ViewAll API here
          var ebooksListingController = Get.find<EbooksListingController>();
          ebooksListingController.prevScreen.value = "homeCollection";
          ebooksListingController.collectionId.value = id.toString();
          homeController.languageModel ?? await homeController.getSortData();
          ebooksListingController.initializeFilter();

          ebooksListingController.booksApiCallType.value =
              'fetchBooksHomeViewAllListing';

          ebooksListingController.viewAllListingBookTitle.value =
              collTitle.toString();

          await ebooksListingController.fetchBooksHomeViewAllListing(
            // collectionBookId: homecollectionResult.id.toString(),
            token: '',
          );

          Get.back();

          if (!ebooksListingController.isLoadingData.value) {
            Get.toNamed(
              AppRoute.ebooksListingScreen,
              arguments: {
                "viewAllListingBookTitle": collTitle.toString(),
              },
            );
          }
        }
        if (collType == 'Video') {
          Utils().showLoader();
          var videoListingController = Get.find<VideoListingController>();
          videoListingController.prevScreen.value = "homeCollection";
          videoListingController.collectionId.value = id.toString();
          homeController.languageModel ?? await homeController.getSortData();
          videoListingController.initializeFilter();

          videoListingController.videoApiCallType.value =
              'fetchVideoHomeViewAllListing';

          videoListingController.viewAllListingVideoTitle.value =
              collTitle.toString();

          await videoListingController.fetchVideoHomeViewAllListing(
            token: '',
            // collectionVideoId: homecollectionResult.id.toString(),
          );
          Get.back();
          if (!videoListingController.isLoadingData.value) {
            Get.toNamed(
              AppRoute.videoListingScreen,
              arguments: {
                "viewAllListingVideoTitle": collTitle.toString(),
              },
            );
          }
        }
        if (collType == 'Artist') {
          Utils().showLoader();
          var gurujiListingController = Get.find<GurujiListingController>();
          gurujiListingController.prevScreen.value = "homeCollection";

          gurujiListingController.collectionId.value = id.toString();

          gurujiListingController.gurujiApiCallType.value =
              'fetchGurujiHomeViewAllListing';

          gurujiListingController.viewAllListingGurujiTitle.value =
              collTitle.toString();

          await gurujiListingController.fetchGurujiHomeViewAllListing(
            collectionArtsitId: id.toString(),
            token: '',
          );

          Get.back();

          if (!gurujiListingController.isLoadingData.value) {
            Get.toNamed(
              AppRoute.gurujiListingScreen,
              arguments: {
                "viewAllListingGurujiTitle": collTitle!.toString(),
              },
            );
          }
        }
        if (collType == 'Audio') {
          var audioListingController = Get.find<AudioListingController>();
          Utils().showLoader();
          audioListingController.prevScreen.value = "homeCollection";
          audioListingController.collectionId.value = id;
          homeController.languageModel ?? await homeController.getSortData();
          audioListingController.initializeFilter();

          audioListingController.audioApiCallType.value =
              'fetchAudioHomeViewAllListing';

          audioListingController.viewAllListingAudioTitle.value =
              collTitle.toString();

          await audioListingController.fetchAudioHomeViewAllListing(
            token: '',
          );
          Get.back();
          if (!audioListingController.isLoadingData.value) {
            Get.toNamed(
              AppRoute.audioListingScreen,
              arguments: {
                "viewAllListingAudioTitle": collTitle.toString(),
              },
            );
          }
        }
      }
      if (type.toString() == 'ExploreCollection') {
        log("Comes here");
        while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
          Get.back();
        }
        Get.find<BottomAppBarServices>().onItemTapped(1);
        if (collType == 'Book') {
          Utils().showLoader();
          //Call Ebooklisting ViewAll API here
          var homeController = Get.find<HomeController>();
          var ebooksListingController = Get.find<EbooksListingController>();
          ebooksListingController.prevScreen.value = "collection";
          ebooksListingController.collectionId.value = id.toString();
          homeController.languageModel ?? await homeController.getSortData();
          ebooksListingController.initializeFilter();

          ebooksListingController.booksApiCallType.value =
              'fetchBooksExploreViewAllListing';

          ebooksListingController.viewAllListingBookTitle.value =
              collTitle.toString();

          await ebooksListingController.fetchBooksExploreViewAllListing(
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
        if (collType == 'Satsang') {
          Utils().showLoader();
          var controller = Get.find<ExploreController>();
          var homeController = Get.find<HomeController>();
          controller.prevScreen.value = "collection";
          controller.collectionId.value = id.toString();
          homeController.languageModel ?? await homeController.getSortData();
          controller.initializeFilter();
          controller.audioApiCallType.value = 'fetchAudioExploreViewAllListing';

          controller.viewAllListingAudioTitle.value = collTitle.toString();
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
      if (type.toString() == 'Quote') {
        log("Comes here Quotes");
        while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
          Get.back();
        }
        Get.find<BottomAppBarServices>().onItemTapped(1);

        var controller = Get.find<ExploreController>();
        Utils().showLoader();
        controller.quotesListing.isEmpty
            ? await controller.fetchQuotes()
            : null;
        controller.tabIndex.value = 3;
        Get.back();
      }
      if (type.toString() == 'Satsang') {
        log("Comes here Satsang");
        while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
          Get.back();
        }
        Get.find<BottomAppBarServices>().onItemTapped(1);

        var controller = Get.find<ExploreController>();
        Utils().showLoader();
        controller.satsangListing.isEmpty
            ? await controller.fetchSatsang()
            : null;
        controller.tabIndex.value = 1;
        Get.back();
      }
      if (type.toString() == 'Mantra') {
        log("Comes here Mantra");
        while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
          Get.back();
        }
        Get.find<BottomAppBarServices>().onItemTapped(1);

        var controller = Get.find<ExploreController>();
        Utils().showLoader();
        controller.mantraListing.isEmpty
            ? await controller.fetchMantra()
            : null;
        controller.tabIndex.value = 2;
        Get.back();
      }
      if (fgType.toString() == 'Event') {
        Utils().showLoader();

        await Get.find<EventDetailsController>()
            .fetchEventDetails(eventId: fgId.toString());

        Get.back();

        if (!Get.find<EventDetailsController>().isLoadingData.value) {
          Get.toNamed(AppRoute.eventDetailsScreen);
        }
      }
    } else {
      log("No Bottom App Services Initialized");
    }
    /////////////////////////VIBHOR//////////////////////

    /////////////////////////////////////OLD CODE
    /*
      var notificationTypeBg = data['type'].toString();

      var orderIdBg = data['type_id'].toString(); //just to check for now

      // showLoading(Get.context!);
      // await Get.find<OrderController>().getMyOrderDetails(orderId);

      // orderId = data['type_id'].toString(); //just to check for now
      print("Firebase class orderid = ${orderIdBg}");

      print("here");

      print("firevib onMessageOpenedApp.listen is triggered");

      // print(
      //     "firevib onMessageOpenedApp.listen is token ${Get.find<OrderController>().token}");

      // showLoading(Get.context!);
      // await Get.find<OrderController>().getMyOrderDetails(orderIdBg);

      print("firevib onMessageOpenedApp.listen is triggered api call k baad");

      */

    print(message.data);
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? fcmToken;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  //Foreground type variables
  dynamic fgType;
  dynamic fgId;
  dynamic fgCollType;
  dynamic fgCollTitle;

  getFirebaseNotification() async {
    FirebaseMessaging.instance.getAPNSToken().then((APNStoken) {
      print('here is APN token ---$APNStoken');
    });
    firebaseMessaging.getToken().then((value) async {
      fcmToken = value.toString();
      print('here is fcm token ---$fcmToken');
    }).catchError((onError) {
      print("Exception: $onError");
    });

    //We can use multiple subscription topics for different different Notifications
    firebaseMessaging.subscribeToTopic("yatharthgeeta");

// # BACKGROUND Running
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   var data = message.data;

    //   var id = data['selected_id'];
    //   var type = data['type'];
    //   var collType = data['collection_type'];
    //   var collTitle = data['collection_title'];

    //   log("NOTIFICATION TAPPED FROM BACKGROUND. id: $id,type: $type");

    //   /////////////////////////VIBHOR//////////////////////
    //   //Background redirection code
    //   if (Get.isRegistered<BottomAppBarServices>()) {
    //     if (type.toString() == 'Book') {
    //       log("Redirecting to book details screen");
    //       Utils().showLoader();

    //       Get.find<EbookDetailsController>().prevRoute.value = Get.currentRoute;
    //       await Get.find<EbookDetailsController>()
    //           .fetchBookDetails(token: '', bookId: int.parse(id));

    //       Get.back();

    //       if (!Get.find<EbookDetailsController>().isLoadingData.value) {
    //         Get.toNamed(AppRoute.ebookDetailsScreen);
    //       }
    //     }

    //     if (type.toString() == 'Audio') {
    //       log("Redirecting to book details screen");
    //       var detailsController = Get.put(AudioDetailsController());
    //       Utils().showLoader();
    //       detailsController.prevRoute.value = Get.currentRoute;
    //       await detailsController.fetchAudioDetails(
    //           audioId: int.parse(id), token: '');
    //       Get.back();
    //       if (!detailsController.isLoadingData.value) {
    //         Get.toNamed(AppRoute.audioDetailsScreen);
    //       }
    //     }

    //     if (type.toString() == 'Video') {
    //       var videoDetailsController = Get.find<VideoDetailsController>();
    //       Utils().showLoader();
    //       videoDetailsController.prevRoute.value = Get.currentRoute;
    //       await videoDetailsController.fetchVideoDetails(
    //           videoId: int.parse(id), isNext: false, token: '');
    //       Get.back();
    //       if (!videoDetailsController.isLoadingData.value) {
    //         Get.toNamed(AppRoute.videoDetailsScreen);
    //       }
    //     }

    //     if (type.toString() == 'Artist') {
    //       Utils().showLoader();
    //       await Get.find<GurujiDetailsController>()
    //           .fetchGurujiDetails(id: id.toString());
    //       Get.back();
    //       if (Get.find<GurujiDetailsController>().isLoadingData.value ==
    //               false &&
    //           Get.find<GurujiDetailsController>().isDataNotFound.value ==
    //               false) {
    //         debugPrint("DAta loaded ...Successfully");
    //         Get.toNamed(AppRoute.gurujiDetailsScreen);
    //       }
    //     }
    //     if (type.toString() == 'HomeCollection') {
    //       log("Comes here");
    //       while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
    //         Get.back();
    //       }
    //       // Get.find<BottomAppBarServices>().onItemTapped(0);
    //       // log("$id yeh kya data aaraha h yrr");

    //       // await Future.delayed(Duration(seconds: 2));
    //       // final homeController = Get.find<HomeController>();
    //       // if (collType == 'Book') {
    //       //   Utils().showLoader();
    //       //   //Call Ebooklisting ViewAll API here
    //       //   var ebooksListingController = Get.find<EbooksListingController>();
    //       //   ebooksListingController.prevScreen.value = "homeCollection";
    //       //   ebooksListingController.collectionId.value = id.toString();
    //       //   homeController.languageModel ?? await homeController.getSortData();
    //       //   ebooksListingController.initializeFilter();
    //       //   log(ebooksListingController.collectionId.value);
    //       //   ebooksListingController.booksApiCallType.value =
    //       //       'fetchBooksHomeViewAllListing';

    //       //   ebooksListingController.viewAllListingBookTitle.value =
    //       //       collTitle.toString();

    //       //   await ebooksListingController.fetchBooksHomeViewAllListing(
    //       //     // collectionBookId: homecollectionResult.id.toString(),
    //       //     token: '',
    //       //   );

    //       //   Get.back();

    //       //   if (!ebooksListingController.isLoadingData.value) {
    //       //     Get.toNamed(
    //       //       AppRoute.ebooksListingScreen,
    //       //       arguments: {
    //       //         "viewAllListingBookTitle": collTitle.toString(),
    //       //       },
    //       //     );
    //       //   }
    //       // }
    //       // if (collType == 'Video') {
    //       //   Utils().showLoader();
    //       //   var videoListingController = Get.put(VideoListingController());
    //       //   videoListingController.prevScreen.value = "homeCollection";
    //       //   videoListingController.collectionId.value = id.toString();
    //       //   homeController.languageModel ?? await homeController.getSortData();
    //       //   videoListingController.initializeFilter();

    //       //   videoListingController.videoApiCallType.value =
    //       //       'fetchVideoHomeViewAllListing';
    //       //   log(videoListingController.videoApiCallType.value);
    //       //   videoListingController.viewAllListingVideoTitle.value =
    //       //       collTitle.toString();

    //       //   await videoListingController.fetchVideoHomeViewAllListing(
    //       //     token: '',
    //       //     // collectionVideoId: homecollectionResult.id.toString(),
    //       //   );
    //       //   Get.back();
    //       //   if (!videoListingController.isLoadingData.value) {
    //       //     Get.toNamed(
    //       //       AppRoute.videoListingScreen,
    //       //       arguments: {
    //       //         "viewAllListingVideoTitle": collTitle.toString(),
    //       //       },
    //       //     );
    //       //   }
    //       // }
    //       // if (collType == 'Artist') {
    //       //   Utils().showLoader();
    //       //   var gurujiListingController = Get.find<GurujiListingController>();
    //       //   gurujiListingController.prevScreen.value = "homeCollection";

    //       //   gurujiListingController.collectionId.value = id.toString();

    //       //   gurujiListingController.gurujiApiCallType.value =
    //       //       'fetchGurujiHomeViewAllListing';

    //       //   gurujiListingController.viewAllListingGurujiTitle.value =
    //       //       collTitle.toString();

    //       //   await gurujiListingController.fetchGurujiHomeViewAllListing(
    //       //     collectionArtsitId: id.toString(),
    //       //     token: '',
    //       //   );

    //       //   Get.back();

    //       //   if (!gurujiListingController.isLoadingData.value) {
    //       //     Get.toNamed(
    //       //       AppRoute.gurujiListingScreen,
    //       //       arguments: {
    //       //         "viewAllListingGurujiTitle": collTitle!.toString(),
    //       //       },
    //       //     );
    //       //   }
    //       // }
    //       // if (collType == 'Audio') {
    //       //   var audioListingController = Get.find<AudioListingController>();
    //       //   Utils().showLoader();
    //       //   audioListingController.prevScreen.value = "homeCollection";
    //       //   audioListingController.collectionId.value = id;
    //       //   homeController.languageModel ?? await homeController.getSortData();
    //       //   audioListingController.initializeFilter();

    //       //   audioListingController.audioApiCallType.value =
    //       //       'fetchAudioHomeViewAllListing';

    //       //   audioListingController.viewAllListingAudioTitle.value =
    //       //       collTitle.toString();

    //       //   await audioListingController.fetchAudioHomeViewAllListing(
    //       //     token: '',
    //       //   );
    //       //   Get.back();
    //       //   if (!audioListingController.isLoadingData.value) {
    //       //     Get.toNamed(
    //       //       AppRoute.audioListingScreen,
    //       //       arguments: {
    //       //         "viewAllListingAudioTitle": collTitle.toString(),
    //       //       },
    //       //     );
    //       //   }
    //       // }
    //     }

    //     if (type.toString() == 'ExploreCollection') {
    //       log("Comes here");
    //       while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
    //         Get.back();
    //       }
    //       Get.find<BottomAppBarServices>().onItemTapped(1);
    //       if (collType == 'Book') {
    //         Utils().showLoader();
    //         //Call Ebooklisting ViewAll API here
    //         var homeController = Get.find<HomeController>();
    //         var ebooksListingController = Get.find<EbooksListingController>();
    //         ebooksListingController.prevScreen.value = "collection";
    //         ebooksListingController.collectionId.value = id.toString();
    //         homeController.languageModel ?? await homeController.getSortData();
    //         ebooksListingController.initializeFilter();

    //         ebooksListingController.booksApiCallType.value =
    //             'fetchBooksExploreViewAllListing';

    //         ebooksListingController.viewAllListingBookTitle.value =
    //             collTitle.toString();

    //         await ebooksListingController.fetchBooksExploreViewAllListing(
    //           // collectionBookId: e.id.toString(),
    //           token: '',
    //         );

    //         Get.back();

    //         if (!ebooksListingController.isLoadingData.value) {
    //           Get.toNamed(
    //             AppRoute.ebooksListingScreen,
    //             // arguments: {
    //             //   "viewAllListingBookTitle":
    //             //       e.title!.toString(),
    //             // },
    //           );
    //         }
    //       }
    //       if (collType == 'Satsang') {
    //         Utils().showLoader();
    //         var controller = Get.find<ExploreController>();
    //         var homeController = Get.find<HomeController>();
    //         controller.prevScreen.value = "collection";
    //         controller.collectionId.value = id.toString();
    //         homeController.languageModel ?? await homeController.getSortData();
    //         controller.initializeFilter();
    //         controller.audioApiCallType.value =
    //             'fetchAudioExploreViewAllListing';

    //         controller.viewAllListingAudioTitle.value = collTitle.toString();
    //         controller.clearSatsangList();
    //         await controller.fetchAudioExploreViewAllListing(
    //           token: '',
    //           // collectionAudioId: e.id.toString(),
    //         );
    //         Get.back();
    //         if (!controller.isSatsangLoadingData.value) {
    //           controller.tabIndex.value = 1;
    //           // Get.toNamed(
    //           //   AppRoute.audioListingScreen,
    //           // arguments: {
    //           //   "viewAllListingAudioTitle":
    //           //       e.title!.toString(),
    //           // },
    //           // );
    //         }
    //       }
    //     }
    //     if (type.toString() == 'Quote') {
    //       log("Comes here Quotes");
    //       while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
    //         Get.back();
    //       }
    //       Get.find<BottomAppBarServices>().onItemTapped(1);

    //       var controller = Get.find<ExploreController>();
    //       Utils().showLoader();
    //       controller.quotesListing.isEmpty
    //           ? await controller.fetchQuotes()
    //           : null;
    //       controller.tabIndex.value = 3;
    //       Get.back();
    //     }
    //     if (type.toString() == 'Satsang') {
    //       log("Comes here Satsang");
    //       while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
    //         Get.back();
    //       }
    //       Get.find<BottomAppBarServices>().onItemTapped(1);

    //       var controller = Get.find<ExploreController>();
    //       Utils().showLoader();
    //       controller.satsangListing.isEmpty
    //           ? await controller.fetchSatsang()
    //           : null;
    //       controller.tabIndex.value = 1;
    //       Get.back();
    //     }
    //     if (type.toString() == 'Mantra') {
    //       log("Comes here Mantra");
    //       while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
    //         Get.back();
    //       }
    //       Get.find<BottomAppBarServices>().onItemTapped(1);

    //       var controller = Get.find<ExploreController>();
    //       Utils().showLoader();
    //       controller.mantraListing.isEmpty
    //           ? await controller.fetchMantra()
    //           : null;
    //       controller.tabIndex.value = 2;
    //       Get.back();
    //     }
    //   } else {
    //     log("No Bottom App Services Initialized");
    //   }
    //   /////////////////////////VIBHOR//////////////////////

    //   /////////////////////////////////////OLD CODE
    //   /*
    //   var notificationTypeBg = data['type'].toString();

    //   var orderIdBg = data['type_id'].toString(); //just to check for now

    //   // showLoading(Get.context!);
    //   // await Get.find<OrderController>().getMyOrderDetails(orderId);

    //   // orderId = data['type_id'].toString(); //just to check for now
    //   print("Firebase class orderid = ${orderIdBg}");

    //   print("here");

    //   print("firevib onMessageOpenedApp.listen is triggered");

    //   // print(
    //   //     "firevib onMessageOpenedApp.listen is token ${Get.find<OrderController>().token}");

    //   // showLoading(Get.context!);
    //   // await Get.find<OrderController>().getMyOrderDetails(orderIdBg);

    //   print("firevib onMessageOpenedApp.listen is triggered api call k baad");

    //   */

    //   print(message.data);
    // });

    // //Terminated
    // // FirebaseMessaging.onBackgroundMessage((message) async {
    // //   print('onBackground Message');

    // //   FirebaseMessaging.instance.getInitialMessage().then(
    // //     (message) async {
    // //       if (message != null) {
    // //         //navigator two orther screen

    // //         var data = message.data;
    // //         var notificationTypeClosed = data['type'].toString();

    // //         // if (notificationType == 'Order') {

    // //         var orderIdClosed =
    // //             data['type_id'].toString(); //just to check for now

    // //         print("Firebase class orderid = ${orderIdClosed}");

    // //         print("here");

    // //         print("firevib onBackgroundMessage is triggered");

    // //         // print(
    // //         //     "firevib onBackgroundMessage is token ${Get.find<OrderController>().token}");

    // //         // showLoading(Get.context!);
    // //         // await Get.find<OrderController>()
    // //         //     .getMyOrderDetails(orderIdClosed);

    // //         print("firevib onBackgroundMessage is triggered api call k baad");

    // //         // }
    // //       } else {
    // //         log("null h bg message");
    // //       }
    // //     },
    // //   );
    // // });

    //For Foreground Notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showFlutterNotification(message);

      print("remote message data ${message.data}");

      var data = message.data;

      fgId = data['selected_id'];
      fgType = data['type'];
      fgCollType = data['collection_type'];
      fgCollTitle = data['collection_title'];

      // var id = data['selected_id'];
      // var type = data['type'];

      print(message.data);
      print('----------- here');
    });
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin?.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android.smallIcon,
              channelDescription: channel.description,
            ),
            iOS: DarwinNotificationDetails()),
      );
    }
  }

  Future<void> setupFlutterNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (Platform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              sound: true,
              provisional: false);
      print("user granted permission : ${settings.authorizationStatus}");
    }
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/launcher_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              print('here is payload ---> $payload');
            });

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMacOS,
    );

    void onReceiveNotificationResponse(NotificationResponse payload) async {
      /////////////////////////VIBHOR//////////////////////
      //Foreground redirection code
      if (Get.isRegistered<BottomAppBarServices>()) {
        if (fgType.toString() == 'Book') {
          log("Redirecting to book details screen");
          Utils().showLoader();

          Get.find<EbookDetailsController>().prevRoute.value = Get.currentRoute;
          await Get.find<EbookDetailsController>()
              .fetchBookDetails(token: '', bookId: int.parse(fgId));

          Get.back();

          if (!Get.find<EbookDetailsController>().isLoadingData.value) {
            Get.toNamed(AppRoute.ebookDetailsScreen);
          }
        }

        if (fgType.toString() == 'Audio') {
          log("Redirecting to book details screen");
          var detailsController = Get.put(AudioDetailsController());
          Utils().showLoader();
          detailsController.prevRoute.value = Get.currentRoute;
          await detailsController.fetchAudioDetails(
              audioId: int.parse(fgId), token: '');
          Get.back();
          if (!detailsController.isLoadingData.value) {
            Get.toNamed(AppRoute.audioDetailsScreen);
          }
        }

        if (fgType.toString() == 'Video') {
          var videoDetailsController = Get.find<VideoDetailsController>();
          Utils().showLoader();
          videoDetailsController.prevRoute.value = Get.currentRoute;
          await videoDetailsController.fetchVideoDetails(
              videoId: int.parse(fgId), isNext: false, token: '');
          Get.back();
          if (!videoDetailsController.isLoadingData.value) {
            Get.toNamed(AppRoute.videoDetailsScreen);
          }
        }

        if (fgType.toString() == 'Artist') {
          Utils().showLoader();
          await Get.find<GurujiDetailsController>()
              .fetchGurujiDetails(id: fgId.toString());
          Get.back();
          if (Get.find<GurujiDetailsController>().isLoadingData.value ==
                  false &&
              Get.find<GurujiDetailsController>().isDataNotFound.value ==
                  false) {
            debugPrint("DAta loaded ...Successfully");
            Get.toNamed(AppRoute.gurujiDetailsScreen);
          }
        }

        if (fgType.toString() == 'HomeCollection') {
          log("Comes here");
          while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
            Get.back();
          }
          Get.find<BottomAppBarServices>().onItemTapped(0);
          // log("$id yeh kya data aaraha h yrr");

          final homeController = Get.find<HomeController>();
          if (fgCollType == 'Book') {
            Utils().showLoader();
            //Call Ebooklisting ViewAll API here
            var ebooksListingController = Get.find<EbooksListingController>();
            ebooksListingController.prevScreen.value = "homeCollection";
            ebooksListingController.collectionId.value = fgId.toString();
            homeController.languageModel ?? await homeController.getSortData();
            ebooksListingController.initializeFilter();

            ebooksListingController.booksApiCallType.value =
                'fetchBooksHomeViewAllListing';

            ebooksListingController.viewAllListingBookTitle.value =
                fgCollTitle.toString();

            await ebooksListingController.fetchBooksHomeViewAllListing(
              // collectionBookId: homecollectionResult.id.toString(),
              token: '',
            );

            Get.back();

            if (!ebooksListingController.isLoadingData.value) {
              Get.toNamed(
                AppRoute.ebooksListingScreen,
                arguments: {
                  "viewAllListingBookTitle": fgCollTitle.toString(),
                },
              );
            }
          }
          if (fgCollType == 'Video') {
            Utils().showLoader();
            var videoListingController = Get.find<VideoListingController>();
            videoListingController.prevScreen.value = "homeCollection";
            videoListingController.collectionId.value = fgId.toString();
            homeController.languageModel ?? await homeController.getSortData();
            videoListingController.initializeFilter();

            videoListingController.videoApiCallType.value =
                'fetchVideoHomeViewAllListing';

            videoListingController.viewAllListingVideoTitle.value =
                fgCollTitle.toString();

            await videoListingController.fetchVideoHomeViewAllListing(
              token: '',
              // collectionVideoId: homecollectionResult.id.toString(),
            );
            Get.back();
            if (!videoListingController.isLoadingData.value) {
              Get.toNamed(
                AppRoute.videoListingScreen,
                arguments: {
                  "viewAllListingVideoTitle": fgCollTitle.toString(),
                },
              );
            }
          }
          if (fgCollType == 'Artist') {
            Utils().showLoader();
            var gurujiListingController = Get.find<GurujiListingController>();
            gurujiListingController.prevScreen.value = "homeCollection";

            gurujiListingController.collectionId.value = fgId.toString();

            gurujiListingController.gurujiApiCallType.value =
                'fetchGurujiHomeViewAllListing';

            gurujiListingController.viewAllListingGurujiTitle.value =
                fgCollTitle.toString();

            await gurujiListingController.fetchGurujiHomeViewAllListing(
              collectionArtsitId: fgId.toString(),
              token: '',
            );

            Get.back();

            if (!gurujiListingController.isLoadingData.value) {
              Get.toNamed(
                AppRoute.gurujiListingScreen,
                arguments: {
                  "viewAllListingGurujiTitle": fgCollTitle!.toString(),
                },
              );
            }
          }
          if (fgCollType == 'Audio') {
            var audioListingController = Get.find<AudioListingController>();
            Utils().showLoader();
            audioListingController.prevScreen.value = "homeCollection";
            audioListingController.collectionId.value = fgId;
            homeController.languageModel ?? await homeController.getSortData();
            audioListingController.initializeFilter();

            audioListingController.audioApiCallType.value =
                'fetchAudioHomeViewAllListing';

            audioListingController.viewAllListingAudioTitle.value =
                fgCollTitle.toString();

            await audioListingController.fetchAudioHomeViewAllListing(
              token: '',
            );
            Get.back();
            if (!audioListingController.isLoadingData.value) {
              Get.toNamed(
                AppRoute.audioListingScreen,
                arguments: {
                  "viewAllListingAudioTitle": fgCollTitle.toString(),
                },
              );
            }
          }
        }

        if (fgType.toString() == 'ExploreCollection') {
          log("Comes here");
          while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
            Get.back();
          }
          Get.find<BottomAppBarServices>().onItemTapped(1);
          if (fgCollType == 'Book') {
            Utils().showLoader();
            //Call Ebooklisting ViewAll API here
            var homeController = Get.find<HomeController>();
            var ebooksListingController = Get.find<EbooksListingController>();
            ebooksListingController.prevScreen.value = "collection";
            ebooksListingController.collectionId.value = fgId.toString();
            homeController.languageModel ?? await homeController.getSortData();
            ebooksListingController.initializeFilter();

            ebooksListingController.booksApiCallType.value =
                'fetchBooksExploreViewAllListing';

            ebooksListingController.viewAllListingBookTitle.value =
                fgCollTitle.toString();

            await ebooksListingController.fetchBooksExploreViewAllListing(
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
          if (fgCollType == 'Satsang') {
            Utils().showLoader();
            var controller = Get.find<ExploreController>();
            var homeController = Get.find<HomeController>();
            controller.prevScreen.value = "collection";
            controller.collectionId.value = fgId.toString();
            homeController.languageModel ?? await homeController.getSortData();
            controller.initializeFilter();
            controller.audioApiCallType.value =
                'fetchAudioExploreViewAllListing';

            controller.viewAllListingAudioTitle.value = fgCollTitle.toString();
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

        if (fgType.toString() == 'Quote') {
          log("Comes here Quotes");
          while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
            Get.back();
          }
          Get.find<BottomAppBarServices>().onItemTapped(1);

          var controller = Get.find<ExploreController>();
          Utils().showLoader();
          controller.quotesListing.isEmpty
              ? await controller.fetchQuotes()
              : null;
          controller.tabIndex.value = 3;
          Get.back();
        }

        if (fgType.toString() == 'Satsang') {
          log("Comes here Satsang");
          while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
            Get.back();
          }
          Get.find<BottomAppBarServices>().onItemTapped(1);

          var controller = Get.find<ExploreController>();
          Utils().showLoader();
          controller.satsangListing.isEmpty
              ? await controller.fetchSatsang()
              : null;
          controller.tabIndex.value = 1;
          Get.back();
        }

        if (fgType.toString() == 'Mantra') {
          log("Comes here Mantra");
          while (Get.currentRoute != AppRoute.bottomAppBarScreen) {
            Get.back();
          }
          Get.find<BottomAppBarServices>().onItemTapped(1);

          var controller = Get.find<ExploreController>();
          Utils().showLoader();
          controller.mantraListing.isEmpty
              ? await controller.fetchMantra()
              : null;
          controller.tabIndex.value = 2;
          Get.back();
        }

        if (fgType.toString() == 'Event') {
          Utils().showLoader();

          await Get.find<EventDetailsController>()
              .fetchEventDetails(eventId: fgId.toString());

          Get.back();

          if (!Get.find<EventDetailsController>().isLoadingData.value) {
            Get.toNamed(AppRoute.eventDetailsScreen);
          }
        }
      } else {
        log("No Bottom App Services Initialized");
      }
      /////////////////////////VIBHOR//////////////////////
      //This is where we redirect on tap
      // if (payload != null) {
      //   log('firevib notification payload: $payload');
      //   log('firevib notification payload: ${payload.payload}');
      // }

      //For audio deails redirection

      // if (payload != null &&
      //     notificationTypeForeground != null &&
      //     notificationTypeForeground == 'Order') {
      // debugPrint('firevib notification payload: $payload');
      // debugPrint('firevib notification payload: ${payload.payload}');

      //   showLoading(Get.context!);
      //   await Get.find<OrderController>().getMyOrderDetails(orderIdForeground);
    }

    await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onReceiveNotificationResponse);

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      playSound: true,
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
