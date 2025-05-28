import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AudioListingSkeleton extends StatelessWidget {
  const AudioListingSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        alignment: Alignment.centerLeft,
        height: screenWidth >= 600 ? 320.h : 200.h,
        child: ListView.separated(
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          // physics: const BouncingScrollPhysics(),

          itemCount: 3, // Total number of images
          itemBuilder: (context, index) {
            return Container(
              // color: Colors.yellow,
              child: AspectRatio(
                aspectRatio: 1.2 / 1.87,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.h),
                        color: Colors.grey.shade300,
                      ),

                      // color: Colors.red,
                      child: //Cover Image
                          ClipRRect(
                        borderRadius: BorderRadius.circular(4.h),
                        child: Container(
                          width: 150.w,
                          height: 190.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              ),
            );
          },

          separatorBuilder: (context, index) {
            return SizedBox(
              width: 15.w,
            );
          },
        ),
      ),
    );
  }
}
