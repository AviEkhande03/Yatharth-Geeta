import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/widgets/common/text_poppins.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    Key? key,
    required this.error,
  }) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: kColorWhite2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/404_error.png', height: 180.h, width: 180.h,),
            SizedBox(
              height: 18.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/swastik.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, right: 6.w),
                  child: TextPoppins(
                    text: 'Something went wrong',
                    color: kColorFont,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                SvgPicture.asset('assets/icons/swastik.svg'),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: TextPoppins(
                text: "Please check your connection\nand restart the app",
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                textAlign: TextAlign.center,
              ),
            ),
            /*Padding(
              padding: EdgeInsets.only(top:45.0.h),
              child: CustomButton(
                btnText: 'Try Again'.tr,
                textColor: kColorWhite,
                isStretchable: false,
                btnColor: kColorPrimary,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
