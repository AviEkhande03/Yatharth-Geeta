import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/select_language/language_card_widget.dart';
import '../../const/colors/colors.dart';
import '../../services/language/language_service.dart';
import '../../utils/utils.dart';
import '../../widgets/common/custom_button.dart';

class LanguagePreferencesScreen extends StatefulWidget {
  const LanguagePreferencesScreen({super.key});

  @override
  State<LanguagePreferencesScreen> createState() =>
      _LanguagePreferencesScreenState();
}

class _LanguagePreferencesScreenState extends State<LanguagePreferencesScreen> {
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      langaugeService.setToCurrent();
    });
  }

  final langaugeService = Get.find<LangaugeService>();

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "langaugeService.languageDataList[0].value!${langaugeService.languageDataList[0].value!}");
    debugPrint(
        "langaugeService.languageDataList[1].value!${langaugeService.languageDataList[1].value!}");
    debugPrint(
        "langaugeService.currentLocale.languageCode${langaugeService.currentLocale.languageCode}");
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: kColorWhite));
    return Container(
      color: kColorWhite,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: kColorWhite2,
          body: Column(
            children: [
              /*Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: kColorWhite,
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      top: 12.h,
                      bottom: 12.h,
                    ),
                    child: Text(
                      'Language Preference'.tr,
                      style: kTextStyleRosarioRegular.copyWith(
                        color: kColorFont,
                        fontSize: FontSize.languagePreferenceTitle.sp,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 24.w),
                        height: 24.h,
                        width: 24.h,
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset('assets/icons/back.svg')),
                      ),
                    ),
                  ),
                ],
              ),*/
              CustomAppBar(
                title: 'Language Preference'.tr,
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0.h),
                child: Container(
                    color: kColorWhite,
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: langaugeService.languageDataList.length,
                          itemBuilder: (context, index) {
                            return Obx(
                              () => LanguageCardWidget(
                                bgImgUrl: langaugeService
                                    .languagesList[index].bgImgUrl,
                                title: langaugeService
                                    .languageDataList[index].english!,
                                nativeText: langaugeService
                                    .languageDataList[index].native!,
                                isDefault: langaugeService
                                    .languageDataList[index].resultDefault!,
                                langaugeCode:
                                    "${langaugeService.languageDataList[index].value!}_${langaugeService.languageDataList[index].countryCode!}",
                                selectedLocale:
                                    langaugeService.selectedLocale.value,
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 24.h);
                          },
                        ),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36.h),
                child: SizedBox(
                  width: 192.w,
                  child: GestureDetector(
                    onTap: () {
                      var list =
                          langaugeService.selectedLocale.value.split("_");
                      //debugPrint("list${list.toString()}");
                      Locale langLocale = Locale(list[0], list[1]);
                      langaugeService.changeLanguage(langLocale);
                      if (Get.isRegistered<PlayerController>()) {
                        // Get.delete<PlayerController>();
                        Get.find<PlayerController>().audioPlayer.value.pause();
                        Get.find<PlayerController>()
                            .audioPlayer
                            .value
                            .dispose();
                      }
                      Utils.showAlertDialog(
                          context,
                          'assets/icons/updated_dialog_icon.svg',
                          'Language Updated!',
                          'Great! Your language preference has been updated successfully',
                          isLanguageCheck: true,
                          isDismissable: false);
                    },
                    child: CustomButton(
                      btnText: 'Update'.tr,
                      textColor: kColorWhite,
                      btnColor: kColorPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
