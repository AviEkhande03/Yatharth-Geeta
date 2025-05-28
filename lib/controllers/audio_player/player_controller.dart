import 'dart:async';
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:subtitle/subtitle.dart';
import 'package:http/http.dart' as http;
import 'package:yatharthageeta/services/network/network_service.dart';
import 'package:yatharthageeta/utils/utils.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../audio_details/audio_details_controller.dart';
import '../../services/audio_player/player_service.dart';
import 'package:yatharthageeta/models/audio_player/audio_chapters_model.dart'
    as chapters;
import 'package:yatharthageeta/models/audio_details/audio_details_model.dart'
    as adm;
import 'package:yatharthageeta/services/bottom_app_bar/bottom_app_bar_services.dart';

//It was initially a controller but because of its constant use was converted to a service
class PlayerController extends GetxService {
  //Audio Player Instance
  final audioPlayer = AudioPlayer(handleInterruptions: true).obs;
  //Network Service Instance
  var networkService = Get.find<NetworkService>();
  RxBool isGuestUser = false.obs;
  bool isBufferComplete = false;

  //Variables to create state of audio player values
  final loopMode = 0.obs;
  final mute = false.obs;
  final visible = false.obs;
  final volume = 1.0.obs;
  final muteVal = false.obs;
  final playback = 4.obs;
  final currPos = 0.0.obs;
  var position = Duration.zero.obs;
  var bufferedPosition = Duration.zero.obs;
  var duration = Duration.zero.obs;
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  var playListData = <AudioSource>[].obs;

  //For managing Player Screen Data
  final chapNext = false.obs;
  final chapPrev = false.obs;
  var hasNext = false.obs;
  var hasPrevious = false.obs;
  var chapterList = <adm.ChaptersList>[].obs;
  var chapterName = "".obs;
  var verseName = "".obs;
  var currVerseList = <chapters.Result>[].obs;
  var modelList = <adm.ChaptersList, List<chapters.Result>>{}.obs;
  var model = chapters.AudioChapterModel().obs;
  var currentIndex = 0.obs;
  var metaData = const MediaItem(id: "", title: "").obs;
  final currIndex = 0.obs;
  var chapterPlaying = adm.ChaptersList().obs;
  var versePlaying = chapters.Result().obs;
  var singleAudio = false.obs;
  var isShloka = false.obs;
  var shlokaHasNext = false.obs;
  var shlokaHasPrevious = false.obs;
  var shlokaHasCurrent = false.obs;
  final currDur = Duration.zero.obs;

  //For creating bookmarks, currently not in use
  var width = 0.0.obs;
  final RxMap<String, List<Duration>> bookmarks =
      <String, List<Duration>>{}.obs;
  var showFrontSide = true.obs;
  var shouldDisplay = false.obs;
  var internetGone = false.obs;
  var noInternet = 1.obs;
  var startPos = const Offset(0, 0).obs;
  var endPos = const Offset(0, 0).obs;
  var mywidgetkey = GlobalKey().obs;
  var caption = <Subtitle>[].obs;
  StreamController streamController = StreamController.broadcast();
  ScrollController scrollController = ScrollController();
  var index = 0.obs;
  var streamIndex = 0.obs;
  var scrollPos = 0.0.obs;
  Duration oldPos = Duration.zero;
  Rx<Subtitle?>? currentSubtitle;

  //-- Vaibhav Chnages -- 04/03025
  bool closeMiniPlayer = false;

