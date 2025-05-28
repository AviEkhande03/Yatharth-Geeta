import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:lottie/lottie.dart';
import 'package:yatharthageeta/routes/app_route.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/ebooks_listing/ebooks_listing_controller.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/books_filter.dart';
import '../../widgets/common/custom_search_bar_new.dart';
import '../../widgets/common/no_data_found_widget.dart';
import '../../widgets/ebooks_listing/ebooks_listing_widget.dart';

import '../../services/network/network_service.dart';
import '../../utils/utils.dart';

class EbooksListingScreen extends StatefulWidget {
  const EbooksListingScreen({super.key});

  @override
  State<EbooksListingScreen> createState() => _EbooksListingScreenState();
}

class _EbooksListingScreenState extends State<EbooksListingScreen>
    with TickerProviderStateMixin {
  final ebooksListingController = Get.find<EbooksListingController>();
  late AnimationController _controller;
  @override
  void dispose() {
    ebooksListingController.category.value = "";
    _controller.dispose();
    super.dispose();
    ebooksListingController.clearEbooksList();
    log('Ebookslisting cleared. EbooksListing = ${ebooksListingController.booksListing}');
  }

  @override
  Widget build(BuildContext context) {
    // String? viewAllListingBookTitle = Get.arguments["viewAllListingBookTitle"];

    final networkService = Get.find<NetworkService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    _controller = AnimationController(
      duration: const Duration(seconds: (2)),
      vsync: this,
    );
    return Obx(
      () => networkService.connectionStatus.value == 0
          ? Utils().noInternetWidget(screenWidth, screenHeight)
          : Scaffold(
              resizeToAvoidBottomInset: true,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: GestureDetector(
                onTap: () => Get.toNamed(AppRoute.filterScreen, arguments: {
                  'screen': 'book',
                  'language': ebooksListingController.languageList,
                  'authors': ebooksListingController.authorsList,
                  'sortList': ebooksListingController.sortList,
                  'typeList': ebooksListingController.typeList,
                  'onTap': ebooksListingController.prevScreen.value ==
                          "homeCollectionMultipleType"
                      ? ebooksListingController.fetchBooksHomeMultipleListing
                      : ebooksListingController.prevScreen.value == "collection"
                          ? ebooksListingController
                              .fetchBooksExploreViewAllListing
                          : ebooksListingController.prevScreen.value ==
                                  "homeCollection"
                              ? ebooksListingController
                                  .fetchBooksHomeViewAllListing
                              : ebooksListingController.fetchBooksListing,
                }),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: kColorWhite,
                      border: Border.all(color: kColorPrimary)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/filters.svg",
                        color: kColorPrimary,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        "Filters".tr,
                        style: kTextStylePoppinsRegular.copyWith(
                          color: kColorPrimary,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Obx(
                () => Get.find<BottomAppBarServices>().miniplayerVisible.value
                    ? const MiniPlayer()
                    : const SizedBox.shrink(),
              ),
              backgroundColor: kColorWhite,
              body: SafeArea(
                child: Column(
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
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      top: 12.h,
                                      // bottom: 12.h,
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 310.w,
                                      child: Text(
                                        ebooksListingController
                                                    .viewAllListingBookTitle
                                                    .value ==
                                                ''
                                            ? 'Books'.tr
                                            : ebooksListingController
                                                        .booksApiCallType
                                                        .value ==
                                                    'fetchBooksListing'
                                                ? 'Books'.tr
                                                : ebooksListingController
                                                    .viewAllListingBookTitle
                                                    .value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            kTextStyleRosarioRegular.copyWith(
                                          color: kColorFont,
                                          fontSize: FontSize.screenTitle.sp,
                                        ),
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
                                      ebooksListingController.category.value =
                                          "";
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
                            height: 28.h,
                          ),

                          //Search Bar
                          Container(
                            margin: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: CustomSearchBarNew(
                              controller:
                                  ebooksListingController.searchController,
                              fillColor: kColorWhite,
                              filled: true,
                              filterAvailable: false,
                              onChanged: (p0) {
                                // if(p0.isNotEmpty){
                                //   ebooksListingController.controllerText.value = p0;
                                // }
                                ebooksListingController.searchController.text =
                                    p0;
                                debugPrint("searchQuery.valuep0:$p0");
                              },
                              contentPadding: EdgeInsets.all(16.h),
                              // filterBottomSheet: BooksFilter(
                              //   tabIndex: ebooksListingController.tabIndex,
                              //   languages: ebooksListingController.languageList,
                              //   authors: ebooksListingController.authorsList,
                              //   sortList: ebooksListingController.sortList,
                              //   typeList: ebooksListingController.typeList,
                              //   onTap: ebooksListingController
                              //               .prevScreen.value ==
                              //           "homeCollectionMultipleType"
                              //       ? ebooksListingController
                              //           .fetchBooksHomeMultipleListing
                              //       : ebooksListingController
                              //                   .prevScreen.value ==
                              //               "collection"
                              //           ? ebooksListingController
                              //               .fetchBooksExploreViewAllListing
                              //           : ebooksListingController
                              //                       .prevScreen.value ==
                              //                   "homeCollection"
                              //               ? ebooksListingController
                              //                   .fetchBooksHomeViewAllListing
                              //               : ebooksListingController
                              //                   .fetchBooksListing,
                              //   // onTap:
                              //   // ebooksListingController.prevScreen.value !=
                              //   //         "collection"
                              //   // ? ebooksListingController
                              //   //     .fetchBookListingFilter
                              //   // : ebooksListingController
                              //   //     .fetchBookViewAllFilter,
                              // ),
                              hintText: 'Search...'.tr,
                              hintStyle: kTextStylePoppinsRegular.copyWith(
                                color: kColorFontOpacity25,
                                fontSize: 18.sp,
                              ),
                              labelStyle: kTextStylePoppinsRegular.copyWith(
                                color: kColorFontOpacity25,
                                fontSize: 18.sp,
                              ),
                              style: kTextStylePoppinsRegular.copyWith(
                                // color: kColorFontOpacity25,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),

                          Container(
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),

                    //Ebooks List
                    Obx(
                      () => Expanded(
                          child: ebooksListingController.booksListing.isNotEmpty
                              ? LazyLoadScrollView(
                                  isLoading: ebooksListingController
                                                  .booksApiCallType.value ==
                                              'fetchBooksListing' ||
                                          ebooksListingController
                                                  .booksApiCallType.value ==
                                              'fetchBooksHomeViewAllListing' ||
                                          ebooksListingController
                                                  .booksApiCallType.value ==
                                              "fetchBooksHomeMultipleListing" ||
                                          ebooksListingController
                                                  .booksApiCallType.value ==
                                              "fetchBooksHomeFilterListing" ||
                                          ebooksListingController
                                                  .booksApiCallType.value ==
                                              'fetchBooksExploreViewAllListing'
                                      ? ebooksListingController
                                          .isLoadingData.value
                                      : false,
                                  onEndOfPage: () async {
                                    log("Comes here " +
                                        ebooksListingController
                                            .booksApiCallType.value);
                                    if (ebooksListingController
                                            .booksApiCallType.value ==
                                        'fetchBooksListing') {
                                      if (ebooksListingController
                                                  .checkRefresh.value ==
                                              false &&
                                          ebooksListingController
                                                  .booksListing.length
                                                  .toString() !=
                                              ebooksListingController
                                                  .totalBooks.value
                                                  .toString()) {
                                        await ebooksListingController
                                            .fetchBooksListing();
                                      } else {
                                        log(
                                          "No more Items to Load. booklist : ${ebooksListingController.booksListing.length.toString()} totalcollectionlength: ${ebooksListingController.totalBooks.value.toString()}",
                                        );
                                      }
                                    } else if (ebooksListingController
                                            .booksApiCallType.value ==
                                        'fetchBooksHomeViewAllListing') {
                                      if (ebooksListingController
                                                  .checkRefresh.value ==
                                              false &&
                                          ebooksListingController
                                                  .booksListing.length
                                                  .toString() !=
                                              ebooksListingController
                                                  .totalBooks.value
                                                  .toString()) {
                                        await ebooksListingController
                                            .fetchBooksHomeViewAllListing(
                                                // collectionBookId:
                                                //     ebooksListingController
                                                //         .collectionId.value,
                                                );
                                      } else {
                                        log(
                                          "No more Items to Load. booklist : ${ebooksListingController.booksListing.length.toString()} totalcollectionlength: ${ebooksListingController.totalBooks.value.toString()}",
                                        );
                                      }
                                    } else if (ebooksListingController
                                            .booksApiCallType.value ==
                                        'fetchBooksHomeMultipleListing') {
                                      if (ebooksListingController
                                                  .checkRefresh.value ==
                                              false &&
                                          ebooksListingController
                                                  .booksListing.length
                                                  .toString() !=
                                              ebooksListingController
                                                  .totalBooks.value
                                                  .toString()) {
                                        await ebooksListingController
                                            .fetchBooksHomeMultipleListing(
                                                // id: ebooksListingController
                                                //     .collectionId.value,
                                                // type: ebooksListingController
                                                //     .collectionType.value,
                                                );
                                      } else {
                                        log(
                                          "No more Items to Load. booklist : ${ebooksListingController.booksListing.length.toString()} totalcollectionlength: ${ebooksListingController.totalBooks.value.toString()}",
                                        );
                                      }
                                    } else if (ebooksListingController
                                            .booksApiCallType.value ==
                                        'fetchBooksHomeFilterListing') {
                                      if (ebooksListingController
                                                  .checkRefresh.value ==
                                              false &&
                                          ebooksListingController
                                                  .booksListing.length
                                                  .toString() !=
                                              ebooksListingController
                                                  .totalBooks.value
                                                  .toString()) {
                                        log("Filter Body:${ebooksListingController.returnFilter()}");
                                        await ebooksListingController
                                            .fetchBooksListing(
                                                body: ebooksListingController
                                                    .returnFilter());
                                      } else {
                                        log("Api call is not fetchBooksListing or fetchBooksHomeViewAllListing");
                                      }
                                    } else if (ebooksListingController
                                            .booksApiCallType.value ==
                                        'fetchBooksExploreViewAllListing') {
                                      log("Atleast yaha aata?");
                                      if (ebooksListingController
                                                  .checkRefresh.value ==
                                              false &&
                                          ebooksListingController
                                                  .booksListing.length
                                                  .toString() !=
                                              ebooksListingController
                                                  .totalBooks.value
                                                  .toString()) {
                                        log("Yeh bhi true h");
                                        await ebooksListingController
                                            .fetchBooksExploreViewAllListing(
                                                // collectionBookId:
                                                //     ebooksListingController
                                                //         .collectionId.value,
                                                );
                                      } else {
                                        log(
                                          "No more Items to Load. booklist : ${ebooksListingController.booksListing.length.toString()} totalcollectionlength: ${ebooksListingController.totalBooks.value.toString()}",
                                        );
                                      }
                                    }
                                  },
                                  child: SingleChildScrollView(
                                    child: Container(
                                      color: kColorWhite2,
                                      child: Column(
                                        children: [
                                          //To check which api call is made
                                          //  Text(ebooksListingController
                                          //     .booksApiCallType
                                          //     .toString()),
                                          SizedBox(
                                            height: 16.h,
                                          ),

                                          //EBooks Listing Widget
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 24.h, bottom: 24.h),
                                            color: kColorWhite,
                                            child: EbooksListingWidget(
                                              ebooksList:
                                                  ebooksListingController
                                                      .booksListing,
                                            ),
                                          ),

                                          ebooksListingController.booksApiCallType
                                                          .value ==
                                                      'fetchBooksListing' ||
                                                  ebooksListingController
                                                          .booksApiCallType.value ==
                                                      'fetchBooksHomeViewAllListing' ||
                                                  ebooksListingController
                                                          .booksApiCallType.value ==
                                                      "fetchBooksHomeMultipleListing" ||
                                                  ebooksListingController
                                                          .booksApiCallType
                                                          .value ==
                                                      "fetchBooksHomeFilterListing" ||
                                                  ebooksListingController
                                                          .booksApiCallType
                                                          .value ==
                                                      'fetchBooksExploreViewAllListing'
                                              ? ebooksListingController
                                                      .isNoDataLoading.value
                                                  ? const SizedBox()
                                                  : ebooksListingController
                                                          .isLoadingData.value
                                                      ? Utils()
                                                          .showPaginationLoader(
                                                              _controller)
                                                      : const SizedBox()
                                              : const SizedBox(),
                                          Container(
                                            color: kColorWhite,
                                            height: 80.h,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              :
                              // !ebooksListingController.isSearching.value?
                              ebooksListingController.isLoadingData.value
                                  ? const SizedBox.shrink()
                                  : NoDataFoundWidget(
                                      svgImgUrl: "assets/icons/no_ebook.svg",
                                      title: ebooksListingController
                                          .checkItem!.value,
                                    )
                          // :const SizedBox.shrink(),
                          // : Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       SvgPicture.asset("assets/icons/no_ebook.svg"),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           SvgPicture.asset(
                          //               "assets/icons/swastik.svg"),
                          //           Text(
                          //             "No Books Available",
                          //             style: kTextStyleNotoRegular.copyWith(
                          //                 fontWeight: FontWeight.w500,
                          //                 fontSize: 20.sp),
                          //           ),
                          //           SvgPicture.asset(
                          //               "assets/icons/swastik.svg"),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
