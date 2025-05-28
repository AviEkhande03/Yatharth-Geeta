import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:yatharthageeta/const/header/headers.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';
import 'package:yatharthageeta/controllers/startup/startup_controller.dart';
import 'package:yatharthageeta/models/shlokas/shloka_chapter_model.dart';
import 'package:yatharthageeta/models/shlokas/shlokas_listing_model.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import '../home/home_controller.dart';
import 'package:yatharthageeta/models/shlokas/shlokas_chapters_list_model.dart'
    as shlokaschapterslist;
import 'package:yatharthageeta/models/shlokas/shlokas_listing_model.dart'
    as shlokaslisting;
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';
import 'package:yatharthageeta/services/shlokas/shlokas_chapters_list_service.dart';
import 'package:yatharthageeta/services/shlokas/shlokas_listing_service.dart';
import 'package:yatharthageeta/utils/utils.dart';

class ShlokasListingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /*
*   Phase 2
*   --------------------------------
*   Can't understand any of the variable, tho gonna create variables to store chapter list and verses list
*/
// initializing chapters model and lisiting model
  Rx<ShlokaChapterModel> shlokaChapterModel = ShlokaChapterModel().obs;
  Rx<ShlokasListingModel> shlokaListingModel = ShlokasListingModel().obs;
  // initializing chapter list and verse list
  List<Map> chaptersList = [];
  RxList<Map> verseList = <Map>[].obs;
  // setting initial chapter and verse to 1
  var chapGroupValue = "1".obs;
  var verseGroupValue = "1".obs;

  /*
  *  Phase 2 variables end here
  */

  final ShlokasChaptersListService shlokasChaptersListService =
      ShlokasChaptersListService();

  final ShlokasListingService shlokasListingService = ShlokasListingService();

  var controller = Get.isRegistered<PlayerController>()
      ? Get.find<PlayerController>()
      : Get.put(PlayerController());
  final bottomAppBarServices = Get.find<BottomAppBarServices>();
  final startupService = Get.find<StartupController>();

  //var searchController = TextEditingController();

  RxList shlokasChaptersList = <Map<String, String>>[].obs;
  RxList<shlokaschapterslist.Result>? shlokasChaptersListResult =
      <shlokaschapterslist.Result>[].obs;

  RxList<shlokaslisting.Result> shlokasListing = <shlokaslisting.Result>[].obs;
  RxInt totalShlokas = 0.obs;

  RxString selectedChapter = '1'.obs;
  RxString selectedLanguage = '2'.obs;

  RxBool isLoadingShlokasChaptersListData = false.obs;
  RxBool isLoadingShlokasListingData = false.obs;

  RxBool isChaptersListDataNotFound = false.obs;
  RxBool isShlokasListDataNotFound = false.obs;

  RxInt totalShlokasChapters = 0.obs;

  RxString? checkShlokaItem = "".obs;
  RxString? checkChapterItem = "".obs;
  var searchQuery = "".obs;
  // Pagination
  RxInt pageNo = 1.obs;
  final limit = 3;
  RxBool isNoDataLoading = false.obs;
  final scrollController = new ScrollController();

