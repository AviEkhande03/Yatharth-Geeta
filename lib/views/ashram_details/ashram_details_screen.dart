// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:yatharthageeta/const/colors/colors.dart';
// import 'package:yatharthageeta/const/text_styles/text_styles.dart';
// import 'package:yatharthageeta/controllers/ashram_details/ashram_details_controller.dart';
// import 'package:yatharthageeta/widgets/ashram_details/ashram_about_section.dart';
// import 'package:yatharthageeta/widgets/ashram_details/ashram_contact_section.dart';
// import 'package:yatharthageeta/widgets/ashram_details/ashram_details_screen_tab_widget.dart';
// import 'package:yatharthageeta/widgets/common/custom_app_bar.dart';

// class AshramDetailsScreen extends StatelessWidget {
//   AshramDetailsScreen({super.key});

//   final ashramDetailsController = Get.find<AshramDetailsController>();

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(resizeToAvoidBottomInset: true,
//       backgroundColor: kColorWhite,
//       body: Obx(
//         () => SafeArea(
//           child: Column(
//             children: [
//               //App Bar
//               CustomAppBar(
//                 sideIconsUrl: 'assets/images/home/satiya_symbol.svg',
//                 title: 'Ashram'.tr,
//               ),

//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     color: kColorWhite2,
//                     child: Column(
//                       children: [
//                         // Text('data'),
//                         Stack(
//                           children: [
//                             SizedBox(
//                               height: 266.h,
//                               width: screenSize.width,
//                               child: Image.asset(
//                                 'assets/images/ashram_details/ashram_bg.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),

//                             //Rest of the Contents
//                             Container(
//                               margin: EdgeInsets.only(top: 250.h),
//                               // height: 1500,
//                               width: screenSize.width,
//                               decoration: BoxDecoration(
//                                 color: kColorWhite2,
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(8.h),
//                                   topRight: Radius.circular(8.h),
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: kColorWhite,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(8.h),
//                                         topRight: Radius.circular(8.h),
//                                       ),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 16.h,
//                                         ),
//                                         Text(
//                                           "Shri Paramhans Ashram",
//                                           style:
//                                               kTextStylePoppinsRegular.copyWith(
//                                             color: kColorFont,
//                                             fontSize: 20.sp,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 16.h,
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 25.w),
//                                           child: Text(
//                                             "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam non tincidunt quam. Pellentesque luctus augue auctor dapibus aliquam.",
//                                             textAlign: TextAlign.center,
//                                             style: kTextStylePoppinsRegular
//                                                 .copyWith(
//                                               color: kColorBlackWithOpacity75,
//                                               fontSize: 12.sp,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 33.h,
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   SizedBox(
//                                     height: 16.h,
//                                   ),

//                                   //Tabs Goes here
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: kColorWhite,
//                                       borderRadius:
//                                           BorderRadius.circular(200.h),
//                                     ),
//                                     width: screenSize.width,
//                                     height: 64.h,
//                                     // color: Colors.grey,
//                                     child: Row(
//                                       children: [
//                                         //About Tab
//                                         GestureDetector(
//                                           onTap: () {
//                                             ashramDetailsController
//                                                 .selectedAshramTab
//                                                 .value = 'About'.tr;
//                                           },
//                                           child: AshramDetailsScreenTabWidget(
//                                             title: 'About'.tr,
//                                             iconImgUrl:
//                                                 'assets/images/ashram_details/mandir_inactive.png',
//                                           ),
//                                         ),

//                                         //Contact Tab
//                                         GestureDetector(
//                                           onTap: () {
//                                             ashramDetailsController
//                                                 .selectedAshramTab
//                                                 .value = 'Contact'.tr;
//                                           },
//                                           child: AshramDetailsScreenTabWidget(
//                                             title: 'Contact'.tr,
//                                             iconImgUrl:
//                                                 'assets/images/ashram_details/phone_inactive.png',
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   SizedBox(
//                                     height: 16.h,
//                                   ),

//                                   ashramDetailsController
//                                               .selectedAshramTab.value.tr ==
//                                           'About'.tr
//                                       ? const AshramAboutSection()
//                                       : const AshramContactSection(),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