  // final playlist = ConcatenatingAudioSource(children: [
  //   AudioSource.uri(
  //       Uri.parse(
  //           "https://www.yatharthgeeta.org/webroot/files/VersesTranslation/st_audio/155635006170.mp3"),
  //       tag: MediaItem(
  //           id: "1",
  //           title: "Chapter 1 : Arjuna Vishada Yoga".tr,
  //           displaySubtitle: "Verse 1".tr,
  //           displayTitle: "Srimad Bhagwad Gita Padhchhed".tr,
  //           extras: {
  //             "lyrics":
  //                 "https://ott-2.s3.eu-north-1.amazonaws.com/Taylor-Swift-Love-Story.srt"
  //           },
  //           artist: "Swami Adganand Maharaj".tr,
  //           artUri: Uri.parse("https://i.ibb.co/4fk0yF8/Rectangle-56-2.png"),
  //           duration: const Duration(minutes: 4, seconds: 45))),
  //   AudioSource.uri(
  //       Uri.parse(
  //           "https://www.yatharthgeeta.org/webroot/files/VersesTranslation/st_audio/153329893479.mp3"),
  //       tag: MediaItem(
  //           id: "2",
  //           title: "Chapter 02: Sankhya Yoga".tr,
  //           displaySubtitle: "Verse 1",
  //           displayTitle: "Srimad Bhagwad Gita Padhchhed".tr,
  //           extras: {
  //             "lyrics":
  //                 "https://geeta-static-files.s3.ap-south-1.amazonaws.com/Ed-Sheeran-Perfect-(Official-Audio).srt"
  //           },
  //           artist: "Swami Adganand Maharaj".tr,
  //           // artUri: Uri.parse(
  //           //     "https://images.fineartamerica.com/images/artworkimages/mediumlarge/2/shri-krishna-avtar-tarun-chopra.jpg"),
  //           duration: const Duration(minutes: 4, seconds: 45))),
  // ]);

  @override
  void onInit() async {
    //initializing the isGuestUser variable
    isGuestUser.value = await Utils.isGuestUser();
    //initializing the bookmark if there exist for the current audio
    playlist.children.forEach((element) =>
        bookmarks["${playlist.children.indexOf(element) + 1}"] = <Duration>[]);
    super.onInit();
  }

  void deleteAudioPlayer() {
    audioPlayer.value.dispose();
  }

  //Setting up the variables for shloka screen as the player has some different functionality for shloka screen
  void shlokaCheck(
      {required bool shlokaValue,
      required bool hasPrevious,
      required bool hasNext,
      required bool hasCurrent}) {
    isShloka.value = shlokaValue;
    shlokaHasPrevious.value = hasPrevious;
    shlokaHasNext.value = hasNext;
    shlokaHasCurrent.value = hasCurrent;
  }

/*  Future<void> downloadAudio(
      BuildContext context, String file, String name) async {
    // if (isGuestUser.value) {
    //   Utils.customToast("Please login to download the Audio", kRedColor,
    //       kRedColor.withOpacity(0.2), "Error");
    //   return;
    // }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      print("Not allowed to download");
      await Permission.manageExternalStorage.request();
    }
    if (Platform.isAndroid) {
      var directory = await Directory('/sdcard/Yatharth\ Geeta/Audios')
          .create(recursive: true);
      FlutterDownloader.enqueue(
          url: file,
          savedDir: directory.path,
          fileName: name + ".mp3",
          showNotification: true,
          saveInPublicStorage: true,
          openFileFromNotification: true);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      //From path_provider package
      var _localPath = dir.path + "/Audios/";
      final savedDir = Directory(_localPath);
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url: file,
          savedDir: savedDir.path,
          fileName: name + ".mp3",
          showNotification: true,
          saveInPublicStorage: true,
          openFileFromNotification: false,
        );
      });
    }
  }*/

