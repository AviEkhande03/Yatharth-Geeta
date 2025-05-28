// To parse this JSON data, do
//
//     final startupModel = startupModelFromJson(jsonString);

import 'dart:convert';

StartupModel startupModelFromJson(String str) =>
    StartupModel.fromJson(json.decode(str));

String startupModelToJson(StartupModel data) => json.encode(data.toJson());

class StartupModel {
  int? success;
  String? message;
  Data? data;

  StartupModel({this.success, this.message, this.data});

  StartupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  Screens? screens;
  LoginWith? loginWith;
  bool? mandatoryUpdate;
  String? redirectionUrl;
  List? shlokas_language_ids;
  String? gaataBooksImage;
  String? gaataAudiosImage;
  String? audioImage;
  String? booksImage;
  String? shlokasImage;
  String? videosImage;
  String? mapImage;

  Result(
      {this.screens,
      this.loginWith,
      this.mandatoryUpdate,
      this.shlokas_language_ids,
      this.redirectionUrl,
      this.gaataBooksImage,
      this.gaataAudiosImage,
      this.audioImage,
      this.booksImage,
      this.shlokasImage,
      this.videosImage,
      this.mapImage});

  Result.fromJson(Map<String, dynamic> json) {
    screens =
        json['screens'] != null ? new Screens.fromJson(json['screens']) : null;
    loginWith = json['login_with'] != null
        ? new LoginWith.fromJson(json['login_with'])
        : null;
    mandatoryUpdate = json['mandatory_update'];
    shlokas_language_ids = json['shlokas_language_ids'];
    redirectionUrl = json['redirection_url'];
    gaataBooksImage = json['gaata_books_image'];
    gaataAudiosImage = json['gaata_audios_image'];
    audioImage = json['audio_image'];
    booksImage = json['books_image'];
    shlokasImage = json['shlokas_image'];
    videosImage = json['videos_image'];
    mapImage = json['map_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.screens != null) {
      data['screens'] = this.screens!.toJson();
    }
    if (this.loginWith != null) {
      data['login_with'] = this.loginWith!.toJson();
    }
    data['mandatory_update'] = this.mandatoryUpdate;
    data['shlokas_language_ids'] = this.shlokas_language_ids;
    data['redirection_url'] = this.redirectionUrl;
    data['gaata_books_image'] = this.gaataBooksImage;
    data['gaata_audios_image'] = this.gaataAudiosImage;
    data['audio_image'] = this.audioImage;
    data['books_image'] = this.booksImage;
    data['shlokas_image'] = this.shlokasImage;
    data['videos_image'] = this.videosImage;
    data['map_image'] = this.mapImage;
    return data;
  }
}

class Screens {
  Home? home;
  Explore? explore;
  BottomNav? bottomNav;
  MeData? meData;

  Screens({this.home, this.explore, this.bottomNav, this.meData});

  Screens.fromJson(Map<String, dynamic> json) {
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
    explore =
        json['explore'] != null ? new Explore.fromJson(json['explore']) : null;
    bottomNav = json['bottom_nav'] != null
        ? new BottomNav.fromJson(json['bottom_nav'])
        : null;
    meData =
        json['me_data'] != null ? new MeData.fromJson(json['me_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.home != null) {
      data['home'] = this.home!.toJson();
    }
    if (this.explore != null) {
      data['explore'] = this.explore!.toJson();
    }
    if (this.bottomNav != null) {
      data['bottom_nav'] = this.bottomNav!.toJson();
    }
    if (this.meData != null) {
      data['me_data'] = this.meData!.toJson();
    }
    return data;
  }
}

class Home {
  bool? books;
  bool? audios;
  bool? videos;
  bool? shlokas;
  bool? yatharthGeetaBooks;
  bool? yatharthGeetaAudios;
  bool? ashramBooks;
  bool? ashramAudios;
  bool? satsangVideos;
  bool? yatharthGeetaShlokas;

  Home(
      {this.books,
      this.audios,
      this.videos,
      this.shlokas,
      this.yatharthGeetaBooks,
      this.yatharthGeetaAudios,
      this.ashramBooks,
      this.ashramAudios,
      this.satsangVideos,
      this.yatharthGeetaShlokas});

