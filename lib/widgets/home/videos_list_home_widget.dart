// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../const/colors/colors.dart';
// import '../../const/font_size/font_size.dart';
// import '../../const/text_styles/text_styles.dart';
// import '../../models/home/videos_model.dart';

// class VideosListHomeWidget extends StatelessWidget {
//   const VideosListHomeWidget({
//     this.videosList = const [],
//     super.key,
//   });

//   final List<VideosModel> videosList;

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return videosList != []
//         ? SizedBox(
//             height: screenWidth >= 600 ? 210.h : 185.h,
//             child: ListView.separated(
//               padding: EdgeInsets.only(left: 25.w, right: 25.w),
//               shrinkWrap: true,
//               // physics: const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 return Stack(
//                   children: [
//                     SizedBox(
//                       width: screenWidth >= 600 ? 160.w : 200.w,
//                       // color: Colors.red,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: 200.w,
//                             height: 125.h,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.h),
//                               child: Image.asset(
//                                 videosList[index].videoCoverImgUrl,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 8.h,
//                           ),
//                           Text(
//                             videosList[index].title,
//                             style: kTextStylePoppinsMedium.copyWith(
//                               fontSize: FontSize.mediaTitle.sp,
//                               color: kColorFont,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),

//                           //Language Tag
//                           Row(
//                             children: [
//                               Container(
//                                 padding:
//                                     EdgeInsets.only(left: 12.w, right: 12.w),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(4.h),
//                                   color:
//                                       kColorFontLangaugeTag.withOpacity(0.05),
//                                 ),
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   '${videosList[index].duration} min | ${videosList[index].langauge}',
//                                   style: kTextStylePoppinsRegular.copyWith(
//                                     fontSize: FontSize.mediaLanguageTags.sp,
//                                     color: kColorFontLangaugeTag,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: screenWidth >= 600 ? 68.h : 45.h,
//                       right: 8.w,
//                       child: Container(
//                         height: 32.h,
//                         width: 32.h,
//                         child: Image.asset('assets/images/home/video_icon.png'),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               separatorBuilder: (context, index) {
//                 return SizedBox(
//                   width: 16.w,
//                 );
//               },
//               itemCount: videosList.length,
//             ),
//           )
//         : const SizedBox();
//   }
// }
