import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../models/guruji_details/guruji_details_model.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';

class VideosListGurujiDetails extends StatelessWidget {
  const VideosListGurujiDetails(
      {required this.videosList, super.key, required this.scrollController});
  final ScrollController scrollController;
  final List<TopVideo> videosList;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var controller = Get.find<VideoDetailsController>();
    return videosList != []
        ? SizedBox(
            height: screenWidth >= 600 ? 210.h : 205.h,
            child: ListView.separated(
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Utils().showLoader();
                    await scrollController.animateTo(0,
                        duration: Duration(seconds: 1), curve: Curves.easeIn);
                    //Call Ebooklisting API here
                    await controller.fetchVideoDetails(
                        token: '',
                        ctx: context,
                        videoId: videosList[index].id,
                        isNext: false);

                    Get.back();
                    if (controller.videoDetails.value!.title == null) {}
                    if (!controller.isLoadingData.value) {
                      Get.toNamed(AppRoute.videoDetailsScreen);
                    } else {
                      Utils.customToast("Something went wrong", kRedColor,
                          kRedColor.withOpacity(0.2), "error");
                    }
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: screenWidth >= 600 ? 190.w : 200.w,
                        // color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 210.w,
                              height: 125.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.h),
                                child: FadeInImage(
                                  image: NetworkImage(
                                      videosList[index].coverImageUrl!),
                                  fit: BoxFit.fill,
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
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              videosList[index].title!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: kTextStylePoppinsMedium.copyWith(
                                fontSize: FontSize.mediaTitle.sp,
                                color: kColorFont,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),

                            //Language Tag
                            Row(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 12.w, right: 12.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.h),
                                    color:
                                        kColorFontLangaugeTag.withOpacity(0.05),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${videosList[index].mediaLanguage}',
                                    style: kTextStylePoppinsRegular.copyWith(
                                      fontSize: FontSize.mediaLanguageTags.sp,
                                      color: kColorFontLangaugeTag,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: screenWidth >= 600 ? 68.h : 65.h,
                        right: 8.w,
                        child: Container(
                          height: 32.h,
                          width: 32.h,
                          child:
                              Image.asset('assets/images/home/video_icon.png'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 16.w,
                );
              },
              itemCount: videosList.length,
            ),
          )
        : const SizedBox();
  }
}