  Home.fromJson(Map<String, dynamic> json) {
    books = json['Books'];
    audios = json['Audios'];
    videos = json['Videos'];
    shlokas = json['Shlokas'];
    yatharthGeetaBooks = json['Yatharth Geeta Books'];
    yatharthGeetaAudios = json['Yatharth Geeta Audios'];
    ashramBooks = json['Ashram Books'];
    ashramAudios = json['Ashram Audios'];
    satsangVideos = json['Satsang Videos'];
    yatharthGeetaShlokas = json['Yatharth Geeta Shlokas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Books'] = this.books;
    data['Audios'] = this.audios;
    data['Videos'] = this.videos;
    data['Shlokas'] = this.shlokas;
    data['Yatharth Geeta Books'] = this.yatharthGeetaBooks;
    data['Yatharth Geeta Audios'] = this.yatharthGeetaAudios;
    data['Ashram Books'] = this.ashramBooks;
    data['Ashram Audios'] = this.ashramAudios;
    data['Satsang Videos'] = this.satsangVideos;
    data['Yatharth Geeta Shlokas'] = this.yatharthGeetaShlokas;
    return data;
  }
}

class Explore {
  bool? satsang;
  bool? mantras;
  bool? quotes;

  Explore({this.satsang, this.mantras, this.quotes});

  Explore.fromJson(Map<String, dynamic> json) {
    satsang = json['Satsang'];
    mantras = json['Mantras'];
    quotes = json['Quotes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Satsang'] = this.satsang;
    data['Mantras'] = this.mantras;
    data['Quotes'] = this.quotes;
    return data;
  }
}

class BottomNav {
  bool? home;
  bool? explore;
  bool? events;
  bool? me;

  BottomNav({this.home, this.explore, this.events, this.me});

  BottomNav.fromJson(Map<String, dynamic> json) {
    home = json['Home'];
    explore = json['Explore'];
    events = json['Events'];
    me = json['Me'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Home'] = this.home;
    data['Explore'] = this.explore;
    data['Events'] = this.events;
    data['Me'] = this.me;
    return data;
  }
}

class MeData {
  Personal? personal;
  Others? others;
  Action? action;
  ExtraaTabs? extraaTabs;
  Profile? profile;

  MeData(
      {this.personal, this.others, this.action, this.extraaTabs, this.profile});

