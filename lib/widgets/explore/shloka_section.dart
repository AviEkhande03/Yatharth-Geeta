// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yatharthageeta/const/colors/colors.dart';
// import 'package:yatharthageeta/controllers/explore/explore_controller.dart';
// import 'package:yatharthageeta/widgets/shlokas_listing/shlokas_card_list_widget.dart';

// class ShlokaSection extends StatelessWidget {
//   const ShlokaSection({Key? key, required this.controller}) : super(key: key);
//   final ExploreController controller;
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         margin: EdgeInsets.only(top: 25.h),
//         color: kColorWhite,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 25.h,
//             ),

//             //Shlokas Card
//             ShlokasCardListWidget(
//               shlokasList: controller.dummyShlokasModelList,
//             ),

//             SizedBox(
//               height: 30.h,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
