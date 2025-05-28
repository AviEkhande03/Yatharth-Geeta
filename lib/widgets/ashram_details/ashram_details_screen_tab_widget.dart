// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:yatharthageeta/const/colors/colors.dart';
// import 'package:yatharthageeta/const/text_styles/text_styles.dart';
// import 'package:yatharthageeta/controllers/ashram_details/ashram_details_controller.dart';

// class AshramDetailsScreenTabWidget extends StatelessWidget {
//   AshramDetailsScreenTabWidget({
//     this.title = '',
//     this.iconImgUrl = '',
//     super.key,
//   });

//   final String title;
//   final String iconImgUrl;

//   final ashramDetailsController = Get.find<AshramDetailsController>();

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Container(
//       color: kColorTransparent,
//       child: Stack(
//         children: [
//           Container(
//             width: screenSize.width / 2,
//             height: 64.h,
//             // color: Colors.pink,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 24.h,
//                   width: 24.h,
//                   child: Image.asset(
//                     iconImgUrl,
//                     color: ashramDetailsController.selectedAshramTab.value ==
//                             title.tr
//                         ? kColorPrimary
//                         : kColorFont,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 Text(
//                   title,
//                   style: ashramDetailsController.selectedAshramTab.value ==
//                           title.tr
//                       ? kTextStylePoppinsMedium.copyWith(
//                           fontSize: 14.sp,
//                           color: kColorPrimary,
//                         )
//                       : kTextStylePoppinsRegular.copyWith(
//                           fontSize: 12.sp,
//                           color: kColorFont,
//                         ),
//                 )
//               ],
//             ),
//           ),
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: screenSize.width,
//                 // height: 64.h,
//                 color: kColorTransparent,
//                 child:
//                     ashramDetailsController.selectedAshramTab.value == title.tr
//                         ? ashramDetailsController.selectedAshramTab.value ==
//                                 'About'.tr
//                             ? Image.asset('assets/images/status_bar_curved.png')
//                             : Image.asset(
//                                 'assets/images/status_bar_curved_right.png')
//                         : const SizedBox(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
