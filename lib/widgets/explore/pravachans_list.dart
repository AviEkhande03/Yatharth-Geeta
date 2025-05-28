import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../models/explore/explore_model.dart';
import 'pravachanas_audio.dart';

class PravachansList extends StatelessWidget {
  const PravachansList({
    this.pravachanas = const [],
    super.key,
  });

  final List<CollectionDatum> pravachanas;

  @override
  Widget build(BuildContext context) {
    // return pravachanas != []
    //     ? ListView.separated(
    //         clipBehavior: Clip.none,
    //         scrollDirection: Axis.horizontal,
    //         shrinkWrap: true,
    //         itemBuilder: (context, index) {
    //           return PravachanasAudio(
    //               imageUrl: pravachanas[index].audioCoverImageUrl!,
    //               title: pravachanas[index].title!,
    //               language: pravachanas[index].mediaLanguage!);
    //         },
    //         separatorBuilder: (context, index) {
    //           return Container(
    //             width: 16.w,
    //           );
    //         },
    //         itemCount: pravachanas.length,
    //       )
    //     : const SizedBox();
    return pravachanas != []
        ? CarouselSlider.builder(
            itemCount: pravachanas.length,
            itemBuilder: (context, index, i) {
              return PravachanasAudio(
                imageUrl: pravachanas[index].audioCoverImageUrl!,
                title: pravachanas[index].title!,
                language: pravachanas[index].mediaLanguage!,
                noOfColumn: 2,
              ).paddingOnly(right: 10.w);
            },
            options: CarouselOptions(
                aspectRatio: 2 / (1.3 / 2 + 0.65),
                viewportFraction: 1 / 2,
                enableInfiniteScroll: false,
                padEnds: false))
        : const SizedBox();
  }
}
