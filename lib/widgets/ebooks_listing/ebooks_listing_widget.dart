import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../models/books_listing/books_listing_model.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';

class EbooksListingWidget extends StatelessWidget {
  const EbooksListingWidget({
    this.ebooksList = const [],
    super.key,
  });

  final List<Result> ebooksList;

  @override
  Widget build(BuildContext context) {
    // final ebooksDetailsController = Get.put(EbookDetailsController());
    final ebooksDetailsController = Get.find<EbookDetailsController>();

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              // Get.toNamed(AppRoute.ebookDetailsScreen);
              Utils().showLoader();

              //Call Ebooklisting API here
              ebooksDetailsController.prevRoute.value = Get.currentRoute;
              await ebooksDetailsController.fetchBookDetails(
                  token: '', ctx: context, bookId: ebooksList[index].id);

              Get.back();

              if (!ebooksDetailsController.isLoadingData.value) {
                Get.toNamed(AppRoute.ebookDetailsScreen);
              } else {
                Utils.customToast("Something went wrong", kRedColor,
                    kRedColor.withOpacity(0.2), "error");
              }
            },
            child: Container(
              color: kColorTransparent,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    // color: Colors.grey,
                    width: screenSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              // color: Colors.red,
                              height: screenWidth >= 600 ? 206.h : 150.h,
                              width: 110.w,
                              child: FadeInImage(
                                image: NetworkImage(
                                    ebooksList[index].coverImageUrl!),
                                placeholderFit: BoxFit.scaleDown,
                                placeholder: const AssetImage(
                                    "assets/icons/default.png"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/icons/default.png");
                                },
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Container(
                              height: screenWidth >= 600 ? 222.h : 166.h,
                              // width: 100.w,
                              color: kColorTransparent,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: SizedBox(
                                height: 32.h,
                                width: 32.h,
                                child: SvgPicture.asset(
                                  'assets/icons/ebook_icon.svg',
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: screenWidth >= 600 ? 232.h : 166.h,
                            // color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ebooksList[index].name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize:
                                            FontSize.listingScreenMediaTitle.sp,
                                        color: kColorFont,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      '${'by'.tr} ${ebooksList[index].artistName!}',
                                      style: kTextStylePoppinsRegular.copyWith(
                                        fontSize: FontSize
                                            .listingScreenMediaAuthorTitle.sp,
                                        color: kColorFontOpacity75,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    //Language Tag
                                    Row(
                                      children: [
                                        Container(
                                          // height: 24.h,
                                          padding: EdgeInsets.only(
                                              left: 12.w, right: 12.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.h),
                                            color: kColorFontLangaugeTag
                                                .withOpacity(0.05),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            ebooksList[index].mediaLanguage!,
                                            style: kTextStylePoppinsRegular
                                                .copyWith(
                                              fontSize: FontSize
                                                  .listingScreenMediaLanguageTag
                                                  .sp,
                                              color: kColorFontLangaugeTag,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 8.h,
                                    ),

                                    Text(
                                      '${ebooksList[index].pages!.toString()} ${"pages".tr}',
                                      style: kTextStylePoppinsLight.copyWith(
                                        fontSize: FontSize
                                            .listingScreenMediaContentCount.sp,
                                        color: kColorBlackWithOpacity75,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Visibility(
                                      visible:
                                          ebooksList[index].viewCount! != '0',
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                // color: Colors.yellow,
                                                margin:
                                                    EdgeInsets.only(left: 47.w),
                                                height: 18.h,
                                                width: 18.h,
                                                child: SvgPicture.asset(
                                                    'assets/icons/eye_ebookdetail.svg'),
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                // '32k',
                                                // Utils.formatNumber(int.parse(
                                                //     ebooksList[index]
                                                //         .viewCount!)),
                                                ebooksList[index].viewCount!,
                                                style: kTextStylePoppinsRegular
                                                    .copyWith(
                                                  fontSize: FontSize.views.sp,
                                                  color: kColorFontOpacity75,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
            child: Divider(
              height: 1.h,
              color: kColorFont.withOpacity(0.10),
              thickness: 1.h,
            ),
          );
        },
        itemCount: ebooksList.length));
  }
}
