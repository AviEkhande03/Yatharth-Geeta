import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../const/colors/colors.dart';
import '../controllers/startup/startup_controller.dart';
import '../widgets/common/text_poppins.dart';
import '../const/constants/constants.dart';
import '../const/font_size/font_size.dart';
import '../widgets/common/update_pop_up_dialog.dart';

class Utils {
  static String formatNumber(int number) {
    var format = NumberFormat.compact(locale: "en");
    return format.format(number);
  }

  static String minutesToTime(int minutes) {
    int minute = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    int hours = minute ~/ 60;
    int remainingMinute = minute % 60;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = remainingMinute.toString().padLeft(2, '0');
    String secondsStr = remainingMinutes.toString().padLeft(2, '0');
    return '${'$hoursStr:'}$minutesStr:$secondsStr';
  }

  static Color getColorByIndex(int index) {
    final colors = [
      const Color(0XFFE4C199),
      const Color(0XFFCACACA),
      const Color(0XFFEBD488),
    ];

    final colorIndex = index % colors.length;

    return colors[colorIndex];
  }

  static Future<String> authHeader() async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('${Constants.username}:${Constants.password}'))}';
    return basicAuth;
  }

  static Future<void> saveToken(String accessToken) async {
    // final box = GetStorage();
    //
    // box.write('access_token', accessToken);
    final box = await SharedPreferences.getInstance();
    await box.setString('access_token', accessToken);
  }

  static Future<String> getToken() async {
    // final box = GetStorage();
    // return box.read('access_token') ?? '';
    final box = await SharedPreferences.getInstance();
    return box.getString('access_token') ?? '';
  }

  static Future<void> saveNotificationStatus(bool notificationStatus) async {
    // final box = GetStorage();
    //
    // box.write('notification_status', notificationStatus);
    final box = await SharedPreferences.getInstance();
    await box.setBool('notification_status', notificationStatus);
  }

  static Future<bool> getNotificationStatus() async {
    // final box = GetStorage();
    //
    // if (await Utils.isGuestUser()) {
    //   return box.read('notification_status') ?? false;
    // } else {
    //   return box.read('notification_status') ?? false;
    // }

    final box = await SharedPreferences.getInstance();
    if (await Utils.isGuestUser()) {
      return box.getBool('notification_status') ?? false;
    } else {
      return box.getBool('notification_status') ?? false;
    }
  }

  static Future<void> saveCurrentLocale(Locale currentLocale) async {
    // final box = GetStorage();
    //
    // box.write('current_locale', {
    //   'languageCode': currentLocale.languageCode,
    //   'countryCode': currentLocale.countryCode,
    // });
    final box = await SharedPreferences.getInstance();

    box.setString(
        'current_locale',
        jsonEncode({
          'languageCode': currentLocale.languageCode,
          'countryCode': currentLocale.countryCode,
        }));
  }

  static Future<Map<String, String>> getCurrentLocale() async {
    // final box = GetStorage();

    // final savedLocale = box.read('current_locale');
    // if (savedLocale != null) {
    //   return {
    //     'languageCode': savedLocale['languageCode'],
    //     'countryCode': savedLocale['countryCode']
    //   };
    // } else {
    //   return {
    //     'languageCode': '',
    //     'countryCode': ''
    //   }; // Return an empty locale if not found
    // }
    final box = await SharedPreferences.getInstance();

    final string = box.getString('current_locale');
    if (string != null) {
      final savedLocale = jsonDecode(string);
      return {
        'languageCode': savedLocale['languageCode'],
        'countryCode': savedLocale['countryCode']
      };
    } else {
      return {
        'languageCode': '',
        'countryCode': ''
      }; // Return an empty locale if not found
    }
  }

  static Future<void> deleteNotificationStatus() async {
    // final box = GetStorage();
    //
    // return box.remove('notification_status');
    final box = await SharedPreferences.getInstance();

    await box.remove('notification_status');
  }

  static Future<void> deleteCurrentLocale() async {
    // final box = GetStorage();
    //
    // return box.remove('current_locale');
    final box = await SharedPreferences.getInstance();

    await box.remove('current_locale');
  }

  static Future<void> deleteToken() async {
    // final box = GetStorage();
    //
    // return box.remove('access_token');
    final box = await SharedPreferences.getInstance();

    await box.remove('access_token');
  }

  static Image loaderImage() {
    return Image.asset('assets/loader/loader_yatharth.gif');
  }

  static Future<bool> isGuestUser() async {
    // final box = GetStorage();
    //
    // return box.read('is_guest') ?? false;
    final box = await SharedPreferences.getInstance();
    return box.getBool('is_guest') ?? false;
  }

  static Future<void> setGuestUser(status) async {
    // final box = GetStorage();
    //
    // box.write('is_guest', status);
    //debugPrint("Successfully Set");
    final box = await SharedPreferences.getInstance();
    await box.setBool('is_guest', status);
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor.toString();
    }
    return deviceId;
  }

  showLoader({bool? isNotStartUp}) {
    showDialog(
      context: Get.context!,
      builder: (context) => PopScope(
        canPop: isNotStartUp ?? true,
        child: Center(
          child:
              // CircularProgressIndicator(),
              Get.width > 600
                  ? Image.asset('assets/loader/loader_yatharth_tab.gif')
                  : Image.asset('assets/loader/loader_yatharth.gif'),
        ),
      ),
      barrierDismissible: false,
      barrierColor: const Color(0x99ffffff),
    );
  }

  getHeaders() async {
    var header = {
      "Keep-Alive": "timeout=5, max=1",
      'authorization': await authHeader(),
      'access-token': await getToken(),
      'uuid': '1234',
      'platform': Platform.operatingSystem,
    };
    return header;
  }

  checkShowTut(StartupController controller) async {
    final box = await SharedPreferences.getInstance();
    if (box.containsKey("openStats")) {
      controller.showTutorials.value = false;
    } else {
      box.setInt("openStats", 1);
    }
  }

  static customToast(message, Color color, Color backgroundColor, type) {
    // return
    // MotionToast(
    //       height: 62.h,
    //       // margin: EdgeInsets.fromLTRB(5.h, 5.h, 5.h, 5.h),
    //       width:
    //           MediaQuery.of(Get.context!).orientation == Orientation.portrait
    //               ? Get.width * 0.90
    //               : Get.width * 0.3,
    //       //radiusColor: Colors.green.shade400,
    //       icon: type == 'Success' ? Icons.check_circle : Icons.cancel,
    //       borderRadius: 5.r,
    //       iconSize: 30,
    //       primaryColor: backgroundColor,
    //       animationDuration: const Duration(milliseconds: 1000),
    //       toastDuration: const Duration(seconds: 3),
    //       animationType: AnimationType.fromBottom,
    //       // animationDuration:Duration( seconds: 1),
    //       // toastDuration: Duration( seconds: 1),
    //       position: MotionToastPosition.bottom,
    //       dismissable: true,
    //       onClose: () {
    //         // Get.back();
    //         //print("OnClose called");
    //       },
    //       contentPadding: EdgeInsets.fromLTRB(5.h, 5.h, 5.h, 5.h),
    //       description: TextPoppins(
    //           text: message,
    //           fontSize: MediaQuery.of(Get.context!).orientation ==
    //                   Orientation.portrait
    //               ? FontSize.customToastFontSize.sp
    //               : 8.sp,
    //           color: color))
    //   .show(Get.context!);

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: color,
        fontSize:
            MediaQuery.of(Get.context!).orientation == Orientation.portrait
                ? FontSize.customToastFontSize.sp
                : 8.sp,
        fontAsset: 'assets/fonts/poppins/Poppins-Regular.ttf');
  }

  static void showAlertDialog(
      BuildContext context, String assetIcon, String title, String contentText,
      {isLanguageCheck = false, isDismissable = true}) {
    showDialog(
      context: context,
      barrierDismissible: isDismissable,
      builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: PopUpDialog(
            asssetIcon: assetIcon,
            title: title.tr,
            contentText: contentText.tr,
            isLanguagePopUp: isLanguageCheck,
          )),
    );
  }
  //Playedlist Media Type Based on Tab Tap

  getMediaTypeBasedOnTab({required String tabMediaTitle}) {
    if (tabMediaTitle.tr == 'Audio'.tr) {
      return Constants.typeMediaAudio;
    } else if (tabMediaTitle.tr == 'Books'.tr) {
      return Constants.typeMediaBook;
    } else if (tabMediaTitle.tr == 'Video'.tr) {
      return Constants.typeMediaVideo;
    } else {
      return Constants.typeMediaAudio;
    }
  }

  Widget noInternetWidget(width, height) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: width,
        height: height,
        color: kColorWhite2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/no_internet.svg'),
            SizedBox(
              height: 18.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/swastik.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, right: 6.w),
                  child: TextPoppins(
                    text: 'Whoops'.tr,
                    color: kColorFont,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                SvgPicture.asset('assets/icons/swastik.svg'),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: TextPoppins(
                text:
                    "No Internet connection found \n Check your connection".tr,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                textAlign: TextAlign.center,
              ),
            ),
            /*Padding(
              padding: EdgeInsets.only(top:45.0.h),
              child: CustomButton(
                btnText: 'Try Again'.tr,
                textColor: kColorWhite,
                isStretchable: false,
                btnColor: kColorPrimary,
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<String> getAppVersion() async {
    PackageInfo? info = await PackageInfo.fromPlatform();
    return info.version.toString();
  }

  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  String getAssetIconFromType(String type) {
    if (type == "Audio") {
      return 'assets/icons/music_for_notification.svg';
    } else if (type == "Video") {
      return 'assets/icons/film.svg';
    } else if (type == "Book") {
      return 'assets/icons/book-opened.svg';
    } else if (type == "Satsang") {
      return 'assets/icons/music_for_notification.svg';
    } else if (type == "ExploreCollection") {
      return 'assets/icons/explore_collection_notification.svg';
    } else if (type == "HomeCollection") {
      return 'assets/icons/home_collection_notification.svg';
    } else if (type == "Event") {
      return 'assets/icons/horn.svg';
    } else {
      return 'assets/icons/swastik_notification.svg';
    }
  }

  String dateToString(date) {
    var finalDateString = '';
    final DateFormat formatter = DateFormat('dd MMMM y');
    String formattedDate = formatter.format(date);
    if (formattedDate == formatter.format(DateTime.now())) {
      finalDateString = "Today";
    } else if (formattedDate ==
        formatter.format(DateTime.now().subtract(const Duration(days: 1)))) {
      finalDateString = "Yesterday";
    } else {
      // Get the day part from the original date,month part from the original date,year part from the original date
      int day = date.day;
      String month = DateFormat.MMMM().format(date);
      int year = date.year;

      // Determine the day suffix (st, nd, rd, or th)
      String daySuffix;
      if (day >= 11 && day <= 13) {
        daySuffix = 'th';
      } else {
        switch (day % 10) {
          case 1:
            daySuffix = 'st';
            break;
          case 2:
            daySuffix = 'nd';
            break;
          case 3:
            daySuffix = 'rd';
            break;
          default:
            daySuffix = 'th';
            break;
        }
        debugPrint(daySuffix);
      }

      finalDateString = '$day$daySuffix $month $year';
      debugPrint(finalDateString);
    }

    return finalDateString;
  }

  Widget showPaginationLoader(AnimationController _controller) {
    return Container(
      color: kColorWhite,
      // height: screenHeight * 0.05,
      child: Center(
          child:
              /*CircularProgressIndicator(color:
            kColorPrimary,
            ),*/
              SizedBox(
        height: 85.h,
        width: 85.h,
        child: Lottie.asset(
          'assets/lottie/pagination_loader.json',
          controller: _controller,
          animate: true,
          repeat: true,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
            _controller.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                _controller.reset();
                _controller.forward();
              }
            });
          },
        ),
      )),
    );
  }

  updateStartUpData(Map<dynamic, dynamic> mapdata) {
    var startupController = Get.find<StartupController>();

    startupController.startupData.first.data!.result!.screens!.meData!.personal!
            .myPlayedList =
        mapdata['data']['result']['me_data']['Personal']['My Played List']
            as bool;
    startupController.startupData.first.data!.result!.screens!.meData!.personal!
            .likedList =
        mapdata['data']['result']['me_data']['Personal']['Liked List'] as bool;
    startupController.startupData.first.data!.result!.screens!.meData!.others!
            .notification =
        mapdata['data']['result']['me_data']['Others']['Notification'] as bool;
    startupController.startupData.first.data!.result!.screens!.meData!.others!
            .languagePreference =
        mapdata['data']['result']['me_data']['Others']['Language Preference']
            as bool;
    startupController.startupData.first.data!.result!.screens!.meData!.others!
            .contactUs =
        mapdata['data']['result']['me_data']['Others']['Contact Us'] as bool;
    startupController.startupData.first.data!.result!.screens!.meData!.others!
        .aboutUs = mapdata['data']['result']['me_data']['Others']['About Us'];
    startupController.startupData.first.data!.result!.screens!.meData!.others!
            .termsNConditions =
        mapdata['data']['result']['me_data']['Others']['Terms n conditions'];
    startupController.startupData.first.data!.result!.screens!.meData!.others!
            .privacyPolicy =
        mapdata['data']['result']['me_data']['Others']['Privacy Policy'];
    startupController.startupData.first.data!.result!.screens!.meData!.others!
        .rateUs = mapdata['data']['result']['me_data']['Others']['Rate Us'];
    startupController.startupData.first.data!.result!.screens!.meData!.others!
        .help = mapdata['data']['result']['me_data']['Others']['Help'];
    startupController.startupData.first.data!.result!.screens!.meData!.others!
        .shareApp = mapdata['data']['result']['me_data']['Others']['Share App'];
    startupController.startupData.first.data!.result!.screens!.meData!.action!
            .changePassword =
        mapdata['data']['result']['me_data']['Action']['Change Password'];
    startupController.startupData.first.data!.result!.screens!.meData!.action!
            .deleteAccount =
        mapdata['data']['result']['me_data']['Action']['Delete account'];
    startupController.startupData.first.data!.result!.screens!.meData!.action!
        .logout = mapdata['data']['result']['me_data']['Action']['Logout'];
    startupController.startupData.first.data!.result!.screens!.meData!.action!
        .login = mapdata['data']['result']['me_data']['Action']['Login'];
    startupController
        .startupData
        .first
        .data!
        .result!
        .screens!
        .meData!
        .extraaTabs!
        .edit = mapdata['data']['result']['me_data']['extraa_tabs']['Edit'];
    startupController.startupData.first.data!.result!.screens!.meData!
            .extraaTabs!.wishlistIcon =
        mapdata['data']['result']['me_data']['extraa_tabs']['Wishlist Icon'];
    startupController.startupData.first.data!.result!.screens!.meData!
            .extraaTabs!.notificationIcon =
        mapdata['data']['result']['me_data']['extraa_tabs']
            ['Notification Icon'];
    startupController.startupData.first.data!.result!.screens!.meData!
            .extraaTabs!.downloadIcon =
        mapdata['data']['result']['me_data']['extraa_tabs']['Download Icon'];
    startupController.startupData.first.data!.result!.screens!.meData!
            .extraaTabs!.audioDownloadIcon =
        mapdata['data']['result']['me_data']['extraa_tabs']
            ['Audio Download Icon'];
    startupController.startupData.first.data!.result!.screens!.meData!
            .extraaTabs!.bookDownloadIcon =
        mapdata['data']['result']['me_data']['extraa_tabs']
            ['Book Download Icon'];
    startupController.startupData.first.data!.result!.screens!.meData!
            .extraaTabs!.shlokDownloadIcon =
        mapdata['data']['result']['me_data']['extraa_tabs']
            ['Shlok Download Icon'];
    startupController.startupData.first.data!.result!.screens!.meData!.profile!
            .emailEditable =
        mapdata['data']['result']['me_data']['profile']['email_editable'];
    startupController.startupData.first.data!.result!.screens!.meData!.profile!
            .phoneEditable =
        mapdata['data']['result']['me_data']['profile']['phone_editable'];
  }
}
