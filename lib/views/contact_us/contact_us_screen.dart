import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/startup/startup_controller.dart';
import '../../const/colors/colors.dart';
import '../../const/constants/constants.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/contact_us/contact_us_controller.dart';
import '../../utils/validations_mixin.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_textfield_widget.dart';
import '../../widgets/common/text_poppins.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget with ValidationsMixin {
  ContactUsScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final contactUsScreenController = Get.find<ContactUsController>();
    final startUpController = Get.find<StartupController>();
    return Container(
      color: kColorWhite,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              CustomAppBar(
                title: "Contact Us".tr,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/shiva.png",
                              fit: BoxFit.fill,
                              width: width,
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            TextPoppins(
                              text: "Contact Form".tr,
                              fontSize: FontSize.contactTitle.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                                padding:
                                    EdgeInsets.only(left: 24.w, right: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextPoppins(
                                      text: "Name".tr,
                                      fontWeight: FontWeight.w400,
                                      fontSize: FontSize.contactInpTitle.sp,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    CustomTextfieldWidget(
                                      hintText: "Enter Your Name".tr,
                                      textInputType: TextInputType.name,
                                      validator: validatedName,
                                      hintStyle: TextStyle(
                                          color: const Color(0xff8A8783),
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      style: TextStyle(
                                          color: kColorFont,
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      errorStyle: TextStyle(
                                        fontSize: FontSize.validationMessage.sp,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                      controller:
                                          contactUsScreenController.name,
                                      // labelText: "Name",
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                                padding:
                                    EdgeInsets.only(left: 24.w, right: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextPoppins(
                                      text: "Email".tr,
                                      fontWeight: FontWeight.w400,
                                      fontSize: FontSize.contactInpTitle.sp,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    CustomTextfieldWidget(
                                      hintText: "Enter Your Email".tr,
                                      validator: validatedEmail,
                                      textInputType: TextInputType.emailAddress,
                                      hintStyle: TextStyle(
                                          color: const Color(0xff8A8783),
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      style: TextStyle(
                                          color: kColorFont,
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      errorStyle: TextStyle(
                                        fontSize: FontSize.validationMessage.sp,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                      controller:
                                          contactUsScreenController.email,
                                      // labelText: "Name",
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                                padding:
                                    EdgeInsets.only(left: 24.w, right: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextPoppins(
                                      text: "Subject".tr,
                                      fontWeight: FontWeight.w400,
                                      fontSize: FontSize.contactInpTitle.sp,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    CustomTextfieldWidget(
                                      hintText: "Enter Your Subject".tr,
                                      validator: validatedSubject,
                                      textInputType: TextInputType.text,
                                      hintStyle: TextStyle(
                                          color: const Color(0xff8A8783),
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      style: TextStyle(
                                          color: kColorFont,
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      errorStyle: TextStyle(
                                        fontSize: FontSize.validationMessage.sp,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                      controller:
                                          contactUsScreenController.subject,
                                      // labelText: "Name",
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                                padding:
                                    EdgeInsets.only(left: 24.w, right: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextPoppins(
                                      text: "Message".tr,
                                      fontWeight: FontWeight.w400,
                                      fontSize: FontSize.contactInpTitle.sp,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    CustomTextfieldWidget(
                                      maxLines: 5,
                                      textInputType: TextInputType.multiline,
                                      hintText: "Type Your Message Here".tr,
                                      validator: validatedDesc,
                                      hintStyle: TextStyle(
                                          color: const Color(0xff8A8783),
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      style: TextStyle(
                                          color: kColorFont,
                                          fontSize: FontSize.contactInpTitle.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400),
                                      errorStyle: TextStyle(
                                        fontSize: FontSize.validationMessage.sp,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                      controller:
                                          contactUsScreenController.message,
                                      // labelText: "Name",
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 24.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  contactUsScreenController.validate();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 36.w,
                                    right: 36.w,
                                    top: 16.h,
                                    bottom: 16.h),
                                decoration: BoxDecoration(
                                    color: kColorPrimary,
                                    borderRadius: BorderRadius.circular(200.r)),
                                child: TextPoppins(
                                  text: "Send Message".tr,
                                  color: kColorWhite,
                                  fontSize: FontSize.contactInpTitle.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              height: 16.h,
                              color: kColorWhite2,
                            ),
                            SizedBox(
                              height: 36.h,
                            ),
                            TextPoppins(
                              text: "or Contact us via".tr,
                              fontSize: FontSize.contactTitle.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: 36.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        "tel://${contactUsScreenController.contactUsDetails.systemContactNo}"));
                                  },
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/call.svg",
                                        width: 78.w,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextPoppins(
                                        text: contactUsScreenController
                                            .contactUsDetails.systemContactNo!,
                                        fontSize: FontSize.contactInpTitle.sp,
                                        fontWeight: FontWeight.w400,
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        "mailto://${contactUsScreenController.contactUsDetails.systemEmail}"));
                                  },
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/email.svg",
                                        width: 78.w,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextPoppins(
                                        text: contactUsScreenController
                                            .contactUsDetails.systemEmail!,
                                        fontSize: FontSize.contactInpTitle.sp,
                                        fontWeight: FontWeight.w400,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 24.w, right: 24.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset("assets/icons/mandir.png"),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      TextPoppins(
                                        text: contactUsScreenController
                                            .contactUsDetails.address!,
                                        fontSize: FontSize.contactTitle.sp,
                                        fontWeight: FontWeight.w500,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(contactUsScreenController
                                          .createCoordinatedUrl(
                                              contactUsScreenController
                                                  .contactUsDetails.latitude
                                                  .toString(),
                                              contactUsScreenController
                                                  .contactUsDetails.longitude
                                                  .toString(),
                                              ''));
                                    },
                                    child:
                                        // Image.asset(
                                        //   "assets/images/map.png",
                                        //   fit: BoxFit.fill,
                                        //   width: width,
                                        // ),
                                        FadeInImage(
                                      image: NetworkImage(startUpController
                                          .startupData
                                          .first
                                          .data!
                                          .result!
                                          .mapImage!
                                          .toString()),
                                      fit: BoxFit.cover,
                                      placeholderFit: BoxFit.scaleDown,
                                      placeholder: AssetImage(
                                          "assets/icons/default.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            "assets/icons/default.png");
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
