// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:yatharthageeta/widgets/common/text_poppins.dart';

// import '../../const/colors/colors.dart';
// import '../../const/font_size/font_size.dart';

// class SelectLanguageBox extends StatelessWidget {
//   const SelectLanguageBox({
//     super.key,
//     this.nativeText,
//     required this.engText,
//     required this.bgPath,
//     this.isDefault = false,
//     this.onTap,
//     required this.index,
//     required this.selectedIndex,
//   });
//   final VoidCallback? onTap;
//   final String? nativeText;
//   final String engText;
//   final String bgPath;
//   final bool isDefault;
//   final int index;
//   final int selectedIndex;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         // padding: EdgeInsets.all(8.0.w),
//         height: 125.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4.r),
//           image: DecorationImage(image: AssetImage(bgPath), fit: BoxFit.fill),
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 16.0.w),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child:
//                 engText == 'English' ?
//                     Row(children: [
//                       TextPoppins(
//                         text: engText,
//                         fontSize: FontSize.languageText.sp,
//                         textAlign: TextAlign.start,
//                         fontWeight: FontWeight.w600,
//                         color: kColorWhite2,
//                       )
//                     ],) :
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // nativeText != null
//                     //     ?
//                 TextPoppins(
//                             text: nativeText ?? '',
//                             fontSize: FontSize.languageText.sp,
//                             // textAlign: TextAlign.start,
//                             fontWeight: FontWeight.w600,
//                             color: kColorWhite2,
//                           ),
//                         // : const SizedBox(),
//                     // nativeText != null
//                     //     ?
//                     // SizedBox(height: 10.h),
//                     //     : SizedBox(height: 0.h),
//                     TextPoppins(
//                       text: engText,
//                       fontSize: FontSize.languageText.sp,
//                       // textAlign: TextAlign.start,
//                       fontWeight: FontWeight.w600,
//                       color: kColorWhite2,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: index == selectedIndex
//                   ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SvgPicture.asset(
//                         'assets/images/language/check_circle.svg',
//                         width: 24.h,
//                         height: 24.h,
//                       ),
//                   )
//                   : const SizedBox(),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
// child: isDefault
//     ? Container(
//         margin: EdgeInsets.only(right: 8.w,bottom: 8.h),
//         padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 4.h),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15.h),
//             color: kColorWhite.withOpacity(0.15)),
//         child: TextPoppins(
//           text: 'Default',
//           color: kColorWhite2,
//           fontSize: FontSize.authScreenFontSize12.sp,
//           fontWeight: FontWeight.w500,
//         ),
//       )
//     : const SizedBox(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
