import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../controllers/change_password/change_password_controller.dart';
import '../../const/font_size/font_size.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/input_textfield.dart';
import '../../widgets/common/text_poppins.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final changePasswordController = Get.find<ChangePasswordController>();
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: kColorWhite));
    return Container(
      color: kColorWhite,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          /*appBar:
          AppBar(
            centerTitle: true,
            title: TextRosario(
              text: "Change Password".tr,
              fontSize: 24.sp,
              color: kColorFont,
              fontWeight: FontWeight.w400,
            ),
            leading: GestureDetector(
              onTap:(){
                Get.back();
              },
              child: Center(
                child: SizedBox(
                  width: 24.h,
                  height: 24.h,
                  child: SvgPicture.asset(
                      'assets/icons/back.svg'
                  ),
                ),
              ),
            ),
          )
          */ /*PreferredSize(
            preferredSize: Size.fromHeight(112.h),
            child: Container(
              color: kColorWhite,
              height: 112.h,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:24.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/icons/back.svg'
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextRosario(
                      text: "Change Password",
                      fontSize: 24.sp,
                      color: kColorFont,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),*/ /*,*/
          backgroundColor: kColorWhite2,
          body: SingleChildScrollView(
            child: Obx(
              () => Column(
                children: [
                  /*Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: kColorWhite,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          top: 12.h,
                          bottom: 12.h,
                        ),
                        child: Text(
                          'Change Password'.tr,
                          style: kTextStyleRosarioRegular.copyWith(
                            color: kColorFont,
                            fontSize: FontSize.changePasswordTitle.sp,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 24.w),
                            height: 24.h,
                            width: 24.h,
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset('assets/icons/back.svg')),
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  CustomAppBar(
                    title: "Change Password".tr,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0.h),
                    child: Container(
                      color: kColorWhite,
                      padding: EdgeInsets.only(top: 24.0.h, bottom: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Padding(
                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                            child: InputFormField(
                              hintText: 'Enter Old Password'.tr,
                              leftIconPath: 'assets/icons/lock-open.svg',
                              controller: changePasswordController.oldPswd,
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 13.0.w),
                                child: InkWell(
                                    onTap: () {
                                      changePasswordController
                                              .isOldPassWordDisabled.value =
                                          !changePasswordController
                                              .isOldPassWordDisabled.value;
                                    },
                                    child: SvgPicture.asset(
                                        changePasswordController
                                                .isOldPassWordDisabled.value
                                            ? 'assets/icons/eye-crossed.svg'
                                            : 'assets/icons/eye.svg')),
                              ),
                              obscureText: changePasswordController
                                  .isOldPassWordDisabled.value,
                              maxLength: 6,
                            ),
                          ),
                          Obx(
                            () => changePasswordController
                                        .oldPswdValidation?.value !=
                                    ''
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(top: 2.0.h, left: 55.w),
                                    child: TextPoppins(
                                      text: changePasswordController
                                          .oldPswdValidation!.value,
                                      color: kRedColor,
                                      fontSize: FontSize.validationMessage.sp,
                                    ),
                                  )
                                : const SizedBox(),
                          ),*/
                          Padding(
                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                            child: InputFormField(
                              hintText: 'Enter new Password'.tr,
                              leftIconPath: 'assets/icons/lock.svg',
                              controller: changePasswordController.newPswd,
                              suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 13.0.w),
                                  child: InkWell(
                                      onTap: () {
                                        changePasswordController
                                                .isNewPassWordDisabled.value =
                                            !changePasswordController
                                                .isNewPassWordDisabled.value;
                                      },
                                      child: SvgPicture.asset(
                                          changePasswordController
                                                  .isNewPassWordDisabled.value
                                              ? 'assets/icons/eye-crossed.svg'
                                              : 'assets/icons/eye.svg'))),
                              obscureText: changePasswordController
                                  .isNewPassWordDisabled.value,
                              maxLength: 6,
                            ),
                          ),
                          Obx(
                            () => changePasswordController
                                        .newPswdValidation?.value !=
                                    ''
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(top: 2.0.h, left: 55.w),
                                    child: TextPoppins(
                                      text: changePasswordController
                                          .newPswdValidation!.value,
                                      color: kRedColor,
                                      fontSize: FontSize.validationMessage.sp,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 24.w, left: 24.w, right: 24.w),
                            child: InputFormField(
                              hintText: 'Confirm new password'.tr,
                              leftIconPath: 'assets/icons/key.svg',
                              controller: changePasswordController.confirmPswd,
                              suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 13.0.w),
                                  child: InkWell(
                                      onTap: () {
                                        changePasswordController
                                                .isConfirmNewPassWordDisabled
                                                .value =
                                            !changePasswordController
                                                .isConfirmNewPassWordDisabled
                                                .value;
                                      },
                                      child: SvgPicture.asset(
                                          changePasswordController
                                                  .isConfirmNewPassWordDisabled
                                                  .value
                                              ? 'assets/icons/eye-crossed.svg'
                                              : 'assets/icons/eye.svg'))),
                              obscureText: changePasswordController
                                  .isConfirmNewPassWordDisabled.value,
                              maxLength: 6,
                            ),
                          ),
                          Obx(
                            () => changePasswordController
                                        .confirmPswdValidation?.value !=
                                    ''
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(top: 2.0.h, left: 55.w),
                                    child: TextPoppins(
                                      text: changePasswordController
                                          .confirmPswdValidation!.value,
                                      color: kRedColor,
                                      fontSize: FontSize.validationMessage.sp,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 36.h),
                    child: GestureDetector(
                      onTap: () {
                        changePasswordController.validate(context);
                        // if () {
                        //   showDialog(
                        //     context: context,
                        //     builder: (ctx) => AlertDialog(
                        //         contentPadding: EdgeInsets.zero,
                        //         buttonPadding: EdgeInsets.zero,
                        //         titlePadding: EdgeInsets.zero,
                        //         actionsPadding: EdgeInsets.zero,
                        //         iconPadding: EdgeInsets.zero,
                        //         insetPadding:
                        //             EdgeInsets.symmetric(horizontal: 10.w),
                        //         content: PopUpDialog(
                        //           asssetIcon:
                        //               'assets/icons/updated_dialog_icon.svg',
                        //           title: 'Password Updated!'.tr,
                        //           contentText:
                        //               'Great! Your password has been updated successfully'
                        //                   .tr,
                        //         )),
                        //   );
                        // }
                      },
                      child: CustomButton(
                        btnText: 'Update Password'.tr,
                        textColor: kColorWhite,
                        btnColor: kColorPrimary,
                        isStretchable: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