//Static States
  List<Map> languageList = [];

  late TabController tabController;

  var tabIndex = 0.obs;
  var hindi = true.obs;
  var english = false.obs;
  var kannada = false.obs;
  var tamil = false.obs;
  var telugu = false.obs;
  var groupValue = "English".obs;
  var groupValueId = 1.obs;
  TextEditingController searchController = TextEditingController();
  RxString controllerText = "".obs;

  final networkService = Get.find<NetworkService>();

  @override
  void onClose() async {
    if (!Get.find<BottomAppBarServices>().miniplayerVisible.value) {
      await controller.audioPlayer.value.stop();
    }
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    // fetchShlokasList(1);
    tabController = TabController(length: 3, vsync: this);
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        controllerText.value = searchController.text;
      }
    });

    debounce(controllerText, (callback) async {
      // if (searchQuery.isEmpty) {
      //   return;
      // }
      debugPrint(
          "chapter_number:${selectedChapter.value},language_id:${groupValueId.value.toString()},query: ${searchQuery.value}");
      debugPrint(
          "bottomAppBarService.isCustomSearchBarNewDisposed.value:${bottomAppBarServices.isCustomSearchBarNewDisposed.value}");
      if (bottomAppBarServices.isCustomSearchBarNewDisposed.value == false) {
        Utils().showLoader();
        clearShlokasListsData();
        await fetchShlokasListing(
          chapterNumber: selectedChapter.value,
          langaugeId: groupValueId.value.toString(),
          token: Get.find<BottomAppBarServices>().token.value,
          body: {
            "chapter_number": selectedChapter.value,
            "language_id": groupValueId.value.toString(),
            "query": searchController.text
          },
        );
        Get.back();
      }
    }, time: const Duration(seconds: 2));
    // initializeFilter();
  }

  // initializing filter as a map for easy access and display
  void initializeFilter() {
    var homeController = Get.find<HomeController>();
    languageList = homeController.shloklanguageModel!.data!.result == null
        ? []
        : homeController.shloklanguageModel!.data!.result!
            .map((e) => {
                  "title": e.name,
                  "value": e.name.obs,
                  "id": e.id,
                  "groupValue": groupValue
                })
            .toList();

    // if locale is hindi then setting default shloka language to hindi else english
    if (languageService.currentLocale.languageCode == 'hi') {
      groupValue.value = languageList[languageList.indexWhere(
              (element) => element['value'].value == 'हिंदी')]['value']
          .value;
      groupValueId.value = languageList[languageList
          .indexWhere((element) => element['value'].value == 'हिंदी')]['id'];
    } else {
      groupValue.value = languageList[languageList.indexWhere(
              (element) => element['value'].value == 'English')]['value']
          .value;
      groupValueId.value = languageList[languageList
          .indexWhere((element) => element['value'].value == 'English')]['id'];
    }

    log("this is language list " + languageList.toString());
    // initializeChapters();
    // initializeVerse();
    // log(verseList.toString());
    // log("This is message ${shlokaListingModel.value.data!.toJson()}");
    //debugPrint("languageList:$languageList");
  }

  // this returns body to pass in api request
  Map<String, String> returnBody() {
    Map<String, String> body = {};
    int i = 0;
    for (var element in languageList) {
      if (element["value"].value == element["groupValue"].value) {
        body["language_id"] = element["id"].toString();
        i++;
      }
    }
    body['chapter_number'] = selectedChapter.value;
    return body;
  }

