// To parse this JSON data, do
//
//     final userMediaPlayedViewedModel = userMediaPlayedViewedModelFromJson(jsonString);

import 'dart:convert';

UserMediaPlayedViewedModel userMediaPlayedViewedModelFromJson(String str) =>
    UserMediaPlayedViewedModel.fromJson(json.decode(str));

String userMediaPlayedViewedModelToJson(UserMediaPlayedViewedModel data) =>
    json.encode(data.toJson());

class UserMediaPlayedViewedModel {
  int? success;
  String? message;
  Data? data;

  UserMediaPlayedViewedModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserMediaPlayedViewedModel.fromJson(Map<String, dynamic> json) =>
      UserMediaPlayedViewedModel(
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
  List<PlaylistDatum>? playlistData;

  Result({
    this.id,
    this.type,
    this.playlistData,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        type: json["type"],
        playlistData: json["playlist_data"] == null
            ? []
            : List<PlaylistDatum>.from(
                json["playlist_data"]!.map((x) => PlaylistDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "playlist_data": playlistData == null
            ? []
            : List<dynamic>.from(playlistData!.map((x) => x.toJson())),
      };
}

class PlaylistDatum {
  int? id;
  dynamic views;
  int? duration;
  String? link;
  bool? visibleOnApp;
  String? peopleAlsoViewIds;
  String? viewCount;
  String? selectedType;
  String? coverImageUrl;
  String? mediaLanguage;
  String? artistName;
  String? durationTime;
  String? title;
  String? description;

  PlaylistDatum({
    this.id,
    this.views,
    this.duration,
    this.link,
    this.visibleOnApp,
    this.peopleAlsoViewIds,
    this.viewCount,
    this.selectedType,
    this.coverImageUrl,
    this.mediaLanguage,
    this.artistName,
    this.durationTime,
    this.title,
    this.description,
  });

  factory PlaylistDatum.fromJson(Map<String, dynamic> json) => PlaylistDatum(
        id: json["id"],
        views: json["views"],
        duration: json["duration"],
        link: json["link"],
        visibleOnApp: json["visible_on_app"],
        peopleAlsoViewIds: json["people_also_view_ids"],
        viewCount: json["view_count"],
        selectedType: json["selected_type"],
        coverImageUrl: json["cover_image_url"],
        mediaLanguage: json["media_language"],
        artistName: json["artist_name"],
        durationTime: json["duration_time"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "views": views,
        "duration": duration,
        "link": link,
        "visible_on_app": visibleOnApp,
        "people_also_view_ids": peopleAlsoViewIds,
        "view_count": viewCount,
        "selected_type": selectedType,
        "cover_image_url": coverImageUrl,
        "media_language": mediaLanguage,
        "artist_name": artistName,
        "duration_time": durationTime,
        "title": title,
        "description": description,
      };
}
