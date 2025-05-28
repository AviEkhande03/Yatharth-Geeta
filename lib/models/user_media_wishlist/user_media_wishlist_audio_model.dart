// To parse this JSON data, do
//
//     final userMediaWishlistAudioModel = userMediaWishlistAudioModelFromJson(jsonString);

import 'dart:convert';

UserMediaWishlistAudioModel userMediaWishlistAudioModelFromJson(String str) =>
    UserMediaWishlistAudioModel.fromJson(json.decode(str));

String userMediaWishlistAudioModelToJson(UserMediaWishlistAudioModel data) =>
    json.encode(data.toJson());

class UserMediaWishlistAudioModel {
  int? success;
  String? message;
  Data? data;

  UserMediaWishlistAudioModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserMediaWishlistAudioModel.fromJson(Map<String, dynamic> json) =>
      UserMediaWishlistAudioModel(
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
  List<Result>? result;
  int? totalCount;
  int? remainingCount;

  Data({
    this.result,
    this.totalCount,
    this.remainingCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        totalCount: json["total_count"],
        remainingCount: json["remaining_count"],
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "total_count": totalCount,
        "remaining_count": remainingCount,
      };
}

class Result {
  int? id;
  String? type;
  List<WishlistDatum>? wishlistData;

  Result({
    this.id,
    this.type,
    this.wishlistData,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        type: json["type"],
        wishlistData: json["wishlist_data"] == null
            ? []
            : List<WishlistDatum>.from(
                json["wishlist_data"]!.map((x) => WishlistDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "wishlist_data": wishlistData == null
            ? []
            : List<dynamic>.from(wishlistData!.map((x) => x.toJson())),
      };
}

class WishlistDatum {
  int? id;
  bool? hasEpisodes;
  int? duration;
  int? views;
  String? viewCount;
  String? selectedType;
  String? mediaLanguage;
  String? authorName;
  String? audioFileUrl;
  String? audioCoverImageUrl;
  String? audioSrtFileUrl;
  String? durationTime;
  String? title;
  String? description;

  WishlistDatum({
    this.id,
    this.hasEpisodes,
    this.duration,
    this.views,
    this.viewCount,
    this.selectedType,
    this.mediaLanguage,
    this.authorName,
    this.audioFileUrl,
    this.audioCoverImageUrl,
    this.audioSrtFileUrl,
    this.durationTime,
    this.title,
    this.description,
  });

  factory WishlistDatum.fromJson(Map<String, dynamic> json) => WishlistDatum(
        id: json["id"],
        hasEpisodes: json["has_episodes"],
        duration: json["duration"],
        views: json["views"],
        viewCount: json["view_count"],
        selectedType: json["selected_type"],
        mediaLanguage: json["media_language"],
        authorName: json["author_name"],
        audioFileUrl: json["audio_file_url"],
        audioCoverImageUrl: json["audio_cover_image_url"],
        audioSrtFileUrl: json["audio_srt_file_url"],
        durationTime: json["duration_time"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "has_episodes": hasEpisodes,
        "duration": duration,
        "views": views,
        "view_count": viewCount,
        "selected_type": selectedType,
        "media_language": mediaLanguage,
        "author_name": authorName,
        "audio_file_url": audioFileUrl,
        "audio_cover_image_url": audioCoverImageUrl,
        "audio_srt_file_url": audioSrtFileUrl,
        "duration_time": durationTime,
        "title": title,
        "description": description,
      };
}
