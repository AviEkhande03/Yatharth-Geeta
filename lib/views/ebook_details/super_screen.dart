import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../../utils/utils.dart';

class SuperScreen extends StatefulWidget {
  SuperScreen({required this.book, required this.bookTitle, super.key});

  //NOt using refBook as of now
  // Future<EpubBookRef> refBook;
  Future<EpubBook?>? book;
  String? bookTitle;

  @override
  State<SuperScreen> createState() => _SuperScreenState();
}

class _SuperScreenState extends State<SuperScreen> {
  // late Future<PageController> _pageControllerFuture;
  late SharedPreferences _prefs;
  int _lastReadPageIndex = 1;

  double _fontSize = 16.sp;

  Color _selectedBackgroundColor = Colors.white;

  final double _minFontSize = 12.sp;
  final double _maxFontSize = 32.sp;
  double _zoomFactor = 1.0;
  int currentPageIndex = 1;

  bool _isBookmarkVisible = false;

  // Future<PageController> _initializePageController() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _prefs = prefs;

  //   final lastReadPageIndex = await _loadLastReadPageIndex();
  //   final _pageController = PageController(initialPage: lastReadPageIndex);

  //   print("current index vib= ${lastReadPageIndex - 1}");

  //   return _pageController;
  // }

  // _loadLastReadPageIndex() async {
  //   _lastReadPageIndex = _prefs.getInt('lastReadPageIndex') ?? 1;
  //   // setState(() {
  //   currentPageIndex = _lastReadPageIndex;
  //   return currentPageIndex - 1;
  //   // });
  // }

  // Future<void> _saveLastReadPageIndex(int pageIndex) async {
  //   _lastReadPageIndex = pageIndex;
  //   await _prefs.setInt('lastReadPageIndex', pageIndex);
  // }

