import 'dart:io';
import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'const/colors/colors.dart';
import 'const/text_styles/text_styles.dart';
import 'services/network/network_service.dart';
import 'utils/utils.dart';
import 'controllers/startup/startup_controller.dart';

//Basically a screen that appears after splash which checks for version update and also fetches out some initial startup data on the basis of which app will proceed
class IntermediateScreen extends StatelessWidget {
  IntermediateScreen({super.key});
  //Putting the startup controller
  final startupController = Get.put(StartupController(), permanent: true);

  //Method for launching url(in case of app update) called on button tap of update dialog
  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  //Method for opening the bottomsheet when there is app update required
  _openVersionBottomSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,

        // clipBehavior: Clip.antiAlias,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: WillPopScope(
              onWillPop: () async {
                return false; // prevent back button from dismissing the sheet
              },
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
                                  final String url =
                                      Get.find<StartupController>()
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
                                padding:
                                    EdgeInsets.only(top: 10.h, bottom: 10.h),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    //Checking whether the network connection  is 0 i.e. there is no internet,if so showing no internet widget else scaffold
    return Obx(
      () => networkService.connectionStatus.value == 0
          ? Utils().noInternetWidget(
              screenWidth,
              screenHeight,
            )
          : Scaffold(
              resizeToAvoidBottomInset: true,
              //if the showUpdateDialog is true that means we need to show the update dialog else container(i.e. only loader will be shown as api call is done in startup controller)
              body: startupController.showUpdateDialog.value
                  ? _openVersionBottomSheet(context)
                  : Container(),
            ),
    );
  }
}
