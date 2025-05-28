import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/startup/startup_model.dart';
import '../../services/language/language_service.dart';
import '../../services/startup/startup_service.dart';
import '../../routes/app_route.dart';
import '../../services/network/network_service.dart';
import '../../utils/utils.dart';

class StartupController extends GetxController {
  final StartupService startupService = StartupService();
  final networkService = Get.find<NetworkService>();
  var startupData = <StartupModel>{}.obs;
  RxBool startupDataLoaded = false.obs;
  RxBool showTutorials = true.obs;
  RxBool showUpdateDialog = false.obs;
  //Setting the length of phone numbers according to Country code
  Map<String, int> country_phone_lengths = {
    "AF": 9,
    "AL": 9,
    "AX": 9,
    "DZ": 9,
    "AS": 10,
    "AD": 6,
    "AO": 9,
    "AI": 10,
    "AQ": 12,
    "AG": 10,
    "AR": 9,
    "AM": 6,
    "AW": 7,
    "AU": 9,
    "AT": 9,
    "AZ": 9,
    "BS": 10,
    "BH": 8,
    "BD": 10,
    "BB": 10,
    "BY": 9,
    "BE": 9,
    "BZ": 7,
    "BJ": 8,
    "BM": 11,
    "BT": 8,
    "BO": 8,
    "BQ": 7,
    "BA": 8,
    "BW": 8,
    "BV": 12,
    "BR": 10,
    "IO": 7,
    "BN": 8,
    "BG": 9,
    "BF": 8,
    "BI": 8,
    "CV": 7,
    "KH": 9,
    "CM": 9,
    "CA": 10,
    "KY": 10,
    "CF": 8,
    "TD": 8,
    "CL": 9,
    "CN": 11,
    "CX": 9,
    "CC": 10,
    "CO": 10,
    "KM": 8,
    "CD": 9,
    "CG": 9,
    "CK": 5,
    "CR": 8,
    "CI": 10,
    "HR": 9,
    "CU": 8,
    "CW": 7,
    "CY": 8,
    "CZ": 9,
    "DK": 8,
    "DJ": 6,
    "DM": 10,
    "DO": 10,
    "EC": 9,
    "EG": 10,
    "SV": 8,
    "GQ": 9,
    "ER": 7,
    "EE": 8,
    "ET": 9,
    "FK": 5,
    "FO": 6,
    "FJ": 7,
    "FI": 9,
    "FR": 9,
    "GF": 10,
    "PF": 6,
    "TF": 12,
    "GA": 8,
    "GM": 9,
    "GE": 9,
    "DE": 9,
    "GH": 9,
    "GI": 8,
    "GR": 10,
    "GL": 6,
    "GD": 10,
    "GP": 10,
    "GU": 10,
    "GT": 9,
    "GG": 6,
    "GN": 8,
    "GW": 9,
    "GY": 7,
    "HT": 8,
    "HM": 9,
    "VA": 5,
    "HN": 8,
    "HK": 8,
    "HU": 9,
    "IS": 8,
    "IN": 10,
    "ID": 9,
    "IR": 10,
    "IQ": 10,
    "IE": 9,
    "IM": 6,
    "IL": 9,
    "IT": 9,
    "JM": 10,
    "JP": 10,
    "JE": 6,
    "JO": 9,
    "KZ": 10,
    "KE": 9,
    "KI": 8,
    "KP": 7,
    "KR": 9,
    "KW": 8,
    "KG": 9,
    "LA": 8,
    "LV": 8,
    "LB": 8,
    "LS": 8,
    "LR": 9,
    "LY": 9,
    "LI": 7,
    "LT": 8,
    "LU": 9,
    "MO": 8,
    "MK": 8,
    "MG": 9,
    "MW": 9,
    "MY": 9,
    "MV": 8,
    "ML": 8,
    "MT": 8,
    "MH": 7,
    "MQ": 10,
    "MR": 8,
    "MU": 10,
    "YT": 9,
    "MX": 10,
    "FM": 10,
    "MD": 8,
    "MC": 9,
    "MN": 8,
    "ME": 8,
    "MS": 10,
    "MA": 9,
    "MZ": 9,
    "MM": 8,
    "NA": 9,
    "NR": 7,
    "NP": 10,
    "NL": 9,
    "NC": 6,
    "NZ": 9,
    "NI": 8,
    "NE": 8,
    "NG": 10,
    "NU": 4,
    "NF": 6,
    "MP": 10,
    "NO": 8,
    "OM": 8,
    "PK": 10,
    "PW": 7,
    "PS": 9,
    "PA": 8,
    "PG": 8,
    "PY": 9,
    "PE": 9,
    "PH": 10,
    "PN": 4,
    "PL": 9,
    "PT": 9,
    "PR": 10,
    "QA": 8,
    "RE": 9,
    "RO": 9,
    "RU": 10,
    "RW": 9,
    "BL": 9,
    "SH": 4,
    "KN": 10,
    "LC": 10,
    "MF": 9,
    "PM": 5,
    "VC": 10,
    "WS": 7,
    "SM": 10,
    "ST": 7,
    "SA": 9,
    "SN": 9,
    "RS": 9,
    "SC": 10,
    "SL": 8,
    "SG": 8,
    "SX": 7,
    "SK": 9,
    "SI": 8,
    "SB": 5,
    "SO": 8,
    "ZA": 9,
    "GS": 12,
    "SS": 9,
    "ES": 9,
    "LK": 9,
    "SD": 9,
    "SR": 7,
    "SJ": 8,
    "SZ": 8,
    "SE": 9,
    "CH": 9,
    "SY": 9,
    "TW": 9,
    "TJ": 9,
    "TZ": 9,
    "TH": 9,
    "TL": 7,
    "TG": 8,
    "TK": 4,
    "TO": 5,
    "TT": 10,
    "TN": 8,
    "TR": 10,
    "TM": 8,
    "TC": 10,
    "TV": 5,
    "UG": 9,
    "UA": 9,
    "AE": 9,
    "GB": 10,
    "US": 10,
    "UM": 10,
    "UY": 8,
    "UZ": 9,
    "VU": 7,
    "VE": 10,
    "VN": 9,
    "VG": 10,
    "VI": 10,
    "WF": 6,
    "EH": 9,
    "YE": 9,
    "ZM": 9,
    "ZW": 9
  };

