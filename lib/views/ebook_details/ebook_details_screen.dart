import 'dart:developer';

import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/image.dart' as img;
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/services/download/download_service.dart';
import 'package:yatharthageeta/views/ebook_details/pdf_viewer_new_screen.dart';
import 'package:yatharthageeta/widgets/common/profile_bottom_dialogs.dart';
import 'package:yatharthageeta/widgets/ebook_details/epub_web_view.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_details/audio_details_controller.dart';
import '../../controllers/ebook_details/ebook_details_controller.dart';
import '../../controllers/startup/startup_controller.dart';
import '../../controllers/user_liked_List/user_liked_list_controller.dart';
import '../../controllers/video_details/video_details_controller.dart';
import '../../routes/app_route.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/user_media_liked_create/service/user_media_liked_create_service.dart';
import '../../services/user_media_played_create/service/user_media_played_create_service.dart';
import '../../utils/utils.dart';
import '../../widgets/audio_player/mini_player.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/text_poppins.dart';
import '../../widgets/ebook_details/description_text_widget.dart';
import '../../widgets/home/heading_home_widget.dart';
import 'pdf_viewer_screen.dart';
import 'super_screen.dart';

class EbookDetailsScreen extends StatefulWidget {
  const EbookDetailsScreen({super.key});

  @override
  State<EbookDetailsScreen> createState() => _EbookDetailsScreenState();
}

class _EbookDetailsScreenState extends State<EbookDetailsScreen> {
  // final EbooksModel? ebook;
  final ebookDetailsController = Get.find<EbookDetailsController>();
  final userMediaPlayedCreateServices =
      Get.find<UserMediaPlayedCreateServices>();
  final userMediaLikedCreateServices = Get.find<UserMediaLikedCreateServices>();
  final ebooksDetailsController = Get.find<EbookDetailsController>();
  final downloadService = Get.find<DownloadService>();
  final scrollController = new ScrollController();
  @override
  void dispose() {
    super.dispose();
    ebookDetailsController.clearEbookDetailsData();
    log('Ebooksdetails cleared. Ebookdetails = ${ebookDetailsController.bookDetails}');
  }

  // final String epubUrl2 =
  //     "http://skyonliners.com/demo/yatharthgeeta/storage/epub_file/536/Yatharth_Geeta-Hindi-Swami_Adgadanand.epub";

  Future<EpubBookRef>? book;
  Future<EpubBook?>? loadedepubBook;

