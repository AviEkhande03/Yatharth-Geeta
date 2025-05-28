import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:epubx/epubx.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yatharthageeta/services/audio_details/audio_details_service.dart';
import 'package:yatharthageeta/services/firebase/dynamic_link_service.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../models/book_details/book_details_model.dart';
import '../../models/home/ebooks_model.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../services/ebook_details/ebook_details_service.dart';
import '../../utils/utils.dart';

class EbookDetailsController extends GetxController {
  final EbookDetailsService ebookDetailsService = EbookDetailsService();

  final bottomAppService = Get.find<BottomAppBarServices>();

  final String epubUrl2 =
      "http://skyonliners.com/demo/yatharthgeeta/storage/epub_file/536/Yatharth_Geeta-Hindi-Swami_Adgadanand.epub";

  Future<EpubBookRef>? book;
  Future<EpubBook?>? loadedepubBook;

  Rx<Result?> bookDetails = Result().obs;
  RxBool isLoadingData = false.obs;
  RxBool isDataNotFound = false.obs;
  Map<String, String> header = {};
  var prevRoute = "".obs;
  RxString? checkItem = "".obs;

  RxBool wishlistFlag = false.obs;
  RxBool isGuestUser = false.obs;

  bool get wishList => wishlistFlag.value;
  RxInt progress = 0.obs;
  //late StreamSubscription progressStream;
  RxBool isDownloading = false.obs;

  void toggleWishlistFlag(bool newValue) {
    wishlistFlag.value = newValue;
  }

  Future<void> fetchBookDetails({
    String? token,
    BuildContext? ctx,
    required bookId,
  }) async {
    log('bookdetails = $bookDetails');
    isLoadingData.value = true;

    final response = await ebookDetailsService.ebookDetailsApi(
        token: bottomAppService.token.value, bookId: bookId);
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());

        //Show error toast here
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          isLoadingData.value = false;
          print('success is 0');

          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final bookDetailsModel = bookDetailsModelFromJson(response.body);

          bookDetails.value = bookDetailsModel.data!.result;

          wishlistFlag.value = bookDetailsModel.data!.result!.wishList!;

          checkItem!.value = mapdata['message'];

          log('book item message = $checkItem');

          isLoadingData.value = false;
        }
      }
    }
  }

  /*Future<void> downloadBook(
      BuildContext context, String file, String name) async {
    if (isGuestUser.value) {
      Utils.customToast("Please login to download the book", kRedColor,
          kRedColor.withOpacity(0.2), "Error");
      return;
    }
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      print("Not allowed to download");
      await Permission.storage.request();
    }
    isDownloading.value = true;
    final permission =
    await NativeFlutterDownloader.requestPermission();
    if (permission == StoragePermissionStatus.granted) {

      //Only for iOS
      final dir = await getApplicationDocumentsDirectory();
      var _localPath = dir.path + "/Books/";
      final savedDir = Directory(_localPath);

      await NativeFlutterDownloader.download(
          file,
          fileName: name+DateTime.now().millisecondsSinceEpoch.toString()+ ".pdf",
          savedFilePath: Platform.isAndroid?'/storage/emulated/0/Download':savedDir.path
      );
    } else {
      debugPrint('Permission denied =(');
    }
    */ /*if (Platform.isAndroid) {
      var directory = await Directory('/sdcard/Yatharth\ Geeta/Books')
          .create(recursive: true);
      FlutterDownloader.enqueue(
          url: file,
          savedDir: directory.path,
          fileName: name + ".pdf",
          showNotification: true,
          saveInPublicStorage: true,
          openFileFromNotification: true);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      var _localPath = dir.path + "/Books/";
      final savedDir = Directory(_localPath);
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url: file,
          savedDir: savedDir.path,
          showNotification: true,
          fileName: name + ".pdf",
          saveInPublicStorage: true,
          openFileFromNotification: false,
        );
      });
    }*/ /*
  }*/

