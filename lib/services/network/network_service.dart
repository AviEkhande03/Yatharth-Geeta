import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:yatharthageeta/controllers/startup/startup_controller.dart';
import 'package:yatharthageeta/routes/app_route.dart';
import 'package:yatharthageeta/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class NetworkService extends GetxService {
//   final service = FlutterBackgroundService();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   var connectionStatus = 1.obs;
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//   // -- vaibhav
//   late StreamSubscription<InternetStatus> _internetStatusSubscription;

//   @override
//   void onInit() {
//     super.onInit();

//     initConnectivity();
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   Future<void> initConnectivity() async {
//     ConnectivityResult result = await _connectivity.checkConnectivity();

//     try {
//       result = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       print(e.toString());
//     }

//     return _updateConnectionStatus(result);
//   }

//   _updateConnectionStatus(ConnectivityResult result) {
//     switch (result) {
//       case ConnectivityResult.none:
//         // TODO: Handle this case.
//         connectionStatus.value = 0;

//         break;
//       case ConnectivityResult.wifi:
//         connectionStatus.value = 1;
//         break;
//       case ConnectivityResult.bluetooth:
//         // TODO: Handle this case.
//         connectionStatus.value = 1;

//         break;
//       case ConnectivityResult.ethernet:
//         // TODO: Handle this case.
//         connectionStatus.value = 1;

//         break;
//       case ConnectivityResult.mobile:
//         // TODO: Handle this case.
//         connectionStatus.value = 1;

//         break;

//       case ConnectivityResult.vpn:
//         // TODO: Handle this case.
//         connectionStatus.value = 1;

//         break;

//       default:
//         debugPrint('Network Error, Failed to get network connection');
//         break;
//     }
//     callStartUpApi();
//   }

//   @override
//   void onClose() {
//     // TODO: implement onClose
//     super.onClose();
//     _connectivitySubscription.cancel();
//   }

//   //Method created here to calll startup Api if the net was turned off then on
//   void callStartUpApi() {
//     if (connectionStatus.value == 1) {
//       // debugPrint("Connection status is Changed");
//       if (Get.currentRoute == AppRoute.intermediateScreen) {
//         Utils().showLoader(isNotStartUp: false);
//         Get.find<StartupController>().fetchStartupData();
//       }
//     }
//   }

// // to ensure this is executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// }

//by vibhor

// vaibhav -- 08/04/25

class NetworkService extends GetxService {
  final service = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var connectionStatus = 1.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late StreamSubscription<InternetStatus> _internetStatusSubscription;

  @override
  void onInit() {
    super.onInit();

    // Listen to actual internet access
    _internetStatusSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        connectionStatus.value = 1;
      } else {
        connectionStatus.value = 0;
      }
      callStartUpApi();
    });
  }



  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
    _internetStatusSubscription.cancel();
  }

  // Method to call startup API when internet comes back
  void callStartUpApi() {
    if (connectionStatus.value == 1) {
      // debugPrint("Connection status is Changed");
      if (Get.currentRoute == AppRoute.intermediateScreen) {
        Utils().showLoader(isNotStartUp: false);
        Get.find<StartupController>().fetchStartupData();
      }
    }
  }
}
