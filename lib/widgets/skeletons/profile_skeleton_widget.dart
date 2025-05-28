import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class ProfileSkeletonWidget extends StatelessWidget {
  const ProfileSkeletonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kColorWhite2,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kColorWhite,
                  border: Border(
                    bottom: BorderSide(
                      color: kColorPrimaryWithOpacity25,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: 12.h,
                  bottom: 12.h,
                ),
                child: Text(
                  'Profile'.tr,
                  style: kTextStyleRosarioRegular.copyWith(
                    color: kColorFont,
                    fontSize: FontSize.profileTitle.sp,
                  ),
                ),
              ),
            ],
          ),

          //Guruji bg img
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 190.h,
                width: screenWidth,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                // margin: EdgeInsets.only(left: 25.w, right: 25.w),
                decoration: BoxDecoration(color: Colors.grey.shade300
                    // image: DecorationImage(
                    //     image: AssetImage(
                    //         'assets/images/profile/profile_bg.png'),
                    //     fit: BoxFit.fill),
                    ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: kColorWhite,
                    padding: EdgeInsets.all(25.w),
                    // height: 120.h,
                    width: screenWidth,
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                        Divider(
                          height: 20.h,
                          color: kNotificationDividerColor,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 35.h,
                            width: screenWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
