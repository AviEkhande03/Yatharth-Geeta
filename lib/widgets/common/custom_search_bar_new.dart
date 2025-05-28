import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../const/colors/colors.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/searchbar/searchbar_controller.dart';
import '../../services/language/language_service.dart';

import '../../services/bottom_app_bar/bottom_app_bar_services.dart';

class CustomSearchBarNew extends StatefulWidget {
  const CustomSearchBarNew({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.labelText,
    this.hintText,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.errorMaxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.textInputType = TextInputType.text,
    this.prefixIconConstraints,
    this.contentPadding,
    this.radius = 16.0,
    this.initialValue,
    this.textAlignVertical,
    required this.filterAvailable,
    this.filterBottomSheet,
    this.fillColor,
    this.filled = false,
    this.hasMic = true,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool filterAvailable;
  final Widget? filterBottomSheet;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final String? labelText;
  final String? hintText;
  final TextStyle? style;
  final bool hasMic;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final int? errorMaxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsets? contentPadding;
  final double radius;
  final String? initialValue;
  final TextAlignVertical? textAlignVertical;
  final bool filled;
  final Color? fillColor;

  @override
  State<CustomSearchBarNew> createState() => _CustomSearchBarNewState();
}

class _CustomSearchBarNewState extends State<CustomSearchBarNew> {
  final bottomAppService = Get.find<BottomAppBarServices>();
  //Get.lazyPut(()=>SearchBarController());
  late SpeechToText speechToText = SpeechToText();
  //var isListening = false;

  @override
  void initState() {
    debugPrint("Widget built");
    super.initState();
    Get.lazyPut(() => SearchBarController());
    bottomAppService.isCustomSearchBarNewDisposed.value = false;
    // debugPrint(
    //     "bottomAppService.isCustomSearchBarNewDisposed.value in init:${bottomAppService.isCustomSearchBarNewDisposed.value}");

    // speechToText = SpeechToText();
    // isListening = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // super.build(context);
    // debugPrint(
    //     "Get.find<LangaugeService>().currentLocale.toString()${Get.find<LangaugeService>().currentLocale.toString()}");
    //debugPrint("mounted:$mounted");
    // var isListening = false;
    // debugPrint("isListening:$isListening");

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: kColorFontOpacity25, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(16.r))),
      child: Row(children: [
        Expanded(
          child: TextFormField(
            maxLines: 1,
            style: kTextStylePoppinsRegular.copyWith(
              // color: kColorFontOpacity25,
              fontSize: 18.sp,
            ),
            controller: widget.controller,
            initialValue: widget.initialValue,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: widget.onEditingComplete,
            textAlignVertical: widget.textAlignVertical,
            cursorWidth: 1.w,
            onSaved: widget.onSaved,
            // expands: true,
            keyboardType: widget.textInputType,
            decoration: InputDecoration(
              fillColor: widget.fillColor,
              isDense: true,
              // isCollapsed: false,
              filled: widget.filled,
              hintText: widget.hintText,
              labelStyle: widget.labelStyle,
              hintStyle: widget.hintStyle,
              labelText: widget.labelText,
              contentPadding: widget.contentPadding,
              errorStyle: widget.errorStyle,
              errorMaxLines: widget.errorMaxLines,
              prefixIconConstraints: widget.prefixIconConstraints,
              prefixIcon: Container(
                //color: Colors.red,
                alignment: Alignment.center,
                width: screenWidth >= 600 ? 50.h : 30.h,
                height: screenWidth >= 600 ? 50.h : 30.h,
                child: SvgPicture.asset(
                  "assets/icons/search.svg",
                  // fit: BoxFit.fill,
                  // clipBehavior: Clip.hardEdge,
                  width: screenWidth >= 600 ? 35.h : 30.h,
                  height: screenWidth >= 600 ? 35.h : 30.h,
                ),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.r)),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 0.0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: widget.filterAvailable,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      builder: (context) => widget.filterBottomSheet!,
                      isScrollControlled: true);
                },
                child: SvgPicture.asset(
                  width: screenWidth > 600 ? 30.w : 28.w,
                  "assets/icons/filter.svg",
                ),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            !widget.hasMic
                ? SizedBox.shrink()
                : Obx(
                    () => AvatarGlow(
                      endRadius: 16.r,
                      glowColor: kColorPrimary,
                      repeat: true,
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      showTwoGlows: true,
                      animate:
                          Get.find<SearchBarController>().isListening.value,
                      child: GestureDetector(
                        onTap: () async {
                          if (!Get.find<SearchBarController>()
                              .isListening
                              .value) {
                            //debugPrint("mounted before:$mounted");
                            var available = await speechToText.initialize(
                                onError: errorListener,
                                onStatus: statusListener);
                            //debugPrint("available:$available");

                            if (available) {
                              Get.find<SearchBarController>()
                                  .isListening
                                  .value = true;
                              //debugPrint("isListening:$isListening");
                              speechToText.listen(
                                  listenFor: const Duration(seconds: 30),
                                  pauseFor: const Duration(seconds: 3),
                                  onResult: (result) {
                                    debugPrint(
                                        "result.recognizedWords:${result.recognizedWords}");
                                    widget.controller?.text =
                                        result.recognizedWords;
                                    //debugPrint("widget.micController?.searchQuery.value${widget.micController?.searchQuery.value}");
                                  },
                                  localeId: Get.find<LangaugeService>()
                                      .currentLocale
                                      .toString());
                            }
                          } else {
                            Get.find<SearchBarController>().isListening.value =
                                false;
                            speechToText.stop();
                          }
                        },
                        child: SvgPicture.asset(
                            Get.find<SearchBarController>().isListening.value
                                ? "assets/icons/listening_mic.svg"
                                : "assets/icons/mic.svg",
                            width: screenWidth > 600 ? 30.w : 28.w),
                      ),
                    ),
                  ),
            SizedBox(
              width: 10.w,
            )
          ],
        )
      ]),
    );
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    debugPrint(': $eventTime $eventDescription');
  }

  void errorListener(SpeechRecognitionError error) {
    debugPrint("Inside errorListener");
    debugPrint("mounted inside errorListener:$mounted");
    _logEvent(
        'MicError:Received error status: $error, listening: ${speechToText.isListening}');
    Get.find<SearchBarController>().isListening.value = false;
    // if (mounted) {
    //   // debugPrint("mounted inside errorListener:$mounted");
    //   // _logEvent(
    //   //     'MicError:Received error status: $error, listening: ${speechToText.isListening}');
    //   setState(() {
    //     isListening = false;
    //   });
    // } else {
    //   debugPrint("Not mounted.");
    // }
  }

  void statusListener(String status) {
    debugPrint("Inside statusListener");
    debugPrint("mounted inside statusListener:$mounted");
    _logEvent(
        'MicError:Received listener status: $status, listening: ${speechToText.isListening}');
    if (status == "done") {
      Get.find<SearchBarController>().isListening.value = false;
    }
    // if (mounted) {
    //   // _logEvent(
    //   //     'MicError:Received listener status: $status, listening: ${speechToText.isListening}');
    //   if (status == "done") {
    //     setState(() {
    //       isListening = false;
    //     });
    //   }
    // } else {
    //   debugPrint("Not mounted.");
    // }
  }

  @override
  void dispose() {
    //isListening = false;
    speechToText.stop();
    // widget.controller?.removeListener(() {
    //   log("Removed Listener");
    // });
    // widget.controller?.clear();
    Get.find<SearchBarController>().isListening.value = false;
    widget.controller?.text = "";
    bottomAppService.isCustomSearchBarNewDisposed.value = true;
    debugPrint("onDispose in listening");
    super.dispose();
  }
// @override
// bool get wantKeepAlive => true;
}