  MeData.fromJson(Map<String, dynamic> json) {
    personal = json['Personal'] != null
        ? new Personal.fromJson(json['Personal'])
        : null;
    others =
        json['Others'] != null ? new Others.fromJson(json['Others']) : null;
    action =
        json['Action'] != null ? new Action.fromJson(json['Action']) : null;
    extraaTabs = json['extraa_tabs'] != null
        ? new ExtraaTabs.fromJson(json['extraa_tabs'])
        : null;
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.personal != null) {
      data['Personal'] = this.personal!.toJson();
    }
    if (this.others != null) {
      data['Others'] = this.others!.toJson();
    }
    if (this.action != null) {
      data['Action'] = this.action!.toJson();
    }
    if (this.extraaTabs != null) {
      data['extraa_tabs'] = this.extraaTabs!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Personal {
  bool? likedList;
  bool? myPlayedList;

  Personal({this.likedList, this.myPlayedList});

  Personal.fromJson(Map<String, dynamic> json) {
    likedList = json['Liked List'];
    myPlayedList = json['My Played List'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Liked List'] = this.likedList;
    data['My Played List'] = this.myPlayedList;
    return data;
  }
}

class Others {
  bool? notification;
  bool? languagePreference;
  bool? contactUs;
  bool? aboutUs;
  bool? termsNConditions;
  bool? privacyPolicy;
  bool? rateUs;
  bool? help;
  bool? shareApp;

  Others(
      {this.notification,
      this.languagePreference,
      this.contactUs,
      this.aboutUs,
      this.termsNConditions,
      this.privacyPolicy,
      this.rateUs,
      this.help,
      this.shareApp});

  Others.fromJson(Map<String, dynamic> json) {
    notification = json['Notification'];
    languagePreference = json['Language Preference'];
    contactUs = json['Contact Us'];
    aboutUs = json['About Us'];
    termsNConditions = json['Terms n conditions'];
    privacyPolicy = json['Privacy Policy'];
    rateUs = json['Rate Us'];
    help = json['Help'];
    shareApp = json['Share App'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Notification'] = this.notification;
    data['Language Preference'] = this.languagePreference;
    data['Contact Us'] = this.contactUs;
    data['About Us'] = this.aboutUs;
    data['Terms n conditions'] = this.termsNConditions;
    data['Privacy Policy'] = this.privacyPolicy;
    data['Rate Us'] = this.rateUs;
    data['Help'] = this.help;
    data['Share App'] = this.shareApp;
    return data;
  }
}

class Action {
  bool? changePassword;
  bool? deleteAccount;
  bool? logout;
  bool? login;

  Action({this.changePassword, this.deleteAccount, this.logout, this.login});

  Action.fromJson(Map<String, dynamic> json) {
    changePassword = json['Change Password'];
    deleteAccount = json['Delete account'];
    logout = json['Logout'];
    login = json['Login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Change Password'] = this.changePassword;
    data['Delete account'] = this.deleteAccount;
    data['Logout'] = this.logout;
    data['Login'] = this.login;
    return data;
  }
}

class ExtraaTabs {
  bool? edit;
  bool? wishlistIcon;
  bool? downloadIcon;
  bool? audioDownloadIcon;
  bool? bookDownloadIcon;
  bool? shlokDownloadIcon;
  bool? notificationIcon;

  ExtraaTabs(
      {this.edit,
      this.wishlistIcon,
      this.downloadIcon,
      this.audioDownloadIcon,
      this.bookDownloadIcon,
      this.shlokDownloadIcon,
      this.notificationIcon});

  ExtraaTabs.fromJson(Map<String, dynamic> json) {
    edit = json['Edit'];
    wishlistIcon = json['Wishlist Icon'];
    downloadIcon = json['Download Icon'];
    audioDownloadIcon = json['Audio Download Icon'];
    bookDownloadIcon = json['Book Download Icon'];
    shlokDownloadIcon = json['Shlok Download Icon'];
    notificationIcon = json['Notification Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Edit'] = this.edit;
    data['Wishlist Icon'] = this.wishlistIcon;
    data['Download Icon'] = this.downloadIcon;
    data['Audio Download Icon'] = this.audioDownloadIcon;
    data['Book Download Icon'] = this.bookDownloadIcon;
    data['Shlok Download Icon'] = this.shlokDownloadIcon;
    data['Notification Icon'] = this.notificationIcon;
    return data;
  }
}

class Profile {
  bool? emailEditable;
  bool? phoneEditable;

  Profile({this.emailEditable, this.phoneEditable});

  Profile.fromJson(Map<String, dynamic> json) {
    emailEditable = json['email_editable'];
    phoneEditable = json['phone_editable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_editable'] = this.emailEditable;
    data['phone_editable'] = this.phoneEditable;
    return data;
  }
}

class LoginWith {
  bool? skipLogin;
  bool? skipLoginAndroid;
  bool? skipLoginIos;
  bool? otp;
  bool? password;
  bool? fb;
  bool? google;
  bool? apple;

  LoginWith(
      {this.skipLogin,
      this.skipLoginAndroid,
      this.skipLoginIos,
      this.otp,
      this.password,
      this.fb,
      this.google,
      this.apple});

  LoginWith.fromJson(Map<String, dynamic> json) {
    skipLogin = json['skip_login'];
    skipLoginAndroid = json['skip_login_android'];
    skipLoginIos = json['skip_login_ios'];
    otp = json['otp'];
    password = json['password'];
    fb = json['fb'];
    google = json['google'];
    apple = json['apple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skip_login'] = this.skipLogin;
    data['skip_login_android'] = this.skipLoginAndroid;
    data['skip_login_ios'] = this.skipLoginIos;
    data['otp'] = this.otp;
    data['password'] = this.password;
    data['fb'] = this.fb;
    data['google'] = this.google;
    data['apple'] = this.apple;
    return data;
  }
}
