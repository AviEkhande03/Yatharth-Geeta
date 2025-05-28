import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../../models/home/shlokas_model.dart';

class ShlokaCardWidget extends StatelessWidget {
  const ShlokaCardWidget({
    required this.shlokasModel,
    super.key,
  });

  final ShlokasModel shlokasModel;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // height: 291.h,
      width: screenSize.width,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      child: Stack(
        children: [
          SizedBox(
            height: screenWidth >= 600 ? 500.h : 363.h,
            width: screenSize.width,
            child: Image.asset(
              shlokasModel.canvasImgUrl,
              fit: BoxFit.fill,
              // width: 1000,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // color: Colors.red.withOpacity(0.2),
            margin: EdgeInsets.only(bottom: 23.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  shlokasModel.shlokaTitle,
                  style: kTextStylePoppinsRegular.copyWith(
                    fontSize: 12.sp,
                    color: kColorShlokasTitle,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  shlokasModel.verseNumber,
                  style: kTextStylePoppinsRegular.copyWith(
                    fontSize: 14.sp,
                    color: kColorBlack,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    shlokasModel.shloka,
                    textAlign: TextAlign.center,
                    style: kTextStylePoppinsRegular.copyWith(
                      fontSize: 14.sp,
                      color: kColorFont,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Container(
                  // padding:
                  //     EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.w,
                        height: 1.h,
                        color: kColorFont,
                      ),
                      SizedBox(width: 14.w),
                      Text(
                        'Shloka Meaning',
                        style: kTextStyleNiconneRegular.copyWith(
                          fontSize: 14.sp,
                          color: kColorFont,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Container(
                        width: 100.w,
                        height: 1.h,
                        color: kColorFont,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 24.h,
                ),

                //Meaning
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Text(
                    shlokasModel.shlokasMeaning,
                    style: kTextStyleNiconneRegular.copyWith(
                      color: kColorShlokasMeaning,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 24.h,
            right: 0,
            left: 0,
            child: Column(
              children: [
                SizedBox(
                  height: 36.h,
                ),
                Text(
                  '- Bhagavad Gita',
                  style: kTextStylePoppinsRegular.copyWith(
                      fontSize: 6.sp,
                      color: kColorShlokasMeaning.withOpacity(0.50)),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  'yatharthgeeta.com',
                  style: kTextStylePoppinsRegular.copyWith(
                    fontSize: 6.sp,
                    color: kColorFont.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   left: 8.w,
          //   top: 8.h,
          //   child: Container(
          //     height: 36.h,
          //     width: 36.h,
          //     child: Image.asset(
          //       'assets/images/home/shlokas_design1.png',
          //     ),
          //   ),
          // ),
          // Positioned(
          //   right: 8.w,
          //   top: 8.h,
          //   child: Container(
          //     height: 36.h,
          //     width: 36.h,
          //     child: Image.asset(
          //       'assets/images/home/shlokas_design2.png',
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: 8.w,
          //   bottom: 8.h,
          //   child: Container(
          //     height: 36.h,
          //     width: 36.h,
          //     child: Image.asset(
          //       'assets/images/home/shlokas_design3.png',
          //     ),
          //   ),
          // ),
          Positioned(
            right: 16.w,
            bottom: 16.h,
            child: Container(
              height: 24.h,
              width: 24.h,
              child: SvgPicture.asset(
                'assets/images/home/whatsapp_logo.svg',
              ),
            ),
          ),
          Positioned(
            left: 65.w,
            top: 14.h,
            child: Container(
              height: 65.h,
              width: 65.h,
              child: Image.asset(
                'assets/images/home/letter_image.png',
                opacity: const AlwaysStoppedAnimation(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
