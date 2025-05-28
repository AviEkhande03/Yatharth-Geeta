import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../../utils/utils.dart';

class ShlokaCardNewWidget extends StatelessWidget {
  const ShlokaCardNewWidget({
    required this.shlokaVerseName,
    required this.shlokaVerseNumber,
    required this.shlokaMain,
    required this.shlokaMeaning,
    this.index = 0,
    super.key,
  });

  // final ShlokasModel shlokasModel;
  final String shlokaVerseName;
  final String shlokaVerseNumber;
  final String shlokaMain;
  final String shlokaMeaning;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 25.w, right: 25.w),
          width: screenWidth,
          color: Utils.getColorByIndex(index!),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Text(
                "अध्याय -$shlokaVerseNumber",
                style: kTextStylePoppinsRegular.copyWith(
                  fontSize: 16.sp,
                  color: kColorShlokasTitle,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                shlokaVerseName,
                style: kTextStylePoppinsRegular.copyWith(
                  fontSize: 16.sp,
                  color: kColorBlack,
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Text(
                  shlokaMain,
                  textAlign: TextAlign.center,
                  style: kTextStylePoppinsRegular.copyWith(
                    fontSize: 16.sp,
                    color: kColorFont,
                  ),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              SizedBox(
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
                        fontSize: 18.sp,
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
                  shlokaMeaning,
                  style: kTextStyleNotoRegular.copyWith(
                    color: kColorShlokasMeaning.withOpacity(0.75),
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                height: 25.h,
              ),
            ],
          ),
        ),
        Positioned(
          left: 95.w,
          top: 5.h,
          child: SizedBox(
            height: 65.h,
            width: 65.h,
            child: Image.asset(
              'assets/images/home/letter_image.png',
              opacity: const AlwaysStoppedAnimation(0.75),
            ),
          ),
        ),
      ],
    );
  }
}
