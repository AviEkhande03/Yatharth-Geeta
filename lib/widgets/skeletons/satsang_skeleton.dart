import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../const/colors/colors.dart';

class SatsangSkeletonWidget extends StatelessWidget {
  const SatsangSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        height: 50.h,
                        width: 50.h,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    SizedBox(
                      width: screenWidth * 0.6,
                      // color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              color: Colors.grey.shade300,
                              width: screenWidth,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    margin: EdgeInsets.only(right: 20.w),
                    height: 24.h,
                    width: 24.h,
                    child: Image.asset(
                      'assets/images/home/music.png',
                      color: Colors.grey.shade300,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 50.w),
          child: Divider(
            height: 1.h,
            color: kColorFont.withOpacity(0.15),
          ),
        );
      },
      itemCount: 20,
    );
  }
}
