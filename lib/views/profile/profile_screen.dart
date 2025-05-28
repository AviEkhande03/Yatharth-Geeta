import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yatharthageeta/controllers/contact_us/contact_us_controller.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../controllers/delete_account/delete_account_controller.dart';
import '../../controllers/about_us/about_us_controller.dart';
import '../../controllers/privacy_policy/privacy_policy_controller.dart';
import '../../controllers/terms_and_conditions/terms_and_conditions_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../widgets/common/profile_bottom_dialogs.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/skeletons/profile_skeleton_widget.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../controllers/user_liked_List/user_liked_list_controller.dart';
import '../../controllers/user_played_list/user_played_list_controller.dart';
import '../../services/network/network_service.dart';
import '../../utils/utils.dart';
import '../../widgets/common/text_rosario.dart';
import '../../widgets/profile/profile_element.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    final bottomAppService = Get.find<BottomAppBarServices>();
    final startUpApiController = Get.find<StartupController>();
    final profileScreenController = Get.find<ProfileController>();
    //final logOutController = Get.lazyPut(() => LogOutController());
    final networkService = Get.find<NetworkService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Get.put(DeleteAccountController());
    final aboutUsController = Get.put(AboutUsController());
    final termsAndConditionsController =
        Get.put(TermsAndConditionsController());
    final privacyPolicyController = Get.put(PrivacyPolicyController());
    final userPlayedListController = Get.put(UserPlayedListsController());
    final userLikedListsController = Get.put(UserLikedListsController());
    debugPrint(
        "startupController.startupData.first.data!.result!.screens!.meData!.personal!.myPlayedList:${startUpApiController.startupData.first.data!.result!.screens!.meData!.personal!.myPlayedList}");
    debugPrint(
        "startupController.startupData.first.data!.result!.screens!.meData!.personal!.likedList!.myPlayedList:${startUpApiController.startupData.first.data!.result!.screens!.meData!.personal!.likedList}");
    debugPrint(
        "isPersonalVisible.value:${profileScreenController.isPersonalVisible.value}");
    debugPrint(
        "isOthersVisible.value:${profileScreenController.isOthersVisible.value}");
    debugPrint(
        "isActionsVisible.value:${profileScreenController.isActionsVisible.value}");
    debugPrint(
        "profileScreenController.profileData.isEmpty:${profileScreenController.profileData.isEmpty}");
    debugPrint(
        "startUpApiController.startupData.isEmpty:${startUpApiController.startupData.isEmpty}");
    //debugPrint("Profile screeen token:${bottomAppService.token.value}");
    return Container(
        color: kColorWhite,
        child: SafeArea(
            child: Obx(
          () => networkService.connectionStatus.value == 0
              ? Utils().noInternetWidget(screenWidth, screenHeight)
              : profileScreenController.profileData.isEmpty &&
                          !profileScreenController.isGuestUser.value ||
                      startUpApiController.startupData.isEmpty

                  //Skeleton or Loader
                  ? const ProfileSkeletonWidget()
                  : Scaffold(
                      resizeToAvoidBottomInset: true,
                      /*appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Container(
                color: kColorWhite,
                height: 60.h,
                child: Center(
                  child: TextRosario(
                    text: "Profile".tr,
                    fontSize: 24.sp,
                    color: kColorFont,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),*/
                      /*AppBar(
              centerTitle: true,
              title: TextRosario(
                text: "Profile".tr,
                fontSize: 24.sp,
                color: kColorFont,
                fontWeight: FontWeight.w400,
              ),
              leading: const SizedBox(),
            ),*/
                      backgroundColor: kColorWhite2,
                      body: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: kColorWhite,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: kColorPrimaryWithOpacity25,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  top: 12.h,
                                  bottom: 12.h,
                                ),
                                child: Text(
                                  'Profile'.tr,
                                  style: kTextStyleRosarioRegular.copyWith(
                                    color: kColorFont,
                                    fontSize: FontSize.profileTitle.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/profile/profile_bg.png'),
                                    fit: BoxFit.fill),
                              ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextRosario(
                                      text: '|| Hari Om ||'.tr,
                                      fontSize: FontSize.hariOmText.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kColorFontLangaugeTag,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 16.h, bottom: 8.0.h),
                                      child: Obx(() => TextRosario(
                                            text:
                                                bottomAppService.token.value !=
                                                        ''
                                                    ? profileScreenController
                                                        .profileData
                                                        .first
                                                        .data!
                                                        .result!
                                                        .name!
                                                        .tr
                                                    : 'Guest User'.tr,
                                            fontSize: FontSize.nameText.sp,
                                            color: kColorFont,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: Obx(
                                        () => TextPoppins(
                                          text: bottomAppService.token.value !=
                                                      '' &&
                                                  profileScreenController
                                                          .profileData
                                                          .first
                                                          .data!
                                                          .result!
                                                          .phone !=
                                                      null
                                              ? '${profileScreenController.profileData.first.data!.result!.phoneCode! == '91' ? '+'+profileScreenController.profileData.first.data!.result!.phoneCode!:profileScreenController.profileData.first.data!.result!.phoneCode!} ${profileScreenController.profileData.first.data!.result!.phone!}'
                                              : ''.tr,
                                          fontWeight: FontWeight.w400,
                                          fontSize: FontSize.phoneText.sp,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => startUpApiController
                                                  .startupData
                                                  .first
                                                  .data!
                                                  .result!
                                                  .screens!
                                                  .meData!
                                                  .extraaTabs!
                                                  .edit ==
                                              true
                                          ? InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoute.editProfileScreen);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: kColorWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  border: Border.all(
                                                      color: kColorPrimary,
                                                      width: 1.w),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.h,
                                                      horizontal: 24.w),
                                                  child: TextPoppins(
                                                    text: 'Edit'.tr,
                                                    color: kColorPrimary,
                                                    fontSize:
                                                        FontSize.editBtnText.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Obx(() => profileScreenController
                                              .isPersonalVisible.value ==
                                          true
                                      ? Container(
                                          color: kColorWhite,
                                          child: Padding(
                                              padding: EdgeInsets.all(24.0.w),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.h),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            height:
                                                                screenWidth >=
                                                                        600
                                                                    ? 30.h
                                                                    : 26.h,
                                                            width:
                                                                screenWidth >=
                                                                        600
                                                                    ? 30.h
                                                                    : 26.h,
                                                            child: SvgPicture.asset(
                                                                'assets/icons/swastik.svg')),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        TextPoppins(
                                                            text: 'Personal'.tr,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                kColorFontOpacity75,
                                                            fontSize: FontSize
                                                                .profileScreenFontSize16
                                                                .sp)
                                                      ],
                                                    ),
                                                  ),
                                                  Obx(() => startUpApiController
                                                              .startupData
                                                              .first
                                                              .data!
                                                              .result!
                                                              .screens!
                                                              .meData!
                                                              .personal!
                                                              .likedList ==
                                                          true
                                                      ? Column(
                                                          children: [
                                                            ProfileElement(
                                                              itemIcon:
                                                                  'assets/icons/profile_favourite.svg',
                                                              itemName:
                                                                  'Liked List'
                                                                      .tr,
                                                              onTap: () async {
                                                                Utils()
                                                                    .showLoader();

                                                                //Call API here
                                                                await userLikedListsController
                                                                    .fetchLikedListingFilter(
                                                                  type: Constants
                                                                      .typeMediaAudio,
                                                                );

                                                                Get.back();

                                                                if (!userLikedListsController
                                                                    .isLoadingData
                                                                    .value) {
                                                                  Get.toNamed(
                                                                      AppRoute
                                                                          .likedListScreen);
                                                                }

                                                                // Get.toNamed(
                                                                //     AppRoute.likedListScreen);
                                                              },
                                                            ),
                                                            Divider(
                                                              height: 1.h,
                                                              color:
                                                                  kNotificationDividerColor,
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox()),
                                                  Obx(() => startUpApiController
                                                              .startupData
                                                              .first
                                                              .data!
                                                              .result!
                                                              .screens!
                                                              .meData!
                                                              .personal!
                                                              .myPlayedList ==
                                                          true
                                                      ? ProfileElement(
                                                          itemIcon:
                                                              'assets/icons/profile_playlist.svg',
                                                          itemName:
                                                              'My Played List'
                                                                  .tr,
                                                          onTap: () async {
                                                            Utils()
                                                                .showLoader();

                                                            //Call API here
                                                            await userPlayedListController
                                                                .fetchFilterUserMediaPlayedViewed(
                                                              token:
                                                                  bottomAppService
                                                                      .token
                                                                      .value,
                                                              ctx: context,
                                                              type: Constants
                                                                  .typeMediaAudio,
                                                            );

                                                            Get.back();

                                                            if (!userPlayedListController
                                                                .isLoadingData
                                                                .value) {
                                                              Get.toNamed(AppRoute
                                                                  .myPlayedListScreen);
                                                            }

                                                            // Get.toNamed(
                                                            //     AppRoute.myPlayedListScreen);
                                                          },
                                                        )
                                                      : const SizedBox())
                                                ],
                                              )),
                                        )
                                      : const SizedBox()),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Obx(() => profileScreenController
                                              .isOthersVisible.value ==
                                          true
                                      ? Container(
                                          color: kColorWhite,
                                          child: Padding(
                                            padding: EdgeInsets.all(24.0.w),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 16.h),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          height:
                                                              screenWidth >= 600
                                                                  ? 30.h
                                                                  : 26.h,
                                                          width:
                                                              screenWidth >= 600
                                                                  ? 30.h
                                                                  : 26.h,
                                                          child: SvgPicture.asset(
                                                              'assets/icons/profile_others.svg')),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      TextPoppins(
                                                          text: 'Others'.tr,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              kColorFontOpacity75,
                                                          fontSize: FontSize
                                                              .profileScreenFontSize16
                                                              .sp)
                                                    ],
                                                  ),
                                                ),
                                                Obx(
                                                  () => startUpApiController
                                                              .startupData
                                                              .first
                                                              .data!
                                                              .result!
                                                              .screens!
                                                              .meData!
                                                              .others!
                                                              .notification ==
                                                          true
                                                      ? Column(
                                                          children: [
                                                            ProfileElement(
                                                              itemIcon:
                                                                  'assets/icons/profile_bell.svg',
                                                              itemName:
                                                                  'Notification'
                                                                      .tr,
                                                              isToggleEnabled:
                                                                  true,
                                                              isToggleOn:
                                                                  profileScreenController
                                                                      .isToggleOn
                                                                      .value,
                                                              onToggleChanged:
                                                                  (val) async {
                                                                debugPrint(
                                                                    "status:$val");
                                                                Utils()
                                                                    .showLoader();
                                                                await profileScreenController
                                                                    .updateNotificationStatus(
                                                                        val);
                                                                await Utils
                                                                    .saveNotificationStatus(
                                                                        val);
                                                                profileScreenController
                                                                    .isToggleOn
                                                                    .value = val;
                                                                //Get.back();
                                                              },
                                                              onTap: () {},
                                                            ),
                                                            Divider(
                                                              height: 1.h,
                                                              color:
                                                                  kNotificationDividerColor,
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ),

                                                Obx(
                                                  () => startUpApiController
                                                              .startupData
                                                              .first
                                                              .data!
                                                              .result!
                                                              .screens!
                                                              .meData!
                                                              .others!
                                                              .languagePreference ==
                                                          true
                                                      ? Column(
                                                          children: [
                                                            ProfileElement(
                                                              itemIcon:
                                                                  'assets/icons/profile_language.svg',
                                                              itemName:
                                                                  'Language Preference'
                                                                      .tr,
                                                              onTap: () {
                                                                Get.toNamed(AppRoute
                                                                    .languagePreferencesScreen);
                                                              },
                                                            ),
                                                            Divider(
                                                              height: 1.h,
                                                              color:
                                                                  kNotificationDividerColor,
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ),

                                                Obx(() => startUpApiController
                                                            .startupData
                                                            .first
                                                            .data!
                                                            .result!
                                                            .screens!
                                                            .meData!
                                                            .others!
                                                            .contactUs ==
                                                        true
                                                    ? Column(
                                                        children: [
                                                          ProfileElement(
                                                            itemIcon:
                                                                'assets/icons/profile_contact_us.svg',
                                                            itemName:
                                                                'Contact Us'.tr,
                                                            onTap: () async {
                                                              Utils()
                                                                  .showLoader();
                                                              var contactUsController =
                                                                  Get.put(
                                                                      ContactUsController());
                                                              await contactUsController
                                                                  .fetchContactUsDetails();
                                                              Get.back();
                                                              Get.toNamed(AppRoute
                                                                  .contactUsScreen);
                                                            },
                                                          ),
                                                          Divider(
                                                            height: 1.h,
                                                            color:
                                                                kNotificationDividerColor,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox()),

                                                Obx(() => startUpApiController
                                                            .startupData
                                                            .first
                                                            .data!
                                                            .result!
                                                            .screens!
                                                            .meData!
                                                            .others!
                                                            .aboutUs ==
                                                        true
                                                    ? Column(
                                                        children: [
                                                          ProfileElement(
                                                            itemIcon:
                                                                'assets/icons/profile_about_us.svg',
                                                            itemName:
                                                                'About Us'.tr,
                                                            onTap: () async {
                                                              Utils()
                                                                  .showLoader();

                                                              //Call API here
                                                              await aboutUsController
                                                                  .fetchAboutUs(
                                                                      token: '',
                                                                      ctx:
                                                                          context,
                                                                      type: Constants
                                                                          .typeAboutUs);

                                                              Get.back();

                                                              if (!aboutUsController
                                                                  .isLoadingData
                                                                  .value) {
                                                                Get.toNamed(AppRoute
                                                                    .aboutUsScreen);
                                                              }
                                                            },
                                                            // onTap: () => Get.toNamed(
                                                            //     AppRoute.aboutUsScreen),
                                                          ),
                                                          Divider(
                                                            height: 1.h,
                                                            color:
                                                                kNotificationDividerColor,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox()),

                                                Obx(() => startUpApiController
                                                            .startupData
                                                            .first
                                                            .data!
                                                            .result!
                                                            .screens!
                                                            .meData!
                                                            .others!
                                                            .termsNConditions ==
                                                        true
                                                    ? Column(
                                                        children: [
                                                          ProfileElement(
                                                            itemIcon:
                                                                'assets/icons/profile_terms_and_conditions.svg',
                                                            itemName:
                                                                'Terms & Conditions'
                                                                    .tr,

                                                            onTap: () async {
                                                              Utils()
                                                                  .showLoader();

                                                              //Call API here
                                                              await termsAndConditionsController
                                                                  .fetchTermsAndConditions(
                                                                      token: '',
                                                                      ctx:
                                                                          context,
                                                                      type: Constants
                                                                          .typeTermsAndConditions);

                                                              Get.back();

                                                              if (!termsAndConditionsController
                                                                  .isLoadingData
                                                                  .value) {
                                                                Get.toNamed(AppRoute
                                                                    .termsAndConditionsScreen);
                                                              }
                                                            },
                                                            // onTap: () => Get.toNamed(AppRoute
                                                            //     .termsAndConditionsScreen,),
                                                          ),
                                                          Divider(
                                                            height: 1.h,
                                                            color:
                                                                kNotificationDividerColor,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox()),

                                                Obx(() => startUpApiController
                                                            .startupData
                                                            .first
                                                            .data!
                                                            .result!
                                                            .screens!
                                                            .meData!
                                                            .others!
                                                            .privacyPolicy ==
                                                        true
                                                    ? Column(
                                                        children: [
                                                          ProfileElement(
                                                            itemIcon:
                                                                'assets/icons/profile_privacy_policy.svg',
                                                            itemName:
                                                                'Privacy Policy'
                                                                    .tr,

                                                            onTap: () async {
                                                              Utils()
                                                                  .showLoader();

                                                              //Call API here
                                                              await privacyPolicyController
                                                                  .fetchPrivacyPolicy(
                                                                      token: '',
                                                                      ctx:
                                                                          context,
                                                                      type: Constants
                                                                          .typePrivacyPolicy);

                                                              Get.back();

                                                              if (!privacyPolicyController
                                                                  .isLoadingData
                                                                  .value) {
                                                                Get.toNamed(AppRoute
                                                                    .privacyPolicyScreen);
                                                              }
                                                            },
                                                            // onTap: () => Get.toNamed(
                                                            //     AppRoute.privacyPolicyScreen),
                                                          ),
                                                          Divider(
                                                            height: 1.h,
                                                            color:
                                                                kNotificationDividerColor,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox()),

                                                Obx(() => startUpApiController
                                                            .startupData
                                                            .first
                                                            .data!
                                                            .result!
                                                            .screens!
                                                            .meData!
                                                            .others!
                                                            .rateUs ==
                                                        true
                                                    ? Column(
                                                        children: [
                                                          ProfileElement(
                                                            itemIcon:
                                                                'assets/icons/profile_rate_us.svg',
                                                            itemName:
                                                                'Rate Us'.tr,
                                                            onTap: () async {
                                                              if (Platform
                                                                  .isAndroid) {
                                                                final String
                                                                    url =
                                                                    startUpApiController
                                                                        .startupData
                                                                        .first
                                                                        .data!
                                                                        .result!
                                                                        .redirectionUrl!;
                                                                AndroidIntent
                                                                    intent =
                                                                    AndroidIntent(
                                                                  action:
                                                                      'action_view',
                                                                  data: url,
                                                                  // package: 'com.android.vending', // This is the package name of the Play Store app
                                                                );
                                                                await intent
                                                                    .launch();
                                                              } else if (Platform
                                                                  .isIOS) {
                                                                print(
                                                                    "urlbh = ${startUpApiController.startupData.first.data!.result!.redirectionUrl!}");
                                                                // Navigator.pop(context);
                                                                final Uri _url =
                                                                    Uri.parse(startUpApiController
                                                                        .startupData
                                                                        .first
                                                                        .data!
                                                                        .result!
                                                                        .redirectionUrl!);
                                                                await _launchUrl(
                                                                    _url);
                                                              }
                                                            },
                                                          ),
                                                          Divider(
                                                            height: 1.h,
                                                            color:
                                                                kNotificationDividerColor,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox()),

                                                Obx(() => startUpApiController
                                                            .startupData
                                                            .first
                                                            .data!
                                                            .result!
                                                            .screens!
                                                            .meData!
                                                            .others!
                                                            .help ==
                                                        true
                                                    ? Column(
                                                        children: [
                                                          ProfileElement(
                                                            itemIcon:
                                                                'assets/icons/help.svg',
                                                            itemName: 'Help'.tr,
                                                            onTap: () async {
                                                              BottomAppBarServices
                                                                  bottomAppBarServices =
                                                                  Get.find<
                                                                      BottomAppBarServices>();
                                                              bottomAppBarServices
                                                                  .selectedIndex
                                                                  .value = 0;
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .startShowCase([
                                                                bottomAppBarServices
                                                                    .keyOne,
                                                                bottomAppBarServices
                                                                    .keyTwo,
                                                                bottomAppBarServices
                                                                    .keyThree,
                                                                bottomAppBarServices
                                                                    .keyFour,
                                                                bottomAppBarServices
                                                                    .keyFive,
                                                                bottomAppBarServices
                                                                    .keySix,
                                                              ]);
                                                              // bottomAppBarController.initItems();
                                                              // Future.delayed(
                                                              //         const Duration(microseconds: 200))
                                                              //     .then((value) {
                                                              //   Tutorial.showTutorial(
                                                              //       context, bottomAppBarController.items,
                                                              //       onTutorialComplete: () {
                                                              //     // Code to be executed after the tutorial ends
                                                              //     print('Tutorial is complete!');
                                                              //   }, );
                                                              // });
                                                            },
                                                          ),
                                                          Divider(
                                                            height: 1.h,
                                                            color:
                                                                kNotificationDividerColor,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox()),

                                                Obx(() => startUpApiController
                                                            .startupData
                                                            .first
                                                            .data!
                                                            .result!
                                                            .screens!
                                                            .meData!
                                                            .others!
                                                            .shareApp ==
                                                        true
                                                    ? ProfileElement(
                                                        itemIcon:
                                                            'assets/icons/profile_share.svg',
                                                        itemName:
                                                            'Share App'.tr,
                                                        onTap: () async {
                                                          await Share.share(
                                                              "${"Read, Listen and View Srimad Bhagavad Gita Yatharth Geeta eBooks and Audios in its True Perspective. Download app from below link :".tr}\n\n${startUpApiController.startupData.first.data!.result!.redirectionUrl!}");
                                                        },
                                                      )
                                                    : const SizedBox()),
                                                // Divider(
                                                //   height: 1.h,
                                                //   color: kNotificationDividerColor,
                                                // ),
                                                // ProfileElement(
                                                //   itemIcon: 'assets/icons/logout.svg',
                                                //   itemName: 'Logout',
                                                //   onTap: () {},
                                                // ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox()),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Obx(
                                      () =>
                                          profileScreenController
                                                      .isActionsVisible.value ==
                                                  true
                                              ? Container(
                                                  color: kColorWhite,
                                                  child: Padding(
                                                      padding: EdgeInsets.all(
                                                          24.0.w),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        16.h),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                    height: screenWidth >=
                                                                            600
                                                                        ? 30.h
                                                                        : 26.h,
                                                                    width: screenWidth >=
                                                                            600
                                                                        ? 30.h
                                                                        : 26.h,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            'assets/icons/swastik.svg')),
                                                                SizedBox(
                                                                  width: 8.w,
                                                                ),
                                                                Text(
                                                                  'Action'.tr,
                                                                  style: kTextStylePoppinsRegular.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color:
                                                                          kColorFontOpacity75,
                                                                      fontSize: FontSize
                                                                          .profileScreenFontSize16
                                                                          .sp),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Obx(
                                                            () => startUpApiController
                                                                        .startupData
                                                                        .first
                                                                        .data!
                                                                        .result!
                                                                        .screens!
                                                                        .meData!
                                                                        .action!
                                                                        .changePassword ==
                                                                    true
                                                                ? Column(
                                                                    children: [
                                                                      ProfileElement(
                                                                        itemIcon:
                                                                            'assets/icons/lock-open.svg',
                                                                        itemName:
                                                                            'Change Password'.tr,
                                                                        onTap:
                                                                            () {
                                                                          Get.toNamed(
                                                                              AppRoute.changePasswordScreen);
                                                                        },
                                                                      ),
                                                                      Divider(
                                                                        height:
                                                                            1.h,
                                                                        color:
                                                                            kNotificationDividerColor,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                                          ),
                                                          Obx(
                                                            () => startUpApiController
                                                                        .startupData
                                                                        .first
                                                                        .data!
                                                                        .result!
                                                                        .screens!
                                                                        .meData!
                                                                        .action!
                                                                        .deleteAccount ==
                                                                    true
                                                                ? Column(
                                                                    children: [
                                                                      ProfileElement(
                                                                        itemIcon:
                                                                            'assets/icons/delete_account.svg',
                                                                        itemName:
                                                                            'Delete account'.tr,
                                                                        onTap:
                                                                            () {
                                                                          showModalBottomSheet(
                                                                              context: context,
                                                                              backgroundColor: Colors.transparent,
                                                                              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                                                                              builder: (context) {
                                                                                return const ProfileDialog(
                                                                                  title: 'Delete Account',
                                                                                  asssetIcon: 'assets/icons/delete_account_dialog_icon.svg',
                                                                                  contentText: 'Are you sure you want to delete account? This will erase all the data related to this account',
                                                                                  titleColor: kColorShlokasTitle,
                                                                                  btn1Text: 'Delete',
                                                                                  btn2Text: 'Cancel',
                                                                                );
                                                                              });
                                                                        },
                                                                        iconColor:
                                                                            kColorShlokasTitle,
                                                                        textColor:
                                                                            kColorShlokasTitle,
                                                                      ),
                                                                      Divider(
                                                                        height:
                                                                            1.h,
                                                                        color:
                                                                            kNotificationDividerColor,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                                          ),
                                                          Obx(
                                                            () => startUpApiController
                                                                        .startupData
                                                                        .first
                                                                        .data!
                                                                        .result!
                                                                        .screens!
                                                                        .meData!
                                                                        .action!
                                                                        .logout ==
                                                                    true
                                                                ? ProfileElement(
                                                                    itemIcon:
                                                                        'assets/icons/logout.svg',
                                                                    itemName:
                                                                        'Logout'
                                                                            .tr,
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                          context:
                                                                              context,
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          constraints:
                                                                              BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                                                                          builder: (context) {
                                                                            return const ProfileDialog(
                                                                              title: 'Logout',
                                                                              asssetIcon: 'assets/icons/logout_dialog_icon.svg',
                                                                              contentText: 'Are you sure you want to logout?',
                                                                              btn1Text: 'Logout',
                                                                              btn2Text: 'Cancel',
                                                                            );
                                                                          });
                                                                    })
                                                                : const SizedBox(),
                                                          ),
                                                          Obx(
                                                            () => startUpApiController
                                                                        .startupData
                                                                        .first
                                                                        .data!
                                                                        .result!
                                                                        .screens!
                                                                        .meData!
                                                                        .action!
                                                                        .login ==
                                                                    true
                                                                ? ProfileElement(
                                                                    itemIcon:
                                                                        'assets/icons/login.svg',
                                                                    itemName:
                                                                        'Login'
                                                                            .tr,
                                                                    iconColor:
                                                                        kColorPrimary,
                                                                    onTap: () {
                                                                      //Utils.setGuestUser(false);
                                                                      if (Get.isRegistered<
                                                                          PlayerController>()) {
                                                                        Get.find<PlayerController>()
                                                                            .audioPlayer
                                                                            .value
                                                                            .pause();
                                                                      }
                                                                      if (startUpApiController
                                                                              .startupData
                                                                              .first
                                                                              .data!
                                                                              .result!
                                                                              .loginWith!
                                                                              .otp ==
                                                                          true) {
                                                                        Get.toNamed(
                                                                            AppRoute.loginWithOTPScreen);
                                                                      } else if (Get.find<StartupController>().startupData.first.data!.result!.loginWith!.otp ==
                                                                              false &&
                                                                          Get.find<StartupController>().startupData.first.data!.result!.loginWith!.password ==
                                                                              true) {
                                                                        Get.toNamed(
                                                                            AppRoute.loginWithPasswordScreen);
                                                                      }
                                                                    })
                                                                : const SizedBox(),
                                                          ),
                                                        ],
                                                      )),
                                                )
                                              : const SizedBox()),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 30.0.h),
                                    child: Obx(
                                      () => TextPoppins(
                                        text:
                                            'App Version ${profileScreenController.appVersion.value}'
                                                .tr,
                                        fontSize: FontSize.appVersionText.sp,
                                        fontWeight: FontWeight.w500,
                                        color: kAppVersionColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
        )));
  }
}
