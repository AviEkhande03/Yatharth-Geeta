import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/startup/startup_controller.dart';
import '../../const/text_styles/text_styles.dart';
import '../../controllers/edit_profile/edit_profile_controller.dart';
import '../../const/colors/colors.dart';
import '../../const/font_size/font_size.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/input_textfield.dart';
import '../../widgets/common/text_poppins.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editProfileScreenController = Get.find<EditProfileController>();
    final profileScreenController = Get.find<ProfileController>();
    final startUpScreenController = Get.find<StartupController>();

    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: kColorWhite));
    return Container(
      color: kColorWhite,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          /*appBar:
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
                      text: "Edit Profile",
                      fontSize: 24.sp,
                      color: kColorFont,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          )*/ /*
          AppBar(
            centerTitle: true,
            title: TextRosario(
              text: "Edit Profile".tr,
              fontSize: 24.sp,
              color: kColorFont,
              fontWeight: FontWeight.w400,
            ),
            leading: GestureDetector(
              onTap:(){
                Get.back();
              },
              child: Center(
                child: SvgPicture.asset(
                    'assets/icons/back.svg'
                ),
              ),
            ),
          ),*/
          backgroundColor: kColorWhite2,
          body: SingleChildScrollView(
            child: Column(
              children: [
                //const CustomAppBar(title: 'Edit Profile'),
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
                        'Edit Profile'.tr,
                        style: kTextStyleRosarioRegular.copyWith(
                          color: kColorFont,
                          fontSize: FontSize.editProfileTitle.sp,
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
                  title: 'Edit Profile'.tr,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0.h),
                  child: Container(
                    color: kColorWhite,
                    padding: EdgeInsets.only(top: 24.0.h, bottom: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 24.w, right: 24.w),
                          child: InputFormField(
                            hintText: 'Enter your Name'.tr,
                            leftIconPath: 'assets/icons/person.svg',
                            controller: editProfileScreenController.name,
                            //initialValue: profileScreenController.profileData.first.data!.result!.name,
                          ),
                        ),
                        Obx(
                          () => editProfileScreenController
                                      .nameValidation?.value !=
                                  ''
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.0.h, left: 55.w),
                                  child: TextPoppins(
                                    text: editProfileScreenController
                                        .nameValidation!.value,
                                    color: kRedColor,
                                    fontSize: FontSize.validationMessage.sp,
                                  ),
                                )
                              : const SizedBox(),
                        ),

                        profileScreenController.profileData.first.data!.result!.socialLoginType == 'apple' && profileScreenController.profileData.first.data!.result!.email == ''?
                        SizedBox.shrink()
                            :Padding(
                          padding: EdgeInsets.only(
                              top: 24.w, left: 24.w, right: 24.w),
                          child: InputFormField(
                            hintText: 'Enter your Email Id'.tr,
                            leftIconPath:
                                'assets/icons/email_ashram_details.svg',
                            enabled: startUpScreenController
                                    .startupData
                                    .first
                                    .data!
                                    .result!
                                    .screens!
                                    .meData!
                                    .profile!
                                    .emailEditable!
                                ? true
                                : false,
                            prefixIconBoxConstraints: const BoxConstraints(),
                            keyBoardType: TextInputType.emailAddress,
                            controller: editProfileScreenController.email,
                            //initialValue: profileScreenController.profileData.first.data!.result!.phone
                          ),
                        ),
                        Obx(
                          () => editProfileScreenController
                                      .emailValidation?.value !=
                                  ''
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.0.h, left: 55.w),
                                  child: TextPoppins(
                                    text: editProfileScreenController
                                        .emailValidation!.value,
                                    color: kRedColor,
                                    fontSize: FontSize.validationMessage.sp,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        Obx(()=>
                          Padding(
                            padding: EdgeInsets.only(
                                top: 24.w, left: 24.w, right: 24.w),
                            child: InputFormField(
                              hintText: 'Enter your mobile number'.tr,
                              leftIconPath: 'assets/icons/phone.svg',
                              enabled: startUpScreenController
                                      .startupData
                                      .first
                                      .data!
                                      .result!
                                      .screens!
                                      .meData!
                                      .profile!
                                      .phoneEditable!
                                  ? true
                                  : false,
                              prefixIcon: SizedBox(
                                // width: 60.w,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                CountryListThemeData(
                                              flagSize: 25,
                                              backgroundColor: Colors.white,
                                              textStyle: kTextStylePoppinsMedium
                                                  .copyWith(
                                                color: kColorFont,
                                              ),
                                              bottomSheetHeight:
                                                  700, // Optional. Country list modal height
                                              //Optional. Sets the border radius for the bottomsheet.
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                              //Optional. Styles the search field.
                                              inputDecoration: InputDecoration(
                                                labelText: 'Search',
                                                contentPadding: EdgeInsets.zero,
                                                labelStyle:
                                                    kTextStylePoppinsRegular
                                                        .copyWith(
                                                            color: kColorFont),
                                                hintText:
                                                    'Start typing to search',
                                                hintStyle:
                                                    kTextStylePoppinsRegular
                                                        .copyWith(
                                                            color: kColorFont),
                                                prefixIcon:
                                                    const Icon(Icons.search),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: const Color(0xFF8C98A8)
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onSelect: (Country country) {
                                              editProfileScreenController
                                                      .countryCode.value =
                                                  "+" + country.phoneCode;
                                              editProfileScreenController.phone.text = '';
                                              // editProfileScreenController.phoneLength.value = country.example.length;
                                              print("country.countryCode:${country.countryCode}");
                                              if(Get.find<StartupController>().country_phone_lengths.containsKey(country.countryCode)){
                                                editProfileScreenController.phoneLength.value =
                                                Get.find<StartupController>().country_phone_lengths['${country.countryCode}']!;
                                              }
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 29.0.w),
                                              child: SvgPicture.asset(
                                                  width: 10.w,
                                                  height: 10.w,
                                                  color: startUpScreenController
                                                          .startupData
                                                          .first
                                                          .data!
                                                          .result!
                                                          .screens!
                                                          .meData!
                                                          .profile!
                                                          .phoneEditable!
                                                      ? kColorPrimary
                                                      : kColorFont
                                                          .withOpacity(0.3),
                                                  'assets/icons/orange_dropdown.svg'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 7.w),
                                              child: Obx(
                                                () => Text(
                                                  editProfileScreenController
                                                      .countryCode.value,
                                                  style: kTextStylePoppinsMedium
                                                      .copyWith(
                                                          color: startUpScreenController
                                                                  .startupData
                                                                  .first
                                                                  .data!
                                                                  .result!
                                                                  .screens!
                                                                  .meData!
                                                                  .profile!
                                                                  .phoneEditable!
                                                              ? kColorPrimary
                                                              : kColorFont
                                                                  .withOpacity(
                                                                      0.3)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextPoppins(
                                        text: '  |  ',
                                        fontSize: FontSize.hintText.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kColorPrimary,
                                      ),
                                    ]),
                              ),
                              prefixIconBoxConstraints: const BoxConstraints(),
                              keyBoardType: TextInputType.number,
                              controller: editProfileScreenController.phone,
                              maxLength: editProfileScreenController.phoneLength.value,
                              //initialValue: profileScreenController.profileData.first.data!.result!.phone
                            ),
                          ),
                        ),
                        Obx(
                          () => editProfileScreenController
                                      .phoneValidation?.value !=
                                  ''
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.0.h, left: 55.w),
                                  child: TextPoppins(
                                    text: editProfileScreenController
                                        .phoneValidation!.value,
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
                            hintText: 'Enter your pincode'.tr,
                            leftIconPath: 'assets/icons/location.svg',
                            maxLength: 6,
                            keyBoardType: TextInputType.number,
                            controller: editProfileScreenController.pincode,
                            //initialValue: profileScreenController.profileData.first.data!.result!.pinCode ?? '',
                          ),
                        ),
                        Obx(
                          () => editProfileScreenController
                                      .pincodeValidation?.value !=
                                  ''
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.0.h, left: 55.w),
                                  child: TextPoppins(
                                    text: editProfileScreenController
                                        .pincodeValidation!.value,
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
                            hintText: 'Enter your State'.tr,
                            leftIconPath: 'assets/icons/map.svg',
                            controller: editProfileScreenController.state,
                            //initialValue: profileScreenController.profileData.first.data!.result!.state ?? '',
                          ),
                        ),
                        Obx(
                          () => editProfileScreenController
                                      .stateValidation?.value !=
                                  ''
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.0.h, left: 55.w),
                                  child: TextPoppins(
                                    text: editProfileScreenController
                                        .stateValidation!.value,
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
                      editProfileScreenController.validate(context);
                    },
                    child: CustomButton(
                      btnText: 'Save Changes'.tr,
                      textColor: kColorWhite,
                      isStretchable: false,
                      btnColor: kColorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
