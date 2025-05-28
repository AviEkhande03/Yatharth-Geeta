import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class AudioListCardWidget extends StatelessWidget {
  const AudioListCardWidget({
    required this.audioBookImgUrl,
    required this.audioBookTitle,
    required this.audioBookAuthor,
    required this.audioBookLanguage,
    required this.audioBookViews,
    required this.audioBookDuration,
    super.key,
  });

  final String audioBookImgUrl;
  final String audioBookTitle;
  final String audioBookAuthor;
  final String audioBookLanguage;
  final String audioBookDuration;
  final String audioBookViews;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          color: kColorTransparent,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 25.w, right: 25.w),
                // color: Colors.grey,
                width: screenSize.width,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.red,
                          ),
                          height: 125.h,
                          width: 125.h,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(200.h),
                              child: FadeInImage(
                                image: NetworkImage(audioBookImgUrl),
                                fit: BoxFit.fill,
                                placeholderFit: BoxFit.scaleDown,
                                placeholder: const AssetImage(
                                    "assets/icons/default.png"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/icons/default.png");
                                },
                              )),
                        ),
                        Container(
                          height: 141.h,
                          // width: 125.w,
                          // color: Colors.yellow.withOpacity(0.3),
                        ),
                        Positioned(
                          bottom: 0,
                          // left: 47.w,
                          right: 0,
                          left: 0,
                          child: SizedBox(
                            height: 32.h,
                            width: 32.h,
                            child: SvgPicture.asset(
                              'assets/icons/audio_icon.svg',
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Expanded(
                      child: Container(
                        height: screenWidth >= 600 ? 195.h : 155.h,
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  audioBookTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStylePoppinsMedium.copyWith(
                                    fontSize:
                                        FontSize.listingScreenMediaTitle.sp,
                                    color: kColorFont,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  '${'by'.tr} $audioBookAuthor',
                                  style: kTextStylePoppinsRegular.copyWith(
                                    fontSize: FontSize
                                        .listingScreenMediaAuthorTitle.sp,
                                    color: kColorFontOpacity75,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                //Language Tag
                                Row(
                                  children: [
                                    Container(
                                      // height: 22.h,
                                      padding: EdgeInsets.only(
                                          left: 12.w, right: 12.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                        color: kColorFontLangaugeTag
                                            .withOpacity(0.05),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        audioBookLanguage,
                                        style:
                                            kTextStylePoppinsRegular.copyWith(
                                          fontSize: FontSize
                                              .listingScreenMediaLanguageTag.sp,
                                          color: kColorFontLangaugeTag,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 8.h,
                                ),

                                Text(
                                  audioBookDuration,
                                  style: kTextStylePoppinsLight.copyWith(
                                    fontSize: FontSize
                                        .listingScreenMediaContentCount.sp,
                                    color: kColorBlackWithOpacity75,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //Views icon
                                    audioBookViews != '0'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                // color: Colors.yellow,
                                                margin:
                                                    EdgeInsets.only(left: 47.w),
                                                height: 18.h,
                                                width: 18.h,
                                                child: SvgPicture.asset(
                                                    'assets/icons/eye_ebookdetail.svg'),
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                // '32k',
                                                // Utils.formatNumber(
                                                //     audioBooksList[index].viewsCount),
                                                audioBookViews,
                                                style: kTextStylePoppinsRegular
                                                    .copyWith(
                                                  fontSize: FontSize.views.sp,
                                                  color: kColorFontOpacity75,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
          child: Divider(
            height: 1.h,
            color: kColorFont.withOpacity(0.10),
            thickness: 1.h,
          ),
        ),
      ],
    );
  }
}
