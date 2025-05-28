import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String bookName;

  const PdfViewerScreen({
    Key? key,
    required this.pdfUrl,
    required this.bookName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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
          child: SfPdfViewerTheme(
            data: SfPdfViewerThemeData(
              backgroundColor: Colors.white,
            ),
            child: SfPdfViewer.network(pdfUrl,
                canShowPaginationDialog: true,
                enableHyperlinkNavigation: true,
                enableDoubleTapZooming: true,
                canShowScrollStatus: false,
                scrollDirection: PdfScrollDirection.horizontal,
                pageLayoutMode: PdfPageLayoutMode.single),
          ),
        ),
        // child: SfPdfViewer.network(
        //   pdfUrl,
        //   canShowPaginationDialog: true,
        // ),
      ),
    );
  }
}
