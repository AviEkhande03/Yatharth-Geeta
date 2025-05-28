import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/text_styles/text_styles.dart';

class RecentVideos extends StatelessWidget {
  const RecentVideos(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.artist,
      required this.language,
      required this.duration,
      required this.views})
      : super(key: key);
  final String imageUrl;
  final String title;
  final String artist;
  final String language;
  final String duration;
  final String views;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        // height: 180.h,
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h),
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 3 / 1.1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 140.h,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: SizedBox(
                              width: 150.w,
                              height: 120.h,
                              child: FadeInImage(
                                image: NetworkImage(imageUrl),
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
                            width: 150.w,
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(right: 10.w),
                            child: SvgPicture.asset(
                              "assets/icons/playIcon.svg",
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
                        child: Text(
                          title,
                          style: kTextStylePoppinsMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          "${'by'.tr} $artist",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kTextStylePoppinsMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp,
                              color: kColorFont,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              top: 2.h, bottom: 2.h, left: 12.w, right: 12.w),
                          margin: EdgeInsets.only(top: 16.h, bottom: 8.h),
                          decoration: BoxDecoration(
                              color: const Color(0xffFEF8F6),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Center(
                              child: Text(
                            language,
                            style: kTextStylePoppinsRegular.copyWith(
                              color: kColorSecondary,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ))),
                      SizedBox(
                        width: width * 0.5,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              duration,
                              style: kTextStylePoppinsMedium.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 11.sp,
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/eye_ebookdetail.svg",
                                  width: 16.w,
                                ),
                                Text(
                                  "   $views",
                                  style: kTextStylePoppinsRegular.copyWith(
                                    color: const Color(0xff514E49),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              Divider(
                thickness: 1.sp,
                color: kColorBlack.withOpacity(0.1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
