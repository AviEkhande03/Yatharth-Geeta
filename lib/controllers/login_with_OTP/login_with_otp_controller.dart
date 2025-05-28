import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../const/colors/colors.dart';
import '../../services/firebase/firebase_cloud_messaging.dart';
import '../../utils/validations_mixin.dart';
import '../../routes/app_route.dart';
import '../../services/login_with_otp/login_with_OTP_service.dart';
import '../../utils/utils.dart';
import '../audio_player/player_controller.dart';
import '../otp_verification/otp_verification_controller.dart';
import '../startup/startup_controller.dart';

class LoginWithOTPController extends GetxController with ValidationsMixin {
  RxString? phoneValidation = ''.obs;
  RxString countryCode = '+91'.obs;
  RxInt phoneLength = 10.obs;
  RxString verificationCode = ''.obs;
  RxInt resendCode = 0.obs;
  RxBool isGuestUser = false.obs;
  TextEditingController phone = TextEditingController();
  //TextEditingController otp = TextEditingController();
  final loginWithOTPService = LoginWithOTPService();
  final startupController = Get.find<StartupController>();
  final otpVerificationController = Get.find<OtpVerificationController>();
  String displayName = '';
  String uid = '';

  //function to validate phone number where method returns true or false on the basis of validatedPhoneNumber method of ValidationsMixin
  bool validatePhone() {
    phoneValidation?.value =
        validatedPhoneNumber(phone.value.text, phoneLength.value) ?? '';
    if (phoneValidation?.value != '') {
      return false;
    } else {
      return true;
    }
  }

  //This function will be called when user taps on login button which first validates phone number
  void validate(context) {
    bool isValidated = validatePhone();
    //If phone number is validated then show the loader and call the sendOtp() for sending OTP
    if (isValidated) {
      Utils().showLoader();
      sendOtp(
        phone.text,
      );
      //loginUser();
    }
  }

  //Phase1 method for login via OTP from backend
  /*Future<void> loginUser() async {
    final response = await loginWithOTPService.loginUser(
        phone.text.toString(), FirebaseCloudMessaging.fcmToken.toString());
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        Utils.customToast(
            mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          print(mapdata);
          Get.back();
          if (mapdata['message'].runtimeType == List<dynamic>) {
            mapdata['message'].forEach((str) {
              Utils.customToast(
                  str, kRedColor, kRedColor.withOpacity(0.2), "Error");
            });
          } else {
            Utils.customToast(mapdata['message'], kRedColor,
                kRedColor.withOpacity(0.2), "Error");
          }
        } else {
          print(mapdata);
          Get.back();
          Get.toNamed(AppRoute.otpVerificationScreen, arguments: [
            {'phone': phone.text.toString()},
            {'workflow': "login"}
          ]);
          phone.clear();
        }
      }
    }
  }*/

