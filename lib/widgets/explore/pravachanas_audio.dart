import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class PravachanasAudio extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String language;
  final int noOfColumn;

  const PravachanasAudio(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.language,
      required this.noOfColumn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: width.h * (0.5 / noOfColumn + 0.25),
          width: width.w * (0.54 / noOfColumn + 0.16),
          child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                  // width: 125.w,
                  // height: 125.h,
                  child: FadeInImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fitWidth,
                placeholderFit: BoxFit.scaleDown,
                placeholder: const AssetImage("assets/icons/default.png"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/icons/default.png");
                },
              )),
              Positioned.fill(
                bottom: -180.h,
                child: Container(
                    // width: 10.w,

                    // alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                  "assets/icons/music.svg",
                  fit: BoxFit.scaleDown,
                  // width: width.h / 4 * (0.7 / noOfColumn + 0.2),
                )),
              )
            ],
          ),
        ),
        // TextPoppins(
        // text: "Lessons from Gita",
        //   fontSize: FontSize.pravachanTitle.sp,
        //   fontWeight: FontWeight.w500,
        // ),
        Container(
          alignment: Alignment.center,
          width: 125.w,
          child: Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: kTextStylePoppinsMedium.copyWith(
              fontSize: FontSize.mediaTitle.sp,
              overflow: TextOverflow.ellipsis,
              color: kColorFont,
            ),
          ),
        ),

        Container(
            // height: 18.h,
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.h),
              color: kColorFontLangaugeTag.withOpacity(0.05),
            ),
            alignment: Alignment.center,
            child: Text(
              language,
              style: kTextStylePoppinsRegular.copyWith(
                fontSize: FontSize.mediaLanguageTags.sp,
                color: kColorFontLangaugeTag,
              ),
            ))

        // Container(
        //     height: 40.h,
        //     width: 60.w,
        //     decoration: BoxDecoration(
        //         color: const Color(0xffFEF8F6),
        //         borderRadius: BorderRadius.circular(4.r)),
        //     child: const Center(
        //         child: TextPoppins(
        //       text: "Hindi",
        //       // fontSize: FontSize.pravachanLanguage.sp,
        //       color: kColorSecondary,
        //       fontWeight: FontWeight.w400,
        //     ))),
      ],
    );
  }
}

//   //Book Title
//   Container(
//     alignment: Alignment.centerLeft,
//     child: Text(
//       ebookslist[index].title,
//       style: kTextStylePoppinsMedium.copyWith(
//         fontSize: FontSize.mediaTitle.sp,
//         color: kColorFont,
//       ),
//     ),
//   ),

//   //Language Tag
//   Row(
//     children: [
// Container(
//   // height: 18.h,
//   padding: EdgeInsets.only(left: 12.w, right: 12.w),
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(4.h),
//     color: kColorFontLangaugeTag.withOpacity(0.05),
//   ),
//   alignment: Alignment.centerLeft,
//   child: Row(
//     children: [
//       Text(
//         ebookslist[index].langauge,
//         style: kTextStylePoppinsRegular.copyWith(
//           fontSize: FontSize.mediaLanguageTags.sp,
//           color: kColorFontLangaugeTag,
//         ),
//       ),
//     ],
//         ),
//       ),
//     ],
//   ),
// ],
