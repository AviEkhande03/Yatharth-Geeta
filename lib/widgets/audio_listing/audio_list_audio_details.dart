// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:yatharthageeta/const/colors/colors.dart';
// import 'package:yatharthageeta/const/font_size/font_size.dart';
// import 'package:yatharthageeta/const/text_styles/text_styles.dart';

// class AudioListAudioDetails extends StatelessWidget {
//   const AudioListAudioDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       margin: EdgeInsets.only(right: 25.w),
//       child: Stack(
//         children: [
//           Container(
//             height: 141.h,
//             // color: Colors.pink,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                   ),
//                   height: 125.h,
//                   width: 125.h,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(200.h),
//                     child: CachedNetworkImage(imageUrl:
//                       controller
//                           .bookDetails.value!.audio!.audioCoverImageUrl
//                           .toString(),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 15.w,
//                 ),
//                 Expanded(
//                   child: Container(
//                     // color: Colors.red,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           controller.bookDetails.value!.audio!.title
//                               .toString(),
//                           style: kTextStylePoppinsMedium.copyWith(
//                             fontSize: FontSize.detailsScreenSubMediaTitle.sp,
//                             color: kColorFont,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 8.h,
//                         ),
//                         Text(
//                           "${'by'.tr} ${controller.bookDetails.value!.audio!.authorName.toString()}",
//                           style: kTextStylePoppinsRegular.copyWith(
//                             fontSize: FontSize.detailsScreenSubMediaAuthor.sp,
//                             color: kColorBlackWithOpacity75,
//                           ),
//                         ),

//                         SizedBox(
//                           height: 16.h,
//                         ),

//                         //Language Tag
//                         Row(
//                           children: [
//                             Container(
//                               height: screenWidth >= 600 ? 20.h : 17.h,
//                               padding: EdgeInsets.only(
//                                 left: 12.w,
//                                 right: 12.w,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(4.h),
//                                 color: kColorFontLangaugeTag.withOpacity(0.05),
//                               ),
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 controller
//                                     .bookDetails.value!.audio!.mediaLanguage
//                                     .toString(),
//                                 style: kTextStylePoppinsRegular.copyWith(
//                                   fontSize: FontSize
//                                       .detailsScreenSubMediaLangaugeTag.sp,
//                                   color: kColorFontLangaugeTag,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         //Duration
//                         Text(
//                           controller.demoEbook.audioDuration,
//                           // style: kText,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Stack(
//             children: [
//               SizedBox(
//                 height: 141.h,
//                 width: 125.h,
//                 // color: Colors.green.withOpacity(0.4),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: SizedBox(
//                   // margin: EdgeInsets.only(left: 47.w),
//                   height: 32.h,
//                   width: 32.h,
//                   child: SvgPicture.asset('assets/icons/audio_icon.svg'),
//                 ),
//               ),
//             ],
//           ),
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.bottomRight,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     // color: Colors.yellow,
//                     margin: EdgeInsets.only(left: 47.w),
//                     height: 18.h,
//                     width: 18.h,
//                     child: SvgPicture.asset('assets/icons/eye_ebookdetail.svg'),
//                   ),
//                   SizedBox(
//                     width: 8.w,
//                   ),
//                   Text(
//                     // Utils.formatNumber(
//                     //     controller
//                     //         .demoEbook.views),
//                     controller.bookDetails.value!.audio!.viewCount
//                         .toString(),
//                     style: kTextStylePoppinsRegular.copyWith(
//                       fontSize: FontSize.views.sp,
//                       color: kColorFontOpacity75,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
