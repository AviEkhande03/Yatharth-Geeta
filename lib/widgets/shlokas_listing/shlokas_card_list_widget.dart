import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/shlokas_listing/shlokas_listing_controller.dart';
import 'shlokas_card_new_widget.dart';
// import 'package:yatharthageeta/widgets/shlokas_listing/shlokas_card_widget.dart';

class ShlokasCardListWidget extends StatelessWidget {
  ShlokasCardListWidget({
    super.key,
  });

  final shlokasListingController = Get.find<ShlokasListingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => shlokasListingController.shlokasListing != []
        ? ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // return Container(
              //   height: 100,
              //   width: 100,
              //   color: Colors.red,
              // );
              return ShlokaCardNewWidget(
                shlokaMain: shlokasListingController
                    .shlokasListing[index].mainShlok
                    .toString(),
                shlokaMeaning: shlokasListingController
                    .shlokasListing[index].explainationShlok
                    .toString(),
                shlokaVerseName: shlokasListingController
                    .shlokasListing[index].verseNumber
                    .toString(),
                shlokaVerseNumber: shlokasListingController
                    .shlokasListing[index].verseNumber
                    .toString(),
                index: index,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 16.h,
              );
            },
            itemCount: shlokasListingController.shlokasListing.length)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                SvgPicture.asset("assets/icons/no_shloka.svg"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/swastik.svg"),
                    Text(
                      "No Shlokas Available",
                      style: kTextStyleNotoRegular.copyWith(
                          fontWeight: FontWeight.w500, fontSize: 20.sp),
                    ),
                    SvgPicture.asset("assets/icons/swastik.svg"),
                  ],
                ),
              ]));
  }
}
