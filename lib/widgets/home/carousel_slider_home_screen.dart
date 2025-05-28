import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';

class CarouselSliderHomeScreen extends StatefulWidget {
  const CarouselSliderHomeScreen({super.key});

  @override
  CarouselSliderHomeScreenState createState() =>
      CarouselSliderHomeScreenState();
}

class CarouselSliderHomeScreenState extends State<CarouselSliderHomeScreen> {
  final List<String> imageList = [
    'assets/images/banner2x.png',
    'assets/images/banner3x.png',
    'assets/images/banner4x.png',
  ];

  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorWhite,
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 16 / 7.5,
              enlargeCenterPage: true,
              viewportFraction: 0.87,
              enlargeFactor: 0.2,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: imageList
                .asMap()
                .entries
                .map((entry) => Center(
                      child: Container(
                        // margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: _currentIndex == entry.key
                            ? Image.asset(
                                entry.value,
                                fit: BoxFit.cover,
                                // width: 1000,
                              )
                            : Image.asset(
                                entry.value,
                                fit: BoxFit.cover,
                                // width: 1000,
                              ),
                      ),
                    ))
                .toList(),
          ),
          Container(
            margin: EdgeInsets.only(left: 24.w, top: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: imageList.asMap().entries.map((entry) {
                int index = entry.key;
                return _currentIndex == index
                    ? Container(
                        width: 12.h,
                        height: 12.h,
                        margin: const EdgeInsets.symmetric(
                          // vertical: 5.h,
                          horizontal: 2.0,
                        ),
                        decoration: const BoxDecoration(
                          color: kColorPrimary,
                          shape: BoxShape.circle,
                        ))
                    : Container(
                        width: 8.h,
                        height: 8.h,
                        margin: const EdgeInsets.symmetric(
                          // vertical: 5.h,
                          horizontal: 2.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kColorCarouselUnselected,
                        ),
                      );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