  @override
  void onInit() {
    super.onInit();
    debugPrint("onInit");
    Utils().checkShowTut(this);
  }

  @override
  void onReady() async {
    super.onReady();
    // while (networkService.connectionStatus.value != 1) {
    //   await Future.delayed(Duration(milliseconds: 500));
    // }

    //If network service connection is 1 i.e. there is internet then showLoader
    if (networkService.connectionStatus.value == 1) {
      Utils().showLoader(isNotStartUp: false);
      //call fetchStartUpData() to fetch startup data
      await fetchStartupData();
    }
  }

  //Method to fetch the startup data
  Future<void> fetchStartupData() async {
    //get the token
    String token = await Utils.getToken();
    //debugPrint('fetchStartupData******$token');
    //firstly clear the existing startup data
    startupData.clear();
    final response = await startupService.startupApi(token);
    if (response == " ") {
    } else if (response is http.Response) {
      //If response is 404 then back() closes the loader and show the error toast
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      }
      //If response is 500 then back() closes the loader and show the error toast
      else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        Get.back();
        // Utils.customToast(
        //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        //If status is 200 i.e OK then
        //jsonDecode() records data into mapdata
        Map mapdata = jsonDecode(response.body.toString());
        //If success is 0 then
        if (mapdata['success'] == 0) {
          print(mapdata);
          //Stop the loader
          Get.back();
          // Utils.customToast(
          //     mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
        } else if (mapdata['success'] == 1) {
          //converting json data to model
          final myStartupData = startupModelFromJson(response.body.toString());
          //adding data to startupData
          startupData.addAll({myStartupData});
          //settings startUpDataLoaded to true
          startupDataLoaded.value = true;
          debugPrint("startupData:${startupData.toString()}");
          String token = '';

          //if mandatory update is true disabling the loader and setting showUpdateDialog.value to true
          if (startupData.first.data!.result!.mandatoryUpdate == true) {
            Get.back();
            showUpdateDialog.value = true;
          } else {
            //Firstly calling loadDefaultLang() of language Service to get the available languages
            await Get.find<LangaugeService>().loadDefaultLang();

            //debugPrint("LangData Loaded");
            //debugPrint("isLangDataLoaded.value:${Get.find<LangaugeService>().isLangDataLoaded.value}");

            //Firstly check if languages are loaded or not i.e. checking isLangDataLoaded is true or not
            if (Get.find<LangaugeService>().isLangDataLoaded.value == true) {
              //if isLangDataLoaded is true setting guest user to false
              bool isGuestUser = false;
              //getting the token
              token = await Utils.getToken();
              //checking whether there is guest user or not
              isGuestUser = await Utils.isGuestUser();
              // final privacyPoliciesController = Get.put(PrivacyPolicyController());
              // final termsAndConditionsController = Get.put(TermsAndConditionsController());

              //closing the loader
              Get.back();

              //if token is not empty go to bottomAppbarScreen by clearing previous routes
              if (token != '') {
                Get.offNamed(AppRoute.bottomAppBarScreen);
              }
              //if the user is a guest user then go to bottomAppbarScreen by clearing all previous routes
              else if (isGuestUser == true) {
                log("You are a guest user true");
                Get.offNamed(AppRoute.bottomAppBarScreen);
              }
              //if loginwith otp is true then route to loginWithOTPScreen else if loginwith otp is false and password is true then route to loginWithPasswordScreen by removing all previous routes
              else {
                //Get.offNamed(AppRoute.selectLanguageScreen);
                if (startupData.first.data!.result!.loginWith!.otp == true) {
                  Get.offNamed(AppRoute.loginWithOTPScreen);
                } else if (startupData.first.data!.result!.loginWith!.otp ==
                        false &&
                    startupData.first.data!.result!.loginWith!.password ==
                        true) {
                  Get.offNamed(AppRoute.loginWithPasswordScreen);
                }
              }
            }
          }
        }
      }
    }
  }
}
