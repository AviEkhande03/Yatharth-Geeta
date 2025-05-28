import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/user_liked_List/user_liked_list_controller.dart';
import '../../utils/utils.dart';

class LikedListTabsButton extends StatelessWidget {
  LikedListTabsButton({
    this.tabButtonTitle = '',
    this.iconImgUrl = '',
    super.key,
  });

  final String tabButtonTitle;
  final String iconImgUrl;

  final userLikedListsController = Get.find<UserLikedListsController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        userLikedListsController.selectedLikedPlaylistTab.value =
            tabButtonTitle.tr;
        userLikedListsController.searchController.text = "";
        if (userLikedListsController.selectedLikedPlaylistTab.value ==
                'Audio'.tr &&
            userLikedListsController.userMediaAudioLikedList.isEmpty) {
          Utils().showLoader();
          //Call API here
          await userLikedListsController.fetchLikedListingFilter(
            type: Utils()
                .getMediaTypeBasedOnTab(tabMediaTitle: tabButtonTitle.tr),
          );

          Get.back();
        } else if (userLikedListsController.selectedLikedPlaylistTab.value ==
                'Books'.tr &&
            userLikedListsController.userMediaBookLikedList.isEmpty) {
          Utils().showLoader();

          //Call API here
          await userLikedListsController.fetchLikedListingFilter(
            type: Utils()
                .getMediaTypeBasedOnTab(tabMediaTitle: tabButtonTitle.tr),
          );

          Get.back();
        } else if (userLikedListsController.selectedLikedPlaylistTab.value ==
            'Video'.tr) {
          Utils().showLoader();
          //Call API here
          await userLikedListsController.fetchLikedListingFilter(
            type: Utils()
                .getMediaTypeBasedOnTab(tabMediaTitle: tabButtonTitle.tr),
          );
          if (tabButtonTitle == "Audio") {
          } else if (tabButtonTitle == "Video") {
          } else {}
          Get.back();
        }
      },
      child: Stack(
        children: [
          Container(
            width: screenSize.width / 3,
            height: 64.h,
            // color: Colors.pink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: Image.asset(
                    iconImgUrl,
                    color: userLikedListsController
                                .selectedLikedPlaylistTab.value.tr ==
                            tabButtonTitle.tr
                        ? kColorPrimary
                        : kColorFont,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  tabButtonTitle,
                  style: userLikedListsController
                              .selectedLikedPlaylistTab.value.tr ==
                          tabButtonTitle.tr
                      ? kTextStylePoppinsMedium.copyWith(
                          fontSize: FontSize.listingScreenTabsButton.sp,
                          color: kColorPrimary,
                        )
                      : kTextStylePoppinsRegular.copyWith(
                          fontSize: FontSize.listingScreenTabsButton.sp,
                          color: kColorFont,
                        ),
                ),
              ],
            ),
          ),
          userLikedListsController.selectedLikedPlaylistTab.value.tr ==
                  tabButtonTitle.tr
              ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: screenSize.width / 3,
                      child: Image.asset(
                        'assets/images/status_bar.png',
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