  @override
  void initState() {
    super.initState();
    log('Ebooksdetails epubwebviewurl. = ${ebookDetailsController.bookDetails.value!.epubWebviewUrl.toString()}');
    print(
        'Ebooksdetails epubwebviewurl. = ${ebookDetailsController.bookDetails.value!.epubWebviewUrl.toString()}');
    debugPrint(
        'Ebooksdetails epubwebviewurl. = ${ebookDetailsController.bookDetails.value!.epubWebviewUrl.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Obx(
        () => Get.find<BottomAppBarServices>().miniplayerVisible.value
            ? const MiniPlayer()
            : const SizedBox.shrink(),
      ),
      backgroundColor: kColorWhite,
      body: Obx(
        () => SafeArea(
          child: Column(
            children: [
              //App Bar
              CustomAppBar(
                title: 'Books'.tr,
              ),

              //Contents
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    color: kColorWhite2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),

                        //Book Cover
                        Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Container(
                                color: kColorWhite,
                                height: 100.h,
                                width: screenSize.width,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                // color: Colors.pink,
                                height: 200.h,
                                width: screenSize.width - 278.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.h),
                                  child: FadeInImage(
                                    image: NetworkImage(
                                      ebookDetailsController
                                          .bookDetails.value!.coverImageUrl
                                          .toString(),
                                    ),
                                    fit: BoxFit.fill,
                                    placeholderFit: BoxFit.scaleDown,
                                    placeholder: const AssetImage(
                                        "assets/icons/default.png"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return img.Image.asset(
                                          "assets/icons/default.png");
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 216.h,
                              width: screenWidth,
                              // color: Colors.amber.withOpacity(0.3),
                            ),
                            Positioned.fill(
                              // bottom: 0,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 40.h,
                                  width: 40.h,
                                  child: SvgPicture.asset(
                                      'assets/icons/ebook.svg'),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          color: kColorWhite,
                          height: 24.h,
                        ),

                        Container(
                          color: kColorWhite,
                          child: Column(
                            children: [
                              //Book Title
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 25.w, right: 25.w),
                                child: Text(
                                  ebookDetailsController.bookDetails.value!.name
                                      .toString(),
                                  style: kTextStylePoppinsMedium.copyWith(
                                    fontSize:
                                        FontSize.detailsScreenMediaTitle.sp,
                                    color: kColorFont,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),

                              SizedBox(
                                height: 8.h,
                              ),

                              //Author Name
                              Text(
                                "${'by'.tr} ${ebookDetailsController.bookDetails.value!.artistName.toString()}",
                                style: kTextStylePoppinsMedium.copyWith(
                                  fontSize:
                                      FontSize.detailsScreenMediaAuthor.sp,
                                  color: kColorFontOpacity75,
                                ),
                              ),

                              SizedBox(
                                height: 17.h,
                              ),

                              //Details
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: const Color(0xffFEF8F6),
                                    margin: EdgeInsets.only(right: 10.w),
                                    padding: EdgeInsets.only(
                                        left: 12.w,
                                        right: 12.w,
                                        top: 2.h,
                                        bottom: 2.h),
                                    child: TextPoppins(
                                      text: ebookDetailsController
                                          .bookDetails.value!.mediaLanguage
                                          .toString(),
                                      color: kColorPrimary,
                                      fontSize:
                                          FontSize.detailsScreenMediaTags.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SvgPicture.asset("assets/icons/line.svg"),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    margin: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    child: TextPoppins(
                                      text:
                                          "${ebookDetailsController.bookDetails.value!.pages.toString()} ${"pages".tr}",
                                      fontSize:
                                          FontSize.detailsScreenMediaTags.sp,
                                    ),
                                  ),
                                  ebookDetailsController
                                              .bookDetails.value!.viewCount !=
                                          '0'
                                      ? SvgPicture.asset(
                                          "assets/icons/line.svg")
                                      : const SizedBox(),
                                  ebookDetailsController
                                              .bookDetails.value!.viewCount !=
                                          '0'
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          margin: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/eye.svg",
                                                width: 16.w,
                                                color: Colors.black,
                                              ),
                                              TextPoppins(
                                                text:
                                                    " ${ebookDetailsController.bookDetails.value!.viewCount.toString()}",
                                                fontSize: FontSize
                                                    .detailsScreenMediaTags.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),

                              SizedBox(
                                height: 24.h,
                              ),

                              //Read Now, Fav, Download button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Ongoing EPub
                                  // ElevatedButton(
                                  //     onPressed: () {
                                  // // Get.to(const CustomReaderViewScreen(),
                                  // //     arguments: book);
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) {
                                  //   return SuperScreen(
                                  //     book: loadedepubBook!,
                                  //     // refBook: book!,
                                  //   );
                                  // }));
                                  //     },
                                  //     child:
                                  //         const Text("Read Now: From Server")),
                                  InkWell(
                                    onTap: () async {
                                      if (ebookDetailsController
                                              .bookDetails.value!.epubWebviewUrl
                                              .toString() !=
                                          '') {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return WebViewScreen(
                                            epubWebViewUrl:
                                                ebooksDetailsController
                                                    .bookDetails
                                                    .value!
                                                    .epubWebviewUrl
                                                    .toString(),
                                            // bookId: ebookDetailsController
                                            //     .bookDetails.value!.id!,
                                          );
                                        }));
                                      } else if (ebookDetailsController
                                              .bookDetails.value!.epubFileUrl
                                              .toString() !=
                                          '') {
                                        loadedepubBook = ebookDetailsController
                                            .loadEpubBookFromServer(
                                                ebookDetailsController
                                                    .bookDetails
                                                    .value!
                                                    .epubFileUrl
                                                    .toString());
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SuperScreen(
                                            bookTitle: ebookDetailsController
                                                .bookDetails.value!.name
                                                .toString(),
                                            book: loadedepubBook!,
                                            // refBook: book!,
                                          );
                                        }));
                                      } else if (ebookDetailsController
                                              .bookDetails.value!.pdfFileUrl
                                              .toString() !=
                                          '') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              // return PdfViewerScreen(
                                              //   pdfUrl: ebookDetailsController
                                              //       .bookDetails
                                              //       .value!
                                              //       .pdfFileUrl
                                              //       .toString(),
                                              //   bookName: ebookDetailsController
                                              //       .bookDetails.value!.name
                                              //       .toString(),
                                              // );
                                              return PdfViewerNewScreen(
                                                pdfUrl: ebookDetailsController
                                                    .bookDetails
                                                    .value!
                                                    .pdfFileUrl
                                                    .toString(),
                                                bookName: ebookDetailsController
                                                    .bookDetails.value!.name
                                                    .toString(),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        log("Epub and PDF links are missing");
                                      }

                                      if (!ebookDetailsController
                                          .isGuestUser.value) {
                                        await userMediaPlayedCreateServices
                                            .updateUserMediaPlayedCreatelist(
                                          token:
                                              Get.find<BottomAppBarServices>()
                                                  .token
                                                  .value,
                                          mediaType: ebookDetailsController
                                              .bookDetails.value!.selectedType
                                              .toString(),
                                          playedId: ebookDetailsController
                                              .bookDetails.value!.id
                                              .toString(),
                                        );
                                      }
                                      ebookDetailsController.increaseCount(
                                          id: ebookDetailsController
                                              .bookDetails.value!.id
                                              .toString());

                                      log("Media Item Id adedd : ${userMediaPlayedCreateServices.userMediaPlayedCreateDetails.value!.id.toString()}");
                                    },
                                    child: (ebookDetailsController
                                                .bookDetails
                                                .value!
                                                .epubWebviewUrl!
                                                .isEmpty &&
                                            ebookDetailsController.bookDetails
                                                .value!.epubFileUrl!.isEmpty &&
                                            ebookDetailsController.bookDetails
                                                .value!.pdfFileUrl!.isEmpty)
                                        ? const SizedBox()
                                        : Container(
                                            alignment: Alignment.center,
                                            height: 41.h,
                                            decoration: BoxDecoration(
                                              color: kColorPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(200.h),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 36.w),
                                            child: Text(
                                              'Read Now'.tr,
                                              style: kTextStyleInterSemiBold
                                                  .copyWith(
                                                fontSize: FontSize
                                                    .detailsScreenMediaButton
                                                    .sp,
                                                color: kColorWhite,
                                              ),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Obx(
                                    () => GestureDetector(
                                      onTap: () async {
                                        if (Get.find<BottomAppBarServices>()
                                                .token
                                                .value !=
                                            '') {
                                          // Show a loading indicator while the API call is in progress.
                                          ebookDetailsController
                                              .toggleWishlistFlag(
                                                  !ebookDetailsController
                                                      .bookDetails
                                                      .value!
                                                      .wishList!);
                                          setState(() {});

                                          try {
                                            await userMediaLikedCreateServices
                                                .updateUserMediaLikedCreate(
                                              token: Get.find<
                                                      BottomAppBarServices>()
                                                  .token
                                                  .value,
                                              mediaType: ebookDetailsController
                                                  .bookDetails
                                                  .value!
                                                  .selectedType
                                                  .toString(),
                                              likedMediaId:
                                                  ebookDetailsController
                                                      .bookDetails.value!.id
                                                      .toString(),
                                            );

                                            log("Successfully ${ebookDetailsController.bookDetails.value!.wishList! ? "removed from" : "added to"} wishlist");
                                            if (ebookDetailsController
                                                    .prevRoute.value ==
                                                AppRoute.likedListScreen) {
                                              Utils().showLoader();
                                              Get.find<
                                                      UserLikedListsController>()
                                                  .clearMediaLikedLists();
                                              await Get.find<
                                                      UserLikedListsController>()
                                                  .fetchLikedListingFilter(
                                                      type: "Book");
                                              Get.back();
                                            }
                                            // Call Ebooklisting API here to fetch updated details.
                                            await ebooksDetailsController
                                                .fetchBookDetails(
                                                    bookId:
                                                        ebookDetailsController
                                                            .bookDetails
                                                            .value!
                                                            .id);

                                            log("Book details API called");

                                            // After the API call is complete, update the icon.
                                            setState(() {});
                                          } catch (error) {
                                            // Handle error and revert the local state if necessary.
                                            // Remove the loading indicator and update the UI accordingly.
                                            ebookDetailsController
                                                .toggleWishlistFlag(
                                                    !ebookDetailsController
                                                        .bookDetails
                                                        .value!
                                                        .wishList!);
                                            setState(() {});
                                          }
                                        } else {
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              constraints: BoxConstraints(
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width),
                                              builder: (context) {
                                                return ProfileDialog(
                                                  title: 'Login'.tr,
                                                  asssetIcon:
                                                      'assets/icons/login_icon_2.svg',
                                                  contentText:
                                                      'You will need to login to carry out this action. Login?'
                                                          .tr,
                                                  btn1Text:
                                                      'Login'.tr, //Save button
                                                  btn2Text: 'Go back'.tr,
                                                );
                                              });
                                        }
                                        // Get.back();
                                      },
                                      child: SizedBox(
                                        height: 41.h,
                                        width: 41.h,
                                        child: ebookDetailsController
                                                    .wishlistFlag.value ==
                                                false
                                            ? SvgPicture.asset(
                                                'assets/icons/fav_empty.svg',
                                              )
                                            : SvgPicture.asset(
                                                'assets/icons/fav.svg',
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),

                                  //Download button Handled based on the startup download flag
                                  Get.find<StartupController>()
                                                  .startupData
                                                  .first
                                                  .data!
                                                  .result!
                                                  .screens!
                                                  .meData!
                                                  .extraaTabs!
                                                  .bookDownloadIcon! ==
                                              true &&
                                          ebookDetailsController
                                                  .bookDetails.value!.pdfFileUrl
                                                  .toString() !=
                                              ''
                                      ? InkWell(
                                          onTap: () async {
                                            if (Get.find<BottomAppBarServices>()
                                                        .token
                                                        .value ==
                                                    null ||
                                                Get.find<BottomAppBarServices>()
                                                        .token
                                                        .value ==
                                                    '') {
                                              // login_icon_2.svg
                                              showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  constraints: BoxConstraints(
                                                      minWidth:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width),
                                                  builder: (context) {
                                                    return ProfileDialog(
                                                      title: 'Login'.tr,
                                                      asssetIcon:
                                                          'assets/icons/login_icon_2.svg',
                                                      contentText:
                                                          'You will need to login to carry out this action. Login?'
                                                              .tr,
                                                      btn1Text: 'Login'
                                                          .tr, //Save button
                                                      btn2Text: 'Go back'.tr,
                                                    );
                                                  });
                                            } else {
                                              // ebookDetailsController.bookDetails.value!
                                              //             .epubFileUrl
                                              //             .toString() !=
                                              //         ''
                                              //     ? await ebookDetailsController
                                              //         .downloadBook(
                                              //             context,
                                              //             ebookDetailsController
                                              //                 .bookDetails
                                              //                 .value!
                                              //                 .epubFileUrl
                                              //                 .toString(),
                                              //             ebookDetailsController
                                              //                 .bookDetails
                                              //                 .value!
                                              //                 .name!)
                                              //     :

                                              //We only need to download PDF files and not ePUB files

                                              // await ebookDetailsController
                                              //     .downloadBook(
                                              //         context,
                                              //         ebookDetailsController
                                              //             .bookDetails
                                              //             .value!
                                              //             .pdfFileUrl
                                              //             .toString(),
                                              //         ebookDetailsController
                                              //             .bookDetails
                                              //             .value!
                                              //             .name!);

                                              await downloadService.requestDownload(
                                                  ebookDetailsController
                                                      .bookDetails
                                                      .value!
                                                      .pdfFileUrl
                                                      .toString(),
                                                  ebookDetailsController
                                                      .bookDetails.value!.name!,
                                                  ebookDetailsController
                                                      .bookDetails.value!.id!
                                                      .toString(),
                                                  'book');

                                              print(
                                                  "downloadService.downloadProgress.values.where((map) => map.containsKey('bookId') && map['bookId'] == ebookDetailsController.bookDetails.value!.id!.toString()).map((map) => map['progress']).first:${downloadService.downloadProgress.values.where((map) => map.containsKey('bookId') && map['bookId'] == ebookDetailsController.bookDetails.value!.id!.toString()).map((map) => map['progress']).first}");
                                            }
                                          },
                                          child: Container(
                                            height: 41.r,
                                            width: 41.r,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Center(
                                                    child: Container(
                                                      height: downloadService
                                                              .downloadProgress
                                                              .values
                                                              .any((map) =>
                                                                  map['bookId'] ==
                                                                  ebookDetailsController
                                                                      .bookDetails
                                                                      .value!
                                                                      .id!
                                                                      .toString())
                                                          ? 38.r
                                                          : 41.r,
                                                      width: downloadService
                                                              .downloadProgress
                                                              .values
                                                              .any((map) =>
                                                                  map['bookId'] ==
                                                                  ebookDetailsController
                                                                      .bookDetails
                                                                      .value!
                                                                      .id!
                                                                      .toString())
                                                          ? 38.r
                                                          : 41.r,
                                                      child: SvgPicture.asset(
                                                        'assets/icons/download.svg',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                downloadService
                                                        .downloadProgress.values
                                                        .any((map) =>
                                                            map['bookId'] ==
                                                            ebookDetailsController
                                                                .bookDetails
                                                                .value!
                                                                .id!
                                                                .toString())
                                                    ? CircularProgressIndicator(
                                                        value: downloadService
                                                                .downloadProgress
                                                                .values
                                                                .where((map) =>
                                                                    map.containsKey(
                                                                        'bookId') &&
                                                                    map['bookId'] ==
                                                                        ebookDetailsController
                                                                            .bookDetails
                                                                            .value!
                                                                            .id!
                                                                            .toString())
                                                                .map((map) => map[
                                                                    'progress'])
                                                                .first
                                                                .value /
                                                            100,
                                                        strokeWidth: 3.w,
                                                        backgroundColor:
                                                            kColorPrimaryWithOpacity25,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                kColorPrimary),
                                                      )
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        ebookDetailsController.sharePage(),
                                    child: SizedBox(
                                      height: 41.h,
                                      width: 41.h,
                                      child: SvgPicture.asset(
                                        'assets/icons/share.svg',
                                      ),
                                    ),
                                  ),
                                  // : const SizedBox(),
                                ],
                              ),

                              SizedBox(
                                height: 24.h,
                              ),

                              //Description Title
                              Container(
                                margin: EdgeInsets.only(left: 25.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description:".tr,
                                      style: kTextStylePoppinsMedium.copyWith(
                                        fontSize: FontSize
                                            .detailsScreenMediaSubHeadings.sp,
                                        color: kColorBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 8.h,
                              ),

                              //Desciption Content
                              DescriptionTextWidget(
                                description: ebookDetailsController
                                    .bookDetails.value!.description
                                    .toString(),
                              ),

                              //Chapters / Verses count hidden for now
                              // SizedBox(
                              //   height: 24.h,
                              // ),

                              // Container(
                              //   margin: EdgeInsets.only(left: 25.w),
                              //   child: Row(
                              //     children: [
                              //       SizedBox(
                              //         height: 34.h,
                              //         width: 34.h,
                              //         child: SvgPicture.asset(
                              //             'assets/icons/ebook_chapters.svg'),
                              //       ),
                              //       SizedBox(
                              //         width: 16.w,
                              //       ),
                              //       Text(
                              //         "${ebookDetailsController.demoEbook.chaptersCount.toString()} Chapters, ${ebookDetailsController.demoEbook.versesCount.toString()} Verses",
                              //         style: kTextStylePoppinsRegular.copyWith(
                              //           fontSize: FontSize
                              //               .detailsScreenMediaChapters.sp,
                              //           color: kColorFont,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              SizedBox(
                                height: 24.h,
                              ),
                            ],
                          ),
                        ),

                        ebookDetailsController.bookDetails.value!.audio ==
                                    null &&
                                ebookDetailsController
                                        .bookDetails.value!.video ==
                                    null
                            ? const SizedBox()
                            : SizedBox(
                                height: 16.h,
                              ),

                        //Audio And Video Section
                        ebookDetailsController.bookDetails.value!.audio ==
                                    null &&
                                ebookDetailsController
                                        .bookDetails.value!.video ==
                                    null
                            ? const SizedBox()
                            : Container(
                                color: kColorWhite,
                                padding: EdgeInsets.only(
                                    left: 25.w, top: 24.h, bottom: 24.h),
                                // color: Colors.amber,
                                child: Column(
                                  children: [
                                    HeadingHomeWidget(
                                      svgLeadingIconUrl:
                                          'assets/images/home/shiv_symbol.svg',
                                      headingTitle:
                                          'Also available in Audio & Video'.tr,
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),

                                    //Audio Section
                                    ebookDetailsController
                                                .bookDetails.value!.audio !=
                                            null
                                        ? GestureDetector(
                                            onTap: () async {
                                              var detailsController = Get.find<
                                                  AudioDetailsController>();
                                              Utils().showLoader();
                                              detailsController.prevRoute
                                                  .value = Get.currentRoute;
                                              await detailsController
                                                  .fetchAudioDetails(
                                                      audioId:
                                                          ebookDetailsController
                                                              .bookDetails
                                                              .value!
                                                              .audio!
                                                              .id,
                                                      ctx: context,
                                                      token: '');
                                              Get.back();
                                              if (!detailsController
                                                  .isLoadingData.value) {
                                                Get.toNamed(AppRoute
                                                    .audioDetailsScreen);
                                              }
                                            },
                                            child: Container(
                                              // color: Colors.pink,
                                              margin:
                                                  EdgeInsets.only(right: 25.w),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 141.h,
                                                    // color: Colors.pink,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          height: 125.h,
                                                          width: 125.h,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        200.h),
                                                            child: FadeInImage(
                                                              image: NetworkImage(
                                                                  ebookDetailsController
                                                                      .bookDetails
                                                                      .value!
                                                                      .audio!
                                                                      .audioCoverImageUrl
                                                                      .toString()),
                                                              placeholderFit:
                                                                  BoxFit
                                                                      .scaleDown,
                                                              placeholder:
                                                                  const AssetImage(
                                                                      "assets/icons/default.png"),
                                                              imageErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return img.Image
                                                                    .asset(
                                                                        "assets/icons/default.png");
                                                              },
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            // color: Colors.red,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  ebookDetailsController
                                                                      .bookDetails
                                                                      .value!
                                                                      .audio!
                                                                      .title
                                                                      .toString(),
                                                                  style: kTextStylePoppinsMedium
                                                                      .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .detailsScreenSubMediaTitle
                                                                            .sp,
                                                                    color:
                                                                        kColorFont,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.h,
                                                                ),
                                                                Text(
                                                                  "${'by'.tr} ${ebookDetailsController.bookDetails.value!.audio!.authorName.toString()}",
                                                                  style: kTextStylePoppinsRegular
                                                                      .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .detailsScreenSubMediaAuthor
                                                                            .sp,
                                                                    color:
                                                                        kColorBlackWithOpacity75,
                                                                  ),
                                                                ),

                                                                SizedBox(
                                                                  height: 16.h,
                                                                ),

                                                                //Language Tag
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      height: screenWidth >=
                                                                              600
                                                                          ? 20.h
                                                                          : 17.h,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        left: 12
                                                                            .w,
                                                                        right:
                                                                            12.w,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.h),
                                                                        color: kColorFontLangaugeTag
                                                                            .withOpacity(0.05),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        ebookDetailsController
                                                                            .bookDetails
                                                                            .value!
                                                                            .audio!
                                                                            .mediaLanguage
                                                                            .toString(),
                                                                        style: kTextStylePoppinsRegular
                                                                            .copyWith(
                                                                          fontSize: FontSize
                                                                              .detailsScreenSubMediaLangaugeTag
                                                                              .sp,
                                                                          color:
                                                                              kColorFontLangaugeTag,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                //Duration
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top: 8
                                                                              .h),
                                                                  // width: 10,
                                                                  // color: Colors.red,
                                                                  child: Text(
                                                                    ebookDetailsController
                                                                            .bookDetails
                                                                            .value!
                                                                            .audio!
                                                                            .hasEpisodes!
                                                                        ? "${ebookDetailsController.bookDetails.value!.audio!.episodesCount} episodes"
                                                                        : "",
                                                                    style: kTextStylePoppinsLight
                                                                        .copyWith(
                                                                      color:
                                                                          kColorFontOpacity75,
                                                                      fontSize:
                                                                          12.sp,
                                                                    ),
                                                                    // style: kText,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      SizedBox(
                                                        height: 141.h,
                                                        width: 125.h,
                                                        // color: Colors.green.withOpacity(0.4),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: SizedBox(
                                                          // margin: EdgeInsets.only(left: 47.w),
                                                          height: 32.h,
                                                          width: 32.h,
                                                          child: SvgPicture.asset(
                                                              'assets/icons/audio_icon.svg'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ebookDetailsController
                                                              .bookDetails
                                                              .value!
                                                              .audio!
                                                              .viewCount
                                                              .toString() !=
                                                          '0'
                                                      ? Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  // color: Colors.yellow,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              47.w),
                                                                  height: 18.h,
                                                                  width: 18.h,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          'assets/icons/eye_ebookdetail.svg'),
                                                                ),
                                                                SizedBox(
                                                                  width: 8.w,
                                                                ),
                                                                Text(
                                                                  // Utils.formatNumber(
                                                                  //     ebookDetailsController
                                                                  //         .demoEbook.views),
                                                                  ebookDetailsController
                                                                      .bookDetails
                                                                      .value!
                                                                      .audio!
                                                                      .viewCount
                                                                      .toString(),
                                                                  style: kTextStylePoppinsRegular
                                                                      .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .views
                                                                            .sp,
                                                                    color:
                                                                        kColorFontOpacity75,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),

                                    ebookDetailsController
                                                .bookDetails.value!.audio !=
                                            null
                                        ? SizedBox(
                                            height: 16.h,
                                          )
                                        : const SizedBox(),

                                    ebookDetailsController
                                                .bookDetails.value!.video !=
                                            null
                                        ? Container(
                                            margin:
                                                EdgeInsets.only(right: 25.w),
                                            child: Divider(
                                              height: 1,
                                              thickness: 1.h,
                                              color:
                                                  kColorFont.withOpacity(0.10),
                                            ),
                                          )
                                        : const SizedBox(),

                                    ebookDetailsController
                                                .bookDetails.value!.video !=
                                            null
                                        ? SizedBox(
                                            height: 16.h,
                                          )
                                        : const SizedBox(),

                                    //Video Section
                                    ebookDetailsController
                                                .bookDetails.value!.video !=
                                            null
                                        ? GestureDetector(
                                            onTap: () async {
                                              var detailsController = Get.find<
                                                  VideoDetailsController>();
                                              Utils().showLoader();
                                              detailsController.prevRoute
                                                  .value = Get.currentRoute;
                                              await detailsController
                                                  .fetchVideoDetails(
                                                      videoId:
                                                          ebookDetailsController
                                                              .bookDetails
                                                              .value!
                                                              .video!
                                                              .id,
                                                      ctx: context,
                                                      isNext: false,
                                                      token: '');
                                              Get.back();
                                              if (!detailsController
                                                  .isLoadingData.value) {
                                                Get.toNamed(AppRoute
                                                    .videoDetailsScreen);
                                              }
                                            },
                                            child: Container(
                                              color: kColorTransparent,
                                              margin:
                                                  EdgeInsets.only(right: 25.w),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: screenWidth >= 600
                                                        ? 175.h
                                                        : 164.h,
                                                    // color: Colors.pink,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          // color: Colors.green,
                                                          height:
                                                              screenWidth >= 600
                                                                  ? 135.h
                                                                  : 120.h,
                                                          width:
                                                              screenWidth >= 600
                                                                  ? 140.w
                                                                  : 166.w,
                                                          child: FadeInImage(
                                                            image: NetworkImage(
                                                                ebookDetailsController
                                                                    .bookDetails
                                                                    .value!
                                                                    .video!
                                                                    .coverImageUrl
                                                                    .toString()),
                                                            fit: BoxFit.fill,
                                                            placeholderFit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            placeholder:
                                                                const AssetImage(
                                                                    "assets/icons/default.png"),
                                                            imageErrorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return img.Image
                                                                  .asset(
                                                                      "assets/icons/default.png");
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            // color: Colors.red,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  ebookDetailsController
                                                                      .bookDetails
                                                                      .value!
                                                                      .video!
                                                                      .title
                                                                      .toString(),
                                                                  style: kTextStylePoppinsMedium
                                                                      .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .detailsScreenSubMediaTitle
                                                                            .sp,
                                                                    color:
                                                                        kColorFont,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.h,
                                                                ),
                                                                Text(
                                                                  "${'by'.tr} ${ebookDetailsController.bookDetails.value!.video!.artistName.toString()}",
                                                                  style: kTextStylePoppinsRegular
                                                                      .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .detailsScreenSubMediaAuthor
                                                                            .sp,
                                                                    color:
                                                                        kColorBlackWithOpacity75,
                                                                  ),
                                                                ),

                                                                SizedBox(
                                                                  height: 16.h,
                                                                ),

                                                                //Language Tag
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      height: screenWidth >
                                                                              600
                                                                          ? 20.h
                                                                          : 17.h,
                                                                      padding: EdgeInsets.only(
                                                                          left: 12
                                                                              .w,
                                                                          right:
                                                                              12.w),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.h),
                                                                        color: kColorFontLangaugeTag
                                                                            .withOpacity(0.05),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        ebookDetailsController
                                                                            .bookDetails
                                                                            .value!
                                                                            .video!
                                                                            .mediaLanguage
                                                                            .toString(),
                                                                        style: kTextStylePoppinsRegular
                                                                            .copyWith(
                                                                          fontSize: FontSize
                                                                              .detailsScreenSubMediaLangaugeTag
                                                                              .sp,
                                                                          color:
                                                                              kColorFontLangaugeTag,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                //Duration
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top: 8
                                                                              .h),
                                                                  // width: 10,
                                                                  // color: Colors.red,
                                                                  child: Text(
                                                                    ebookDetailsController
                                                                        .bookDetails
                                                                        .value!
                                                                        .video!
                                                                        .durationTime
                                                                        .toString(),
                                                                    style: kTextStylePoppinsLight
                                                                        .copyWith(
                                                                      color:
                                                                          kColorFontOpacity75,
                                                                      fontSize:
                                                                          12.sp,
                                                                    ),
                                                                    // style: kText,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 27.h,
                                                            left: screenWidth >=
                                                                    600
                                                                ? 111.w
                                                                : 127.w),
                                                        height: 32.h,
                                                        width: 32.h,
                                                        child: SvgPicture.asset(
                                                            'assets/icons/video_icon.svg'),
                                                      ),
                                                    ),
                                                  ),
                                                  ebookDetailsController
                                                              .bookDetails
                                                              .value!
                                                              .video!
                                                              .viewCount !=
                                                          '0'
                                                      ? Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  // color: Colors.yellow,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              47.w),
                                                                  height: 18.h,
                                                                  width: 18.h,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          'assets/icons/eye_ebookdetail.svg'),
                                                                ),
                                                                SizedBox(
                                                                  width: 8.w,
                                                                ),
                                                                Text(
                                                                  // Utils.formatNumber(
                                                                  //     ebookDetailsController
                                                                  //         .demoEbook.views),
                                                                  ebookDetailsController
                                                                      .bookDetails
                                                                      .value!
                                                                      .video!
                                                                      .viewCount
                                                                      .toString(),
                                                                  style: kTextStylePoppinsRegular
                                                                      .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .views
                                                                            .sp,
                                                                    color:
                                                                        kColorFontOpacity75,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),

