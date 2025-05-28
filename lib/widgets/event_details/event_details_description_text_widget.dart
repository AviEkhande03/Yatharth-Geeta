import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';

class EventDetailsDescriptionTextWidget extends StatefulWidget {
  const EventDetailsDescriptionTextWidget({
    required this.description,
    super.key,
  });

  final String description;

  @override
  EventDetailsDescriptionTextWidgetState createState() =>
      EventDetailsDescriptionTextWidgetState();
}

class EventDetailsDescriptionTextWidgetState
    extends State<EventDetailsDescriptionTextWidget> {
  String firstHalf = '';
  String secondHalf = '';

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.description.length > 700) {
      firstHalf = widget.description.substring(0, 700);
      secondHalf = widget.description.substring(700, widget.description.length);
    } else {
      firstHalf = widget.description;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf.isEmpty
        ? Text(
            firstHalf,
            style: kTextStylePoppinsRegular.copyWith(
              fontSize: FontSize.detailsScreenEventDesc.sp,
              color: kColorBlackWithOpacity75,
            ),
          )
        : Column(
            children: <Widget>[
              Text(
                flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                style: kTextStylePoppinsRegular.copyWith(
                  fontSize: FontSize.detailsScreenEventDesc.sp,
                  color: kColorBlackWithOpacity75,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          flag = !flag;
                        },
                      );
                    },
                    child: Text(
                      flag ? "More".tr : "Less".tr,
                      style: kTextStylePoppinsMedium.copyWith(
                        fontSize: FontSize.detailsScreenEventDescMore.sp,
                        color: kColorPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: kColorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
