import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../const/constants/constants.dart';
import '../../models/explore/explore_model.dart';
import 'download_dialog.dart';

class Quotes extends StatelessWidget {
  const Quotes({this.quoteList = const [], super.key, this.scrollDirection});
  final Axis? scrollDirection;
  final List<CollectionDatum> quoteList;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return quoteList != []
        ? scrollDirection == Axis.horizontal
            //For Horizontal
            ? SizedBox(
                height: 500.h,
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  scrollDirection: scrollDirection ?? Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Get.toNamed(AppRoute.ebookDetailsScreen);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //   return EbookDetailsScreen();
                        // }));
                      },
                      child: AspectRatio(
                        aspectRatio: 3 / 3.7,
                        child: Stack(
                          fit: StackFit.expand,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Cover Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: FadeInImage(
                                image: NetworkImage(
                                    quoteList[index].quoteImageUrl!),
                                fit: BoxFit.cover,
                                placeholderFit: BoxFit.scaleDown,
                                placeholder: const AssetImage(
                                    "assets/icons/default.png"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/icons/default.png");
                                },
                              ),
                            ),
                            Positioned(
                              // alignment: Alignment.bottomRight,
                              bottom: 10.h,
                              left: 10.w,
                              child: InkWell(
                                onTap: () async {
                                  downloadAndShareImage(
                                      quoteList[index].quoteImageUrl!, context);
                                  // var data = await downloadImage(
                                  //     quoteList[index].quoteImageUrl!);
                                  // shareImage(data, context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    "assets/images/home/whatsapp_logo.svg",
                                    height: screenWidth >= 600 ? 30.h : 26.h,
                                    width: screenWidth >= 600 ? 30.h : 26.h,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: 16.w,
                    );
                  },
                  itemCount: quoteList.length,
                ),
              )
            //For Vertical
            : SizedBox(
                width: width,
                child: Column(
                  // clipBehavior: Clip.hardEdge,
                  // scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  // physics: AlwaysScrollableScrollPhysics(),
                  children: quoteList.map((e) {
                    return GestureDetector(
                      onTap: () {
                        // Get.toNamed(AppRoute.ebookDetailsScreen);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //   return EbookDetailsScreen();
                        // }));
                      },
                      child: Column(
                        children: [
                          Stack(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Cover Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.h),
                                child: SizedBox(
                                  // width: 382.w,
                                  // height: 497.h,
                                  child: Center(
                                    child: FadeInImage(
                                      image: NetworkImage(e.quoteImageUrl!),
                                      fit: BoxFit.fill,
                                      placeholderFit: BoxFit.fitWidth,
                                      alignment: Alignment.center,
                                      placeholder: const AssetImage(
                                          "assets/icons/default.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            "assets/icons/default.png");
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // alignment: Alignment.bottomRight,
                                bottom: 10.h,
                                left: 10.w,
                                child: InkWell(
                                  onTap: () {
                                    downloadAndShareImage(
                                        e.quoteImageUrl!, context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      "assets/images/home/whatsapp_logo.svg",
                                      height: screenWidth >= 600 ? 30.h : 26.h,
                                      width: screenWidth >= 600 ? 30.h : 26.h,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 24.h,
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
        : const SizedBox();
  }
}
