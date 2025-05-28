import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class QuotesSkeletonWidget extends StatelessWidget {
  const QuotesSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h),
                height: 500.h,
                width: screenWidth,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 20.h,
          margin: EdgeInsets.only(left: 50.w),
        );
      },
      itemCount: 3,
    );
  }
}
