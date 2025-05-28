import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../models/guruji_details/guruji_details_model.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';

class EbooksListGurujiDetails extends StatelessWidget {
  const EbooksListGurujiDetails(
      {required this.ebookslist, super.key, required this.scrollController});

  final List<TopBook> ebookslist;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ebookslist != []
        ? ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  Utils().showLoader();
                  await scrollController.animateTo(0,
                      duration: Duration(seconds: 1), curve: Curves.easeIn);
                  //Call Ebooklisting API here
                  await Get.find<EbookDetailsController>().fetchBookDetails(
                      token: '', ctx: context, bookId: ebookslist[index].id);

                  Get.back();

                  if (!Get.find<EbookDetailsController>().isLoadingData.value) {
                    Get.toNamed(AppRoute.ebookDetailsScreen);
                  } else {
                    Utils.customToast("Something went wrong", kRedColor,
                        kRedColor.withOpacity(0.2), "error");
                  }
                  //Get.toNamed(AppRoute.ebookDetailsScreen);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return EbookDetailsScreen();
                  // }));
                },
                child: AspectRatio(
                  aspectRatio: 1.2 / 2.2,
                  // color: Colors.red,
                  // width: 150.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Cover Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.h),
                        child: SizedBox(
                          width: 150.w,
                          height: 180.h,
                          child: FadeInImage(
                            image:
                                NetworkImage(ebookslist[index].coverImageUrl!),
                            fit: BoxFit.fitWidth,
                            placeholderFit: BoxFit.scaleDown,
                            placeholder:
                                const AssetImage("assets/icons/default.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/icons/default.png");
                            },
                          ),
                        ),
                      ),

                      //Book Title
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ebookslist[index].name!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
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
                                  ebookslist[index].mediaLanguage!,
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
