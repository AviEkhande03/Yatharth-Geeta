import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/audio_player/player_controller.dart';
import '../../models/explore/explore_model.dart';
import '../../routes/app_route.dart';
import '../../utils/utils.dart';

class AudioBooksListHomeWidget extends StatelessWidget {
  const AudioBooksListHomeWidget({
    required this.audioBooksList,
    super.key,
  });

  final List<CollectionDatum> audioBooksList;

  @override
  Widget build(BuildContext context) {
    return audioBooksList != []
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
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
                          audioBooksList[index].audioFileUrl!,
                        ),
                        tag: MediaItem(
                            id: "1",
                            title: audioBooksList[index].title!,
                            displaySubtitle: "Verse 1",
                            displayTitle: audioBooksList[index].authorName!,
                            extras: {
                              "lyrics": "",
                              "type": "Audio",
                              "file": audioBooksList[index].audioFileUrl!,
                            },
                            artist: audioBooksList[index].authorName!,
                            artUri: Uri.parse(
                                audioBooksList[index].audioCoverImageUrl!),
                            duration: Duration(
                                seconds: audioBooksList[index].duration!)))
                  ]);
                  controller.audioPlayer.value
                      .setAudioSource(controller.playlist);
                  controller.audioPlayer.value.setLoopMode(LoopMode.off);
                  controller.loopMode.value = 0;
                  Get.back();
                  Get.toNamed(AppRoute.audioPlayerScreen);
                  audioBooksList[index].audioFileUrl!;
                },
                child: Container(
                  // color: Colors.green,
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
                                  image: NetworkImage(audioBooksList[index]
                                      .audioCoverImageUrl!),
                                  fit: BoxFit.fill,
                                  placeholderFit: BoxFit.scaleDown,
                                  placeholder: const AssetImage(
                                      "assets/icons/default.png"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        "assets/icons/default.png");
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Container(
                                // color: Colors.red,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        audioBooksList[index].title!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStylePoppinsMedium.copyWith(
                                          fontSize: FontSize.mediaTitle.sp,
                                          color: kColorBlack,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),

                                    //Language and Duration Tag
                                    Container(
                                      // height: 18.h,
                                      padding: EdgeInsets.only(
                                          left: 12.w, right: 12.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                        color: kColorFontLangaugeTag
                                            .withOpacity(0.05),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            audioBooksList[index].durationTime!,
                                            style: kTextStylePoppinsRegular
                                                .copyWith(
                                              fontSize:
                                                  FontSize.mediaLanguageTags.sp,
                                              color: kColorFontLangaugeTag,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20.w),
                                height: 24.h,
                                width: 24.h,
                                child: Image.asset(
                                  'assets/images/home/music.png',
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50.w),
                        child: Divider(
                          height: 1.h,
                          color: kColorFont.withOpacity(0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10.h,
              );
            },
            itemCount: audioBooksList.length,
          )
        : const SizedBox();
  }
}
