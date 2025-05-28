import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../const/colors/colors.dart';
import '../../controllers/privacy_policy/privacy_policy_controller.dart';
import '../../controllers/terms_and_conditions/terms_and_conditions_controller.dart';
import '../../routes/app_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final privacyPoliciesController = Get.put(PrivacyPolicyController());
  final termsAndConditionsController = Get.put(TermsAndConditionsController());
  // final startupController = Get.put(StartupController());
  @override
  void initState() {
    super.initState();
    // Utils().checkShowTut(startupController);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kColorTransparent,
      ),
    );
    _controller = AnimationController(
      duration: const Duration(seconds: (3)),
      vsync: this,
    );
  }

  // void apiCall() async {
  //   await startupController.fetchStartupData();
  // }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //color: Colors.redAccent,
        child: Lottie.asset(
          'assets/lottie/Yatharth-Splash.json',
          fit: BoxFit.fill,
          controller: _controller,
          animate: true,
          onLoaded: (composition) {
            //apiCall();
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() async {
                // String token = '';
                // bool isGuestUser = false;
                // token = await Utils.getToken();
                // isGuestUser = await Utils.isGuestUser();
                // //Get.offNamed(AppRoute.bottomAppBarScreen);
                // if (token != '') {
                //   Get.offNamed(AppRoute.bottomAppBarScreen);
                // } else if (isGuestUser == true) {
                //   Get.offNamed(AppRoute.bottomAppBarScreen);
                // } else {
                //   Get.offNamed(AppRoute.selectLanguageScreen);
                // }
                Get.offNamed(AppRoute.intermediateScreen);
              });
          },
        ),
      ),
    );
  }
}
