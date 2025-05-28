class LoginModel {
  int? success;
  String? message;
  Data? data;

  LoginModel({this.success, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? email;
  String? phoneCode;
  String? phone;
  String? state;
  String? pinCode;
  String? rememberToken;
  bool? fcmNotification;
  MeData? meData;

  Result(
      {this.id,
      this.name,
      this.email,
      this.phoneCode,
      this.phone,
      this.state,
      this.pinCode,
      this.rememberToken,
      this.fcmNotification,
      this.meData});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneCode = json['phone_code'];
    phone = json['phone'];
    state = json['state'];
    pinCode = json['pin_code'];
    rememberToken = json['remember_token'];
    fcmNotification = json['fcm_notification'];
    meData =
        json['me_data'] != null ? new MeData.fromJson(json['me_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_code'] = this.phoneCode;
    data['phone'] = this.phone;
    data['state'] = this.state;
    data['pin_code'] = this.pinCode;
    data['remember_token'] = this.rememberToken;
    data['fcm_notification'] = this.fcmNotification;
    if (this.meData != null) {
      data['me_data'] = this.meData!.toJson();
    }
    return data;
  }
}

class MeData {
  Personal? personal;
  Others? others;
  Action? action;
  ExtraaTabs? extraaTabs;

  MeData({this.personal, this.others, this.action, this.extraaTabs});

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
  bool? notificationIcon;

  ExtraaTabs(
      {this.edit, this.wishlistIcon, this.downloadIcon, this.notificationIcon});

  ExtraaTabs.fromJson(Map<String, dynamic> json) {
    edit = json['Edit'];
    wishlistIcon = json['Wishlist Icon'];
    downloadIcon = json['Download Icon'];
    notificationIcon = json['Notification Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Edit'] = this.edit;
    data['Wishlist Icon'] = this.wishlistIcon;
    data['Download Icon'] = this.downloadIcon;
    data['Notification Icon'] = this.notificationIcon;
    return data;
  }
}
