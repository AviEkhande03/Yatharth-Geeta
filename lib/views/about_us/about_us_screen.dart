import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart' as size;
import '../../const/text_styles/text_styles.dart';
import '../../controllers/about_us/about_us_controller.dart';
import '../../widgets/common/custom_app_bar.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final aboutUsController = Get.find<AboutUsController>();

  @override
  void dispose() {
    super.dispose();
    aboutUsController.clearAboutUsData();
    log('aboutUs cleared. aboutUs = ${aboutUsController.aboutUs}');
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        color: kColorWhite,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                CustomAppBar(
                  title: "About Us".tr,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: kColorWhite2,
                          padding: EdgeInsets.only(top: 30.h),
                          height: 258.h,
                          child: Stack(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Image.asset(
                                //   "assets/images/baba1.png",
                                //   width: 190.w,
                                //   fit: BoxFit.fill,
                                // ),
                                FadeInImage(
                                  width: 190.w,
                                  image: NetworkImage(aboutUsController
                                      .aboutUs.value!.guru1Image!
                                      .toString()),
                                  fit: BoxFit.cover,
                                  placeholderFit: BoxFit.scaleDown,
                                  placeholder:
                                      AssetImage("assets/icons/default.png"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        "assets/icons/default.png");
                                  },
                                ),
                                // Image.asset(
                                //   "assets/images/baba2.png",
                                //   width: 190.w,
                                //   fit: BoxFit.fill,
                                // ),
                                FadeInImage(
                                  width: 190.w,
                                  image: NetworkImage(aboutUsController
                                      .aboutUs.value!.guru2Image!
                                      .toString()),
                                  fit: BoxFit.cover,
                                  placeholderFit: BoxFit.scaleDown,
                                  placeholder:
                                      AssetImage("assets/icons/default.png"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        "assets/icons/default.png");
                                  },
                                ),
                              ],
                            ),
                            Positioned(
                                bottom: -70.h,
                                // left: 100.w,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    "assets/images/about_us_bg.png",
                                    width: 230.h,
                                    fit: BoxFit.fill,
                                  ),
                                ))
                          ]),
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        Text(
                          "Who are we?".tr,
                          style: kTextStylePoppinsRegular.copyWith(
                            fontSize: size.FontSize.aboutTitle.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 24.w, right: 24.w, top: 16.h),
                          child: Html(
                            data: aboutUsController.aboutUs.value!.content!,
                            style: {
                              "p": Style(fontFamily: "Poppins-Regular"),
                            },
                          ),
                        ),
                        Container(
                          height: 270.h,
                          padding: EdgeInsets.only(left: 24.w, right: 24.w),
                          margin: EdgeInsets.only(top: 16.h),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child:
                                    // Image.asset(
                                    //   "assets/images/shiva.png",
                                    //   width: 150.w,
                                    //   fit: BoxFit.fill,
                                    // )
                                    FadeInImage(
                                  width: 150.w,
                                  image: NetworkImage(aboutUsController
                                      .aboutUs.value!.shivaImage!
                                      .toString()),
                                  fit: BoxFit.cover,
                                  placeholderFit: BoxFit.scaleDown,
                                  placeholder:
                                      AssetImage("assets/icons/default.png"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        "assets/icons/default.png");
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child:
                                    // Image.asset(
                                    //   "assets/images/buddha.png",
                                    //   width: 150.w,
                                    //   fit: BoxFit.fill,
                                    // )
                                    FadeInImage(
                                  width: 150.w,
                                  image: NetworkImage(aboutUsController
                                      .aboutUs.value!.buddhaImage!
                                      .toString()),
                                  fit: BoxFit.cover,
                                  placeholderFit: BoxFit.scaleDown,
                                  placeholder:
                                      AssetImage("assets/icons/default.png"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        "assets/icons/default.png");
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    // Image.asset(
                                    //   "assets/images/yoga.png",
                                    //   width: 150.w,
                                    //   fit: BoxFit.fill,
                                    // )
                                    FadeInImage(
                                  width: 150.w,
                                  image: NetworkImage(aboutUsController
                                      .aboutUs.value!.yogaImage!
                                      .toString()),
                                  fit: BoxFit.cover,
                                  placeholderFit: BoxFit.scaleDown,
                                  placeholder:
                                      AssetImage("assets/icons/default.png"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        "assets/icons/default.png");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(
                        //       left: 24.w, right: 24.w, top: 24.h),
                        //   child: Html(
                        //     data: aboutUsController.aboutUs.value!.content!,
                        //     style: {
                        //       "p": Style(fontFamily: "Poppins-Regular"),
                        //     },
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 24.h,
                        // ),
                        Container(
                          padding: EdgeInsets.only(top: 46.h, bottom: 46.h),
                          color: kColorWhite2,
                          width: screenSize.width,
                          // height: 150.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Get to know more".tr,
                                style: kTextStylePoppinsRegular.copyWith(
                                  color: const Color(0xffC1C0BB),
                                  fontSize: size.FontSize.aboutcontent.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                "Follow us on".tr,
                                style: kTextStylePoppinsRegular.copyWith(
                                  color: const Color(0xffC1C0BB),
                                  fontSize: size.FontSize.aboutcontent1.sp,
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: 89.w, right: 89.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse(
                                            aboutUsController
                                                .aboutUs.value!.twitterLink
                                                .toString());
                                        await _launchUrl(url);
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons/x.svg"),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse(
                                            aboutUsController
                                                .aboutUs.value!.fbLink
                                                .toString());
                                        await _launchUrl(url);
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons/facebook.svg"),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse(
                                            aboutUsController
                                                .aboutUs.value!.instaLink
                                                .toString());
                                        await _launchUrl(url);
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons/instagram.svg"),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        debugPrint(
                                            "aboutUsController.aboutUs.value!.webUrl.toString():${aboutUsController.aboutUs.value!.webUrl.toString()}");
                                        final Uri url = Uri.parse(
                                            aboutUsController
                                                .aboutUs.value!.webUrl
                                                .toString());
                                        await _launchUrl(url);
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons/internet.svg"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 22.h,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
