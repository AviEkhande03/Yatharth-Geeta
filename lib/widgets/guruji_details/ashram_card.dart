// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:yatharthageeta/const/colors/colors.dart';
// import 'package:yatharthageeta/const/text_styles/text_styles.dart';
// import 'package:yatharthageeta/routes/app_route.dart';

// class AshramCard extends StatelessWidget {
//   const AshramCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Get.toNamed(AppRoute.ashramDetailsScreen),
//       child: AspectRatio(
//         aspectRatio: 4 / 2.2,
//         child: Container(
//           // height: 206.h,
//           margin: EdgeInsets.only(left: 24.w, right: 24.w),
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(
//                 blurRadius: 10,
//                 color: kColorBlackWithOpacity25,
//                 spreadRadius: 0,
//                 blurStyle: BlurStyle.outer,
//                 offset: Offset(0, 4.h))
//           ], borderRadius: BorderRadius.circular(8.r)),
//           child: Column(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(8.r),
//                     topRight: Radius.circular(8.r)),
//                 child: Image.asset(
//                   "assets/images/aashram.png",
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(
//                     left: 16.w, right: 16.w, top: 16.h, bottom: 16.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Sri Paramhans Ashram",
//                       style: kTextStylePoppinsRegular.copyWith(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: kColorBlack),
//                     ),
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     Text(
//                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam non tincidunt quam. Pellentesque luctus augue auctor dapibus aliquam.",
//                       style: kTextStylePoppinsRegular.copyWith(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w400,
//                           color: kColorBlackWithOpacity75),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