                                    ebookDetailsController
                                                .bookDetails.value!.video !=
                                            null
                                        ? SizedBox(
                                            height: 16.h,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),

                        ebookDetailsController.bookDetails.value!
                                    .peopleAlsoReadData!.isNotEmpty &&
                                ebookDetailsController.bookDetails.value!
                                        .peopleAlsoReadData !=
                                    null
                            ? SizedBox(
                                height: 16.h,
                              )
                            : const SizedBox(),

                        ebookDetailsController.bookDetails.value!
                                    .peopleAlsoReadData!.isNotEmpty &&
                                ebookDetailsController.bookDetails.value!
                                        .peopleAlsoReadData !=
                                    null
                            ? Container(
                                color: kColorWhite,
                                padding:
                                    EdgeInsets.only(top: 24.h, bottom: 24.h),
                                child: Column(
                                  children: [
                                    //Heading
                                    Padding(
                                      padding: EdgeInsets.only(left: 25.h),
                                      child: HeadingHomeWidget(
                                        svgLeadingIconUrl:
                                            'assets/images/home/satiya_symbol.svg',
                                        headingTitle: 'People also read'.tr,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 25.h,
                                    ),

                                    //Books List
                                    Container(
                                      alignment: Alignment.centerLeft,

                                      height:
                                          screenWidth >= 600 ? 320.h : 280.h,
                                      // color: Colors.blue,
                                      // padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                                      margin: EdgeInsets.only(
                                        top: 15.h,
                                        bottom: 15.h,
                                      ),
                                      child: ListView.separated(
                                        padding: EdgeInsets.only(
                                            left: 25.w, right: 25.w),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        // physics: const BouncingScrollPhysics(),

                                        itemCount: ebookDetailsController
                                            .bookDetails
                                            .value!
                                            .peopleAlsoReadData!
                                            .length, // Total number of images
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              // Get.toNamed(AppRoute.ebookDetailsScreen);
                                              Utils().showLoader();
                                              await scrollController.animateTo(
                                                  0,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  curve: Curves.easeIn);
                                              //Call Ebookdetails API here
                                              ebooksDetailsController.prevRoute
                                                  .value = Get.currentRoute;
                                              await ebooksDetailsController
                                                  .fetchBookDetails(
                                                token: '',
                                                ctx: context,
                                                bookId: ebookDetailsController
                                                    .bookDetails
                                                    .value!
                                                    .peopleAlsoReadData![index]
                                                    .id,
                                              );

                                              Get.back();

                                              if (!ebooksDetailsController
                                                  .isLoadingData.value) {
                                                Get.toNamed(AppRoute
                                                    .ebookDetailsScreen);
                                              } else {
                                                Utils.customToast(
                                                    "Something went wrong",
                                                    kRedColor,
                                                    kRedColor.withOpacity(0.2),
                                                    "error");
                                              }
                                            },
                                            child: Container(
                                              // color: Colors.yellow,
                                              child: AspectRatio(
                                                aspectRatio: 1.2 / 2.62,

                                                // aspectRatio: 1 / 2.21, //DIC value: 3
                                                // aspectRatio: 1 / 1.875, //DIC value: 2
                                                // aspectRatio: 1 / 1.875, //DIC value: 1

                                                child: Column(
                                                  children: [
                                                    Container(
                                                      // color: Colors.red,
                                                      child: //Cover Image
                                                          ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.h),
                                                        child: Container(
                                                          width: 150.w,
                                                          height: 170.h,
                                                          child: FadeInImage(
                                                            image: NetworkImage(
                                                                ebookDetailsController
                                                                    .bookDetails
                                                                    .value!
                                                                    .peopleAlsoReadData![
                                                                        index]
                                                                    .coverImageUrl
                                                                    .toString()),
                                                            fit: BoxFit.fill,
                                                            placeholderFit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            placeholder:
                                                                const AssetImage(
                                                                    "assets/icons/default.png"),
                                                            imageErrorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return img.Image
                                                                  .asset(
                                                                      "assets/icons/default.png");
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height: 5.h,
                                                    ),

                                                    //Book Title
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        ebookDetailsController
                                                            .bookDetails
                                                            .value!
                                                            .peopleAlsoReadData![
                                                                index]
                                                            .title
                                                            .toString(),
                                                        style:
                                                            kTextStylePoppinsMedium
                                                                .copyWith(
                                                          fontSize: FontSize
                                                              .mediaTitle.sp,
                                                          color: kColorFont,
                                                        ),
                                                      ),
                                                    ),

                                                    //Language Tag
                                                    Row(
                                                      children: [
                                                        Container(
                                                          // height: 18.h,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.w,
                                                                  right: 12.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.h),
                                                            color:
                                                                kColorFontLangaugeTag
                                                                    .withOpacity(
                                                                        0.05),
                                                          ),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                ebookDetailsController
                                                                    .bookDetails
                                                                    .value!
                                                                    .peopleAlsoReadData![
                                                                        index]
                                                                    .mediaLanguage
                                                                    .toString(),
                                                                style:
                                                                    kTextStylePoppinsRegular
                                                                        .copyWith(
                                                                  fontSize: FontSize
                                                                      .mediaLanguageTags
                                                                      .sp,
                                                                  color:
                                                                      kColorFontLangaugeTag,
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
                                          return SizedBox(
                                            width: 15.w,
                                          );
                                        },
                                      ),
                                    )
                                    // SizedBox(
                                    //   height: screenWidth >= 600 ? 330.h : 246.h,
                                    //   child: EbooksListHomeWidget(
                                    //     ebookslist: EbooksModel.ebooksList1,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        ebookDetailsController.bookDetails.value!
                                    .peopleAlsoReadData!.isNotEmpty &&
                                ebookDetailsController.bookDetails.value!
                                        .peopleAlsoReadData !=
                                    null
                            ? SizedBox(
                                height: 16.h,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
