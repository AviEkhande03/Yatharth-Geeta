import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Contants class holds the API related URls and Endpoints, and const strings
double width = MediaQuery.of(Get.context!).size.width;
double height = MediaQuery.of(Get.context!).size.height;

class Constants {
  //Basic auth credentials
  // static const String username = String.fromEnvironment("USERNAME");
  // static const String password = String.fromEnvironment("PASSWORD");
  static const String acceptedLanguage = 'en';
  static const String epubUrl = 'https://willowy-blini-019c14.netlify.app';

  //BaseUrl
  // static const String baseUrl = String.fromEnvironment("BASE_URL");

  static const String username = 'admin';
  static const String password = 'mypcot';
  // static const String baseUrl =
  //     'https://mynewapp.yatharthgeeta.org/webservices/v1/';

  //http://skyonliners.com/demo/yatharthgeeta-apis/webservices/v1/

  //New UAT URL
  //'https://mynewapp.yatharthgeeta.org/webservices/v1/'
  //New Production URL
  //'https://ygapi.yatharthgeeta.org/webservices/v1/'

  // static const String baseUrl =
  //     'https://mynewapp.yatharthgeeta.org/webservices/v1/';
  //
  // static const String baseUrl2 =
  //     'https://mynewapp.yatharthgeeta.org/webservices/v2/';

  static const String baseUrl =
      'https://ygapi.yatharthgeeta.org/webservices/v1/';

  static const String baseUrl2 =
      'https://ygapi.yatharthgeeta.org/webservices/v2/';

//API Sub URLs// *start*
  static const String startupApi = 'startup_api';
  static const String login = 'login_api';
  static const String social_login = 'social_login_api';
  static const String loginPasswordApi = "password_login_api";
  static const String register = 'register_api';
  static const String validateOTP = 'validate_otp';
  static const String resendOtpApi = 'resend_otp';
  static const String profileDataApi = 'users/me';
  static const String profileUpdateApi = "users/update";
  static const String contactUsApi = 'contact/create';
  static const String contactUsDetailsApi = 'contact/show';
  static const String logOutApi = 'users/logout';
  static const String deleteAccountApi = 'users/delete';
  static const String changePasswordApi = 'users/change_password';
  static const String updateNotificationStatusApi = 'users/notification/status';
  static const String preferredLanguageApi = 'preferred_language/details';
  static const String notificationListingApi = 'notification/list';
  static const String gurujiDetailsApi = 'artist/show';
  static const String gurujiListingApi = 'artist/list';
  static const String ebooksListing = 'books/list';
  static const String videoListing = 'videos/list';
  static const String ebookDetails = 'books/show';
  static const String audioDetails = 'audios/show';
  static const String adminPolicies = 'policies';
  static const Locale englishLocale = Locale('en', 'US');
  // static const Locale hindiLocale = Locale('hi', 'IN');
  static const String videoDetails = 'videos/show';
  static const String videoEpisode = 'videos_episode/show';
  static const String audioListing = 'audios/list';
  static const String languageSort = 'language/list';
  static const String authorSort = 'artist/filter/list';
  static const String quoteApi = 'quotes/list';
  static const String mantraApi = 'mantras/list';
  static const String exploreApi = 'explore_collection/list';
  static const String satsangApi = 'pravachan/list';
  static const String eventsListing = 'event/list';
  static const String eventDetails = 'event/show';
  static const String userMediaPlayedCreateApi = 'user_playlist/create';
  static const String userMediaPlayedViewedApi = 'user_playlist/view';
  static const String playerChapterApi = 'audios/chapter_verses';
  static const String userMediaLikedCreateApi = 'user_wishlist/create';
  static const String userLikedListApi = 'user_wishlist/view';
  static const String shlokasChaptersListApi = 'shloks/chapter_number_list';
  static const String shlokasListingApi = 'shloks/list';
  static const String updateFcmTokenApi = 'notification_token/update';
  static const String homeCollectionListApi = 'home_collection/list';
  static const String homeCollectionDetailsApi = 'home_collection/show';
  static const String homeCollectionViewAllApi = 'home_collection/view_all';
  static const String exploreCollectionViewAllApi =
      'explore_collection/view_all';
  static const String bookCategory = 'book_category/list';
  static const String audioCategory = 'audio_category/list';
  static const String videoCategory = 'video_category/list';
  static const String socialLoginApi = 'social_login_api';
  static const String count = 'users/view_count';

//API Sub URLs// *end*

//API Body Parameters Data// *start*
  //Admin Policies
  static const String typeAboutUs = 'about';
  static const String typeTermsAndConditions = 'terms';
  static const String typePrivacyPolicy = 'policy';

