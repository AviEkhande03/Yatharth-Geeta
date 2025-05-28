import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../models/explore/satsang_model.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';

class PravachansList extends StatelessWidget {
  const PravachansList({
    this.audioBooksList = const [],
    super.key,
  });

  final List<Result> audioBooksList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            var controller = Get.put(PlayerController());
            Utils().showLoader();
            controller.singleAudio.value = true;
            controller.isShloka.value = false;
            controller.shlokaCheck(
                shlokaValue: false,
                hasPrevious: false,
                hasNext: false,
                hasCurrent: false);
            controller.playlist = ConcatenatingAudioSource(children: [
              AudioSource.uri(
                  Uri.parse(
                    audioBooksList[index].satsangFileUrl!,
                  ),
                  tag: MediaItem(
                      id: "1",
                      title: audioBooksList[index].title!,
                      displaySubtitle: "Verse 1",
                      displayTitle: audioBooksList[index].authorName!,
                      extras: {
                        "lyrics": "",
                        "file": audioBooksList[index].satsangFileUrl!,
                        // "type": "Pravachan",
                        "type": "Audio",
                      },
                      artist: audioBooksList[index].authorName!,
                      artUri: Uri.parse(
                          audioBooksList[index].satsangCoverImageUrl!),
                      duration:
                          Duration(seconds: audioBooksList[index].duration!)))
            ]);
            controller.audioPlayer.value.setAudioSource(controller.playlist);
            await controller.audioPlayer.value.setLoopMode(LoopMode.off);
            controller.loopMode.value = 0;
            Get.back();
            Get.toNamed(AppRoute.audioPlayerScreen);
            audioBooksList[index].satsangFileUrl!;
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: 50.h,
                        child: FadeInImage(
                          image: NetworkImage(
                              audioBooksList[index].satsangCoverImageUrl!),
                          fit: BoxFit.fill,
                          placeholderFit: BoxFit.scaleDown,
                          placeholder:
                              const AssetImage("assets/icons/default.png"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset("assets/icons/default.png");
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      SizedBox(
                        width: width * 0.6,
                        // color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              audioBooksList[index].title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kTextStylePoppinsMedium.copyWith(
                                fontSize: FontSize.mediaTitle.sp,
                                color: kColorBlack,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),

                            //Language and Duration Tag
                            Row(
                              children: [
                                Container(
                                  // height: 18.h,
                                  // width: 150.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.h),
                                    color:
                                        kColorFontLangaugeTag.withOpacity(0.05),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${audioBooksList[index].durationTime} | ${audioBooksList[index].mediaLanguage!}',
                                    style: kTextStylePoppinsRegular.copyWith(
                                      fontSize: FontSize.mediaLanguageTags.sp,
                                      color: kColorFontLangaugeTag,
                                    ),
                                  ),
                                ),
                                const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.w),
                    height: 24.h,
                    width: 24.h,
                    child: Image.asset(
                      'assets/images/home/music.png',
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              index != audioBooksList.length - 1
                  ? Container(
                      margin: EdgeInsets.only(left: 50.w),
                      child: Divider(
                        height: 1.h,
                        color: kColorFont.withOpacity(0.15),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10.h,
        );
      },
      itemCount: audioBooksList.length,
    );
  }
}
