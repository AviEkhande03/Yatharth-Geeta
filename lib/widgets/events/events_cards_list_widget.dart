// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:yatharthageeta/const/colors/colors.dart';
// import 'package:yatharthageeta/const/font_size/font_size.dart';
// import 'package:yatharthageeta/const/text_styles/text_styles.dart';
// import 'package:yatharthageeta/controllers/events_listing/events_listing_controller.dart';
// import 'package:yatharthageeta/routes/app_route.dart';
// import 'package:yatharthageeta/widgets/home/heading_home_widget.dart';

// class EventsCardsListWidget extends StatelessWidget {
//   EventsCardsListWidget({
//     super.key,
//   });

//   final eventsController = Get.find<EventsListingController>();

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return ListView.separated(
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, outerIndex) {
//         return Container(
          // padding: EdgeInsets.only(
          //   top: 25.h,
          //   bottom: 25.h,
          //   left: 25.w,
          //   right: 25.w,
          // ),
//           color: kColorWhite,
//           child: Column(
//             children: [
//               //Event Card Widget
//               EventsListingWidget(eventsController: eventsController, screenSize: screenSize)
//             ],
//           ),
//         );
//       },
//       separatorBuilder: (context, outerIndex) {
//         return SizedBox(
//           height: 24.h,
//         );
//       },
//       itemCount: eventsController.dummyyEventsList.length,
//     );
//   }
// }