  //User Media Played Types
  static const String typeMediaAudio = 'Audio';
  static const String typeMediaAudioEpisode = 'AudioEpisode';
  static const String typeMediaVideo = 'Video';
  static const String typeMediaBook = 'Book';
//API Body Parameters Data// *end*

//Flags
  static const int homeMediaDetailsClickableTrueFlag = 1;
  static const int homeMediaDetailsClickableFalseFlag = 0;

  static const bool homeMultipleListingClickableFalseBoolFlag = false;
  static const bool homeMultipleListingClickableTrueBoolFlag = true;

  //Dummy Data
  static String ebookDummyDesc =
      'The Bhagavad Gita is set in a narrative framework of dialogue between the Pandava prince Arjuna and his charioteer guide Krishna, an avatar of lord Vishnu.The Bhagavad Gita is set in a narrative framework of dialogue between the Pandava prince Arjuna and his charioteer guide Krishna, an avatar of lord Vishnu.';

  static String eventDummyDesc =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eu libero et est varius interdum non ut sit amet blandit dolor, mattis dignissim velit.';

  static String eventBrief =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam non tincidunt quam. Pellentesque luctus augue auctor dapibus aliquam.';

  static String eventDummyAbout =
      "Diwali, or Dipawali, is India's biggest and most important holiday of the year. The festival gets its name from the row (avali) of clay lamps (deepa) that Indians light outside their homes to symbolize the inner light that protects from spiritual darkness. This festival is as important to Hindus as the Christmas holiday is to Christians.\n Over the centuries, Diwali has become a national festival that's also enjoyed by non-Hindu communities. For instance, in Jainism, Diwali marks the nirvana, or spiritual awakening, of Lord Mahavira on October 15, 527 B.C.; in Sikhism, it honors the day that Guru Hargobind Ji, the Sixth Sikh Guru, was freed from imprisonment. Buddhists in India celebrate Diwali as well.\nDiwali, or Dipawali, is India's biggest and most important holiday of the year. The festival gets its name from the row (avali) of clay lamps (deepa) that Indians light outside their homes to symbolize the inner light that protects from spiritual darkness. This festival is as important to Hindus as the Christmas holiday is to Christians.";

  static String dummyShlokaMeaning = '''
Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?
Dhritrashtr is the very image of ignorance, and Sanjay is the embodiment of self-restraint. Ignorance lurks at the core of the objective, the outward-looking mind. With his mind enveloped in darkness, Dhritrashtr is blind since birth, but he sees and hears through Sanjay, the epitome of self-control. He knows that God alone is real, but as long as his infatuation for Duryodhan born from ignorance lasts, his inner eye will be focused on the Kaurav, who symbolize the ungodly forces of negative, sinful impulses.
The human body is a field for combat. When there is abundance of divinity in the realm of the heart, the body is transmuted into a Dharmkshetr [], but it degenerates into a Kurukshetr when it is infested with demoniacal powers. Kuru means “do” and the word is an imperative. As Lord Krishn has said, “Driven by the three properties [] born out of prakriti (nature) man is compelled to act; without action he cannot even live for a moment.” These properties, virtue, ignorance, and passion, compel him to act. Even in sleep action does not cease, for it is the necessary sustenance for the body. The three properties bind men, from the level of gods to that of the lowest creatures such as worms. So long as the material world and its properties are, kuru must be. Therefore, the sphere of birth and death, of sinful impulses, which are evolved from a previous source or prakriti (nature) is Kurukshetr, whereas the sphere of righteous impulses which guide the Self to God, the highest spiritual reality, is Dharmkshetr.Archaeologists are engaged in research in Punjab, Kashi, and Prayag to locate Kurukshetr. But the poet of the Geeta has himself suggested, through Lord Krishn, where the war of his sacred poem was fought. “This body is itself, O Arjun, a battlefield, and one who conquers it grows spiritually dexterous by perceiving its essence.” He then elaborates the structure of this “battlefield”, sphere of action, constituted of ten perceptors [], the objective and the subjective mind, the ego, all the five perversions [object carriers (tanmatra) of the five senses of perception - word, touch, form, taste and smell - these are the five objects of the senses] and the three properties. The body itself is a field, a ring or an arena. The forces that clash on this field are twofold, the godly and the ungodly, the divine and the devilish, the offspring of Pandu and those of Dhritrashtr, the forces that are congenial to the essentially divine character of the Self and those which offend and demean it.
''';
}
