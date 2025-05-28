import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../const/text_styles/text_styles.dart';
import '../../services/bottom_app_bar/bottom_app_bar_services.dart';
import '../../utils/utils.dart';
import 'text_poppins.dart';
import 'text_rosario.dart';

class SortFilter extends StatelessWidget {
  final String type;

  const SortFilter(
      {Key? key,
      required this.tabIndex,
      required this.sortList,
      required this.type,
      required this.onTap})
      : super(key: key);
  final RxInt tabIndex;
  final List sortList;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        height: 340.h,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 36.h, left: 28.w, right: 28.w),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                    child: TextRosario(
                      text: "Sort By".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: FontSize.searchFilterHeading.sp,
                    ),
                  )),
                  InkWell(
                      onTap: () => Get.back(),
                      child: SizedBox(
                          child: SvgPicture.asset("assets/icons/cross.svg")))
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(child: sortFilter(sortList)),
            Container(
              padding: EdgeInsets.only(
                  left: 24.w, right: 24.w, top: 24.h, bottom: 24.h),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      Utils().showLoader();
                      for (var i = 0; i < sortList.length; i++) {
                        sortList[i]["groupValue"].value = sortList[0]['value'];
                      }
                      await onTap(
                          token: Get.find<BottomAppBarServices>().token.value,
                          body: <String, String>{
                            "type": Utils()
                                .getMediaTypeBasedOnTab(tabMediaTitle: type.tr)
                          },
                          ctx: context,
                          type: Utils()
                              .getMediaTypeBasedOnTab(tabMediaTitle: type.tr));
                      Get.back();
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kColorWhite,
                          border: Border.all(color: kColorPrimary, width: 1.sp),
                          borderRadius: BorderRadius.circular(200.r)),
                      child: Text(
                        "Reset".tr,
                        style: kTextStylePoppinsRegular.copyWith(
                            color: kColorPrimary,
                            fontSize: FontSize.searchFilterButtons.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 24.w,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      Map<String, String> body = {};
                      for (var element in sortList) {
                        if (element["value"] == element["groupValue"].value) {
                          body["type"] = Utils()
                              .getMediaTypeBasedOnTab(tabMediaTitle: type.tr);
                          body["order_by"] = element["order_by"];
                          body["sort_by"] = element["sort_by"];
                        }
                      }
                      print(body);
                      await onTap(
                          token: Get.find<BottomAppBarServices>().token.value,
                          body: body,
                          ctx: context,
                          type: Utils()
                              .getMediaTypeBasedOnTab(tabMediaTitle: type.tr));
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kColorPrimary,
                          border: Border.all(color: kColorPrimary, width: 1.sp),
                          borderRadius: BorderRadius.circular(200.r)),
                      child: Text(
                        "Apply".tr,
                        style: kTextStylePoppinsRegular.copyWith(
                            color: kColorWhite,
                            fontSize: FontSize.searchFilterButtons.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget sortFilter(sortList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Obx(
          () => RadioListTile(
              visualDensity: const VisualDensity(vertical: -4),
              groupValue: sortList[index]["groupValue"].value,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: kColorPrimary,
              title: TextPoppins(
                text: sortList[index]["title"],
                color: sortList[index]["value"] ==
                        sortList[index]["groupValue"].value
                    ? kColorPrimary
                    : kColorFont,
                fontSize: FontSize.searchFilterContent.sp,
                fontWeight: FontWeight.w500,
              ),
              value: sortList[index]["value"],
              onChanged: (val) {
                sortList[index]["groupValue"].value = val;
              }),
        );
      },
      itemCount: sortList.length,
    );
  }
}
