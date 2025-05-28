import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class ShlokasCarouselSlider extends StatefulWidget {
  const ShlokasCarouselSlider({super.key});

  @override
  ShlokasCarouselSliderState createState() => ShlokasCarouselSliderState();
}

class ShlokasCarouselSliderState extends State<ShlokasCarouselSlider> {
  final List<String> imageList = [
    'assets/images/home/shlokas_canvas.jpg',
    'assets/images/home/shlokas_canvas.jpg',
    'assets/images/home/shlokas_canvas.jpg',
  ];

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 16 / 11.5,
            enlargeCenterPage: false,
            viewportFraction: 0.87,
            enlargeFactor: 0.2,
            onPageChanged: (index, reason) {
              setState(() {});
            },
          ),
          items: imageList
              .asMap()
              .entries
              .map(
                (entry) => Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Stack(
                      children: [
                        Image.asset(
                          entry.value,
                          fit: BoxFit.fill,
                          // width: 1000,
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
                                'अध्याय -2',
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize: FontSize.homeShlokasTitle.sp,
                                  color: kColorShlokasTitle,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                'Gita Shloka 47',
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize: FontSize.homeShlokasContent.sp,
                                  color: kColorBlack,
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              Text(
                                'नैनं छिद्रन्ति शस्त्राणि नैनं दहति पावक: ।न चैनं क्लेदयन्त्यापो न शोषयति मारुत ॥',
                                textAlign: TextAlign.center,
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize: FontSize.homeShlokasContent.sp,
                                  color: kColorFont,
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
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
                                      fontSize: FontSize.homeShlokasContent.sp,
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

                              //Meaning
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  'Weapons cannot shred the soul, nor can fire burn it. Water cannot wet it, nor can the wind dry it.',
                                  style: kTextStyleNiconneRegular.copyWith(
                                    color: kColorShlokasMeaning,
                                    fontSize: FontSize.homeShlokasContent.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                '- Bhagavad Gita',
                                style: kTextStylePoppinsRegular.copyWith(
                                    fontSize: FontSize.homeShlokasRefTitle.sp,
                                    color:
                                        kColorShlokasMeaning.withOpacity(0.50)),
                              ),

                              SizedBox(
                                height: 4.h,
                              ),

                              Text(
                                'yatharthgeeta.com',
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize: FontSize.homeShlokasRefTitle.sp,
                                  color: kColorFont.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 8.w,
                          top: 8.h,
                          child: SizedBox(
                            height: 36.h,
                            width: 36.h,
                            child: Image.asset(
                              'assets/images/home/shlokas_design1.png',
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8.w,
                          top: 8.h,
                          child: SizedBox(
                            height: 36.h,
                            width: 36.h,
                            child: Image.asset(
                              'assets/images/home/shlokas_design2.png',
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8.w,
                          bottom: 50.h,
                          child: SizedBox(
                            height: 36.h,
                            width: 36.h,
                            child: Image.asset(
                              'assets/images/home/shlokas_design3.png',
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8.w,
                          bottom: 50.h,
                          child: SizedBox(
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
                          child: SizedBox(
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
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
