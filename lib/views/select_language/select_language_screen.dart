import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../routes/app_route.dart';
import '../../services/language/language_service.dart';
import '../../utils/utils.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/common/text_rosario.dart';
import '../../widgets/select_language/language_card_widget.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final langaugeService = Get.find<LangaugeService>();
  // final startupController = Get.put(StartupController());

  @override
  void initState() {
    super.initState();
    Utils.deleteCurrentLocale();
    // startupController.fetchStartupData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: height * 0.26,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/authentication/Login.png'),
                      fit: BoxFit.fill),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 48.r,
                              //backgroundColor: Colors.red,
                              child: Image.asset(
                                  'assets/images/authentication/babaji.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 9.h),
                              child: TextRosario(
                                text: "Yatharth Geeta",
                                fontSize: FontSize.ygText.sp,
                                color: kColorWhite2,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36.0.h),
                child: TextRosario(
                  text: 'Language',
                  fontWeight: FontWeight.w400,
                  fontSize: FontSize.headingText.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: TextPoppins(
                  text: 'Select App Language',
                  fontWeight: FontWeight.w400,
                  fontSize: FontSize.subHeadingText.sp,
                  color: kColorFont.withOpacity(0.75),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 48.h),
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
                          bgImgUrl:
                              langaugeService.languagesList[index].bgImgUrl,
                          title:
                              langaugeService.languageDataList[index].english!,
                          nativeText:
                              langaugeService.languageDataList[index].native!,
                          isDefault: langaugeService
                              .languageDataList[index].resultDefault!,
                          langaugeCode:
                              "${langaugeService.languageDataList[index].value!}_${langaugeService.languageDataList[index].countryCode!}",
                          selectedLocale: langaugeService.selectedLocale.value,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 24.h);
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: GestureDetector(
                onTap: () {
                  var list = langaugeService.selectedLocale.value.split("_");
                  //debugPrint("list${list.toString()}");
                  Locale langLocale = Locale(list[0], list[1]);
                  langaugeService.changeLanguage(langLocale);
                  Get.toNamed(AppRoute.loginWithOTPScreen);
                },
                child: const CustomButton(
                  btnText: 'Proceed',
                  isStretchable: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
