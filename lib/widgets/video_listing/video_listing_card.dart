import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../utils/utils.dart';
import '../common/text_poppins.dart';

class VideoListingCard extends StatelessWidget {
  VideoListingCard(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.artist,
      required this.language,
      this.duration,
      required this.views,
      required this.isEnd,
      this.durationTime = ''})
      : super(key: key);
  final String imageUrl;
  final String title;
  final String artist;
  final String language;
  final int? duration;
  final String? durationTime;
  final String views;
  final bool isEnd;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: kColorTransparent,
      // height: 190.h,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: width >= 600 ? height * 0.18 : height * 0.15,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: SizedBox(
                        width: width * 0.35,
                        height: width >= 600 ? height * 0.15 : height * 0.11,
                        child: FadeInImage(
                          image: NetworkImage(
                            imageUrl,
                          ),
                          placeholderFit: BoxFit.scaleDown,
                          placeholder:
                              const AssetImage("assets/icons/default.png"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset("assets/icons/default.png");
                          },
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                        width: width * 0.35,
                        margin: EdgeInsets.only(
                            bottom: width >= 600
                                ? screenHeight * 0.010.h
                                : screenHeight * 0.030.h),
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgPicture.asset(
                          "assets/icons/video.svg",
                          width: width >= 600 ? 35.w : 35.w,
                          height: width >= 600 ? 35.h : 35.h,
                          fit: BoxFit.fitHeight,
                          // width: 35.w,
                        ))
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width * 0.5,
                    child: TextPoppins(
                      text: title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.listingScreenMediaTitle.sp,
                    ),
                  ),
                  Container(
                    width: 220.w,
                    child: Text(
                      artist == '.' || artist == null || artist == ''
                          ? ''
                          : "${'by'.tr} $artist",
                      overflow: TextOverflow.ellipsis,
                      style: kTextStylePoppinsRegular.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: FontSize.listingScreenMediaAuthorTitle.sp,
                        color: kColorFontOpacity75,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.h, bottom: 8.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: const Color(0xffFEF8F6),
                        borderRadius: BorderRadius.circular(4.r)),
                    child: Center(
                      child: TextPoppins(
                        text: language,
                        color: kColorSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: FontSize.listingScreenMediaLanguageTag.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          durationTime.toString(),
                          style: kTextStylePoppinsRegular.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize:
                                FontSize.listingScreenMediaContentCount.sp,
                            color: kColorFontOpacity75,
                          ),
                        ),
                        Visibility(
                          visible: views != "0",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/eye_ebookdetail.svg",
                                width: 18.w,
                              ),
                              TextPoppins(
                                text: " $views",
                                color: const Color(0xff514E49),
                                fontSize: FontSize.views.sp,
                                fontWeight: FontWeight.w400,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          !isEnd
              ? Divider(
                  thickness: 1.sp,
                  color: kColorBlack.withOpacity(0.1),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
