import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../utils/utils.dart';

class AudioListingCard extends StatelessWidget {
  const AudioListingCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.language,
    required this.duration,
    required this.views,
    required this.isEnd,
    required this.hasEpisodes,
  }) : super(key: key);
  final String imageUrl;
  final String title;
  final String artist;
  final bool hasEpisodes;
  final String language;
  final String duration;
  final String views;
  final bool isEnd;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 18 5.h,
      color: kColorWhite,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 145.w,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    SizedBox(
                        width: 125.w,
                        height: 125.w,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(125.w),
                          child: FadeInImage(
                            image: NetworkImage(imageUrl),
                            placeholderFit: BoxFit.scaleDown,
                            placeholder:
                                const AssetImage("assets/icons/default.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/icons/default.png");
                            },
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Container(
                        width: 125.w,
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(
                          "assets/icons/music.svg",
                          width: 35.w,
                        ))
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: kTextStylePoppinsMedium.copyWith(
                            fontSize: FontSize.listingScreenMediaTitle.sp,
                            color: kColorFont,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        artist != ''
                            ? SizedBox(
                                child: Text(
                                  '${'by'.tr} $artist',
                                  style: kTextStylePoppinsRegular.copyWith(
                                    fontSize: FontSize
                                        .listingScreenMediaAuthorTitle.sp,
                                    color: kColorFontOpacity75,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: 15.h,
                        ),
                        //Language Tag
                        Row(
                          children: [
                            Container(
                              // height: 22.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.h),
                                color: kColorFontLangaugeTag.withOpacity(0.05),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                language,
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize:
                                      FontSize.listingScreenMediaLanguageTag.sp,
                                  color: kColorFontLangaugeTag,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 8.h,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hasEpisodes ? "$duration episodes" : "",
                              style: kTextStylePoppinsLight.copyWith(
                                fontSize:
                                    FontSize.listingScreenMediaContentCount.sp,
                                color: kColorBlackWithOpacity75,
                              ),
                            ),
                            Visibility(
                              visible: views != "0" && views != "",
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          // color: Colors.yellow,
                                          margin: EdgeInsets.only(left: 47.w),
                                          // height: 16.h,

                                          child: SvgPicture.asset(
                                            'assets/icons/eye_ebookdetail.svg',
                                            width: 18.w,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          views,
                                          // Utils.formatNumber(
                                          //     ebooksList[index].views),
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            fontSize: FontSize.views.sp,
                                            color: kColorFontOpacity75,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [],
                    ),
                  ],
                ),
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ConstrainedBox(
              //       constraints: BoxConstraints(maxWidth: 250.w),
              //       child: TextPoppins(
              //         text: title,
              //         fontWeight: FontWeight.w500,
              //         fontSize: 14.sp,
              //         maxLines: 2,
              //       ),
              //     ),
              //     SizedBox(
              //       height: 5.h,
              //     ),
              //     Text(
              //       "${'by'.tr} $artist",
              //       style: kTextStylePoppinsRegular.copyWith(
              //         fontWeight: FontWeight.w400,
              //         fontSize: 10.sp,
              //         color: kColorFontOpacity75,
              //       ),
              //     ),
              //     Container(
              //         height: 22.h,
              //         width: 54.w,
              //         margin: EdgeInsets.only(top: 16.h, bottom: 8.h),
              //         decoration: BoxDecoration(
              //             color: const Color(0xffFEF8F6),
              //             borderRadius: BorderRadius.circular(4.r)),
              //         child: Center(
              //             child: TextPoppins(
              //           text: language,
              //           color: kColorSecondary,
              //           fontWeight: FontWeight.w400,
              //           fontSize: 12.sp,
              //         ))),
              //     Text(
              //       duration,
              //       style: kTextStylePoppinsRegular.copyWith(
              //         fontWeight: FontWeight.w300,
              //         fontSize: 10.sp,
              //         color: kColorFontOpacity75,
              //       ),
              //     ),
              //     Row(
              //       children: [
              //         SizedBox(
              //           width: width * 0.48,
              //         ),
              //         SvgPicture.asset(
              //           "assets/icons/eye_ebookdetail.svg",
              //           width: 16.w,
              //         ),
              //         TextPoppins(
              //           text: "  $views",
              //           color: const Color(0xff514E49),
              //           fontSize: 10.sp,
              //           fontWeight: FontWeight.w400,
              //         )
              //       ],
              //     )
              //   ],
              // )
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
