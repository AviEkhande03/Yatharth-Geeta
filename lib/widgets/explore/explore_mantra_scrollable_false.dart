import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../models/explore/explore_model.dart';
import '../common/text_poppins.dart';
import 'mantra_meaning.dart';

class ExploreMantraScrollableFalse extends StatefulWidget {
  const ExploreMantraScrollableFalse({super.key, required this.mantraList});
  final List<CollectionDatum> mantraList;
  @override
  MantraCarouselState createState() => MantraCarouselState();
}

class MantraCarouselState extends State<ExploreMantraScrollableFalse> {
  final List<String> imageList = [
    'assets/icons/mantra_canvas.png',
    'assets/icons/mantra_canvas.png',
    'assets/icons/mantra_canvas.png',
  ];

  //final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    // return CarouselSlider(
    //   carouselController: _controller,
    //   options: CarouselOptions(
    //     autoPlay: false,
    //     aspectRatio: 16 / 9,
    //     enlargeCenterPage: false,
    //     viewportFraction: 1,
    //     enlargeFactor: 0.2,
    //     initialPage: 0,
    //     enableInfiniteScroll: false,
    //     disableCenter: true,
    //     onPageChanged: (index, reason) {
    //       setState(() {});
    //     },
    //   ),
    //   items:
    // );
    return Column(
      // scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      children: widget.mantraList
          .map(
            (entry) => AspectRatio(
              aspectRatio: 16 / 9,
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    builder: (context) => MantraMeaning(
                        mantra: entry.sanskritTitle!, meaning: entry.meaning!),
                    isScrollControlled: true,
                    useSafeArea: false),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/icons/mantra_canvas1.png',
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
                              // SizedBox(
                              //   height: 35.h,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20.w, right: 20.w, top: 47.h),
                                child: Text(
                                  entry.sanskritTitle!,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStylePoppinsRegular.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kColorFont,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              TextPoppins(
                                text: "Click for Mantra Meaning",
                                fontSize: FontSize.mantraMeaning.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                '- ${entry.referenceName}',
                                style: kTextStylePoppinsRegular.copyWith(
                                    fontSize: FontSize.mantraGita.sp,
                                    color:
                                        kColorShlokasMeaning.withOpacity(0.50)),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                entry.referenceUrl!,
                                style: kTextStylePoppinsRegular.copyWith(
                                  fontSize: FontSize.mantraGita.sp,
                                  color: kColorFont.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
