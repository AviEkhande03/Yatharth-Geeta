import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/utils/utils.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class PdfViewerNewScreen extends StatelessWidget {
  final String pdfUrl;
  final String bookName;

  PdfViewerNewScreen({
    Key? key,
    required this.pdfUrl,
    required this.bookName,
  }) : super(key: key);
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context).size;
    TextEditingController goToController = TextEditingController();
    FocusNode node = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: FutureBuilder<PDFViewController>(
              future: _pdfViewController.future,
              builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // SizedBox(
                      //   width: 25.w,
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.h),
                            color: kColorWhite,
                            border: Border.all(
                              color: Colors.black,
                            )),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(22.w, 22.w),
                          ),
                          child: Transform.rotate(
                            angle: 22 / 14,
                            child: SvgPicture.asset(
                              'assets/icons/arrow-back-book.svg',
                              height: 15.w,
                              width: 15.w,
                              color: kColorFont,
                            ),
                          ),
                          onPressed: () async {
                            final PDFViewController pdfController =
                                snapshot.data!;
                            final int currentPage =
                                (await pdfController.getCurrentPage())! - 1;
                            final int lastPage = await pdfController.getPageCount() ?? 0;
                            if (currentPage >= 0) {
                              await pdfController.setPage(currentPage);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.h),
                            color: kColorWhite,
                            border: Border.all(color: Colors.black)),
                        // color: kColorPrimary,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(22.w, 22.w),
                          ),
                          // heroTag: '+',
                          // child: Icon(
                          //   Icons.arrow_forward,
                          //   size: 25.h,
                          //   color: kColorFont,
                          // ),
                          child: Transform.rotate(
                            angle: 22 / 14,
                            child: SvgPicture.asset(
                              'assets/icons/arrow-forward-book.svg',
                              color: kColorFont,
                              height: 15.w,
                              width: 15.w,
                            ),
                          ),

                          onPressed: () async {
                            final PDFViewController pdfController =
                                snapshot.data!;

                            final int currentPage =
                                (await pdfController.getCurrentPage())! + 1;
                            final int numberOfPages =
                                await pdfController.getPageCount() ?? 0;
                            if (numberOfPages > currentPage) {
                              await pdfController.setPage(currentPage);
                            }
                          },
                        ),
                      ),
                    ],
                  ).paddingOnly(left: 36.w);
                }
                return const SizedBox();
              },
            ),
          ),
          StreamBuilder<String>(
            stream: _pageCountController.stream,
            builder: (_, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return FutureBuilder<PDFViewController>(
                    future: _pdfViewController.future,
                    builder: (_, AsyncSnapshot<PDFViewController> snapshot1) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return FloatingActionButton(
                          splashColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          heroTag: 'page',
                          child: Text(
                            snapshot.data!,
                            style: kTextStylePoppinsMedium.copyWith(
                                fontSize: 12.sp, color: kColorFont),
                          ),
                          onPressed: () {
                            // You can add any functionality you want when the button is pressed
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'Cancel'.tr,
                                        style:
                                            kTextStylePoppinsRegular.copyWith(
                                          fontSize: 14.sp,
                                          color: kColorFont,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final PDFViewController pdfController =
                                            snapshot1.data!;
                                        if (goToController.text == '') {
                                          Get.back();
                                          Utils.customToast(
                                              "Please Enter a page number".tr,
                                              kRedColor,
                                              kRedColor.withOpacity(0.4),
                                              'error');
                                          return;
                                        }
                                        final int currentPage =
                                            int.parse(goToController.text);
                                        final int numberOfPages =
                                            await pdfController
                                                    .getPageCount() ??
                                                0;
                                        if (numberOfPages >= currentPage &&
                                            currentPage > 0) {
                                          node.unfocus();
                                          Get.back();
                                          await pdfController
                                              .setPage(currentPage - 1);
                                        } else {
                                          print("I am here");
                                          Utils.customToast(
                                              "Page Number is Invalid".tr,
                                              kRedColor,
                                              kRedColor.withOpacity(0.4),
                                              'Error');
                                          print("Below toast");
                                          Get.back();
                                        }
                                      },
                                      child: Text(
                                        'OK'.tr,
                                        style:
                                            kTextStylePoppinsRegular.copyWith(
                                          fontSize: 14.sp,
                                          color: kColorPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                  scrollable: true,
                                  content: Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Go To Page Number".tr,
                                          style:
                                              kTextStylePoppinsRegular.copyWith(
                                            fontSize: 16.sp,
                                            color: kColorFont,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: goToController,
                                          focusNode: node,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    });
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _pdfViewController.future,
      //   builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData && snapshot.data != null) {
      //       return Row(
      //         mainAxisSize: MainAxisSize.max,
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: <Widget>[
      //           FloatingActionButton(
      //             heroTag: '-',
      //             child: const Text('-'),
      //             onPressed: () async {
      //               final PDFViewController pdfController = snapshot.data!;
      //               final int currentPage =
      //                   (await pdfController.getCurrentPage())! - 1;
      //               if (currentPage >= 0) {
      //                 await pdfController.setPage(currentPage);
      //               }
      //             },
      //           ),
      //           FloatingActionButton(
      //             heroTag: '+',
      //             child: const Text('+'),
      //             onPressed: () async {
      //               final PDFViewController pdfController = snapshot.data!;
      //               final int currentPage =
      //                   (await pdfController.getCurrentPage())! + 1;
      //               final int numberOfPages =
      //                   await pdfController.getPageCount() ?? 0;
      //               if (numberOfPages > currentPage) {
      //                 await pdfController.setPage(currentPage);
      //               }
      //             },
      //           ),
      //         ],
      //       );
      //     }
      //     return const SizedBox();
      //   },
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          bookName,
          style: kTextStyleRosarioRegular.copyWith(
            color: kColorFont,
            fontSize: FontSize.screenTitle.sp,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 14.w),
                      height: 40.h,
                      width: 40.h,
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        width: width >= 600 ? 35.w : 25.w,
                        height: width >= 600 ? 35.h : 25.h,
                      ),
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
            )),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: kColorPrimary,
              ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: kColorPrimary,
          ),
        ),
        child: Container(
          color: Colors.white,

          child: PDF(
            onPageChanged: (int? currentPage, int? pageCount) {
              // _pageCountController.add('${currentPage! + 1} - $pageCount');
              _pageCountController.add('${currentPage! + 1}');
            },
            swipeHorizontal: false,
            onViewCreated: (PDFViewController pdfViewController) async {
              _pdfViewController.complete(pdfViewController);
              final int currentPage =
                  await pdfViewController.getCurrentPage() ?? 0;
              final int? pageCount = await pdfViewController.getPageCount();
              _pageCountController.add('${currentPage + 1}');
            },
          ).cachedFromUrl(
              placeholder: (double progress) => Center(
                  child: Image.asset('assets/loader/loader_yatharth.gif')),
              pdfUrl),

          // child: SfPdfViewerTheme(
          //   data: SfPdfViewerThemeData(
          //     backgroundColor: Colors.white,
          //   ),
          //   child: SfPdfViewer.network(pdfUrl,
          //       canShowPaginationDialog: true,
          //       enableHyperlinkNavigation: true,
          //       enableDoubleTapZooming: true,
          //       canShowScrollStatus: false,
          //       scrollDirection: PdfScrollDirection.horizontal,
          //       pageLayoutMode: PdfPageLayoutMode.single),
          // ),
        ),
        // child: SfPdfViewer.network(
        //   pdfUrl,
        //   canShowPaginationDialog: true,
        // ),
      ),
    );
  }
}
