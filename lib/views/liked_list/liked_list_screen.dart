import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../controllers/user_liked_List/user_liked_list_controller.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_search_bar_new.dart';
import '../../widgets/common/no_data_found_widget.dart';
import '../../widgets/common/sort_filter.dart';
import '../../widgets/liked_and_played/audio_list_card_widget.dart';
import '../../widgets/liked_and_played/book_list_card_widget.dart';
import '../../widgets/liked_and_played/video_list_card_widget.dart';
import '../../widgets/liked_lists/liked_list_tabs_button.dart';

class LikedListScreen extends StatefulWidget {
  const LikedListScreen({super.key});

  @override
  State<LikedListScreen> createState() => _LikedListScreenState();
}

class _LikedListScreenState extends State<LikedListScreen> {
  final userLikedListsController = Get.find<UserLikedListsController>();
  final ebooksDetailsController = Get.find<EbookDetailsController>();

  @override
  void dispose() {
    super.dispose();
    userLikedListsController.resetMediaLikedLists();
  }

  // final ebooksListingController = Get.find<EbooksListingController>();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final networkService = Get.find<NetworkService>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Obx(
      () => networkService.connectionStatus.value == 0
          ? Utils().noInternetWidget(screenWidth, screenHeight)
          : Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: kColorWhite,
              bottomNavigationBar: Obx(
                () => Get.find<BottomAppBarServices>().miniplayerVisible.value
                    ? const MiniPlayer()
                    : const SizedBox.shrink(),
              ),
              body: SafeArea(
                child: Obx(
                  () => Column(
                    children: [
                      //App Bar
                      Container(
                        decoration: BoxDecoration(
                          color: kColorWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 15),
                              blurRadius: 20,
                            ),
                          ],
                          border: Border(
                            bottom: BorderSide(
                              color: kColorPrimaryWithOpacity25,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      // color: Colors.red,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        top: 12.h,
                                        bottom: 12.h,
                                      ),
                                      child: Text(
                                        'Liked'.tr,
                                        style:
                                            kTextStyleRosarioRegular.copyWith(
                                          color: kColorFont,
                                          fontSize: FontSize.screenTitle.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 24.w),
                                      height: 24.h,
                                      width: 24.h,
                                      child: SvgPicture.asset(
                                          'assets/icons/back.svg'),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        height: 50.h,
                                        width: 70.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10.h,
                            ),

                            Container(
                              height: 64.h,
                              width: screenSize.width,
                              // color: Colors.yellow,
                              child: Row(
                                children: [
                                  LikedListTabsButton(
                                    iconImgUrl:
                                        'assets/images/liked_list/music_unselected.png',
                                    tabButtonTitle: 'Audio'.tr,
                                  ),
                                  LikedListTabsButton(
                                    iconImgUrl:
                                        'assets/images/liked_list/ebook_unselected.png',
                                    tabButtonTitle: 'Books'.tr,
                                  ),
                                  LikedListTabsButton(
                                    iconImgUrl:
                                        'assets/images/liked_list/video_unselected.png',
                                    tabButtonTitle: 'Video'.tr,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 25.h,
                            ),

                            //Search Bar
                            Container(
                              margin: EdgeInsets.only(left: 25.w, right: 25.w),
                              child: CustomSearchBarNew(
                                controller:
                                    userLikedListsController.searchController,
                                fillColor: kColorWhite,
                                filled: true,
                                filterAvailable: true,
                                onChanged: (p0) {
                                  userLikedListsController
                                      .searchController.text = p0;
                                  debugPrint("searchQuery.valuep0:$p0");
                                },
                                contentPadding: EdgeInsets.all(16.h),
                                filterBottomSheet: SortFilter(
                                    tabIndex: userLikedListsController.tabIndex,
                                    type: userLikedListsController
                                        .selectedLikedPlaylistTab.value,
                                    onTap: userLikedListsController
                                        .fetchLikedListingFilter,
                                    sortList:
                                        userLikedListsController.sortList),
                                hintText: 'Search...'.tr,
                                hintStyle: kTextStylePoppinsRegular.copyWith(
                                  color: kColorFontOpacity25,
                                  fontSize: FontSize.searchBarHint.sp,
                                ),
                              ),
                            ),

                            Container(
                              height: 25.h,
                            ),
                          ],
                        ),
                      ),

                      //Lists goes here
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            color: kColorWhite2,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16.h,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 24.h, bottom: 24.h),
                                  color: kColorWhite,
                                  child: Column(
                                    children: [
                                      userLikedListsController
                                                      .selectedLikedPlaylistTab
                                                      .value
                                                      .tr ==
                                                  'Audio'.tr &&
                                              userLikedListsController
                                                      .isLoadingData.value ==
                                                  false
                                          ? userLikedListsController
                                                  .userMediaAudioLikedList
                                                  .isNotEmpty
                                              ? ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return userLikedListsController
                                                            .userMediaAudioLikedList[
                                                                index]
                                                            .wishlistData!
                                                            .isNotEmpty
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              var detailsController =
                                                                  Get.put(
                                                                      AudioDetailsController());
                                                              Utils()
                                                                  .showLoader();
                                                              detailsController
                                                                      .prevRoute
                                                                      .value =
                                                                  Get.currentRoute;
                                                              await detailsController.fetchAudioDetails(
                                                                  audioId: userLikedListsController
                                                                      .userMediaAudioLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .id,
                                                                  ctx: context,
                                                                  token: '');
                                                              Get.back();
                                                              if (!detailsController
                                                                  .isLoadingData
                                                                  .value) {
                                                                Get.toNamed(AppRoute
                                                                    .audioDetailsScreen);
                                                              }
                                                            },
                                                            child:
                                                                AudioListCardWidget(
                                                              audioBookTitle:
                                                                  userLikedListsController
                                                                      .userMediaAudioLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .title
                                                                      .toString(),
                                                              audioBookAuthor:
                                                                  userLikedListsController
                                                                      .userMediaAudioLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .authorName
                                                                      .toString(),
                                                              audioBookImgUrl: userLikedListsController
                                                                  .userMediaAudioLikedList[
                                                                      index]
                                                                  .wishlistData!
                                                                  .first
                                                                  .audioCoverImageUrl
                                                                  .toString(),
                                                              audioBookLanguage:
                                                                  userLikedListsController
                                                                      .userMediaAudioLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .mediaLanguage
                                                                      .toString(),
                                                              audioBookViews:
                                                                  userLikedListsController
                                                                      .userMediaAudioLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .viewCount
                                                                      .toString(),
                                                              audioBookDuration:
                                                                  userLikedListsController
                                                                      .userMediaAudioLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .durationTime
                                                                      .toString(),
                                                            ),
                                                          )
                                                        : const SizedBox();
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox();
                                                  },
                                                  itemCount:
                                                      userLikedListsController
                                                          .userMediaAudioLikedList
                                                          .length,
                                                )
                                              : SizedBox(
                                                  height:
                                                      screenSize.height / 1.7,
                                                  child:
                                                      userLikedListsController
                                                              .isLoadingData
                                                              .value
                                                          ? const SizedBox
                                                              .shrink()
                                                          : NoDataFoundWidget(
                                                              svgImgUrl:
                                                                  "assets/icons/no_audio.svg",
                                                              title:
                                                                  userLikedListsController
                                                                      .checkItem!
                                                                      .value,
                                                            ),
                                                )
                                          : userLikedListsController
                                                          .selectedLikedPlaylistTab
                                                          .value
                                                          .tr ==
                                                      'Books'.tr &&
                                                  userLikedListsController
                                                          .isLoadingData
                                                          .value ==
                                                      false
                                              ? userLikedListsController
                                                      .userMediaBookLikedList
                                                      .isNotEmpty
                                                  ? ListView.separated(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return userLikedListsController
                                                                .userMediaBookLikedList[
                                                                    index]
                                                                .wishlistData!
                                                                .isNotEmpty
                                                            ? GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Utils()
                                                                      .showLoader();

                                                                  //Call Ebooklisting API here
                                                                  ebooksDetailsController
                                                                          .prevRoute
                                                                          .value =
                                                                      Get.currentRoute;
                                                                  await ebooksDetailsController.fetchBookDetails(
                                                                      token: '',
                                                                      ctx:
                                                                          context,
                                                                      bookId: userLikedListsController
                                                                          .userMediaBookLikedList[
                                                                              index]
                                                                          .wishlistData!
                                                                          .first
                                                                          .id);

                                                                  Get.back();

                                                                  if (!ebooksDetailsController
                                                                      .isLoadingData
                                                                      .value) {
                                                                    Get.toNamed(
                                                                        AppRoute
                                                                            .ebookDetailsScreen);
                                                                  }
                                                                },
                                                                child:
                                                                    BookListCardWidget(
                                                                  bookTitle: userLikedListsController
                                                                      .userMediaBookLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .name
                                                                      .toString(),
                                                                  bookAuthor: userLikedListsController
                                                                      .userMediaBookLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .artistName
                                                                      .toString(),
                                                                  bookImgUrl: userLikedListsController
                                                                      .userMediaBookLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .coverImageUrl
                                                                      .toString(),
                                                                  bookLanguage: userLikedListsController
                                                                      .userMediaBookLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .mediaLanguage
                                                                      .toString(),
                                                                  bookViews: userLikedListsController
                                                                      .userMediaBookLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .viewCount
                                                                      .toString(),
                                                                  bookPages: userLikedListsController
                                                                      .userMediaBookLikedList[
                                                                          index]
                                                                      .wishlistData!
                                                                      .first
                                                                      .pages
                                                                      .toString(),
                                                                ),
                                                              )
                                                            : const SizedBox();
                                                      },
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return const SizedBox();
                                                      },
                                                      itemCount:
                                                          userLikedListsController
                                                              .userMediaBookLikedList
                                                              .length,
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          screenSize.height /
                                                              1.7,
                                                      child:
                                                          userLikedListsController
                                                                  .isLoadingData
                                                                  .value
                                                              ? const SizedBox
                                                                  .shrink()
                                                              : NoDataFoundWidget(
                                                                  svgImgUrl:
                                                                      "assets/icons/no_ebook.svg",
                                                                  title: userLikedListsController
                                                                      .checkItem!
                                                                      .value,
                                                                ),
                                                    )
                                              : userLikedListsController
                                                              .selectedLikedPlaylistTab
                                                              .value
                                                              .tr ==
                                                          'Video'.tr &&
                                                      userLikedListsController
                                                              .isLoadingData
                                                              .value ==
                                                          false
                                                  ? userLikedListsController
                                                          .userMediaVideoLikedList
                                                          .isNotEmpty
                                                      ? ListView.separated(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return userLikedListsController
                                                                    .userMediaVideoLikedList[
                                                                        index]
                                                                    .wishlistData!
                                                                    .isNotEmpty
                                                                ? GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      var detailsController =
                                                                          Get.find<
                                                                              VideoDetailsController>();
                                                                      Utils()
                                                                          .showLoader();
                                                                      detailsController
                                                                          .prevRoute
                                                                          .value = Get.currentRoute;
                                                                      await detailsController.fetchVideoDetails(
                                                                          videoId: userLikedListsController
                                                                              .userMediaVideoLikedList[
                                                                                  index]
                                                                              .wishlistData!
                                                                              .first
                                                                              .id,
                                                                          isNext:
                                                                              false,
                                                                          ctx:
                                                                              context,
                                                                          token:
                                                                              '');
                                                                      Get.back();
                                                                      if (!detailsController
                                                                          .isLoadingData
                                                                          .value) {
                                                                        Get.toNamed(
                                                                            AppRoute.videoDetailsScreen);
                                                                      }
                                                                    },
                                                                    child:
                                                                        VideoListCardWidget(
                                                                      videoTitle: userLikedListsController
                                                                          .userMediaVideoLikedList[
                                                                              index]
                                                                          .wishlistData!
                                                                          .first
                                                                          .title
                                                                          .toString(),
                                                                      videoArtist: userLikedListsController
                                                                          .userMediaVideoLikedList[
                                                                              index]
                                                                          .wishlistData!
                                                                          .first
                                                                          .artistName
                                                                          .toString(),
                                                                      videoImgUrl: userLikedListsController
                                                                          .userMediaVideoLikedList[
                                                                              index]
                                                                          .wishlistData!
                                                                          .first
                                                                          .coverImageUrl
                                                                          .toString(),
                                                                      videoLanguage: userLikedListsController
                                                                          .userMediaVideoLikedList[
                                                                              index]
                                                                          .wishlistData!
                                                                          .first
                                                                          .mediaLanguage
                                                                          .toString(),
                                                                      videoViews: userLikedListsController
                                                                          .userMediaVideoLikedList[
                                                                              index]
                                                                          .wishlistData!
                                                                          .first
                                                                          .viewCount
                                                                          .toString(),
                                                                      videoDuration: userLikedListsController
                                                                          .userMediaVideoLikedList[
                                                                              index]
                                                                          .wishlistData!
                                                                          .first
                                                                          .durationTime
                                                                          .toString(),
                                                                    ),
                                                                  )
                                                                : const SizedBox();
                                                          },
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return const SizedBox();
                                                          },
                                                          itemCount:
                                                              userLikedListsController
                                                                  .userMediaVideoLikedList
                                                                  .length,
                                                        )
                                                      : SizedBox(
                                                          height: screenSize
                                                                  .height /
                                                              1.7,
                                                          child: userLikedListsController
                                                                  .isLoadingData
                                                                  .value
                                                              ? const SizedBox
                                                                  .shrink()
                                                              : NoDataFoundWidget(
                                                                  svgImgUrl:
                                                                      "assets/icons/no_video.svg",
                                                                  title: userLikedListsController
                                                                      .checkItem!
                                                                      .value,
                                                                ),
                                                        )
                                                  : const SizedBox()
                                    ],
                                  ),
                                ),
                                Container(
                                  color: kColorWhite,
                                  height: 24.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),),
    );
  }
}