/*
*   Phase 2
*   --------------------------------
*   new Chapters api which will be called and all the verses will be loaded of that particular chapter
*/
  // fetching chapters
  Future<void> fetchChapters(
      {String? token, required String langaugeId}) async {
    log("Fetching chapters Api Called");
    var response = await shlokasChaptersListService.shlokasChaptersListApi(
        languageId: langaugeId, token: token);
    // log(response.toString());
    if (response == " ") {
    } else {
      log("Response have some data");
      shlokaChapterModel.value =
          ShlokaChapterModel.fromJson(jsonDecode(response.body.toString()));
      log(shlokaChapterModel.toString());
      isChaptersListDataNotFound.value = false;
      checkShlokaItem!.value = shlokaChapterModel.value.message.toString();
      log(shlokaListingModel.value.message.toString());
      // calling initialize chapter, it creates a map of chapters
      initializeChapters();
    }
  }

  // fetching verses
  Future<void> fetchAllVerses(
      {String? token,
      required String chapterId,
      required String langaugeId}) async {
    log("Clear the verse list before calling the api");
    log("Fetching verses Api Called");
    var response = await shlokasListingService.shlokasListingApi(
        languageId: langaugeId, chapterNumber: chapterId, token: token);
    log(response.toString());
    if (response == " ") {
    } else {
      log("Response have some data");
      shlokaListingModel.value =
          ShlokasListingModel.fromJson(jsonDecode(response.body.toString()));
      log(shlokaListingModel.toString());
      isShlokasListDataNotFound.value = false;
      // calling initialize verse, it creates a map of verses
      initializeVerse();
    }
  }

  // this returns the listing result object for a particular verse number
  shlokaslisting.Result? returnVerse({required int verseNumber}) {
    log(verseNumber.toString());
    for (var element in shlokaListingModel.value.data!.result!) {
      if (element.verseNumber == verseNumber) {
        return element;
      }
    }
  }

  // checks if verse list has next verse (currently not in use)
  bool hasNext({required int verseNumber}) {
    var next = returnVerse(verseNumber: verseNumber);
    print("Current Index" +
        shlokaListingModel.value.data!.result!.indexOf(next!).toString());
    print("Length" + shlokaListingModel.value.data!.result!.length.toString());
    print(shlokaListingModel.value.data!.result!.indexOf(next) + 1 <
        shlokaListingModel.value.data!.result!.length);
    if (shlokaListingModel.value.data!.result!.indexOf(next) + 1 <
        shlokaListingModel.value.data!.result!.length) {
      return true;
    }
    return false;
  }

  // checks if verse list has previous verse (currently not in use)
  bool hasPrevious({required int verseNumber}) {
    var prev = returnVerse(verseNumber: verseNumber);
    if (shlokaListingModel.value.data!.result!.indexOf(prev!) > 0) {
      return true;
    }
    return false;
  }

  // initializes the verse list as a map
  initializeVerse() {
    verseList.value = shlokaListingModel.value.data!.result == null
        ? []
        : shlokaListingModel.value.data!.result!
            .map((e) => {
                  "title": e.verseNumber.toString(),
                  "value": e.verseNumber.toString().obs,
                  "id": e.verseNumber,
                  "groupValue": verseGroupValue,
                })
            .toList();
    log(verseList.where((element) => element['title'] == '2').toString() +
        ' this is verse list after filter');
    verseGroupValue.value = verseList.first['value'].value;
    // initialize the audio of a verse
    // var engVal = 1;
    // if (languageService.currentLocale.languageCode == 'hi') {
    //   engVal = languageList
    //       .indexWhere((element) => element['value'].value == 'हिंदी');
    // } else {
    //   engVal = languageList
    //       .indexWhere((element) => element['value'].value == 'English');
    // }
    if (controller.audioPlayer.value.playing) {
      controller.audioPlayer.value.pause();
    }
    if (startupService.startupData.first.data!.result!.shlokas_language_ids!
        .contains(groupValueId.value)) {
      initializeAudio(verseNumber: int.parse(verseGroupValue.value));
      // controller.audioPlayer.value.play();
      Get.find<BottomAppBarServices>().miniplayerVisible.value = true;
    } else {
      // controller.currentIndex.value = verseList.length - 1;
      Get.find<BottomAppBarServices>().miniplayerVisible.value = false;
    }
  }

  // initializes the chapter list as a map
  initializeChapters() {
    chapGroupValue.value = "1";
    // chaptersList = shlokaChapterModel.value.data!.result == null
    //     ? []
    //     : shlokaChapterModel.value.data!.result!
    //         .map((e) => {
    //               "title": e.chapterNumber.toString(),
    //               "value": e.chapterNumber.obs,
    //               "id": e.chapterId,
    //               "groupValue": chapGroupValue
    //             })
    //         .toList();

    // vaibhav changes in above code 18/03025--
    // Using null-aware operators (??) instead of checking for null.
    // Removing unnecessary ternary conditions (== null ? [] : is redundant with ?? []).

    chaptersList = (shlokaChapterModel.value.data?.result ?? [])
        .map((e) => {
              "title": e.chapterNumber.toString(),
              "value": e.chapterNumber.obs,
              "id": e.chapterId,
              "groupValue": chapGroupValue,
            })
        .toList();
  }

  // initializeAudio({required int verseNumber}) async {
  //   final verse = returnVerse(
  //     verseNumber: verseNumber,
  //   );

  //   var controller = Get.put(PlayerController());
  //   if (verse!.shlokAudioFileUrl == "" || verseList.length == 0) {
  //     log("Inside here");
  //     Get.find<BottomAppBarServices>().miniplayerVisible.value = false;
  //     await controller.audioPlayer.value.pause();
  //     controller.shlokaCheck(
  //         shlokaValue: true,
  //         hasPrevious: hasPrevious(verseNumber: verseNumber),
  //         hasNext: hasNext(verseNumber: verseNumber),
  //         hasCurrent: false);
  //     return;
  //   }
  //   controller.singleAudio.value = true;
  //   controller.shlokaCheck(
  //       shlokaValue: true,
  //       hasPrevious: hasPrevious(verseNumber: verseNumber),
  //       hasNext: hasNext(verseNumber: verseNumber),
  //       hasCurrent: true);
  //   controller.playlist = ConcatenatingAudioSource(children: [
  //     AudioSource.uri(
  //       Uri.parse(verse.shlokAudioFileUrl!),
  //       tag: MediaItem(
  //         id: "1",
  //         title: "Chapter ${chapGroupValue.value}",
  //         displaySubtitle: "Verse ${verseGroupValue.value}",
  //         displayTitle: "Chapter ${chapGroupValue.value}",
  //         extras: {
  //           "lyrics": "",
  //           "file": verse.shlokAudioFileUrl!,
  //           "type": "Shloka",
  //         },
  //         artist: "Verse ${verseGroupValue.value}",
  //         artUri: Uri.parse(
  //             "https://www.yatharthgeeta.com/wp-content/uploads/2018/12/logo-png.png"),
  //         duration: Duration(seconds: 0),
  //       ),
  //     )
  //   ]);

  //   await controller.audioPlayer.value
  //       .setAudioSource(controller.playlist)
  //       .whenComplete(() =>
  //           Get.find<BottomAppBarServices>().miniplayerVisible.value = true);
  //   await controller.audioPlayer.value.play();
  //   await controller.audioPlayer.value.setLoopMode(LoopMode.off);
  //   // controller.audioPlayer.value.playbackEventStream.listen((event) {
  //   //   event.
  //   // })

  //   controller.audioPlayer.value.positionStream.listen((event) async {
  //     if ((event.inSeconds ==
  //                 controller.audioPlayer.value.duration?.inSeconds &&
  //             event.inSeconds != 0) &&
  //         controller.audioPlayer.value.loopMode == LoopMode.off) {
  //       log("Comes Here");
  //       if (hasNext(verseNumber: verseNumber)) {
  //         log("Has Next");
  //         // var shlokasListingController = Get.find<ShlokasListingController>();
  //         int index = verseList.indexWhere((verse) {
  //           return verse["value"].value == verseGroupValue.value;
  //         });
  //         print(index);
  //         if (index < verseList.length - 1) {
  //           verseGroupValue.value =
  //               (int.parse(verseGroupValue.value) + 1).toString();
  //           await this
  //               .initializeAudio(verseNumber: int.parse(verseGroupValue.value));
  //         }

  //         return;
  //       }
  //     }
  //   });

  //   controller.loopMode.value = 0;
  // }

  // initialized the audio
  initializeAudio({required int verseNumber}) async {
    // final verse = returnVerse(verseNumber: verseNumber);
    PlayerController controller;
    if (Get.isRegistered<PlayerController>()) {
      controller = Get.find<PlayerController>();
    } else {
      controller = Get.put(PlayerController());
    }

    // if (verse!.shlokAudioFileUrl == "" || verseList.length == 0) {
    //   log("Inside here");
    //   Get.find<BottomAppBarServices>().miniplayerVisible.value = false;
    //   await controller.audioPlayer.value.pause();
    //   controller.shlokaCheck(
    //       shlokaValue: true,
    //       hasPrevious: hasPrevious(verseNumber: verseNumber),
    //       hasNext: hasNext(verseNumber: verseNumber),
    //       hasCurrent: false);
    //   return;
    // }

    // controller.singleAudio.value = true;
    // setting the audio player value for shloka to true indicating its a shloka
    controller.shlokaCheck(
        shlokaValue: true,
        hasPrevious: hasPrevious(verseNumber: verseNumber),
        hasNext: hasNext(verseNumber: verseNumber),
        hasCurrent: true);

    // creating a playlist for all the verses
    controller.playlist = ConcatenatingAudioSource(
        children: shlokaListingModel.value.data!.result!
            .map((e) => AudioSource.uri(
                  Uri.parse((e.shlokAudioFileUrl! == "" ||
                          e.shlokAudioFileUrl == null)
                      ? "https://ygadmin.yatharthgeeta.org/storage/shlok/no_audio_found.mp3"
                      : e.shlokAudioFileUrl!),
                  tag: MediaItem(
                    id: e.verseNumber.toString(),
                    title: "${"Chapter".tr} ${e.chapterNumber}",
                    displaySubtitle: "${"Verse".tr} ${e.verseNumber}",
                    displayTitle: "${"Chapter".tr} ${e.chapterNumber}",
                    extras: {
                      "lyrics": "",
                      "file": (e.shlokAudioFileUrl! == "" ||
                              e.shlokAudioFileUrl == null)
                          ? "https://ygadmin.yatharthgeeta.org/storage/shlok/no_audio_found.mp3"
                          : e.shlokAudioFileUrl,
                      "type": "Shloka",
                    },
                    artist: "",
                    artUri: Uri.parse(
                        "https://www.yatharthgeeta.com/wp-content/uploads/2018/12/logo-png.png"),
                    duration: Duration(seconds: 0),
                  ),
                ))
            .toList());
    // controller.playlist = ConcatenatingAudioSource(children: [
    //   AudioSource.uri(
    //     Uri.parse(verse.shlokAudioFileUrl!),
    //     tag: MediaItem(
    //       id: "1",
    //       title: "Chapter ${chapGroupValue.value}",
    //       displaySubtitle: "Verse ${verseGroupValue.value}",
    //       displayTitle: "Chapter ${chapGroupValue.value}",
    //       extras: {
    //         "lyrics": "",
    //         "file": verse.shlokAudioFileUrl!,
    //         "type": "Shloka",
    //       },
    //       artist: "Verse ${verseGroupValue.value}",
    //       artUri: Uri.parse(
    //           "https://www.yatharthgeeta.com/wp-content/uploads/2018/12/logo-png.png"),
    //       duration: Duration(seconds: 0),
    //     ),
    //   )
    // ]);

    // when loaded enable miniplayer flag
    // await controller.audioPlayer.value.setAudioSource(source)
    // VAIBHAV CHANGES -- 04/03/25
    // added listener for sequncestream and playerStateStream
    print("\x1B[32mGetting slokas listing from shlokas listing controller");
    await controller.audioPlayer.value
        .setAudioSource(controller.playlist, initialIndex: 0, preload: true);
    controller.audioPlayer.value.sequenceStateStream.listen((event) {
      log("Audio player is updated to new aadhya in shlokas listings current index stream");
      log("\x1B[32mChecking sequence in sequenceStateStream: ${DateTime.now()}");
      if (controller.networkService.connectionStatus == 0) {
        controller.audioPlayer.value.stop();
        controller.internetGone.value = true;
        log("\x1B[32m Pause due to no internet in sequenceStateStream stream");
      }
    });

    // controller.audioPlayer.value.playerStateStream.listen((event) {
    //   print("\x1B[32mChecking sequence in playerStateStream: ${DateTime.now()}");
    //   print("\x1B[32mChecking sequence in state : ${event.processingState}");
    //   // if (event.processingState == ProcessingState.ready &&
    //   //     controller.networkService.connectionStatus == 0) {
    //   //   controller.audioPlayer.value.pause();
    //   //   print("\x1B[32m Pause due to no internet");
    //   // }
    // });
    // .whenComplete(() =>
    //     );
    if (controller.audioPlayer.value.audioSource != null) {
      Get.find<BottomAppBarServices>().miniplayerVisible.value = true;
    }
    controller.chapterName.value = "${"Verse".tr} ${verseList.first['title']}";
    // await controller.audioPlayer.value.play();
    // setting loop mode to off
    await controller.audioPlayer.value.setLoopMode(LoopMode.off);

    // controller.audioPlayer.value.positionStream.listen((event) async {
    //   if (event.inSeconds == controller.audioPlayer.value.duration!.inSeconds &&
    //       event.inSeconds != 0) {
    //     log("Came here");
    //     await controller.audioPlayer.value.pause();
    //     await controller.audioPlayer.value.play();
    //   }
    // });

    // listening to current index stream
    controller.audioPlayer.value.currentIndexStream.listen((event) async {
      controller.oldPos = Duration.zero;
      controller.position.value = Duration.zero;
      log("Old position is updated casue new verse is loaded: ${controller.oldPos}");
      log("Current position is updated casue new verse is loded: ${controller.position.value}");

      print(
          "\x1B[32mHere i'm checking the intrnet connection and also index is incrasing");
      int backForth = event! -
          verseList.indexWhere((verse) => verse["value"] == verseGroupValue);
      log(backForth.toString() + " number of time go back or forth");
      log("verse group value ${verseGroupValue.value.toString()}");

      // setting verse value to current index + 1 as it starts from 0
      verseGroupValue.value = (event + 1).toString();

      // setting group value to verse group value
      verseList[event]["groupValue"].value = verseGroupValue.value;
      log("verse group value firse ${verseGroupValue.value.toString()}");

      // setting current index to current index
      controller.currentIndex.value = event;

      // setting chapter name from verselist index appending Verse behind
      controller.chapterName.value =
          "${"Verse".tr} ${verseList[event]['title']}";
      log(controller.chapterName.value);

      if (!Get.find<BottomAppBarServices>().miniplayerVisible.value) {
        Get.find<BottomAppBarServices>().miniplayerVisible.value = true;
        controller.shouldDisplay.value = true;
      }

      if (controller.networkService.connectionStatus == 0) {
        print("\x1B[31mNo internet connection, stopping index update.");
        return;
      }
      // }

      // }
      // else {
      //   await controller.audioPlayer.value.pause();
      // }

      // if (shlokaListingModel.value.data!.result![event].shlokAudioFileUrl ==
      //         null ||
      //     shlokaListingModel.value.data!.result![event].shlokAudioFileUrl ==
      //         '') {
      //   await controller.audioPlayer.value.pause();
      //   log("Comes Here");
      // }
      // final mediaItem = controller
      //     .audioPlayer.value.sequenceState?.currentSource?.tag as MediaItem?;
      // if (mediaItem?.extras?['file'] ==
      //     "https://ygadmin.yatharthgeeta.org/storage/shlok/no_audio_found.mp3") {
      //   await controller.audioPlayer.value.pause();
      // }
    });
    // controller.audioPlayer.value.currentIndexStream.listen((event) {
    // });

    // controller.audioPlayer.value.positionStream.listen((event) {

    //   if ((event.inSeconds ==
    //               controller.audioPlayer.value.duration?.inSeconds &&
    //           event.inSeconds != 0) &&
    //       controller.audioPlayer.value.loopMode == LoopMode.off) {
    //     final mediaItem = controller
    //         .audioPlayer.value.sequenceState?.currentSource?.tag as MediaItem;
    //     if (mediaItem.extras!['type'] == 'Shloka') {
    //       print("Is Shloka");
    //       final shlokasListingController = Get.find<ShlokasListingController>();
    //       shlokasListingController.verseGroupValue.value =
    //           (int.parse(shlokasListingController.verseGroupValue.value) + 1)
    //               .toString();
    //     }
    //   }
    // });
    // Cancel the previous subscription when creating a new one
    // StreamSubscription<Duration>? positionSubscription;
    // positionSubscription =
    //     controller.audioPlayer.value.positionStream.listen((event) async {
    //   if ((event.inSeconds ==
    //               controller.audioPlayer.value.duration?.inSeconds &&
    //           event.inSeconds != 0) &&
    //       controller.audioPlayer.value.loopMode == LoopMode.off) {
    //     log("Comes Here");
    //     if (hasNext(verseNumber: verseNumber)) {
    //       log("Has Next");
    //       int index = verseList.indexWhere((verse) {
    //         return verse["value"].value == verseGroupValue.value;
    //       });
    //       print(index);
    //       if (index < verseList.length - 1) {
    //         verseGroupValue.value =
    //             (int.parse(verseGroupValue.value) + 1).toString();
    //         // Cancel the previous subscription before initializing the next audio
    //         await initializeAudio(
    //             verseNumber: int.parse(verseGroupValue.value));
    //         positionSubscription?.cancel();
    //       }
    //     }
    //   }
    // });

    // play pause is done for resolving some issues that were arising (Never remove this, i can't explain why but everything will break).
    controller.internetGone.value = false;
    await controller.audioPlayer.value.pause();
    // await controller.audioPlayer.value.play();
    controller.loopMode.value = 0;
  }

