// To parse this JSON data, do
//
//     final aboutUsModel = aboutUsModelFromJson(jsonString);

import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) => AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  int? success;
  String? message;
  Data? data;

  AboutUsModel({
    this.success,
    this.message,
    this.data,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Result? result;

  Data({
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
  };
}

class Result {
  String? fbLink;
  String? instaLink;
  String? twitterLink;
  String? webUrl;
  String? guru1Image;
  String? guru2Image;
  String? buddhaImage;
  String? shivaImage;
  String? yogaImage;
  String? content;

  Result({
    this.fbLink,
    this.instaLink,
    this.twitterLink,
    this.webUrl,
    this.guru1Image,
    this.guru2Image,
    this.buddhaImage,
    this.shivaImage,
    this.yogaImage,
    this.content,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    fbLink: json["fb_link"],
    instaLink: json["insta_link"],
    twitterLink: json["twitter_link"],
    webUrl: json["web_url"],
    guru1Image: json["guru1_image"],
    guru2Image: json["guru2_image"],
    buddhaImage: json["buddha_image"],
    shivaImage: json["shiva_image"],
    yogaImage: json["yoga_image"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "fb_link": fbLink,
    "insta_link": instaLink,
    "twitter_link": twitterLink,
    "web_url": webUrl,
    "guru1_image": guru1Image,
    "guru2_image": guru2Image,
    "buddha_image": buddhaImage,
    "shiva_image": shivaImage,
    "yoga_image": yogaImage,
    "content": content,
  };
}
