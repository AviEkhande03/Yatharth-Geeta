import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class VideoListCardWidget extends StatelessWidget {
  const VideoListCardWidget({
    required this.videoArtist,
    required this.videoDuration,
    required this.videoImgUrl,
    required this.videoLanguage,
    required this.videoTitle,
    required this.videoViews,
    super.key,
  });

  final String videoImgUrl;
  final String videoTitle;
  final String videoArtist;
  final String videoLanguage;
  final String videoDuration;
  final String videoViews;

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
                        SizedBox(
                          height: screenWidth >= 600 ? 139.h : 111.h,
                          width: 166.w,
                          child: FadeInImage(
                            image: NetworkImage(videoImgUrl),
                            fit: BoxFit.cover,
                            placeholderFit: BoxFit.scaleDown,
                            placeholder:
                                const AssetImage("assets/icons/default.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/icons/default.png");
                            },
                          ),
                        ),
                        SizedBox(
                          height: screenWidth >= 600 ? 155.h : 127.h,
                          width: 166.w,
                          // color: Colors.yellow.withOpacity(0.3),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 127.w,
                          child: SizedBox(
                            height: 32.h,
                            width: 32.h,
                            child: SvgPicture.asset(
                              'assets/icons/video_icon.svg',
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: screenWidth >= 600 ? 220.h : 155.h,
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  videoTitle,
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
                                  '${'by'.tr} $videoArtist',
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
                                screenWidth >= 600
                                    ? Row(
                                        children: [
                                          Container(
                                            // height: 22.h,
                                            padding: EdgeInsets.only(
                                              left: 12.w,
                                              right: 12.w,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                              color: kColorFontLangaugeTag
                                                  .withOpacity(0.05),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              videoLanguage,
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                fontSize: FontSize
                                                    .listingScreenMediaLanguageTag
                                                    .sp,
                                                color: kColorFontLangaugeTag,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Container(
                                            height: 22.h,
                                            padding: EdgeInsets.only(
                                              left: 12.w,
                                              right: 12.w,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                              color: kColorFontLangaugeTag
                                                  .withOpacity(0.05),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              videoLanguage,
                                              style: kTextStylePoppinsRegular
                                                  .copyWith(
                                                fontSize: FontSize
                                                    .listingScreenMediaLanguageTag
                                                    .sp,
                                                color: kColorFontLangaugeTag,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                SizedBox(
                                  height: 8.h,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      videoDuration,
                                      style: kTextStylePoppinsLight.copyWith(
                                        fontSize: FontSize
                                            .listingScreenMediaContentCount.sp,
                                        color: kColorBlackWithOpacity75,
                                      ),
                                    ),
                                    videoViews != '0'
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
                                                //     videosList[index].viewsCount),
                                                videoViews,
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
        )
      ],
    );
  }
}