/*
*  Phase 2 Functions End Here
*  --------------------------------
*/

  // RxList selectedShlokasList = [].obs;

  // RxList shlokasChaptersListStatic =
  //     [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19].obs;
  // Future<void> fetchShlokaListingFilter(
  //     {String? token, BuildContext? ctx, Map? body}) async {
  //   // isLoadingData.value = true;
  //   // Loading(Utils.loaderImage()).start(ctx!);
  //   Utils().showLoader();
  //   final response = await ShlokasListingService().shlokaFilterApi('', body);
  //   if (response == " ") {
  //     clearShlokasListsData();
  //   } else if (response is http.Response) {
  //     if (response.statusCode == 404) {
  //       clearShlokasListsData();
  //     } else if (response.statusCode == 500) {
  //       clearShlokasListsData();
  //     } else if (response.statusCode == 200) {
  //       var mapdata = jsonDecode(response.body.toString());
  //
  //       if (mapdata['success'] == 0) {
  //         // isLoadingData.value = false;
  //         clearShlokasListsData();
  //         if (pageNo.value == 1 && shlokasChaptersList.isEmpty) {
  //           // isDataNotFound.value = true;
  //         }
  //
  //         // checkItem!.value = mapdata['message'];
  //       } else {
  //         final audioListingModel =
  //             shlokaslisting.shlokasListingModelFromJson(response.body);
  //
  //         clearShlokasListsData();
  //         shlokasListing.addAll(audioListingModel.data!.result!);
  //         // totalBooks.value = audioListingModel.data!.totalCount!;
  //
  //         // Loading.stop();
  //         pageNo.value++;
  //         // isLoadingData.value = false;
  //         // isDataNotFound.value = false;
  //       }
  //     }
  //   }
  //   Get.back();
  // }

