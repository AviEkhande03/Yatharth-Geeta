import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import 'dos_donts_bullet_text.dart';
import '../home/heading_home_widget.dart';

class AshramContactSection extends StatelessWidget {
  const AshramContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        //Location Map
        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              const HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/images/home/satiya_symbol.svg',
                headingTitle: 'Chalisgaon, Maharashtra',
              ),
              SizedBox(
                height: 25.h,
              ),
              SizedBox(
                height: 258.h,
                width: screenSize.width,
                child: Image.asset(
                  'assets/images/map.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 16.h,
        ),

        //Contact Number
        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/icons/phone_black.svg',
                headingTitle: 'Contact Number'.tr,
              ),
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const DosDontsBulletText(
                      text: "+91 22-28255300",
                    );
                  },
                  itemCount: 2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        //Email Address
        Container(
          color: kColorWhite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            children: [
              HeadingHomeWidget(
                svgLeadingIconUrl: 'assets/icons/email_ashram_details.svg',
                headingTitle: 'Email Address'.tr,
              ),
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const DosDontsBulletText(
                      text: "contact@yatharthgeeta.com",
                    );
                  },
                  itemCount: 1,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }
}
