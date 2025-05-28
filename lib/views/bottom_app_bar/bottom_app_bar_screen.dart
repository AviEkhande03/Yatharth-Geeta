import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/utils/utils.dart';
import 'package:yatharthageeta/widgets/common/text_poppins.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import 'package:get/get.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_showcase.dart';

class BottomAppBarScreen extends StatefulWidget {
  const BottomAppBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomAppBarScreen> createState() => _BottomAppBarScreenState();
}

class _BottomAppBarScreenState extends State<BottomAppBarScreen> {
  // late BottomAppBarServices bottomAppBarServices;
  BottomAppBarServices bottomAppBarServices = Get.put(BottomAppBarServices());

  bool isServiceInitialized = false;

  @override
  void initState() {
    super.initState();
    // vaibhav 01/04/25
    // if bottom app bar controller is not register then checking and rebuilding the screen again
    if (!Get.isRegistered<BottomAppBarServices>()) {
      bottomAppBarServices = Get.put(BottomAppBarServices());
    } 
    // Ensure the service is fully initialized
    bottomAppBarServices.ensureInitialized().then((_) {
      setState(() {
        isServiceInitialized = true;
      });
    });
  }

  DateTime? currentBackPressTime;

  void onWillPop(willpop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Press back to exit',
          backgroundColor: kColorBlack.withOpacity(0.8));

      // return false;
    } else {
      if (Get.isRegistered<PlayerController>()) {
        Get.find<PlayerController>().audioPlayer.value.stop();
      }
      SystemNavigator.pop();
    }

    // return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
      ),
      child: PopScope(
        canPop: false,
        onPopInvoked: onWillPop,
        // onWillPop: onWillPop,
        child: Theme(
          data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(
            color: Colors.transparent,
          )),
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              // extendBody: true,
              // backgroundColor: kColorTransparent,
              persistentFooterButtons: [
                Obx(
                  () => Get.find<BottomAppBarServices>().miniplayerVisible.value
                      ? const MiniPlayer()
                      : const SizedBox.shrink(),
                ),
              ],
              persistentFooterAlignment: AlignmentDirectional.centerEnd,
              extendBody: true,
              primary: true,
              body: Stack(
                children: [
                  Obx(() {
                    if (!Get.isRegistered<BottomAppBarServices>()) {
                      return Center(
                        child: SizedBox(
                          height: screenWidth >= 600 ? 50.h : 43.h,
                          width: screenWidth >= 600 ? 50.h : 43.h,
                          child: const CircularProgressIndicator(
                            color: kColorPrimary,
                          ),
                        ),
                      );
                    } else {
                      final bottomAppBarServices =
                          Get.find<BottomAppBarServices>();

                      if (bottomAppBarServices.isInitialized.value == false) {
                        return Center(
                            child: SizedBox(
                          height: screenWidth >= 600 ? 50.h : 43.h,
                          width: screenWidth >= 600 ? 50.h : 43.h,
                          child: const CircularProgressIndicator(
                            color: kColorPrimary,
                          ),
                        ));
                      } else {
                        return bottomAppBarServices.widgetOptions.elementAt(
                            bottomAppBarServices.selectedIndex.value);
                      }
                    }
                    // () => bottomAppBarServices.widgetOptions
                    //     .elementAt(bottomAppBarServices.selectedIndex.value)
                  }),
                ],
              ),
              bottomNavigationBar: Builder(builder: (context) {
                if (!isServiceInitialized ||
                    !Get.isRegistered<BottomAppBarServices>()) {
                  return SizedBox
                      .shrink(); // Return empty widget until fully ready
                }
                return Obx(
                  () {
                    return Container(
                      decoration: BoxDecoration(
                        // border: Border(
                        //   top: BorderSide(width: 2, color: kColorPrimary),
                        // ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.h),
                          topLeft: Radius.circular(30.h),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: kColorPrimary.withOpacity(0.25),
                              spreadRadius: 0,
                              blurRadius: 10),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.h),
                          topRight: Radius.circular(30.h),
                        ),
                        child: CustomShowcase(
                          title: "",
                          desc:
                              "Tap or click on the tabs to navigate to Home, Explore, Events and Profile."
                                  .tr,
                          showKey: bottomAppBarServices.keyOne,
                          child: BottomNavigationBar(
                            // key: bottomAppBarController.keyOne,
                            type: BottomNavigationBarType.fixed,
                            backgroundColor: Colors.white,
                            items: [
                              BottomNavigationBarItem(
                                activeIcon: Image.asset(
                                  'assets/icons/home_active.png',
                                  width: 24.w,
                                ),
                                icon: // Active icon
                                    Image.asset(
                                  'assets/icons/home_inactive.png',
                                  width: 24.w,
                                ), // Inactive icon
                    
                                label: 'Home'.tr,
                              ),
                              BottomNavigationBarItem(
                                activeIcon: Image.asset(
                                  'assets/icons/explore_active.png',
                                  width: 24.w,
                                ),
                                icon: // Active icon
                                    Image.asset(
                                  'assets/icons/explore_inactive.png',
                                  width: 24.w,
                                ), // Inactive icon
                    
                                label: 'Explore'.tr,
                              ),
                              BottomNavigationBarItem(
                                activeIcon: Image.asset(
                                  'assets/icons/events_active.png',
                                  width: 24.w,
                                ),
                                icon: // Active icon
                                    Image.asset(
                                  'assets/icons/events_inactive.png',
                                  width: 24.w,
                                ), //
                                label: 'Events'.tr,
                              ),
                              BottomNavigationBarItem(
                                activeIcon: Image.asset(
                                  'assets/icons/profile_active.png',
                                  width: 24.w,
                                ),
                                icon: // Active icon
                                    Image.asset(
                                  'assets/icons/profile_inactive.png',
                                  width: 24.w,
                                ), //
                                label: 'Me'.tr,
                              ),
                            ],
                            currentIndex: bottomAppBarServices.selectedIndex.value,
                            selectedItemColor: kColorPrimary,
                            unselectedItemColor: kColorBlackWithOpacity75,
                            selectedIconTheme: IconThemeData(size: 24.w),
                            selectedLabelStyle: kTextStylePoppinsMedium.copyWith(
                                fontSize: FontSize.appBarFontsSize.sp,
                                color: kColorPrimary),
                            unselectedLabelStyle: kTextStylePoppinsRegular.copyWith(
                                fontSize: FontSize.appBarFontsSize.sp,
                                color: kColorBlackWithOpacity75),
                            onTap: bottomAppBarServices.onItemTapped,
                          ),
                        ),
                      ),
                    );
                  }
                );
              })),
        ),
      ),
    );
  }
}
