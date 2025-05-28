import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_flutter_downloader/native_flutter_downloader.dart';

import '../../const/colors/colors.dart';
import '../../utils/utils.dart';

//A service class for downloading audios and books and showing progress
class DownloadService extends GetxService {
  RxBool isDownloading = false.obs;
  RxInt progress = 0.obs;
  //A dictionary which stores the download progress as per below structure
  //{taskId:{
  //          bookId/audioId:
  //          progress:
  // }}
  RxMap<String, dynamic> downloadProgress = <String, dynamic>{}.obs;

  //A stream for listening progress
  late StreamSubscription progressStream;

  static DownloadService get to => Get.find();

  @override
  void onInit() {
    _initializeDownloader();
    super.onInit();
  }

  @override
  void onClose() {
    //Cancelling the progressStream
    progressStream.cancel();
    super.onClose();
  }

  Future<void> _initializeDownloader() async {
    //Initializing NativeFlutterDownloader for downloading purpose
    await NativeFlutterDownloader.initialize();

    //Setting listener for listening progress
    progressStream = NativeFlutterDownloader.progressStream.listen((event) {
      //if the download is running then updating the download progress in dictionary and printing the values
      if (event.status == DownloadStatus.running) {
        isDownloading.value = true;
        print("event.progress:${event.progress}");
        downloadProgress[event.downloadId.toString()]['progress'].value =
            event.progress;
        print("event.downloadId.toString(): ${event.downloadId.toString()}");
        print("downloadProgress: $downloadProgress");
      }
      //if the download is successful then removing the key with that particular download task Id
      //also showing the toast
      else if (event.status == DownloadStatus.successful) {
        isDownloading.value = downloadProgress.isNotEmpty;
        downloadProgress.remove(event.downloadId.toString());
        Utils.customToast("Downloaded Successfully...", kGreenPopUpColor,
            kGreenPopUpColor.withOpacity(0.2), "Success");
      }
      //if the download status is failed then too removing that key from the dictionary and showing appropriate toast
      else if (event.status == DownloadStatus.failed) {
        debugPrint('event: ${event.statusReason?.message}');
        debugPrint('Download failed');
        isDownloading.value = downloadProgress.isNotEmpty;
        downloadProgress.remove(event.downloadId.toString());
        Utils.customToast("Downloading Failed...", kRedColor,
            kRedColor.withOpacity(0.2), "Error");
      }
      //if the download status is paused then requesting to attach progress after 250 ms
      else if (event.status == DownloadStatus.paused) {
        debugPrint('Download paused');
        Future.delayed(
          const Duration(milliseconds: 250),
          () =>
              NativeFlutterDownloader.attachDownloadProgress(event.downloadId),
        );
      }
      //if download is cancelled then remove the key from the dictionary
      else if (event.status == DownloadStatus.canceling) {
        debugPrint('event: ${event.statusReason?.message}');
        debugPrint('Download canceling');
        isDownloading.value = downloadProgress.isNotEmpty;
        downloadProgress.remove(event.downloadId.toString());
        //Utils.customToast("Downloading Failed...", kRedColor, kRedColor.withOpacity(0.2), "Error");
      }
      //if download status is pending that is, it is yet to be downloaded then show debug message
      else if (event.status == DownloadStatus.pending) {
        debugPrint('Download pending');
      }
    });
  }

  //method to request the download of an audio or pdf file
  //method takes 4 parameters i.e. url of file to be downloaded,filename i.e. name of file to be downloaded,id of the file to be downloaded,type of the file i.e.audio oe book
  Future<void> requestDownload(
      String url, String fileName, String id, String type) async {
    //Removing punctuation characters from filename as it may cause error leading to no download of file
    final punctuationRegex =
        RegExp(r'[^\p{L}\p{M}\p{N}\p{Z}\p{Sc}_-]', unicode: true);
    fileName = fileName.replaceAll(punctuationRegex, '');

    //Downloading can proceed if the _checkPermission() returns true i.e. permission is granted by user
    if (await _checkPermission()) {
      //If permission check succeeds get the download directory
      final savedDir = await _getDownloadDirectory();
      print(
          "DateTime.now().millisecondsSinceEpoch.toString():${fileName + DateTime.now().millisecondsSinceEpoch.toString()}");

      List<String> keysToRemove = [];

      if (type == 'book') {
        //If the requested download is of type book and already a download task exists which is downloading that book then remove that task

        //iterating through downloadProgress dictionary and checking if it contains 'bookId' key and if that bookId is equal to the id of the entered book then adding it to keysToRemove as there is a new request to download that book
        downloadProgress.forEach((key, value) {
          if (value.containsKey('bookId') && value['bookId'] == id) {
            keysToRemove.add(key);
          }
        });

        //Removing all the keys which are there in keysToRemove from downloadProgress
        keysToRemove.forEach((key) {
          downloadProgress.remove(key);
        });

        print(
            "savedDir:${savedDir + '/' + fileName.replaceAll('/', '-') + ".pdf"}");

        //Starting the download by passing the required parameters
        final taskId = await NativeFlutterDownloader.download(
          url,
          fileName: fileName.replaceAll('/', '-') + ".pdf",
          savedFilePath:
              savedDir, //replacing '/ in filename with '-' as it was considered as nested path in iOS'
        );

        //Once the download task is started,creating a key in downloadProgress with the task id and setting bookId and initial progress
        downloadProgress[taskId.toString()] = {'bookId': id, 'progress': 0.obs};
        print("downloadProgress: $downloadProgress");
      } else {
        //If the requested download is of type audio and already a download task exists which is downloading that audio then remove that task

        //iterating through downloadProgress dictionary and checking if it contains 'audioId' key and if that audioId is equal to the id of the entered book then adding it to keysToRemove as there is a new request to download that audio
        downloadProgress.forEach((key, value) {
          if (value.containsKey('audioId') && value['audioId'] == id) {
            keysToRemove.add(key);
          }
        });

        //Removing all the keys which are there in keysToRemove from downloadProgress
        keysToRemove.forEach((key) {
          downloadProgress.remove(key);
        });

        //Starting the download by passing the required parameters
        final taskId = await NativeFlutterDownloader.download(
          url,
          fileName: fileName.replaceAll('/', '-') + ".mp3",
          savedFilePath: savedDir,
        );
        //Once the download task is started,creating a key in downloadProgress with the task id and setting audioId and initial progress
        downloadProgress[taskId.toString()] = {
          'audioId': id,
          'progress': 0.obs
        };
        print("downloadProgress: $downloadProgress");
      }
    } else {
      // Handle permission denied
    }
  }

  //method to check permission
  Future<bool> _checkPermission() async {
    //if the platform is android then request for permission and return true or false on the basis of whether the permission is granted or not
    if (Platform.isAndroid) {
      final status = await NativeFlutterDownloader.requestPermission();
      return status == StoragePermissionStatus.granted;
    } else {
      return true; // iOS has storage permission by default
    }
  }

  //method to get the downloads directory
  Future<String> _getDownloadDirectory() async {
    //In case of android return the public download directory
    if (Platform.isAndroid) {
      //final directory = await getExternalStorageDirectory();
      print("This came in android");
      return '/storage/emulated/0/Download';
    }
    //In case of iOS return path of documents directory of iOS
    else {
      final directory = await getApplicationSupportDirectory();
      print("directory Path ${directory.path}");
      return directory.path;
    }
  }
}