  //This method creates a playlist for audio to play
  createPlaylist(adm.Result model) async {
    isShloka.value = false;
    //If it has episodes, then it will map through the chapters List
    playlist = model.hasEpisodes!
        ? ConcatenatingAudioSource(children: [
            for (int i = 0; i < model.chapters!.chaptersList!.length; i++) ...[
              AudioSource.uri(
                Uri.parse(model.chapters!.chaptersList![i].audioFileUrl!),
                //Media Item is the model for displaying data on the player screen
                tag: MediaItem(
                  id: "$i",
                  title: model.chapters!.chaptersList![i].chapterName!,
                  displaySubtitle: model.chapters!.chaptersList![i].title ?? '',
                  displayTitle: model.chapters!.chaptersList![i].chapterName!,
                  extras: {
                    "lyrics": model.chapters!.chaptersList![i].audioSrtFileUrl!,
                    "file": model.chapters!.chaptersList![i].audioFileUrl!,
                    "type": "Audio"
                  },
                  artist: model.authorName!,
                  artUri: Uri.parse(model.audioCoverImageUrl!),
                  duration: Duration(
                      seconds: model.chapters!.chaptersList![i].duration!),
                ),
              ),
            ]
          ])
        //Else it will create a single audio playlist
        : ConcatenatingAudioSource(children: [
            AudioSource.uri(
              Uri.parse(model.audioFileUrl!),
              tag: MediaItem(
                id: "1",
                title: model.title!,
                displaySubtitle: "",
                displayTitle: model.title!,
                extras: {
                  "lyrics": model.audioSrtFileUrl!,
                  "file": model.audioFileUrl!,
                  "type": "Audio"
                },
                artist: model.authorName!,
                artUri: Uri.parse(model.audioCoverImageUrl!),
                duration: Duration(seconds: model.duration!),
              ),
            )
          ]);

    //setting up chapterList for the pop up on the player screen (only sets when there are episodes in the audio)
    if (model.hasEpisodes!) {
      chapterList.value = model.chapters!.chaptersList!;
    }

    //initializing the audio player
    try {
      //Setting the audio source of the player
      log("Initializing audio player...");
      await audioPlayer.value
          .setAudioSource(playlist, initialIndex: 0, preload: true);
      //setting loop mode off
      await audioPlayer.value.setLoopMode(LoopMode.off);

      /*this is for managing the icon of the repeat on player screen 
      * 0-> Off
      * 1-> Play One
      * 2-> Play All
      */
      loopMode.value = 0;
      //Setting all the shloka values to false as it is audio screen
      shlokaCheck(
          shlokaValue: false,
          hasPrevious: false,
          hasNext: false,
          hasCurrent: false);

      //Listening to the position stream to set the position value for to display on progress bar
      // audioPlayer.value.positionStream.listen((event) {
      //   position.value = event;
      //   print("Position: ${position.value}");
      // });

      // audioPlayer.value.currentIndexStream.listen((event) {
      //   if (audioPlayer.value.loopMode == LoopMode.one) {
      //     audioPlayer.value.setLoopMode(LoopMode.off);
      //     loopMode.value = 0;
      //   }
      // });
      //Listening to the duration stream to set the duration value for to display on progress bar
      audioPlayer.value.durationStream.listen((event) {
        duration.value = event!;
      });

      //Listening to the Current Index stream to set current chapter value as the chapter name should change as the audio index is changed
      audioPlayer.value.currentIndexStream.listen((event) {
        if (!isShloka.value) {
          chapterName.value = chapterList[event!].chapterName.toString();
        }
      });

      // //Listening to the buffered position stream to set the buffered position value for to display on progress bar
      // audioPlayer.value.bufferedPositionStream.listen((event) async {
      //   bufferedPosition.value = event;
      //   print("Buffered Position: ${bufferedPosition.value}");
      //   //checking if there is no internet connection
      //   if (noInternet.value == 0) {
      //     log("No Internet but outside");
      //     //Checking if the difference between position and buffered position is less than 10 seconds
      //     if (bufferedPosition.value - position.value < Duration(seconds: 10)) {
      //       //Pausing the player and disabling the seek bar
      //       oldPos = position.value;
      //       audioPlayer.value.pause();
      //       log("No Internet");
      //       //this also disables the next and previous buttons
      //       internetGone.value = true;
      //     }
      //   } else {
      //     //this is executed when the internet is back
      //     if (internetGone.value) {
      //       //enabling the seek bar and the next and previous buttons and playing the audio back
      //       await audioPlayer.value
      //           .setAudioSource(playlist, initialIndex: 0, preload: true);
      //       await audioPlayer.value.seek(oldPos);
      //       internetGone.value = false;
      //       audioPlayer.value.play();
      //     }
      //   }

      //   // constantly listening for no internet connection
      //   // networkService.connectionStatus.listen((p0) async {
      //   //   log("Inside netwrok service");
      //   //   if (p0 == 0) {
      //   //     noInternet.value = 0;
      //   //   } else {
      //   //     noInternet.value = 1;
      //   //   }
      //   // });
      // });

//       // Set up network listener ONCE, outside of buffered position listener
//       networkService.connectionStatus.listen((status) {
//         log("Network Status Changed: $status");
//         noInternet.value = status;
//       });

//       audioPlayer.value.positionStream.listen((event) async {
//         position.value = event;
//         log("Current Position: ${position.value}");

//         // When no internet
//         if (noInternet.value == 0) {
//           log("No Internet detected");

//           // Pause if only 10s of buffer is left
//           if (bufferedPosition.value - position.value < Duration(seconds: 10)) {
//             oldPos = position.value;
//             await audioPlayer.value.pause();
//             log("Paused due to no internet");
//             internetGone.value = true;
//           }
//         }
//       });

// // Periodic internet recovery check
//       Timer.periodic(Duration(seconds: 3), (timer) async {
//         if (noInternet.value == 1 && internetGone.value) {
//           log("Internet is back, resuming playback...");

//           // Resume playback without reloading source
//           await audioPlayer.value.seek(oldPos);
//           internetGone.value = false;
//           audioPlayer.value.play();

//           timer.cancel(); // Stop the periodic check
//         }
//       });

      // Listening to the state stream to set the state value for to display on player screen
      // VAIBHAV CHANGES -- 18/03/25
      // Added internet connection check to stop playback
      audioPlayer.value.currentIndexStream.listen((event) {
        log("Audio player index updated.");
        oldPos = Duration.zero;
        position.value = Duration.zero;
        log("Old position is updated casue new verse is loded: ${oldPos}");
        log("Current position is updated casue new verse is loded: ${position.value}");
        if (networkService.connectionStatus == 0) {
          audioPlayer.value.stop();
          internetGone.value = true;
          log("\x1B[32m Pause due to no internet in sequenceStateStream stream");
        } else {
          var currIndex = event!;
          currentIndex.value = event;
          for (var chapter in modelList.keys) {
            if (currIndex < modelList[chapter]!.length) {
              chapterPlaying.value = chapter;
              currVerseList.value = modelList[chapter]!;
              versePlaying.value = modelList[chapter]![currIndex];
              break;
            } else {
              currIndex -= modelList[chapter]!.length;
            }
          }
        }

        // print("-----> ${sum - event!}");
        // versePlaying.value = modelList.values.toList()[i]
        //     [modelList.values.toList()[i].length - (event! - sum)];
        // chapterName.value =
        //     "Chapter ${modelList.keys.toList().indexOf(chapterPlaying.value) + 1}";
        // verseName.value =
        //     "Verse ${modelList[chapterPlaying.value]!.indexOf(versePlaying.value) + 1}";
      });

      //Listening to sequence stream to check if there are next or previous chapters in the audio (Its not in use i feel)
      audioPlayer.value.sequenceStream.listen((event) {
        log("Audio player is updated to new  sequence stream");

        // if (event!.length == 1) {
        //   hasNext.value = false;
        //   hasPrevious.value = false;
        // } else {
        //   hasNext.value = true;
        //   hasPrevious.value = true;
        // }

        // vaibhav changes --
        // simplified the above conditions

        hasNext.value = event!.length > 1;
        hasPrevious.value = event.length > 1;
      });
    } catch (e) {
      Get.back();
      // if the error occurs its displayed here
      log("Here's the error $e");
      log(e.toString());
      Utils.customToast(
          "Something Went Wrong".tr, kColorWhite, kRedColor, "Error");
    }
  }

