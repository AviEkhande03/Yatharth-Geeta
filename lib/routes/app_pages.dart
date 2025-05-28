import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:yatharthageeta/views/book_library/book_library_screen.dart';
import 'package:yatharthageeta/widgets/common/search_filter_new.dart';
import '../bindings/audio_details/audio_details_binding.dart';
import '../bindings/audio_listing/audio_listing_binding.dart';
import '../bindings/audio_player/player_binding.dart';
import '../bindings/change_password/change_password_binding.dart';
import '../bindings/contact_us/contact_us_binding.dart';
import '../bindings/ebook_details/ebook_details_bindings.dart';
import '../bindings/ebooks_listing/ebooks_listing_bindings.dart';
import '../bindings/edit_profile/edit_profile_binding.dart';
import '../bindings/event_details/event_details_bindings.dart';
import '../bindings/gallery/gallery_binding.dart';
import '../bindings/guruji_details/guruji_details_binding.dart';
import '../bindings/home/home_bindings.dart';
import '../bindings/notification/notification_binding.dart';
import '../bindings/profile/profile_binding.dart';
import '../bindings/shlokas_listing/shlokas_listing_bindings.dart';
import '../bindings/video_details/video_details_binding.dart';
import '../bindings/video_listing/video_listing_binding.dart';
import '../bindings/video_player/video_player_binding.dart';
import '../intermediate.dart';
import 'app_route.dart';
import '../views/about_us/about_us_screen.dart';
import '../views/audio_details/all_chapters.dart';
import '../views/audio_details/audio_details_screen.dart';
import '../views/audio_listing/audio_listing_screen.dart';
import '../views/audio_player/player_screen.dart';
import '../views/bottom_app_bar/bottom_app_bar_screen.dart';
import '../views/change_password/change_password_screen.dart';
import '../views/contact_us/contact_us_screen.dart';
import '../views/ebook_details/ebook_details_screen.dart';
import '../views/ebooks_listing/ebooks_listing_screen.dart';
import '../views/edit_profile/edit_profile_screen.dart';
import '../views/event_details/event_details_screen.dart';
import '../views/events/events_screen.dart';
import '../views/gallery/gallery_screen.dart';
import '../views/guruji_details/guruji_details_screen.dart';
import '../views/guruji_listing/guruji_listing_screen.dart';
import '../views/home/home_screen.dart';
import '../views/language_preferences/language_preferences_screen.dart';
import '../views/liked_list/liked_list_screen.dart';
import '../views/my_played_list/my_played_list_screen.dart';
import '../views/notification/notification_screen.dart';
import '../views/privacy_policy/privacy_policy_screen.dart';
import '../views/profile/profile_screen.dart';
import '../views/shlokas_listing/shlokas_listing_screen.dart';
import '../views/terms_and_conditions/terms_and_conditions_screen.dart';
import '../views/video_details/video_details_screen.dart';
import '../views/video_listing/video_listing_screen.dart';
import '../bindings/login_with_OTP/login_with_otp_binding.dart';
import '../bindings/registration/registration_binding.dart';
import '../views/login_with_otp/login_with_otp_screen.dart';
import '../views/otp_verification/otp_verification_screen.dart';
import '../views/registration/registration_screen.dart';
import '../views/select_language/select_language_screen.dart';
import '../views/video_player/video_player_screen.dart';
import '../bindings/login_with_password/login_with_password_binding.dart';
import '../bindings/otp_verification/otp_verification_binding.dart';
import '../views/login_with_password/login_with_password_screen.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoute.intermediateScreen,
      page: () => IntermediateScreen(),
    ),
    GetPage(
        name: AppRoute.homeScreen,
        page: () => const HomeScreen(),
        binding: HomeBinding()),
    GetPage(
      name: AppRoute.bottomAppBarScreen,
      page: () => ShowCaseWidget(
          enableAutoScroll: true,
          builder: (context){
            return const BottomAppBarScreen();
          }),
      // binding: BottomAppBarBinding(),
    ),
    GetPage(
        name: AppRoute.audioListingScreen,
        page: () => const AudioListingScreen(),
        binding: AudioListingBinding()),
    GetPage(
        name: AppRoute.audioDetailsScreen,
        page: () => const AudioDetailsScreen(),
        binding: AudioDetailsBinding()),
    GetPage(
        name: AppRoute.videoListingScreen,
        page: () => const VideoListingScreen(),
        binding: VideoListingBinding()),
    GetPage(
        name: AppRoute.contactUsScreen,
        page: () => ContactUsScreen(),
        binding: ContactUsBinding()),
    GetPage(
      name: AppRoute.aboutUsScreen,
      page: () => const AboutUsScreen(),
      // binding: AboutUsBinding(),
    ),
    GetPage(
        name: AppRoute.loginWithPasswordScreen,
        page: () => const LoginScreen(),
        binding: LoginBinding()),
    GetPage(
        name: AppRoute.registrationScreen,
        page: () => const RegistrationScreen(),
        binding: RegistrationBinding()),
    GetPage(
        name: AppRoute.loginWithOTPScreen,
        page: () => LoginWithOtpScreen(),
        binding: LoginWithOTPBinding()),
    GetPage(
        name: AppRoute.otpVerificationScreen,
        page: () => const OtpVerificationScreen(),
        //binding: OtpVerificationBinding()),
    ),
    GetPage(
      name: AppRoute.selectLanguageScreen,
      page: () => const SelectLanguageScreen(),
      // binding: SelectLanguageBinding(),
    ),
    GetPage(
        name: AppRoute.changePasswordScreen,
        page: () => const ChangePasswordScreen(),
        binding: ChangePasswordBinding()),
    GetPage(
        name: AppRoute.notificationScreen,
        page: () => const NotificationScreen(),
        binding: NotificationBinding()),
    GetPage(
        name: AppRoute.profileScreen,
        page: () => const ProfileScreen(),
        binding: ProfileBinding()),
    GetPage(
        name: AppRoute.editProfileScreen,
        page: () => const EditProfileScreen(),
        binding: EditProfileBinding()),
    GetPage(
      name: AppRoute.languagePreferencesScreen,
      page: () => const LanguagePreferencesScreen(),
      // binding: LanguagePreferencesBinding(),
    ),
    GetPage(
      name: AppRoute.audioPlayerScreen,
      page: () => const PlayerScreen(),
      binding: PlayerBinding(),
    ),
    GetPage(
        name: AppRoute.galleryScreen,
        page: () => const GalleryScreen(),
        binding: GalleryBinding()),
    GetPage(
        name: AppRoute.allChaptersScreen,
        page: () => const AllChapters(),
        binding: AudioDetailsBinding()),
    GetPage(
        name: AppRoute.videoDetailsScreen,
        page: () => const VideoDetailsScreen(),
        binding: VideoDetailsBinding()),
    GetPage(
        name: AppRoute.videoPlayerScreen,
        page: () => const VideoPlayerScreen(),
        binding: VideoPlayerBinding()),
    GetPage(
        name: AppRoute.ebookDetailsScreen,
        page: () => const EbookDetailsScreen(),
        binding: EbookDetailsBindings()),
    GetPage(
        name: AppRoute.shlokasListingScreen,
        page: () => const ShlokasListingScreen(),
        binding: ShlokasListingBindings()),
    GetPage(
      name: AppRoute.eventsScreen,
      page: () => const EventsScreen(),
      // binding: EventsBindings(),
    ),
    GetPage(
      name: AppRoute.gurujiDetailsScreen,
      page: () => const GurujiDetailsScreen(),
      binding: GurujiDetailsBinding(),
    ),
    GetPage(
      name: AppRoute.gurujiListingScreen,
      page: () => const GurujiListingScreen(),
      // binding: GurujiListingBinding(),
    ),
    GetPage(
      name: AppRoute.ebooksListingScreen,
      page: () => const EbooksListingScreen(),
      binding: EbooksListingBindings(),
    ),
    GetPage(
      name: AppRoute.likedListScreen,
      page: () => const LikedListScreen(),
      // binding: LikedListBindings(),
    ),
    GetPage(
      name: AppRoute.myPlayedListScreen,
      page: () => const MyPlayedListScreen(),
      // binding: MyPlayedListBindings(),
    ),
    GetPage(
        name: AppRoute.eventDetailsScreen,
        page: () => const EventDetailsScreen(),
        binding: EventDetailsBindings()),
    // GetPage(
    //   name: AppRoute.ashramDetailsScreen,
    //   page: () => AshramDetailsScreen(),
    //   binding: AshramDetailsBindings(),
    // ),

    GetPage(
      name: AppRoute.termsAndConditionsScreen,
      page: () => const TermsAndConditionsScreen(),
      // binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: AppRoute.privacyPolicyScreen,
      page: () => const PrivacyPolicyScreen(),
      // binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: AppRoute.bookLibraryScreen,
      page: () => const BookLibraryScreen(),
      // binding: PrivacyPolicyBinding(),
    ),
    GetPage(
        name: AppRoute.filterScreen,
        page: () => const SearchFilterNew(),
        transition: Transition.downToUp
        // binding: PrivacyPolicyBinding(),
        ),
  ];
}
