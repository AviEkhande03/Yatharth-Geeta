import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../models/home/ebooks_model.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';

class EbooksListHomeWidget extends StatelessWidget {
  const EbooksListHomeWidget({
    this.ebookslist = const [],
    super.key,
  });

  final List<EbooksModel> ebookslist;

  @override
  Widget build(BuildContext context) {
    final ebooksDetailsController = Get.find<EbookDetailsController>();
    return ebookslist != []
        ? ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  // Get.toNamed(AppRoute.ebookDetailsScreen);
                  Utils().showLoader();

                  //Call Ebooklisting API here
                  await ebooksDetailsController.fetchBookDetails(
                      token: '', ctx: context, bookId: 2);

                  Get.back();

                  if (!ebooksDetailsController.isLoadingData.value) {
                    Get.toNamed(AppRoute.ebookDetailsScreen);
                  } else {
                    Utils.customToast("Something went wrong", kRedColor,
                        kRedColor.withOpacity(0.2), "error");
                  }
                },
                child: Container(
                  // color: Colors.red,
                  child: AspectRatio(
                    aspectRatio: 1.2 / 2.1,
                    // color: Colors.red,
                    // width: 150.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Cover Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.h),
                          child: Container(
                            width: 150.w,
                            child: Image.asset(
                              ebookslist[index].bookCoverImgUrl,
                            ),
                          ),
                        ),

                        //Book Title
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ebookslist[index].title,
                            style: kTextStylePoppinsMedium.copyWith(
                              fontSize: FontSize.mediaTitle.sp,
                              color: kColorFont,
                            ),
                          ),
                        ),

                        //Language Tag
                        Row(
                          children: [
                            Container(
                              // height: 18.h,
                              padding: EdgeInsets.only(left: 12.w, right: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.h),
                                color: kColorFontLangaugeTag.withOpacity(0.05),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    ebookslist[index].langauge,
                                    style: kTextStylePoppinsRegular.copyWith(
                                      fontSize: FontSize.mediaLanguageTags.sp,
                                      color: kColorFontLangaugeTag,
                                    ),
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
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                width: 16.w,
              );
            },
            itemCount: ebookslist.length,
          )
        : const SizedBox();
  }
}
