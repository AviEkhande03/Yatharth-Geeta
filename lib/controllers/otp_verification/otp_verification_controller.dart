import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:telephony/telephony.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import '../startup/startup_controller.dart';
import '../../utils/validations_mixin.dart';
import 'package:http/http.dart' as http;
import '../../const/colors/colors.dart';
import '../../routes/app_route.dart';
import '../../services/firebase/firebase_cloud_messaging.dart';
import '../../services/otp_verification/otp_verification_service.dart';
import '../../utils/utils.dart';

class OtpVerificationController extends GetxController with ValidationsMixin {
  TextEditingController otpCode = TextEditingController();
  final otpValidationService = OTPVerificationService();
  final startupController = Get.find<StartupController>();
  //dynamic argumentData = Get.arguments;
  dynamic argumentData;
  RxString? otpValidation = ''.obs;
  RxBool isResendVisible = false.obs;
  var _remainingSeconds =
      60.obs; // Use the "obs" extension for reactive variables
  Timer? _timer;
  String _verificationId = "";
  int? _resendToken;
  //Telephony telephony = Telephony.instance;

  int get remainingMinutes => (_remainingSeconds.value / 60).floor();
  int get remainingSeconds => _remainingSeconds.value % 60;

  // Method to set arguments after initialization
  void setArguments(dynamic args) {
    argumentData = args;
  }

