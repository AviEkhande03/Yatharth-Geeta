// To parse this JSON data, do
//
//     final userMediaPlayedAudioViewedModel = userMediaPlayedAudioViewedModelFromJson(jsonString);

import 'dart:convert';

UserMediaPlayedAudioViewedModel userMediaPlayedAudioViewedModelFromJson(
        String str) =>
    UserMediaPlayedAudioViewedModel.fromJson(json.decode(str));

String userMediaPlayedAudioViewedModelToJson(
        UserMediaPlayedAudioViewedModel data) =>
    json.encode(data.toJson());

class UserMediaPlayedAudioViewedModel {
  int? success;
  String? message;
  Data? data;

  UserMediaPlayedAudioViewedModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserMediaPlayedAudioViewedModel.fromJson(Map<String, dynamic> json) =>
      UserMediaPlayedAudioViewedModel(
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

  PlaylistDatum({
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

  factory PlaylistDatum.fromJson(Map<String, dynamic> json) => PlaylistDatum(
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
