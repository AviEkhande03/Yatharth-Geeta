import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/widgets/guruji_details/guruji_hindi_heading.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/guruji_details/guruji_details_controller.dart';
import '../../services/language/language_service.dart';
import '../event_details/event_details_description_text_widget.dart';
import '../home/heading_home_widget.dart';
import 'ebook_list_guruji_details.dart';
import 'video_list_guruji_details.dart';

class GurujiAbout extends StatelessWidget {
  final GurujiDetailsController controller;
  final languageService = Get.find<LangaugeService>();
  final ScrollController scrollController;
  GurujiAbout(
      {Key? key, required this.controller, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 24.h),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      height: screenWidth >= 600 ? 40.h : 26.h,
                      width: screenWidth >= 600 ? 40.h : 26.h,
                      child: SvgPicture.asset("assets/icons/swastik.svg")),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Brief".tr,
                    style: kTextStylePoppinsRegular.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: FontSize.gurujiDescTitle.sp),
                  )
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              /*Obx(
                () => buildText(
                    "Swami Shri Adgadanand Ji Maharaj came to the recluse saint Paramanand Ji at the age of 23 in November 1955 searching for the truth. The hermitage of Parmanand Ji was in Chitrakoot at Anusuiya, Satna, Madhya Pradesh (India) amidst dense forests infested with wild animals. Living in such an uninhabitable forest in the absence of any facility, rightly reflect that he was an accomplished sage. Reverend Paramhans Ji received a premonition of Swami Adgadanand Ji Maharaj’s arrival many years earlier. The day he reached the ashram, Paramhans Ji received divine guidance. He told his disciples, “A young man who is ardently seeking to go beyond the impermanence of life must be coming at any moment now.” The moment he cast his eye upon him, Paramhans Ji declared, “Here he is!” Whenever a spiritual seeker comes in contact with a great sage, it is not immediately possible for him to realise the greatness of the sage. He dreamt of a divine soul and a chaste Brahmin who had told him, “Your Guru has all those qualities that are found in the greatest sages incarnated in this world and he is such sage.” With the strengthening of his faith in the Guru his spiritual pursuit also picked up. Guided under the angelic direction of the Guru he set out on the path of spiritual freedom. The aim was achieved."
                        .tr,
                    controller.readMore.value),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      controller.readMore.value = !controller.readMore.value;
                    },
                    child: Obx(
                      () => Text(
                        !controller.readMore.value ? "More".tr : "Less".tr,
                        style: kTextStylePoppinsRegular.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: kColorPrimary,
                            decoration: TextDecoration.underline,
                            decorationColor: kColorPrimary),
                      ),
                    )),
              )*/
              EventDetailsDescriptionTextWidget(
                  description: controller
                      .gurujiDetails.first.data!.result!.artist!.description!)
            ],
          ),
        ),

        controller.gurujiDetails.first.data!.result!.topBooks!.isNotEmpty ||
                controller
                    .gurujiDetails.first.data!.result!.topVideos!.isNotEmpty
            ? Container(
                height: 16.h,
                color: kColorWhite2,
              )
            : const SizedBox(),

        //Removed Ashram Section
        // Container(
        //   padding:
        //       EdgeInsets.only(left: 24.w, right: 24.w, top: 24.h, bottom: 24.h),
        //   child: HeadingHomeWidget(
        //     svgLeadingIconUrl: 'assets/images/home/shiv_symbol.svg',
        //     headingTitle: 'Ashram'.tr,
        //     // authorName: 'Swami Shri Adganand Ji Maharaj',
        //   ),
        // ),
        // GestureDetector(
        //     onTap: () {
        //       Get.toNamed(AppRoute.ashramDetailsScreen);
        //     },
        //     child: AshramCard()),
        // Container(
        //   margin: EdgeInsets.only(top: 24.h),
        //   height: 16.h,
        //   color: kColorWhite2,
        // ),
        controller.gurujiDetails.first.data!.result!.topBooks!.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(
                    left: 25.w, right: 25.w, top: 25.h, bottom: 25.h),
                child: Column(
                  children: [
                    //Heading

                    languageService.getCurrentLocale.languageCode == 'en'
                        ? HeadingHomeWidget(
                            svgLeadingIconUrl:
                                'assets/images/home/shiv_symbol.svg',
                            headingTitle: 'Top Books'.tr,
                            authorName: controller.gurujiDetails.first.data!
                                .result!.artist!.name!,
                          )
                        : GurujiHindiHeadingWidget(
                            svgLeadingIconUrl:
                                'assets/images/home/shiv_symbol.svg',
                            headingTitle: 'Top Books'.tr,
                            authorName: controller.gurujiDetails.first.data!
                                .result!.artist!.name!),

                    SizedBox(
                      height: 25.h,
                    ),

                    //Books List
                    Container(
                      alignment: Alignment.centerLeft,
                      height: screenWidth >= 600 ? 320.h : 251.h,
                      child: EbooksListGurujiDetails(
                        ebookslist: controller
                            .gurujiDetails.first.data!.result!.topBooks!,
                        scrollController: scrollController,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),

        controller.gurujiDetails.first.data!.result!.topVideos!.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(top: 25.h, bottom: 25.h),
                child: Column(
                  children: [
                    //Heading
                    Container(
                      margin: EdgeInsets.only(left: 25.w, right: 25.w),
                      child:
                          languageService.getCurrentLocale.languageCode == 'en'
                              ? HeadingHomeWidget(
                                  svgLeadingIconUrl:
                                      'assets/images/home/satiya_symbol.svg',
                                  headingTitle: 'Top Videos'.tr,
                                  authorName: controller.gurujiDetails.first
                                      .data!.result!.artist!.name!,
                                )
                              : GurujiHindiHeadingWidget(
                                  svgLeadingIconUrl:
                                      'assets/images/home/satiya_symbol.svg',
                                  headingTitle: 'Top Videos'.tr,
                                  authorName: controller.gurujiDetails.first
                                      .data!.result!.artist!.name!,
                                ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),

                    //Videos List
                    VideosListGurujiDetails(
                      scrollController: scrollController,
                      videosList: controller
                          .gurujiDetails.first.data!.result!.topVideos!,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget buildText(String text, bool isReadmore) {
    // if read more is false then show only 3 lines from text
    // else show full text
    final lines = isReadmore ? null : 10;
    return Text(
      text,
      style: kTextStylePoppinsRegular.copyWith(
          fontSize: FontSize.mantra.sp, fontWeight: FontWeight.w400),
      maxLines: lines,
      textAlign: TextAlign.left,
      // overflow properties is used to show 3 dot in text widget
      // so that user can understand there are few more line to read.
      overflow: isReadmore ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }
}
