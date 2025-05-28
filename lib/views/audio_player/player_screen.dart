import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/const/constants/constants.dart';
import 'package:yatharthageeta/const/text_styles/text_styles.dart';
import '../../const/colors/colors.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../controllers/audio_player/player_view_controller.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../widgets/audio_player/player.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    PlayerViewController controller = Get.find<PlayerViewController>();

    return WillPopScope(
      onWillPop: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        Get.find<BottomAppBarServices>().miniplayerVisible.value = true;
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          elevation: 0,
          leading: InkWell(
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/back.svg",
                width: 24.w,
                color: kColorWhite,
              ),
            ),
            onTap: () {
              Get.find<BottomAppBarServices>().miniplayerVisible.value = true;
              Get.back();
            },
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Get.find<PlayerController>().showFrontSide.value =
          //             !Get.find<PlayerController>().showFrontSide.value;
          //       },
          //       icon: const Icon(Icons.lyrics))
          // ],
          title: StreamBuilder(
              stream: Get.find<PlayerController>()
                  .audioPlayer
                  .value
                  .sequenceStateStream,
              builder: (context, snapshot) {
                if (snapshot.data?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                MediaItem metadata =
                    snapshot.data?.currentSource?.tag as MediaItem;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 50.w),
                      width: width * 0.75,
                      child: Text(
                        Get.find<PlayerController>().isShloka.value
                            ? "${"From".tr} “${metadata.displayTitle}”"
                            : "${"From".tr} “${metadata.artist}”",
                        maxLines: 1,
                        style: kTextStylePoppinsMedium.copyWith(
                            fontSize: 16.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: kColorWhite),
                      ),
                    ),
                  ],
                );
              }),
          // centerTitle: true,
        ),
        backgroundColor: const Color(0xff1c1b1b),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Player(index: 0, duration: Duration.zero),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }
}
