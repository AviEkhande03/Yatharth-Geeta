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
import '../../controllers/ebooks_listing/ebooks_listing_controller.dart';
import '../../controllers/user_played_list/user_played_list_controller.dart';
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
import '../../widgets/my_played_list/my_played_list_tabs_button.dart';

class MyPlayedListScreen extends StatefulWidget {
  const MyPlayedListScreen({super.key});

  @override
  State<MyPlayedListScreen> createState() => _MyPlayedListScreenState();
}

class _MyPlayedListScreenState extends State<MyPlayedListScreen> {
  final userPlayedListsController = Get.find<UserPlayedListsController>();
  final ebooksListingController = Get.find<EbooksListingController>();

  @override
  void dispose() {
    super.dispose();
    userPlayedListsController.resetMediaPlayedLists();
  }

  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkService>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenSize = MediaQuery.of(context).size;
    return Obx(() => networkService.connectionStatus.value == 0
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
              child: Obx(() => Column(
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
                                        'Played List'.tr,
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

                            SizedBox(
                              height: 64.h,
                              width: screenSize.width,
                              // color: Colors.yellow,
                              child: Row(
                                children: [
                                  MyPlayedListTabsButton(
                                    iconImgUrl:
                                        'assets/images/liked_list/music_unselected.png',
                                    tabButtonTitle: 'Audio'.tr,
                                  ),
                                  MyPlayedListTabsButton(
                                    iconImgUrl:
                                        'assets/images/liked_list/ebook_unselected.png',
                                    tabButtonTitle: 'Books'.tr,
                                  ),
                                  MyPlayedListTabsButton(
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
                                    userPlayedListsController.searchController,
                                fillColor: kColorWhite,
                                filled: true,
                                filterAvailable: true,
                                onChanged: (p0) {
                                  userPlayedListsController
                                      .searchController.text = p0;
                                  debugPrint("searchQuery.valuep0:$p0");
                                },
                                filterBottomSheet: SortFilter(
                                    tabIndex:
                                        userPlayedListsController.tabIndex,
                                    type: userPlayedListsController
                                        .selectedPlaylistTab.value,
                                    onTap: userPlayedListsController
                                        .fetchFilterUserMediaPlayedViewed,
                                    sortList:
                                        userPlayedListsController.sortList),
                                contentPadding: EdgeInsets.all(16.h),
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
                                      userPlayedListsController
                                                      .selectedPlaylistTab
                                                      .value
                                                      .tr ==
                                                  'Audio'.tr &&
                                              userPlayedListsController
                                                      .isLoadingData.value ==
                                                  false
                                          ? userPlayedListsController
                                                  .userMediaAudioPlayedList
                                                  .isNotEmpty
                                              ? ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return userPlayedListsController
                                                            .userMediaAudioPlayedList[
                                                                index]
                                                            .playlistData!
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
                                                                  audioId: userPlayedListsController
                                                                      .userMediaAudioPlayedList[
                                                                          index]
                                                                      .playlistData!
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
                                                                  userPlayedListsController
                                                                      .userMediaAudioPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .title
                                                                      .toString(),
                                                              audioBookAuthor:
                                                                  userPlayedListsController
                                                                      .userMediaAudioPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .authorName
                                                                      .toString(),
                                                              audioBookImgUrl: userPlayedListsController
                                                                  .userMediaAudioPlayedList[
                                                                      index]
                                                                  .playlistData!
                                                                  .first
                                                                  .audioCoverImageUrl
                                                                  .toString(),
                                                              audioBookLanguage:
                                                                  userPlayedListsController
                                                                      .userMediaAudioPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .mediaLanguage
                                                                      .toString(),
                                                              audioBookViews:
                                                                  userPlayedListsController
                                                                      .userMediaAudioPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .viewCount
                                                                      .toString(),
                                                              audioBookDuration:
                                                                  userPlayedListsController
                                                                      .userMediaAudioPlayedList[
                                                                          index]
                                                                      .playlistData!
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
                                                      userPlayedListsController
                                                          .userMediaAudioPlayedList
                                                          .length,
                                                )
                                              : SizedBox(
                                                  height:
                                                      screenSize.height / 1.7,
                                                  child:
                                                      userPlayedListsController
                                                              .isLoadingData
                                                              .value
                                                          ? const SizedBox
                                                              .shrink()
                                                          : NoDataFoundWidget(
                                                              svgImgUrl:
                                                                  "assets/icons/no_audio.svg",
                                                              title:
                                                                  userPlayedListsController
                                                                      .checkItem!
                                                                      .value,
                                                            ),
                                                )
                                          : userPlayedListsController
                                                          .selectedPlaylistTab
                                                          .value
                                                          .tr ==
                                                      'Books'.tr &&
                                                  userPlayedListsController
                                                          .isLoadingData
                                                          .value ==
                                                      false
                                              ? userPlayedListsController
                                                      .userMediaBookPlayedList
                                                      .isNotEmpty
                                                  ? ListView.separated(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return userPlayedListsController
                                                                .userMediaBookPlayedList[
                                                                    index]
                                                                .playlistData!
                                                                .isNotEmpty
                                                            ? GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Utils()
                                                                      .showLoader();

                                                                  //Call Ebooklisting API here
                                                                  Get.find<EbookDetailsController>()
                                                                          .prevRoute
                                                                          .value =
                                                                      Get.currentRoute;
                                                                  await Get.find<EbookDetailsController>().fetchBookDetails(
                                                                      token: '',
                                                                      ctx:
                                                                          context,
                                                                      bookId: userPlayedListsController
                                                                          .userMediaBookPlayedList[
                                                                              index]
                                                                          .playlistData!
                                                                          .first
                                                                          .id);

                                                                  Get.back();

                                                                  if (!Get.find<
                                                                          EbookDetailsController>()
                                                                      .isLoadingData
                                                                      .value) {
                                                                    Get.toNamed(
                                                                        AppRoute
                                                                            .ebookDetailsScreen);
                                                                  }
                                                                },
                                                                child:
                                                                    BookListCardWidget(
                                                                  bookTitle: userPlayedListsController
                                                                      .userMediaBookPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .name
                                                                      .toString(),
                                                                  bookAuthor: userPlayedListsController
                                                                      .userMediaBookPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .artistName
                                                                      .toString(),
                                                                  bookImgUrl: userPlayedListsController
                                                                      .userMediaBookPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .coverImageUrl
                                                                      .toString(),
                                                                  bookLanguage: userPlayedListsController
                                                                      .userMediaBookPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .mediaLanguage
                                                                      .toString(),
                                                                  bookViews: userPlayedListsController
                                                                      .userMediaBookPlayedList[
                                                                          index]
                                                                      .playlistData!
                                                                      .first
                                                                      .viewCount
                                                                      .toString(),
                                                                  bookPages: userPlayedListsController
                                                                      .userMediaBookPlayedList[
                                                                          index]
                                                                      .playlistData!
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
                                                          userPlayedListsController
                                                              .userMediaBookPlayedList
                                                              .length,
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          screenSize.height /
                                                              1.7,
                                                      child:
                                                          userPlayedListsController
                                                                  .isLoadingData
                                                                  .value
                                                              ? const SizedBox
                                                                  .shrink()
                                                              : NoDataFoundWidget(
                                                                  svgImgUrl:
                                                                      "assets/icons/no_ebook.svg",
                                                                  title: userPlayedListsController
                                                                      .checkItem!
                                                                      .value,
                                                                ),
                                                    )
                                              : userPlayedListsController
                                                              .selectedPlaylistTab
                                                              .value
                                                              .tr ==
                                                          'Video'.tr &&
                                                      userPlayedListsController
                                                              .isLoadingData
                                                              .value ==
                                                          false
                                                  ? userPlayedListsController
                                                          .userMediaVideoPlayedList
                                                          .isNotEmpty
                                                      ? ListView.separated(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return userPlayedListsController
                                                                    .userMediaVideoPlayedList[
                                                                        index]
                                                                    .playlistData!
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
                                                                          videoId: userPlayedListsController
                                                                              .userMediaVideoPlayedList[
                                                                                  index]
                                                                              .playlistData!
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
                                                                      videoTitle: userPlayedListsController
                                                                          .userMediaVideoPlayedList[
                                                                              index]
                                                                          .playlistData!
                                                                          .first
                                                                          .title
                                                                          .toString(),
                                                                      videoArtist: userPlayedListsController
                                                                          .userMediaVideoPlayedList[
                                                                              index]
                                                                          .playlistData!
                                                                          .first
                                                                          .artistName
                                                                          .toString(),
                                                                      videoImgUrl: userPlayedListsController
                                                                          .userMediaVideoPlayedList[
                                                                              index]
                                                                          .playlistData!
                                                                          .first
                                                                          .coverImageUrl
                                                                          .toString(),
                                                                      videoLanguage: userPlayedListsController
                                                                          .userMediaVideoPlayedList[
                                                                              index]
                                                                          .playlistData!
                                                                          .first
                                                                          .mediaLanguage
                                                                          .toString(),
                                                                      videoViews: userPlayedListsController
                                                                          .userMediaVideoPlayedList[
                                                                              index]
                                                                          .playlistData!
                                                                          .first
                                                                          .viewCount
                                                                          .toString(),
                                                                      videoDuration: userPlayedListsController
                                                                          .userMediaVideoPlayedList[
                                                                              index]
                                                                          .playlistData!
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
                                                              userPlayedListsController
                                                                  .userMediaVideoPlayedList
                                                                  .length,
                                                        )
                                                      : SizedBox(
                                                          height: screenSize
                                                                  .height /
                                                              1.7,
                                                          child: userPlayedListsController
                                                                  .isLoadingData
                                                                  .value
                                                              ? const SizedBox
                                                                  .shrink()
                                                              : NoDataFoundWidget(
                                                                  svgImgUrl:
                                                                      "assets/icons/no_video.svg",
                                                                  title: userPlayedListsController
                                                                      .checkItem!
                                                                      .value,
                                                                ),
                                                        )
                                                  : const SizedBox(),
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
                  )),
            ),
          ),);
  }
}
