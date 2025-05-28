import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/preferred_model/preferred_language_model.dart';
import '../../models/select_language/select_language_model.dart';
import '../preferred_language/preffered_language_service.dart';
import '../../const/constants/constants.dart';
import '../../utils/utils.dart';

class LangaugeService extends GetxService {
  Locale currentLocale = Constants.englishLocale;
  late Map<String, String> languageMap;
  RxString selectedLocale = ''.obs;
  String defaultLangCode = "";
  String defaultCountryCode = "";
  String deviceLocaleCode ="";
  Locale get getCurrentLocale => currentLocale;
  final preferredLanguageService = PrefferedLanguageService();
  var languageDataList = <Result>[].obs;
  var isLangDataLoaded = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    deviceLocaleCode =Platform.localeName;
    print("localeCode:$deviceLocaleCode");
  }

  Future<void> loadDefaultLang() async {
    await getLanguages();
    await getCurrentLocaleFromStorage();
    debugPrint(
        'defaultLangCode:$defaultLangCode defaultCountryCode:$defaultCountryCode');

    //The above code was as per phase1 ...as per the phase 2 if the device language is hindi or marathi then the default language should be hindi else english
    //below lines are for that

    if(defaultCountryCode == '' && defaultLangCode == ''){
      if(deviceLocaleCode == 'mr_IN' || deviceLocaleCode == 'hi_IN'){
        defaultLangCode = 'hi';
        defaultCountryCode = 'IN';
      }else{
        defaultLangCode = 'en';
        defaultCountryCode = 'US';
      }
    }

    selectedLocale.value = "${defaultLangCode}_$defaultCountryCode";
    currentLocale = Locale(defaultLangCode, defaultCountryCode);
    changeLanguage(currentLocale);
    isLangDataLoaded.value = true;
  }

  setToCurrent() {
    selectedLocale.value = getCurrentLocale.toString();
  }

  void changeLanguage(Locale newLocale) {
    currentLocale = newLocale;
    Get.updateLocale(newLocale);
    Utils.saveCurrentLocale(newLocale);
  }

  RxList<SelectLanguageModel> languagesList = [
    SelectLanguageModel(
      title: 'English',
      bgImgUrl: 'assets/images/language/english_bg.png',
      nativeText: 'English',
      isDefault: true,
      languageCode: 'en_US',
    ),
    SelectLanguageModel(
      title: 'Hindi',
      bgImgUrl: 'assets/images/language/hindi_bg.png',
      isDefault: false,
      nativeText: 'हिंदी',
      languageCode: 'hi_IN',
    ),
  ].obs;

  Future<void> getLanguages() async {
    final response = await preferredLanguageService.getPreferredLanguage();
    if (response == " ") {
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        //Loading.stop();
        //Utils.customToast(
        //   mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 500) {
        Map mapdata = jsonDecode(response.body.toString());
        print(mapdata);
        //Loading.stop();
        //Utils.customToast(
        //    mapdata['message'], kRedColor, kRedColor.withOpacity(0.2), "Error");
      } else if (response.statusCode == 200) {
        Map mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          print(mapdata);
          //Loading.stop();
          //Utils.customToast(mapdata['message'], kRedColor,
          //    kRedColor.withOpacity(0.2), "Error");
        } else {
          print(mapdata);
          final preferredLanguageModel =
              preferredLanguageModelFromJson(response.body.toString());
          languageDataList.addAll(preferredLanguageModel.data!.result!);
          print("langList:$languageDataList");

          //Below code disabled for phase2 as I don't need default language check from apis and needs to be handled on basis of device locale

          // for (int i = 0; i < languageDataList.length; i++) {
          //   if (languageDataList.elementAt(i).resultDefault! == true) {
          //     defaultLangCode = languageDataList.elementAt(i).value!;
          //     defaultCountryCode = languageDataList.elementAt(i).countryCode!;
          //     debugPrint(
          //         'defaultLangCode:$defaultLangCode defaultCountryCode:$defaultCountryCode');
          //     //print(defaultLangCode);
          //     //debugPrint(defaultCountryCode);
          //   }
          // }
          //Loading.stop();
          //Utils.customToast(mapdata['message'], kGreenPopUpColor,
          //    kGreenPopUpColor.withOpacity(0.2), "Success");
        }
      }
    }
  }

  getCurrentLocaleFromStorage() async {
    languageMap = await Utils.getCurrentLocale();
    debugPrint(
        "${languageMap.entries.first.value}${languageMap.entries.last.value}");
    //Checking for emptiness of values because empty strings should not be written to defaultLangCode and defaultCountryCode
    if (languageMap.entries.first.value != "" &&
        languageMap.entries.last.value != "") {


      //Below part not needed in Phase2

    /*  //Check if the stored language code is there in language list
      for (int i = 0; i < languageDataList.length; i++) {
        if (languageDataList.elementAt(i).value! ==
                languageMap.entries.first.value &&
            languageDataList.elementAt(i).countryCode! ==
                languageMap.entries.last.value) {
          defaultLangCode = languageMap.entries.first.value;
          defaultCountryCode = languageMap.entries.last.value;
          //So basically defaultLangCode and defaultCountryCode will be updated only and only when local lang. code and country code exists in language list called from api
        }
      }*/

      defaultLangCode = languageMap.entries.first.value;
      defaultCountryCode = languageMap.entries.last.value;
    }
  }
}