//For Fetching Shlokas Chapters List
  Future<void> fetchShlokasChaptersList(
      {String? token, required String langaugeId}) async {
    log('shlokas chapters List = $shlokasChaptersList');

    shlokasChaptersList.clear();

    isLoadingShlokasChaptersListData.value = true;

    final response = await shlokasChaptersListService.shlokasChaptersListApi(
        token: bottomAppBarServices.token.value, languageId: langaugeId);
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
          // Get.back();
          isLoadingShlokasChaptersListData.value = false;
          log('success is 0');
          if (pageNo.value == 1 && shlokasChaptersList.isEmpty) {
            isChaptersListDataNotFound.value = true;
          }
          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else {
          final shlokasChaptersListModel = shlokaschapterslist
              .shlokasChaptersListModelFromJson(response.body);
          shlokasChaptersListResult!.value =
              shlokasChaptersListModel.data!.result!;
          // shlokasChaptersList.addAll(shlokasChaptersListModel.data!.result!);

          if (shlokasChaptersList.isNotEmpty) {
            selectedChapter.value = shlokasChaptersList.first.toString();
          }

          // totalShlokasChapters.value =
          //     shlokasChaptersListModel.data!.result!.chapterNumbers!.length;
          checkChapterItem!.value = mapdata['message'];
          log('item message = $checkChapterItem');
          // log("shlokas chapters listing result = ${shlokasChaptersListResult.value.toString()}");
          log("pre selected shlokas chapter = ${selectedChapter.value.toString()}");
          //pageNo.value++;
          // log('total shlokas chapters value---> ${totalShlokasChapters.value}');
          log('total shlokas chapters list----> ${shlokasChaptersList.toString()}');
          isLoadingShlokasChaptersListData.value = false;
          isChaptersListDataNotFound.value = false;
        }
      }
    }
  }

  //For Fetching Shlokas Chapters List
  Future<void> fetchShlokasListing(
      {String? token,
      required String langaugeId,
      required String chapterNumber,
      Map<String, String>? body}) async {
    log('shlokas listing = $shlokasListing');
    isLoadingShlokasListingData.value = true;
    log('pageNo.value.toString()  = ${pageNo.value.toString()}');
    log("limit.toString() = ${limit.toString()}");
    final response = await shlokasListingService.shlokasListingApi(
        token: bottomAppBarServices.token.value,
        languageId: langaugeId,
        chapterNumber: chapterNumber,
        pageNo: pageNo.value.toString(),
        limit: limit.toString(),
        body: body);
    if (response == " ") {
      //Do Something here
    } else if (response is http.Response) {
      if (response.statusCode == 404) {
        // Map mapdata = jsonDecode(response.body.toString());
        isNoDataLoading.value = true;
        //clearShlokasListsData();
        //Show error toast here
      } else if (response.statusCode == 500) {
        // Map mapdata = jsonDecode(response.body.toString());
        //Show error toast here
        isNoDataLoading.value = true;
        //clearShlokasListsData();
      } else if (response.statusCode == 200) {
        var mapdata = jsonDecode(response.body.toString());
        //clearShlokasListsData();
        if (mapdata['success'] == 0) {
          // Get.back();
          isLoadingShlokasListingData.value = false;
          isNoDataLoading.value = true;
          log('success is 0');
          if (pageNo.value == 1 && shlokasListing.isEmpty) {
            isShlokasListDataNotFound.value = true;
          }
          // checkItem!.value = mapdata['message'];

          // log('item message = $checkItem');
        } else {
          //clearShlokasListsData();
          final shlokasListingModel =
              shlokaslisting.shlokasListingModelFromJson(response.body);

          shlokasListing.addAll(shlokasListingModel.data!.result!);
          // totalShlokas.value = shlokasListingModel.data!.totalCount ?? 0;
          checkShlokaItem!.value = mapdata['message'];
          log('totalShlokas.value  = ${totalShlokas.value}');
          log("shlokas listing = ${shlokasListing.toString()}");
          pageNo.value++;
          // log('total shlokas chapters value---> ${totalShlokasChapters.value}');

          //log('shlokasListing.length.toString(): ${shlokasListing.length.toString()}');
          log('shlokasListing.length.toString(): ${shlokasListing.length.toString()}');
          isLoadingShlokasListingData.value = false;
          isShlokasListDataNotFound.value = false;
          isNoDataLoading.value = false;
        }
      }
    }
  }

  clearShlokasListsData() {
    debugPrint("clearShlokasListsData() called");
    isLoadingShlokasChaptersListData.value = false;
    isLoadingShlokasListingData.value = false;
    // shlokasChaptersList.value = [];
    shlokasListing.value = [];
    // shlokasChaptersList.value = [];

    // selectedChapter.value = "1";
    isShlokasListDataNotFound.value = false;
    isChaptersListDataNotFound.value = false;
    pageNo = 1.obs;
  }

  // fetchShlokasList(int chapter) {
  //   if (chapter.isEven) {
  //     selectedShlokasList.value = dummyShlokasModelList2;
  //   } else {
  //     selectedShlokasList.value = dummyShlokasModelList;
  //   }
  //   return selectedShlokasList;
  // }

  // final List<ShlokasModel> dummyShlokasModelList = [
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas1_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning: Constants.dummyShlokaMeaning,
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas2_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas3_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning:
  //         'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas1_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas2_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning:
  //         'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas3_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas1_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning:
  //         'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas2_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  // ];

  // final List<ShlokasModel> dummyShlokasModelList2 = [
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas2_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning:
  //         'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas1_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas3_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning:
  //         'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas1_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas2_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning:
  //         'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas3_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas1_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||',
  //     shlokasMeaning:
  //         'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
  //   ),
  //   ShlokasModel(
  //     canvasImgUrl: 'assets/images/shlokas/canvas2_new.png',
  //     shlokaTitle: 'अध्याय -2',
  //     verseNumber: 'Gita Shloka 47',
  //     shloka:
  //         'सञ्जय उवाच ।दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ।। 2।।',
  //     shlokasMeaning:
  //         'Sanjay said: On observing the Pandava army standing in military formation, King Duryodhan approached his teacher Dronacharya, and said the following words.',
  //   ),
  // ];
}