/*  Future<void> downloadBook(BuildContext context, String file) async {
    if (isGuestUser.value) {
      Utils.customToast("Please login to download the book", kRedColor,
          kRedColor.withOpacity(0.2), "Error");
      return;
    }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      print("Not allowed to download");
      await Permission.manageExternalStorage.request();
    }
    Directory directory;
    if (Platform.isAndroid) {
      directory = await Directory('/sdcard/Yatharth\ Geeta/Books')
          .create(recursive: true);
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    FlutterDownloader.enqueue(
        url: file,
        savedDir: directory.path,
        showNotification: true,
        saveInPublicStorage: Platform.isIOS,
        openFileFromNotification: true);
  }*/

  /*
  * Phase 2 Methods are called here
  * ----------------------------------------------------------------
  */

  Future<void> increaseCount({required String id}) async {
    final response = await AudioDetailsService.increaseCountApi(
        token: bottomAppService.token.value, id: id, master: 'Book');
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(re~sponse.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());
        if (mapdata['success'] == 0) {
          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          log("Count Updated Successfully");
        }
      }
    }
  }

  sharePage() async {
    Utils().showLoader();
    final dynamicLink = DynamicLinkService.instance;
    final link = await dynamicLink.createDynamicLink(
        type: "Book", id: bookDetails.value!.id.toString());

    final shareData =
        "${"Discover the profound wisdom and guidance within the sacred text".tr} *${bookDetails.value!.name.toString()}* ${"only on *Yatharth Geeta* Mobile Application".tr} \n\n ${link.toString()}";
    await Share.share(shareData);
    Get.back();
  }

  /*
  * ----------------------------------------------------------------
  * Phase 2 Methods end here
   */

  Future<void> fetchEbookHomeCollectionDetails({
    String? token,
    required bookId,
    required type,
  }) async {
    log('bookdetails = $bookDetails');
    isLoadingData.value = true;

    final response = await ebookDetailsService.ebookHomeCollectionDetailsApi(
      token: bottomAppService.token.value,
      bookId: bookId,
      type: type,
    );
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());

        //Show error toast here
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());

        if (mapdata['success'] == 0) {
          isLoadingData.value = false;
          print('success is 0');

          // checkItem!.value = mapdata['message'];
          // log('item message = $checkItem');
        } else {
          final bookDetailsModel = bookDetailsModelFromJson(response.body);

          bookDetails.value = bookDetailsModel.data!.result;

          wishlistFlag.value = bookDetailsModel.data!.result!.wishList!;

          checkItem!.value = mapdata['message'];

          log('book item message = $checkItem');

          isLoadingData.value = false;
          increaseCount(id: bookId.toString());
        }
      }
    }
  }

  Future<EpubBook?> loadEpubBookFromServer(String epubUrl) async {
    EpubBook? epubBook;

    try {
      log("epubUrl : $epubUrl");
      final response = await http.get(Uri.parse(epubUrl));
      log("response : $response");
//       log(epubUrl);
//       final response = await http.get(Uri.parse(epubUrl),
//           headers: {'content-type': 'application/epub+zip'});

// >>>>>>> feature-unused-17-1
      // Download the EPUB file from the server
      // log(response.body.toString());
      if (response.statusCode == 200) {
        final epubContent = response.bodyBytes;
        log("epubContent : $epubContent");
        // Load the EPUB book from the downloaded content
        epubBook = await EpubReader.readBook(epubContent);
        log("Loaded successfully");
      } else {
        print('Failed to download EPUB file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading EPUB book: $e');
      Get.back();
      Utils.customToast("Issues reading file", kColorWhite, kRedColor, "Error");
    }

    return epubBook;
  }

  final EbooksModel demoEbook = EbooksModel(
    title: 'Srimad Bhagwad Gita Padhchhed',
    bookCoverImgUrl: 'assets/images/ebook_details/bookcover1.png',
    langauge: 'Hindi',
    author: 'Swami Adganand Maharaj',
    favoriteFlag: 0,
    views: 32000,
    pagesCount: 500,
    desription: Constants.ebookDummyDesc,
    chaptersCount: 18,
    versesCount: 700,
    audioCoverImgUrl: 'assets/images/ebook_details/audio_book_bg1.png',
    videoCoverImgUrl: 'assets/images/ebook_details/video_cover_bg.png',
  );

  clearEbookDetailsData() {
    isLoadingData.value = false;
    isDataNotFound = false.obs;
  }

  @override
  void onInit() async {
    header = await Utils().getHeaders();
    isGuestUser.value = await Utils.isGuestUser();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    isLoadingData.value = false;
    isDataNotFound = false.obs;
    //progressStream.cancel();
  }
}
