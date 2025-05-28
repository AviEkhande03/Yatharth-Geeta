import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class DescriptionTextWidget extends StatefulWidget {
  const DescriptionTextWidget({
    required this.description,
    super.key,
  });

  final String description;

  @override
  DescriptionTextWidgetState createState() => DescriptionTextWidgetState();
}

class DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf = '';
  String secondHalf = '';

  bool flag = true;

  @override
  void initState() {
    super.initState();
    updateDescription(widget.description);
  //   if (widget.description.length > 50) {
  //     firstHalf = widget.description.substring(
  //         0, widget.description.length > 155 ? 155 : widget.description.length);
  //     secondHalf = widget.description.substring(
  //         widget.description.length > 155 ? 155 : widget.description.length,
  //         widget.description.length);
  //   } else {
  //     firstHalf = widget.description;
  //     secondHalf = "";
  //   }
  }

  @override
  void didUpdateWidget(DescriptionTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.description != widget.description) {
      updateDescription(widget.description);
    }
  }


  void updateDescription(String description) {
    if (description.length > 50) {
      firstHalf = description.substring(0, description.length > 155 ? 155 : description.length);
      secondHalf = description.substring(description.length > 155 ? 155 : description.length, description.length);
    } else {
      firstHalf = description;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("description:${widget.description}");
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
      ),
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              style: kTextStylePoppinsRegular.copyWith(
                fontSize: FontSize.detailsScreenMediaDesc.sp,
                color: kColorBlackWithOpacity75,
              ),
            )
          : Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: kTextStylePoppinsRegular.copyWith(
                      fontSize: FontSize.detailsScreenMediaDesc.sp,
                      color: kColorBlackWithOpacity75,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: flag ? " Read more".tr : " Read less".tr,
                        style: kTextStylePoppinsMedium.copyWith(
                          fontSize: FontSize.detailsScreenMediaDesc.sp,
                          color: kColorBlack,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => setState(
                                () {
                                  flag = !flag;
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

}