  @override
  void initState() {
    super.initState();
    // _isBookmarkVisible = false;

    // _pageControllerFuture = _initializePageController();
  }

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: _selectedBackgroundColor == Colors.black
              ? Colors.grey.shade800
              : _selectedBackgroundColor == Colors.grey.shade800
                  ? Colors.black
                  : const Color(0xffE49C28),
          title: FutureBuilder(
            future: widget.book,
            // initialData: InitialData,
            builder: (context, snp) {
              if (snp.hasData) {
                //For Now set from the API data and not from book data itself
                // return Text(
                //   snp.data!.Title!,
                //   style: kTextStyleRosarioRegular.copyWith(
                //     color: kColorFont,
                //     overflow: TextOverflow.ellipsis,
                //     fontSize: 26.sp,
                //   ),
                // );

                return Text(
                  widget.bookTitle.toString(),
                  style: kTextStyleRosarioRegular.copyWith(
                    color: kColorFont,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 26.sp,
                  ),
                );
              } else {
                return Text(widget.bookTitle.toString(),
                    style: kTextStyleRosarioRegular.copyWith(
                      color: kColorFont,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 26.sp,
                    ));
              }
            },
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Icon(
                  Icons.close,
                  size: 25.h,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _selectedBackgroundColor,
        drawer: Drawer(
          backgroundColor: _selectedBackgroundColor == Colors.black
              ? Colors.black
              : _selectedBackgroundColor == Colors.grey.shade800
                  ? Colors.grey.shade800
                  : Colors.white,
          child: FutureBuilder(
              future: widget.book,
              builder: (context, dataSnap) {
                if (dataSnap.hasData) {
                  return FutureBuilder(
                      future: widget.book,
                      builder: (context, bookSnapshot) {
                        if (bookSnapshot.hasData) {
                          return ListView.separated(
                            // itemCount: bookSnapshot.data!.length,
                            itemCount: bookSnapshot.data!.Chapters!.length,

                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: Color(0xffE49C28),
                                height: 1,
                              );
                            },
                            itemBuilder: (context, index) {
                              final chapter =
                                  bookSnapshot.data!.Chapters![index];
                              return ListTile(
                                title: Text(
                                  chapter.Title ?? 'Chapter $index',
                                  style: TextStyle(
                                      color: _selectedBackgroundColor ==
                                              Colors.black
                                          ? Colors.white
                                          : _selectedBackgroundColor ==
                                                  Colors.grey.shade800
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 16.sp),
                                ),
                                onTap: () {
                                  int selectedPageIndex = 0;
                                  for (int i = 0; i < index; i++) {
                                    selectedPageIndex += splitChapterIntoPages(
                                            bookSnapshot.data!.Chapters![i]
                                                    .HtmlContent ??
                                                '',
                                            context,
                                            _zoomFactor)
                                        .length;
                                  }
                                  _pageController.jumpToPage(selectedPageIndex);
                                  setState(() {
                                    currentPageIndex = selectedPageIndex + 1;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      });
                } else {
                  return const SizedBox();
                }
              }),
        ),
        // body: const Center(
        //   child: Text("Book Content Goes here"),
        // ),
        body: FutureBuilder(
            future: widget.book,
            builder: (context, bookMainSnap) {
              if (bookMainSnap.hasData) {
                return Stack(
                  children: [
                    // if (!_isBookmarkVisible)
                    Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            itemCount: getTotalPages(bookMainSnap.data!),
                            controller: _pageController,
                            onPageChanged: (pageIndex) {
                              setState(() {
                                currentPageIndex = pageIndex + 1;
                              });
                              // _saveLastReadPageIndex(currentPageIndex);
                            },
                            itemBuilder: (context, index) {
                              final chapterIndex =
                                  getChapterIndex(index, bookMainSnap.data!);
                              final pageIndex =
                                  getPageIndex(index, bookMainSnap.data!);

                              // var package = bookMainSnap
                              //     .data!.Schema!.Package!.Guide!.Items!
                              //     .toString();

                              // log("package schema: ${bookMainSnap.data!.Schema!.Package!.Guide!.Items!.toString()}");

                              // var allContent =
                              //     bookMainSnap.data!.Content!.Html;
                              // log("HTML content: ${allContent.toString()}");
                              // log("HTML content length: ${allContent!.length.toString()}");
                              final chapter =
                                  bookMainSnap.data!.Chapters![chapterIndex];

                              // log("Chapter: ${bookMainSnap.data!.Chapters![4]}");

                              // log("Chapter content length: ${bookMainSnap.data!.Chapters!.length.toString()}");

                              final pages = splitChapterIntoPages(
                                  chapter.HtmlContent ?? '',
                                  context,
                                  _zoomFactor);

                              if (pageIndex >= pages.length) {
                                return Container();
                              }

                              var pageContent = pages[pageIndex];

                              print('MODIFIED Page Content = $pageContent');

                              final cssContent = concatenateAndCleanCss(
                                  bookMainSnap.data!.Content?.AllFiles?.values,
                                  bookMainSnap.data!);

                              final modifiedHtmlContent =
                                  modifyHtmlWithImagePaths(
                                pageContent,
                                cssContent,
                                bookMainSnap.data!,
                                // widget.imagesDir!,
                              );

                              return SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Html(
                                  data: modifiedHtmlContent,
                                  style: {
                                    "body":
                                        Style(fontSize: FontSize(_fontSize)),
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Center(child: Utils.loaderImage());
              }
            }),
        bottomNavigationBar: FutureBuilder(
          future: widget.book,
          builder: (context, bookMainSnap) {
            if (bookMainSnap.hasData) {
              return (!_isBookmarkVisible)
                  ? Container(
                      height: 50.h,
                      color: _selectedBackgroundColor == Colors.black
                          ? Colors.grey.shade800
                          : _selectedBackgroundColor == Colors.grey.shade800
                              ? Colors.black
                              : Colors.orange,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 1),
                                          curve: Curves.linear,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        size: 25.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 1),
                                          curve: Curves.linear,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        size: 25.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8.w,
                                          right: 8.w,
                                          top: 5.h,
                                          bottom: 5.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.h),
                                          color: Colors.white.withOpacity(0.2)),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _fontSize = (_fontSize - 2.0)
                                                    .clamp(_minFontSize,
                                                        _maxFontSize);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 15.h,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 5.w, right: 5.w),
                                            child: Text(
                                              'Aa',
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _fontSize = (_fontSize + 2.0)
                                                    .clamp(_minFontSize,
                                                        _maxFontSize);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 15.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20.w),
                                      child: Text(
                                        '$currentPageIndex/${getTotalPages(bookMainSnap.data!)}',
                                        style: TextStyle(
                                            color: kColorWhite,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
            } else {
              return Container(
                height: 50.h,
                color: _selectedBackgroundColor == Colors.black
                    ? Colors.grey.shade800
                    : _selectedBackgroundColor == Colors.grey.shade800
                        ? Colors.black
                        : Colors.orange,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // _pageController!.previousPage(
                                  //   duration: const Duration(milliseconds: 1),
                                  //   curve: Curves.linear,
                                  // );
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 25.h,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // _pageController!.nextPage(
                                  //   duration: const Duration(milliseconds: 1),
                                  //   curve: Curves.linear,
                                  // );
                                },
                                icon: Icon(
                                  Icons.arrow_forward,
                                  size: 25.h,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 5.h,
                                    bottom: 5.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.h),
                                    color: Colors.white.withOpacity(0.2)),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // setState(() {
                                        //   _fontSize = (_fontSize - 2.0).clamp(
                                        //       _minFontSize, _maxFontSize);
                                        // });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          size: 15.h,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
                                      child: Text(
                                        'Aa',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // setState(() {
                                        //   _fontSize = (_fontSize + 2.0).clamp(
                                        //       _minFontSize, _maxFontSize);
                                        // });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 15.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                // width: 60.w,
                                margin: EdgeInsets.only(right: 20.w),
                                child: Text(
                                  '- / -',
                                  style: TextStyle(
                                      color: kColorWhite, fontSize: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  int getTotalPages(EpubBook book) {
    int totalPages = 0;
    for (final chapter in book.Chapters ?? []) {
      totalPages +=
          splitChapterIntoPages(chapter.HtmlContent ?? '', context, _zoomFactor)
              .length;
    }
    return totalPages;
  }

  int getChapterIndex(int pageIndex, EpubBook book) {
    int totalChapters = book.Chapters?.length ?? 0;
    int currentPage = 0;
    for (int chapterIndex = 0; chapterIndex < totalChapters; chapterIndex++) {
      final chapter = book.Chapters![chapterIndex];
      final chapterPages =
          splitChapterIntoPages(chapter.HtmlContent ?? '', context, _zoomFactor)
              .length;
      if (currentPage + chapterPages > pageIndex) {
        return chapterIndex;
      }
      currentPage += chapterPages;
    }
    return totalChapters - 1;
  }

  int getPageIndex(int pageIndex, EpubBook book) {
    int totalChapters = book.Chapters?.length ?? 0;
    int currentPage = 0;
    for (int chapterIndex = 0; chapterIndex < totalChapters; chapterIndex++) {
      final chapter = book.Chapters![chapterIndex];
      final chapterPages =
          splitChapterIntoPages(chapter.HtmlContent ?? '', context, _zoomFactor)
              .length;
      if (currentPage + chapterPages > pageIndex) {
        return pageIndex - currentPage;
      }
      currentPage += chapterPages;
    }
    return 0;
  }

  List<String> splitChapterIntoPages(
      String chapterContent, BuildContext context, double zoomFactor) {
    int maxPageLength = getMaxPageLength(context, zoomFactor);
    List<String> pages = [];

    List<String> lines = chapterContent.split('\n');

    String currentPage = '';
    for (String line in lines) {
      // List<String> words = line.split(' ');

      if ('$currentPage ${line.trim()}'.length <= maxPageLength) {
        currentPage = '$currentPage ${line.trim()}';
      } else {
        pages.add(currentPage);

        currentPage = line.trim();
      }
    }
    if (currentPage.isNotEmpty) {
      pages.add(currentPage);
    }

    return pages;
  }

  int getMaxPageLength(BuildContext context, double zoomFactor) {
    double availableHeight = MediaQuery.of(context).size.height - 70;
    int maxLines = (availableHeight / (_fontSize * 1.5 * zoomFactor)).floor();
    double averageCharWidth = 8.0;
    int maxCharsPerLine =
        (MediaQuery.of(context).size.width / averageCharWidth).floor();
    int maxPageLength = maxLines * maxCharsPerLine;
    return maxPageLength;
  }

  concatenateAndCleanCss(contentFiles, EpubBook book) {
    String concatenatedCss = '';

    print('contentFiles = ${contentFiles.length}');
    print('contentFiles2 = ${book.Content?.AllFiles?.values}');

    for (EpubContentFile contentFile in contentFiles) {
      if (contentFile.FileName!.endsWith('.css')) {
        print(contentFile.FileName);
        // log("HINDI book content css ${widget.book.Content!.Css![contentFile.FileName.toString()]!.Content.toString()}");
        concatenatedCss = book
            .Content!.Css![contentFile.FileName.toString()]!.Content
            .toString();
      }
    }

    final cleanedCssContent = concatenatedCss.replaceAllMapped(
      RegExp(
        r':nth-of-type\([^)]+\)',
      ),
      (match) => '',
    );

    return cleanedCssContent;
  }

  String modifyHtmlWithImagePaths(
    String bodyContent,
    String cssContent,
    EpubBook book,
    // Directory imagesDir,
  ) {
    return '''
    <html>
      <head>
        <style>
          $cssContent
        </style>
      </head>
      <body>
        $bodyContent
      </body>
    </html>
  ''';
  }
}
