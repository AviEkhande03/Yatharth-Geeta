import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yatharthageeta/const/colors/colors.dart';
import 'package:yatharthageeta/controllers/audio_player/player_controller.dart';

class Controls extends StatefulWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
    required this.internetGone,
  });
  final AudioPlayer audioPlayer;
  final bool internetGone;

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  var controller = Get.find<PlayerController>();
  var waitingBuffer;

  // VAIBHVA CODE -- 04/03/25
  // handle buffer on no intenert senario

  @override
  void initState() {
    super.initState();

    // Network listener
    controller.networkService.connectionStatus.listen((status) async {
      log("\x1B[32mNetwork Status Changed: $status");

      controller.noInternet.value = status;

      if (controller.closeMiniPlayer) {
        controller.closeMiniPlayer = false;
        controller.audioPlayer.value.stop();
        log("\x1B[32mMini player was closed, not resuming playback.");
        return;
      }

      if (status == 0) {
        log("\x1B[32mInternet Gone Value: ${controller.noInternet.value}");

        log("\x1B[32mNo Internet detected");

        log("\x1B[32mcurrent position: ${controller.position.value}");
        log("\x1B[32mbuffered position: ${controller.bufferedPosition.value}");
        final remaningBuffer =
            controller.bufferedPosition.value - controller.position.value;
        log("\x1B[32mRemaining buffer: ${remaningBuffer}");

        if (!(controller.internetGone.value)) {
          await Future.delayed(remaningBuffer);
          if (controller.noInternet.value != 0) {
            log("\x1B[32mInternet is back before delay finished, skipping pause");
            return;
          }

          controller.isBufferComplete = true;
          log("\x1B[32mCondition met!");
          controller.oldPos = controller.position.value;
          log("\x1B[32m\x1B[32mOld Position: ${controller.oldPos}");
          if (widget.audioPlayer.playing) {
            widget.audioPlayer.pause();
          }
          log("\x1B[32mPaused due to no internet");

          controller.internetGone.value = true;
          log("\x1B[32mInternet gone value updated: ${controller.internetGone.value}");
        }
      } else {
        if (controller.internetGone.value) {
          controller.isBufferComplete = false;
          log("\x1B[32mInternet is back, resuming playback...");
          log("\x1B[32mOld Position: ${controller.oldPos}");
          await widget.audioPlayer.seek(controller.oldPos);
          widget.audioPlayer.play();
          controller.internetGone.value = false;
          log("\x1B[32mInternet gone value updated: ${controller.internetGone.value}");
          return;
        }
      }
    });

    //Position listener
    widget.audioPlayer.positionStream.listen((event) {
      if (event.inSeconds == 0 && controller.position.value.inSeconds > 0) {
        log("\x1B[31mIgnoring unexpected reset to zero.");
        return;
      }
      log("\x1B[32mCurrent position updated: $event");
      controller.position.value = event;
    });

    // buffer listener to listen updated buffer position
    widget.audioPlayer.bufferedPositionStream.listen((buffered) {
      if (buffered > Duration.zero) {
        log("\x1B[32mBuffered position updated: $buffered");
        controller.bufferedPosition.value = buffered;
      }
    });
  }

  // -- Shoyeb code --

  @override
  Widget build(BuildContext context) {
    log("Internet Status: ${controller.internetGone.value}");

    return Obx(() {
      // Using Obx to listen to changes
      if (controller.internetGone.value) {
        return Center(
          child: CircularProgressIndicator(color: kColorPrimary),
        );
      }

      return StreamBuilder<PlayerState>(
        stream: widget.audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing ?? false;
          log("Playing state: $playing");

          bool isDisabled = controller.internetGone.value;

          if (!playing) {
            return GestureDetector(
              onTap: isDisabled ? null : () => widget.audioPlayer.play(),
              child: Opacity(
                opacity: isDisabled ? 0.5 : 1.0,
                child: SvgPicture.asset("assets/icons/play.svg"),
              ),
            );
          } else if (processingState != ProcessingState.completed) {
            return GestureDetector(
              onTap: isDisabled ? null : () => widget.audioPlayer.pause(),
              child: Opacity(
                opacity: isDisabled ? 0.5 : 1.0,
                child: SvgPicture.asset("assets/icons/pause.svg"),
              ),
            );
          }

          return SvgPicture.asset("assets/icons/play.svg");
        },
      );
    });
  }
}
