import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
//import 'package:lecle_volume_flutter/lecle_volume_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:subtitle/subtitle.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:yatharthageeta/routes/app_route.dart';
import 'package:yatharthageeta/services/network/network_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../models/video_details/video_details_model.dart';

// using ticker provider state as there are tabs in the screen for settings
class VideoPlayerSreenController extends GetxController
    with GetTickerProviderStateMixin {
  final networkService = Get.find<NetworkService>();

  // this was the testing link so ignore it
  final String link =
      "https://archive.org/`download`/srimad-devi-bhagavatam-raja-visuddhi-dharmasar/Srimad%20Devi%20Bha%CC%84gavatam%201.5.1%E2%80%94%20Story%20of%20Hayagri%CC%84va.mp4";

  // defining the controller variable as observable
   Rx<VideoPlayerController>? controller;

  // declaring the position and duration variable to show on progress bar
  var position = const Duration(seconds: 0).obs;
  var bufferedPosition = const Duration(seconds: 0).obs;
  var duration = const Duration(seconds: 0).obs;
  Duration oldPos = Duration.zero;

  // flag to check is playing or not
  RxBool isPlaying = false.obs;

  var sliderVal = 0.0.obs;
  // visibility check
  var isVisible = true.obs;
  // setting brightness and volume to full at start
  final setBrightness = 1.0.obs;
  final setVolumeValue = 1.0.obs;

  // setting is mute to false
  var isMute = false.obs;

  // the video can have episodes or can be a single video
  final isEpisode = false.obs;

  // visibility check for volume and brightness slider
  var volVisible = false.obs;
  var brightVisible = false.obs;

  // tab controller to control settings tab
  late TabController tabController;

  // setting the playback speed to 4 that is normal
  /*
  * 1 -> 0.25x
  * 2 -> 0.5x
  * 3 -> 0.75x
  * 4 -> 1x
  * 5 -> 1.25x
  * 6 -> 1.5x
  * 7 -> 1.75x
  * 8 -> 2x
  */
  var playback = 4.obs;

  // setting captions to empty array
  var caption = [].obs;

  // not in use currently but is used to change the subtitles
  var subVal = 0.obs;

  // initializing the MuxedSteamInfo as an observable list
  RxList<VideoStreamInfo> qualities = <VideoStreamInfo>[].obs;

  // setting the initial quality as full hd
  var qualityGroupValue = "Full HD upto 1080p".obs;

  // creating subtitle object
  Subtitle? currentSubtitle;

  // initializing volume controller object
  VolumeController volController = VolumeController();

  // initializing youtube explode for fetching the playable link of youtube video
  var yt = YoutubeExplode();

  // declaring the SteamManifest to store youtube video's metadata
  StreamManifest? manifest;

  // initializing the is initialized variable to false as it takes time to load
  var isInitialized = false.obs;

  // declaring a variable video details to store the details of the video which comes from api
  var videoDetails;

  // initializing the stream controller with a boolean object, it is used for maintaining the isPlaying state
  StreamController<bool> streamController = StreamController.broadcast();

  var id = "".obs;

  var internetGone = false.obs;

  // not in use currently but was used to format duration for captions
  Duration durationRangeToDuration(List<DurationRange> buffered) {
    Duration totalDuration = Duration.zero;
    Duration prevEnd = buffered.first.start;
    for (final range in buffered) {
      // Check if ranges overlap
      final overlap = prevEnd.compareTo(range.start);

      // Adjust for overlap
      if (overlap <= 0) {
        // totalDuration += range.start;
      } else {
        totalDuration += range.end - prevEnd;
      }

      prevEnd = range.end;
    }
    return totalDuration;
  }

  // get the metadata for youtube video and store it in a manifest file
  getUrls(String url) async {
    manifest =
        await yt.videos.streamsClient.getManifest(getYouTubeVideoId(url));
  }

  @override
  void onInit() async {
    log("init state called");
    log(Get.arguments.toString());

    // getting video details and isEpisodes from arguments
    videoDetails = Get.arguments['data'];
    isEpisode.value = Get.arguments['isEpisode'];

    // await Volume.initAudioStream(AudioManager.streamMusic);
    // setting volume controller to not show ui when volume is changed
    volController.showSystemUI = false;
    // var data = await Volume.getMaxVol;
    // log(data.toString());

    // setting volume controller to listen to changing volume level
    volController.listener((p0) {
      setVolumeValue.value = p0;
      log(setVolumeValue.value.toString());
      if (p0 == 0) {
        isMute.value = true;
      } else {
        isMute.value = false;
      }
    });
    log("videodetails are stored: ${videoDetails.toJson()}");
    log(videoDetails.title!);
    print(videoDetails.link);

    // setting device orientation to portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    initializeVideo();

    // listen network connection
    // isInitialized.value = false;

    // if (networkService.connectionStatus.value == 1) {
    //   log("Network connected initially");
    //   log("Video is Initialized");
    //   await initializeVideo();
    // }

    networkService.connectionStatus.listen((status) async {
      if (status == 1 && !(isInitialized.value) && Get.currentRoute == AppRoute.videoPlayerScreen) {
       log("\x1B[32mReinitializing the video");
          initializeVideo();
      }
    });

    // networkService.connectionStatus.listen((status) async {
    //   if (status == 0) {
    //     log("\x1B[32mNo Internet detected");

    //     if (!(internetGone.value) && isInitialized.value) {
    //       final remaningBuffer = bufferedPosition.value - Duration(seconds: 20);
    //       log("\x1B[32mRemaining buffer: ${remaningBuffer}");
    //       await Future.delayed(remaningBuffer);
    //       oldPos = position.value;
    //       if (controller.value.value.isPlaying) {
    //         log("Video player is stopped");
    //         controller.value.pause();
    //         internetGone.value = true;
    //       }
    //     }
    //   } else {
    //     if (internetGone.value) {
    //       await controller.value.seekTo(oldPos);
    //       controller.value.play();
    //       internetGone.value = false;
    //       log("Video player is start");
    //       log("Internet gone value : ${internetGone.value}");
    //     } else if (!isInitialized.value) {
    //       log("Reinitializing video...");
    //       await initializeVideo(); // Only reinitialize if video wasn't playing before
    //     }
    //   }
    // });

    super.onInit();
  }

  // initializing the video
  initializeVideo() async {
    isInitialized.value = false;
// fetching the metadata of the youtube video and storing it into manifest
    manifest = await yt.videos.streamsClient.getManifest(
        getYouTubeVideoId(videoDetails.link!),
        fullManifest: true,
        ytClients: [YoutubeApiClient.androidVr, YoutubeApiClient.ios]);
// accessing the qualities of the video and storing it in qualitites list
    qualities.value = manifest!.muxed.toList();
// print("qualities.value:${qualities.value}");
// print("manifest!.video.first:${manifest!.video.first.url.toString()}");
// print("manifest!.video.toList().first.videoCodec:${manifest!.video.toList().first.codec.mimeType.toString()}");
    Map<String, VideoStreamInfo> qualitiedFiltered = {};
// qualities.forEach((data){
// qualitiedFiltered.putIfAbsent(data.qualityLabel, ()=>data);
// });
// qualities.value = qualitiedFiltered.values.toList();
// removing the 144p quality as it was creating error
// manifest!.video.toList().first.qualityLabel == '144p+'
// ? qualities.remove(manifest!.video.toList().first)
// : null;
    print("--->$qualities");
// getting info of the best quality
    VideoStreamInfo streamInfo = manifest!.muxed.bestQuality;
// getting the url of the best quality video
    var url = streamInfo.url;
// initializing the video controller
    controller = VideoPlayerController.networkUrl(
      url,
      videoPlayerOptions: VideoPlayerOptions(),
    ).obs;
// when initialized then set the position and duration value and setting initialized flag to true
    controller!.value
      ..initialize().then((value) async {
        position.value = controller!.value.value.position;
        duration.value = controller!.value.value.duration;
        isInitialized.value = true;
        controller!.value.play();
        isPlaying.value = true;
        await controller!.value.setLooping(true);
      });
    controller!.value.value.isPlaying;
// adding a listener to set the position and duration value, also keeping tabs on isPlaying, if the value changes the stream forwards it to the widget
    controller!.value.addListener(() async {
      position.value = controller!.value.value.position;
      if (controller!.value.value.buffered.isNotEmpty) {
        bufferedPosition.value = controller!.value.value.buffered.last.end;
      } else {
        bufferedPosition.value = const Duration(seconds: 0); // Default value
      }
      sliderVal.value = position.value.inSeconds / duration.value.inSeconds;
      streamController.add(controller!.value.value.isPlaying);
      print("message ${sliderVal.value.toString()}");
      log("Current position value: ${position.value.toString()}");
      log("Buffered position value: ${bufferedPosition.value.toString()}");

      //print("${controller.value.value.duration.toString()} duration");
// if (position.value.inSeconds == duration.value.inSeconds) {
// print("Duration is equal");
// // isPlaying.value = false;
// }
    });
// listening the streamController to change the isPlaying state
    streamController.stream.listen((event) {
      this.isPlaying.value = event;
    });
// setting tab controller for settings menu
    tabController = TabController(length: 2, vsync: this);
// setting brightness and volume levels to max
    ScreenBrightness()
        .current
        .then((brightness) => setBrightness.value = brightness);
    VolumeController()
        .getVolume()
        .then((volume) => setVolumeValue.value = volume);
    setVolumeValue.value == 0 ? isMute.value = true : isMute.value = false;
// this was for subtitles but currently not in use
    controller!.value.addListener(() {
      if (caption.isNotEmpty) {
        currentSubtitle = getSubtitleForCurrentPosition(position.value);
// print("---->${currentSubtitle!.data}");
      }
    });
  }

  @override
  void onClose() {
    controller!.value.pause();
    controller!.value.dispose();
    super.onClose();
  }

  // fetching the id of youtube video from the url
  String getYouTubeVideoId(String url) {
    final List data = url.split("v=");
    return data[1];
  }

  // formatting the duration (currently not in use i feel)
  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  // getting the subtitle for the current position of the video
  Future<List> getCloseCaptionFile(url) async {
    try {
      final data = await http.get(Uri.parse(url));
      final srtContent = data.body.toString().trim();
      var lines = srtContent.split('\n');
      // var subtitles = <String, String>{};
      // print("---->${lines.length}");
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
          // print("---->${subtitles.length}");
        }
        // print("---->${subtitles.length}");
      }
      return subtitles;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  // parsing the duration of the subtitles
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

  Subtitle? getSubtitleForCurrentPosition(Duration position) {
    // print("----->${caption.value.length}");
    // ignore: invalid_use_of_protected_member
    for (var subtitle in caption.value) {
      // print("----->${subtitle.start}---${subtitle.end}");
      if (position >= subtitle.start && position <= subtitle.end) {
        return subtitle;
      }
    }
    return null;
  }
}