  //fetch all the verses by chapters
  modelData(adm.ChaptersList chapNo) async {
    http.Response response = await PlayerService().playerChapterApi(
        token: Get.find<BottomAppBarServices>().token.value,
        audioId: Get.find<AudioDetailsController>().audioDetails.value!.id,
        chapterNo: chapNo.chapterNumber);
    model.value = chapters.audioChapterModelFromJson(response.body);
    log("Model data called");
    modelList.clear();
    // modelList[chapNo] = modelList[chapNo] ?? [];
    if (modelList.keys.contains(chapNo)) {
      log("inside present");
      modelList.update(
          chapNo, (value) => [...value, ...model.value.data!.result!]);
    } else {
      log("inside absent");
      modelList.putIfAbsent(chapNo, () => [...model.value.data!.result!]);
      log("Model Data " + modelList.value.toString());
    }

    // VAIBHAV CHANGES -- 18/03/25
    // In above code the the keys are checked maually, and here i used update() directly
    // modelList.update(
    //   chapNo,
    //   (existingList) => [...existingList, ...model.value.data!.result!],
    //   ifAbsent: () => [...model.value.data!.result!],
    // );
    // modelList[chapNo]!.add(model.value);
  }

  // initialize the verses in the player controller
  initData(dynamic chapNo) async {
    // Shoyeb code--------------------------------

    var detailsController = Get.find<AudioDetailsController>();
    if (detailsController.audioDetails.value!.hasEpisodes!) {
      singleAudio.value = false;
      chapNext.value = true;
      for (var i = 0;
          i <
              detailsController
                  .audioDetails.value!.chapters!.chaptersList!.length;
          i++) {
        var element =
            detailsController.audioDetails.value!.chapters!.chaptersList![i];
        if (element == chapNo) {
          if (i == 0) {
            chapPrev.value = false;
            chapNext.value = true;
            if (detailsController
                    .audioDetails.value!.chapters!.chaptersList!.length ==
                1) {
              chapPrev.value = false;
              chapNext.value = false;
            }
          }
          if (i ==
              detailsController
                      .audioDetails.value!.chapters!.chaptersList!.length -
                  1) {
            chapPrev.value = true;
            chapNext.value = false;

            if (i == 0) {
              chapPrev.value = false;
              chapNext.value = false;
            }
          }

          await modelData(element);
          break;
        }
        print("----> ${element.chapterNumber}");
      }
      // ----------------------------------------------------------------
      // final chapterData = (chapterFutures);
      //   int i = 1;
      //   for (var element in modelList.keys) {
      //     for (var e in modelList[element]!) {
      //       playListData.add(AudioSource.uri(
      //           Uri.parse(
      //             e.audioFileUrl!,
      //           ),
      //           tag: MediaItem(
      //               id: i.toString(),
      //               title: element.chapterName!,
      //               displaySubtitle: e.versesName!,
      //               displayTitle:
      //                   detailsController.audioDetails.value!.authorName!.tr,
      //               extras: {"lyrics": e.audioSrtFileUrl!},
      //               artist: detailsController.audioDetails.value!.authorName!.tr,
      //               artUri: Uri.parse(detailsController
      //                   .audioDetails.value!.audioCoverImageUrl!),
      //               duration: Duration(seconds: e.duration!))));
      //     }
      //   }
      //   print(modelList);
      //   log("playlist data : ${playListData.length}");
      //   // var playListData1 = Future.wait(playListData);
      //   // var playListData2 = await playListData1;
      //   log("model list ${modelList.length}");
      //   playlist = ConcatenatingAudioSource(children: playListData);
      // } else {
      //   singleAudio.value = true;
      //   chapNext.value = false;
      //   chapPrev.value = false;
      //   playlist = ConcatenatingAudioSource(children: [
      //     AudioSource.uri(
      //         Uri.parse(
      //           detailsController.audioDetails.value!.audioFileUrl!,
      //         ),
      //         tag: MediaItem(
      //             id: "1",
      //             title: detailsController.audioDetails.value!.title!.tr,
      //             displaySubtitle: "",
      //             displayTitle:
      //                 detailsController.audioDetails.value!.authorName!.tr,
      //             extras: {
      //               "lyrics":
      //                   detailsController.audioDetails.value!.audioSrtFileUrl!
      //             },
      //             artist: detailsController.audioDetails.value!.authorName!.tr,
      //             artUri: Uri.parse(
      //                 detailsController.audioDetails.value!.audioCoverImageUrl!),
      //             duration: Duration(
      //                 seconds: detailsController.audioDetails.value!.duration!)))
      //   ]);
    }

    // audioPlayer.value.positionStream.listen((event) {
    //   if (caption.isNotEmpty &&
    //       getSubtitleForCurrentPosition(audioPlayer.value.position, caption)
    //               ?.data !=
    //           null) {
    //     streamController.add(
    //         getSubtitleForCurrentPosition(audioPlayer.value.position, caption));
    //   }
    // });
  }

