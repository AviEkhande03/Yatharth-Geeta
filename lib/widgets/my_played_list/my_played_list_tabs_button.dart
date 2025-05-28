import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/user_played_list/user_played_list_controller.dart';
import '../../utils/utils.dart';

class MyPlayedListTabsButton extends StatelessWidget {
  MyPlayedListTabsButton({
    this.tabButtonTitle = '',
    this.iconImgUrl = '',
    super.key,
  });

  final String tabButtonTitle;
  final String iconImgUrl;

  final userPlayedListController = Get.find<UserPlayedListsController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () async {
          userPlayedListController.selectedPlaylistTab.value =
              tabButtonTitle.tr;
          userPlayedListController.searchController.text = "";

          if (userPlayedListController.selectedPlaylistTab.value ==
                  'Audio'.tr &&
              userPlayedListController.userMediaAudioPlayedList.isEmpty) {
            Utils().showLoader();

            //Call API here
            await userPlayedListController.fetchFilterUserMediaPlayedViewed(
              type: Utils()
                  .getMediaTypeBasedOnTab(tabMediaTitle: tabButtonTitle.tr),
            );

            Get.back();
          } else if (userPlayedListController.selectedPlaylistTab.value ==
                  'Books'.tr &&
              userPlayedListController.userMediaBookPlayedList.isEmpty) {
            Utils().showLoader();

            //Call API here
            await userPlayedListController.fetchFilterUserMediaPlayedViewed(
              type: Utils()
                  .getMediaTypeBasedOnTab(tabMediaTitle: tabButtonTitle.tr),
            );

            Get.back();
          } else if (userPlayedListController.selectedPlaylistTab.value ==
                  'Video'.tr &&
              userPlayedListController.userMediaVideoPlayedList.isEmpty) {
            Utils().showLoader();

            //Call API here
            await userPlayedListController.fetchFilterUserMediaPlayedViewed(
              type: Utils()
                  .getMediaTypeBasedOnTab(tabMediaTitle: tabButtonTitle.tr),
            );

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
                      color: userPlayedListController
                                  .selectedPlaylistTab.value.tr ==
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
                    style:
                        userPlayedListController.selectedPlaylistTab.value.tr ==
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
            userPlayedListController.selectedPlaylistTab.value.tr ==
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
        ));
  }
}