  //Below is the method for triggering OTP from firebase
  Future<dynamic> sendOtp(phoneNumber) async {
    //Creating Firebase Auth instance
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      //phone number to be passed with country code
      phoneNumber: '${countryCode.value}${phoneNumber}',
      //timeout seconds i.e. time for which app should wait for auto reading OTP
      timeout: const Duration(seconds: 60),
      //below part is triggerred when the auto-verification is completed
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("Inside verificationCompleted");
        //Get.back();
        //await auth.signInWithCredential(credential);
        // await loginUser();

        //Once the auto-verification is done and the current screen is login screen then route to the OTP screen
        if (Get.currentRoute == AppRoute.loginWithOTPScreen) {
          //As OTPVerification Controller is initialized prior,we need to set the arguments that are required in OTPVerification Controller
          otpVerificationController.setArguments({
            'verificationId': verificationCode.value,
            'phone': phone.text,
            'countryCode': countryCode.value,
            'resendToken': resendCode.value
          });
          //Routing to OTP Verification Screeen
          Get.toNamed(AppRoute.otpVerificationScreen);
          //Once we route resetting the timer as the timer should have a fresh start
          otpVerificationController.resetTimer();
        }

        //If the current screen is not login screen and it's already OTP verification screen then simply set the OTP in OTP field
        otpVerificationController.otpCode.text = credential.smsCode!;

        //Once this gets done signing in with credential by below code
        await auth.signInWithCredential(credential).then((value) {
          //Calling loginuser() to make the api call for login process and redirecting accordingly
          otpVerificationController.loginUser();
        });
      },
      //Below part is called when verification is failed
      verificationFailed: (FirebaseAuthException e) {
        //Below back() is for closing the loader
        Get.back();
        //print("verification failed"+e.message!);
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.' + e.message!);
        }
        //Logging and displaying the error toast to the user.
        log(e.code);
        print("verification failed" + e.message!);
        Utils.customToast(
            e.code, kRedColor, kRedColor.withOpacity(0.2), "Error");
      },
      //Below part is triggered when the OTP code is sent to user phone number
      codeSent: (String verificationId, int? resendToken) async {
        Get.back(); //for closing the loader
        //Assigning the values to use it later
        verificationCode.value = verificationId;
        resendCode.value = resendToken ?? 0;
        //setting the arguments in OTP verification controller to use ahead
        otpVerificationController.setArguments({
          'verificationId': verificationCode.value,
          'phone': phone.text,
          'countryCode': countryCode.value,
          'resendToken': resendCode.value
        });
        //Navigating to OTP verification screen
        Get.toNamed(AppRoute.otpVerificationScreen);
        //Once we route resetting the timer as the timer should have a fresh start
        otpVerificationController.resetTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationCode.value = verificationId;
      },
    );
  }

  //Method that is called when user taps on signInWithGoogle
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    debugPrint("googleUser:$googleUser");

    //If the googleUser is not null then perform below steps
    if (googleUser != null) {
      //Getting the display name and id
      displayName = googleUser.displayName!;
      uid = googleUser.id;

      //Show the loader
      Utils().showLoader();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      //debugPrint("googleAuth:$googleAuth");

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      //debugPrint("credentials:${credential.accessToken}");

      // Once signed in, return the UserCredential
      var response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("response.email:${response.user!.email}");
      return response;
    }
  }

  //Below method is triggered when user clicks on apple btn
  Future<AuthorizationCredentialAppleID> signInWithApple() async {
    //Following call gets the user's apple account signed in
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential);
    return credential;
    //Remember to put {List<Scope> scopes = const []} in parameters for the_apple_sign_in
    // result = await TheAppleSignIn.performRequests(
    //   [AppleIdRequest(requestedScopes: scopes)]);

    // switch (result.status) {
    //   case AuthorizationStatus.authorized:
    //     final AppleIdCredential = result.credential!;
    //     final oAuthProvider = OAuthProvider('apple.com');
    //     final credential = oAuthProvider.credential(
    //         idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
    //     var response = await FirebaseAuth.instance.signInWithCredential(credential);
    //     // final firebaseUser = UserCredential.user!;
    //     // if (scopes.contains(Scope.fullName)) {
    //     //   final fullName = AppleIdCredential.fullName;
    //     //   if (fullName != null &&
    //     //       fullName.givenName != null &&
    //     //       fullName.familyName != null) {
    //     //     final displayName = '${fullName.givenName} ${fullName.familyName}';
    //     //     await firebaseUser.updateDisplayName(displayName);
    //     //   }
    //     // }
    //     print("response:$response");
    //     return response;
    //   case AuthorizationStatus.error:
    //     throw PlatformException(
    //         code: 'ERROR_AUTHORIZATION_DENIED',
    //         message: result.error.toString());
    //
    //   case AuthorizationStatus.cancelled:
    //     throw PlatformException(
    //         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    //
    //   default:
    //     throw UnimplementedError();
    // }
  }

  //Below method is called for after gmail or apple sign for marking that the user is logged in to backend
  Future<void> socialLogin(
      String email, String loginType, String loginId, name) async {
    //Calling the socialLoginUser method of loginWithOTPService
    //We passed the required parameters like
    // 1.email,
    // 2.isVerified flag i.e. 'Y' or 'N'(which can be decided on the basis of login via google or apple status),
    // 3.fcm token,
    // 4.loginType i.e. the type through which they are logged in which can be either 'google' or 'apple'
    // 5.loginId i.e. the unique id of the user that we get while logging via google or apple
    // 6.name that is the display name of the user
    final response = await loginWithOTPService.socialLoginUser(email, "Y",
        FirebaseCloudMessaging.fcmToken.toString(), loginType, loginId, name);
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
      //If response is 500 then back() closes the loader and show the error toast
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
          print(mapdata);
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

          print(
              "mapdata['data']['result']['me_data']['profile']['email_editable']:${mapdata['data']['result']['me_data']['profile']['email_editable']}");
          print(
              "mapdata['data']['result']['me_data']['profile']['phone_editable']:${mapdata['data']['result']['me_data']['profile']['phone_editable']}");
          //Updating StartUp Data(as the user is logged in many attribute might change in startup hence it's needed to be done)
          Utils().updateStartUpData(mapdata);

          //As the user is logged in now it's notification status i.e. user will receive notification or not which is in profile section needs to be updated locally as well
          await Utils.saveNotificationStatus(
              mapdata['data']['result']['fcm_notification']);

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

  @override
  void onInit() async {
    super.onInit();
    //setting the guest user value by reading it from utils
    isGuestUser.value = await Utils.isGuestUser();
    // debugPrint("isGuestUser in login with otp init$isGuestUser");
  }

  @override
  void dispose() {
    //setting the guest user value to false
    isGuestUser.value = false;
    super.dispose();
  }
}