  // this was created for fetching and parsing the srt file
  Future<List<Subtitle>> getCloseCaptionFile(url) async {
    try {
      final data = await http.get(Uri.parse(url));
      final srtContent = data.body.toString();
      var lines = srtContent.split('\n');
      // var subtitles = <String, String>{};
      List<Subtitle> subtitles = [];
      int index = 0;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        if (line.isEmpty) {
          continue;
        }

        if (int.tryParse(line) != null) {
          index = int.parse(line);
        } else if (line.contains('-->')) {
          final parts = line.split(' --> ');
          final start = parseDuration(parts[0]);
          final end = parseDuration(parts[1]);

          var data = lines[++i].trim();
          var j = i + 1;
          if (lines[j].isNotEmpty) {
            data += " ${lines[++i]}";
          }
          subtitles
              .add(Subtitle(index: index, start: start, end: end, data: data));
        }
        // print("---->${subtitles[subtitles.length]}");
      }
      return subtitles;
    } catch (e) {
      debugPrint(e.toString());
      debugPrintStack();
    }
    return [];
  }

  //this parses the duration string to a formatted duration string (Currently not in use i feel)
  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int seconds;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    seconds = (double.parse(parts[parts.length - 1].split(",")[0])).round();
    // print("----->$hours $minutes $seconds");
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  // this was created for getting the current position of the subtitle
  Subtitle? getSubtitleForCurrentPosition(Duration position, caption) {
    // print("----->${caption.value.length}");
    for (var subtitle in caption.value) {
      if (position >= subtitle.start && position <= subtitle.end) {
        return subtitle;
      }
    }
    return null;
  }

  @override
  void onClose() {
    audioPlayer.value.dispose();
    super.onClose();
  }

  // this was created to seek at a specific index in audio player while reloading the audio player
  void changeIndex(currIndex, duration) async {
    await audioPlayer.value.setAudioSource(playlist,
        initialIndex: currIndex, preload: true, initialPosition: duration);
  }

  // this was to get the width of bookmarks widget
  void findWidth(GlobalKey widgetkey) {
    var box = widgetkey.currentContext?.findRenderObject() as RenderBox;
    width.value = box.size.width;
  }

  //this was used to create the bookmark icon on the progress bar
  List<Widget> getBookmarks(metaData, position, widgetkey) {
    try {
      List<Widget> data = bookmarks[metaData?.id]!.map((bookmark) {
        findWidth(widgetkey);
        double bookmarkPosition = bookmark.inSeconds.toDouble();
        double bookmarkWidth = (bookmarkPosition /
                audioPlayer.value.duration!.inSeconds.toDouble()) *
            width.value;
        return GestureDetector(
          onTap: () => audioPlayer.value.seek(bookmark),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 11.5.w,
                height: 20.0,
                margin: EdgeInsets.only(left: bookmarkWidth),
                // decoration: const BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage(
                //             "assets/PlaylistAssets/pin.png"))),
                child: SvgPicture.asset("assets/HomeAssets/pin.svg",
                    // color: bookmark.inSeconds >=
                    //         position!.position.inSeconds
                    //     ? Colors.white
                    //     : Colors.red,
                    theme: SvgTheme(
                      currentColor:
                          bookmark.inSeconds >= position!.position.inSeconds
                              ? Colors.white
                              : kColorPrimary,
                    )),
              ),
              Text("${bookmarkPosition.toInt().toString()}s",
                  style: kTextStylePoppinsRegular.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: kColorWhite)),
            ],
          ),
        );
      }).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  ConcatenatingAudioSource? audioSource() {
    audioPlayer.value.setAudioSource(AudioSource.uri(Uri.parse("uri")));
    audioPlayer.value.setAudioSource(playlist);
    return null;
  }
}

// class AudioHandler extends BaseAudioHandler with SeekHandler {
//   PlaybackState _transformEvent(PlaybackEvent event) {
//     return PlaybackState(
//       controls: [
//         MediaControl.rewind,
//         // if (_player.playing) MediaControl.pause else MediaControl.play,
//         MediaControl.stop,
//         MediaControl.fastForward,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       // processingState: const {
//       //   ProcessingState.idle: AudioProcessingState.idle,
//       //   ProcessingState.loading: AudioProcessingState.loading,
//       //   ProcessingState.buffering: AudioProcessingState.buffering,
//       //   ProcessingState.ready: AudioProcessingState.ready,
//       //   ProcessingState.completed: AudioProcessingState.completed,
//       // }[_player.processingState]!,
//       // playing: _player.playing,
//       // updatePosition: _player.position,
//       // bufferedPosition: _player.bufferedPosition,
//       // speed: _player.speed,
//       // queueIndex: event.currentIndex,
//     );
//   }
// }