  // Start the timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds--;
        //Making resend TP option visible only when timer is set to 00:00
        if (_remainingSeconds.value == 0) {
          otpCode.clear();
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          isResendVisible.value = true;
        } else {
          isResendVisible.value = false;
        }
      } else {
        _timer?.cancel();
        // Timer finished, you can perform any action you want here
      }
    });
  }

  //Method to reset the timer
  void resetTimer() {
    // Stop the existing timer if it's running
    _timer?.cancel();

    //Making the OTP field clear
    otpCode.clear();

    // Reset the remaining seconds to 60
    _remainingSeconds.value = 60;

    // Start the timer again
    startTimer();
  }

  @override
  void onInit() {
    super.onInit();
    /*if(Platform.isAndroid){
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          print(message.address); // +977981******67, sender nubmer
          print(message.body); // Your OTP code is 34567
          print(message.date); // 1659690242000, timestamp

          // get the message
          String sms = message.body.toString();

          if(message.body!.contains('yatharth-geeta-prod-76169.firebaseapp.com')){
            // verify SMS is sent for OTP with sender number
            RegExp regex = RegExp(r'\b\d{6}\b');
            RegExpMatch? match = regex.firstMatch(message.body!);

            if (match != null) {
              String otp = match.group(0)!;
              print("OTP: $otp");
              otpCode.text = otp;
              validateWithOTP();
            }
          }else{
            print("Normal message.");
          }
        },
        listenInBackground: false,
      );
    }*/
  }

  @override
  void onReady() {
    super.onReady();
    //startTimer();
    // _verificationId = argumentData['verificationId'];
    // _resendToken = argumentData['resendToken'];
    // print(argumentData[0]['phone']);
    // print(argumentData[1]['workflow']);
  }

  // Dispose the timer when the controller is disposed
  @override
  void onClose() {
    // _timer?.cancel();
    super.onClose();
  }

  bool validateOTP() {
    //Validating the value entered in OTP field
    otpValidation?.value = validatedOtp(otpCode.value.text) ?? '';
    if (otpValidation?.value != '') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> validateWithOTP() async {
    bool isValidated = validateOTP();
    //If the OTP field is validated then below code will be executed
    if (isValidated) {
      //Show the loader
      Utils().showLoader();
      // final response = await otpValidationService.validateOTP(
      //     argumentData[0]['phone'],
      //     otpCode.text.toString(),
      //     argumentData[1]['workflow'],
      //     FirebaseCloudMessaging.fcmToken.toString());
      // if (response == " ") {
      // } else if (response is http.Response) {
      //   if (response.statusCode == 404) {
      //     Map mapdata = jsonDecode(response.body.toString());
      //     Get.back();
      //     Utils.customToast(mapdata['message'], kRedColor,
      //         kRedColor.withOpacity(0.2), "Error");
      //     // print(mapdata);
      //   } else if (response.statusCode == 500) {
      //     Map mapdata = jsonDecode(response.body.toString());
      //     Get.back();
      //     Utils.customToast(mapdata['message'], kRedColor,
      //         kRedColor.withOpacity(0.2), "Error");
      //     // print(mapdata);
      //   } else if (response.statusCode == 200) {
      //     Map mapdata = jsonDecode(response.body.toString());
      //     if (mapdata['success'] == 0) {
      //       Get.back();
      //       otpCode.clear();
      //       if (mapdata['message'].runtimeType == List<dynamic>) {
      //         mapdata['message'].forEach((str) {
      //           Utils.customToast(
      //               str, kRedColor, kRedColor.withOpacity(0.2), "Error");
      //         });
      //       } else {
      //         Utils.customToast(mapdata['message'], kRedColor,
      //             kRedColor.withOpacity(0.2), "Error");
      //       }
      //       // print(mapdata);
      //     } else {
      //       Utils.saveToken(mapdata['data']['result']['remember_token']);
      //       debugPrint(
      //           '----Token---> ${mapdata['data']['result']['remember_token']}');
      //       //await startupController.fetchStartupData();
      //       //If an user was in Guest mode and logs in now then guest mode should be false
      //       if (await Utils.isGuestUser()) {
      //         Utils.setGuestUser(false);
      //       }
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .personal!.myPlayedList =
      //           mapdata['data']['result']['me_data']['Personal']
      //               ['My Played List'] as bool;
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .personal!.likedList =
      //           mapdata['data']['result']['me_data']['Personal']['Liked List']
      //               as bool;
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.notification =
      //           mapdata['data']['result']['me_data']['Others']['Notification']
      //               as bool;
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.languagePreference =
      //           mapdata['data']['result']['me_data']['Others']
      //               ['Language Preference'] as bool;
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.contactUs =
      //           mapdata['data']['result']['me_data']['Others']['Contact Us']
      //               as bool;
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.aboutUs =
      //           mapdata['data']['result']['me_data']['Others']['About Us'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.termsNConditions =
      //           mapdata['data']['result']['me_data']['Others']
      //               ['Terms n conditions'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.privacyPolicy =
      //           mapdata['data']['result']['me_data']['Others']
      //               ['Privacy Policy'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.rateUs =
      //           mapdata['data']['result']['me_data']['Others']['Rate Us'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //           .others!.help =
      //           mapdata['data']['result']['me_data']['Others']['Help'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .others!.shareApp =
      //           mapdata['data']['result']['me_data']['Others']['Share App'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .action!.changePassword =
      //           mapdata['data']['result']['me_data']['Action']
      //               ['Change Password'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .action!.deleteAccount =
      //           mapdata['data']['result']['me_data']['Action']
      //               ['Delete account'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .action!.logout =
      //           mapdata['data']['result']['me_data']['Action']['Logout'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .action!.login =
      //           mapdata['data']['result']['me_data']['Action']['Login'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .extraaTabs!.edit =
      //           mapdata['data']['result']['me_data']['extraa_tabs']['Edit'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .extraaTabs!.wishlistIcon =
      //           mapdata['data']['result']['me_data']['extraa_tabs']
      //               ['Wishlist Icon'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .extraaTabs!.notificationIcon =
      //           mapdata['data']['result']['me_data']['extraa_tabs']
      //               ['Notification Icon'];
      //       startupController.startupData.first.data!.result!.screens!.meData!
      //               .extraaTabs!.downloadIcon =
      //           mapdata['data']['result']['me_data']['extraa_tabs']
      //               ['Download Icon'];
      //       debugPrint(
      //           "mapdata['data']['result']['fcm_notification']:${mapdata['data']['result']['fcm_notification']}");
      //       await Utils.saveNotificationStatus(
      //           mapdata['data']['result']['fcm_notification']);
      //       _timer?.cancel();
      //       Get.back();
      //       // debugPrint("After OTpValidateion");
      //       // debugPrint("startupController.startupData.first.data!.result!.screens!.meData!.personal!.myPlayedList:${startupController.startupData.first.data!.result!.screens!.meData!.personal!.myPlayedList}");
      //       // debugPrint("startupController.startupData.first.data!.result!.screens!.meData!.personal!.likedList!.myPlayedList:${startupController.startupData.first.data!.result!.screens!.meData!.personal!.likedList}");
      //       Get.offAllNamed(AppRoute.bottomAppBarScreen);
      //     }
      //   }
      // }

      //Phase 2 changes for OTP from Firebase

      //Below part will be executed when the when OTP is received in some other device
      //Below try catch block will create credential using verification Id and OTP received from previous screen and signIn
      try {
        print("argumentData.toString():${argumentData.toString()}");
        FirebaseAuth auth = FirebaseAuth.instance;
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: argumentData['verificationId'],
            smsCode: otpCode.text);
        await auth.signInWithCredential(credential).then((value) {
          print("value.user!.displayName:${value.user!.displayName}");
          Get.back();
          //After signIn using phone below method is called for notifying backend that the login has happened via firebase.
          loginUser();
        });
      } catch (ex) {
        if (ex is FirebaseAuthException) {
          Get.back();
          log(ex.toString());
          Utils.customToast(ex.code.toString(), kRedColor,
              kRedColor.withOpacity(0.2), "Error");
        } else {
          Get.back();
          log(ex.toString());
          Utils.customToast(
              ex.toString(), kRedColor, kRedColor.withOpacity(0.2), "Error");
        }
      }
    }
  }

  loginUser() async {
    //Show Loader
    Utils().showLoader();
    //Below api call loginUser method of otpValidationService with below parameters
    //1.phone number
    //2.country code
    //3.is verified which can be 'Y' or 'N' on the basis whether it's verified or not
    //fcm token
    final response = await otpValidationService.loginUser(
        argumentData['phone'],
        argumentData['countryCode'],
        "Y",
        FirebaseCloudMessaging.fcmToken.toString());
    if (response == " ") {
    } else if (response is http.Response) {
      //If response is 404 then back() closes the loader and show the error toast
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      }
      //If response is 500 then back() closes the loader and show the error toas
      else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        //If status is 200 i.e OK then
        //jsonDecode() records data into mapdata
        Map mapdata = jsonDecode(response.body.toString());
        //If success is 0 then
        if (mapdata['success'] == 0) {
          //Turn off the loader by back()
          print(mapdata);
          Get.back();
          //As success code is o there might be list pof validation errors, so checking if message parameter's type is list then iterate through it and toast out the messages.
          if (mapdata['message'].runtimeType == List<dynamic>) {
            mapdata['message'].forEach((str) {
              Utils.customToast(
                  str, kRedColor, kRedColor.withOpacity(0.2), "Error");
            });
          }
          //Else if it's simply a message simply show it out via toast
          else {
            Utils.customToast(mapdata['message'], kRedColor,
                kRedColor.withOpacity(0.2), "Error");
          }
        }
        //If success code is not 0 i.e. 1
        else {
          //save the token we got in internal storage
          Utils.saveToken(mapdata['data']['result']['remember_token']);
          debugPrint(
              '----Token---> ${mapdata['data']['result']['remember_token']}');

          //If an user was in Guest mode and logs in now then guest mode should be false
          if (await Utils.isGuestUser()) {
            Utils.setGuestUser(false);
            if (Get.isRegistered<PlayerController>()) {
              Get.find<PlayerController>().isGuestUser.value = false;
            }
          }

          //Updating StartUp Data(as the user is logged in many attribute might change in startup hence it's needed to be done)
          Utils().updateStartUpData(mapdata);

          debugPrint(
              "mapdata['data']['result']['fcm_notification']:${mapdata['data']['result']['fcm_notification']}");

          //As the user is logged in now it's notification status i.e. user will receive notification or not which is in profile section needs to be updated locally as well
          await Utils.saveNotificationStatus(
              mapdata['data']['result']['fcm_notification']);
          _timer?.cancel();

          //Close the loader
          Get.back();
          if (Get.isRegistered<PlayerController>()) {
            // Get.delete<PlayerController>();
            Get.find<PlayerController>().audioPlayer.value.pause();
            Get.find<PlayerController>().audioPlayer.value.dispose();
          }
          //Move to the bottom App bar screen by removing all previous screens
          Get.offAllNamed(AppRoute.bottomAppBarScreen);
        }
      }
    }
  }

  //Method that gets trigerred when clicked on resendOTP()
  Future<void> resendOTP() async {
    //show the loader
    Utils().showLoader();
    // final response = await otpValidationService.resendOTP(
    //     argumentData[0]['phone'], argumentData[1]['workflow']);
    // if (response == " ") {
    // } else if (response is http.Response) {
    //   if (response.statusCode == 404) {
    //     Map mapdata = jsonDecode(response.body.toString());
    //     Get.back();
    //     Utils.customToast(
    //         mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
    //     // print(mapdata);
    //   } else if (response.statusCode == 500) {
    //     Map mapdata = jsonDecode(response.body.toString());
    //     Get.back();
    //     Utils.customToast(
    //         mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
    //     // print(mapdata);
    //   } else if (response.statusCode == 200) {
    //     Map mapdata = jsonDecode(response.body.toString());
    //     if (mapdata['success'] == 0) {
    //       Get.back();
    //       Utils.customToast(mapdata['message'], kRedColor,
    //           kRedColor.withOpacity(0.2), "Error");
    //       // print(mapdata);
    //     } else {
    //       Get.back();
    //       resetTimer();
    //     }
    //   }
    // }

    //sendOTP() called for retriggering the OTP
    sendOtp(argumentData['phone']);
  }

  Future<dynamic> sendOtp(phoneNumber) async {
    //verification Id received from previous screen
    _verificationId = argumentData['verificationId'];
    //resend Token received from previous screen
    _resendToken = argumentData['resendToken'];

    //Creating Firebase auth instance
    FirebaseAuth auth = FirebaseAuth.instance;

    //For below method documentation refer loginWithOTP controller.
    await auth.verifyPhoneNumber(
      phoneNumber: '${argumentData['countryCode']}${phoneNumber}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // if (Get.isDialogOpen == true) {
        //   Get.back();
        // }
        otpCode.text = credential.smsCode!;
        await auth.signInWithCredential(credential).then((value) {
          loginUser();
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.back();
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        log(e.code);
        Utils.customToast(
            e.code, kRedColor, kRedColor.withOpacity(0.2), "Error");
      },
      codeSent: (String verificationId, int? resendToken) async {
        Get.back();
        _verificationId = verificationId;
        _resendToken = resendToken;
        resetTimer();
      },
      forceResendingToken: _resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }
}
