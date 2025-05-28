import 'dart:convert';

AudioListModel AudioListingModelFromJson(String str) =>
    AudioListModel.fromJson(json.decode(str));

String AudioListingModelToJson(AudioListModel data) =>
    json.encode(data.toJson());

class AudioListModel {
  int? success;
  String? message;
  Data? data;

  AudioListModel({this.success, this.message, this.data});

  AudioListModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  List<Result>? result;
  int? totalCount;
  int? remainingCount;

  Data({this.result, this.totalCount, this.remainingCount});

  Data.fromJson(Map<String, dynamic> json) {
    result = json["result"] == null
        ? null
        : (json["result"] as List).map((e) => Result.fromJson(e)).toList();
    totalCount = json["total_count"];
    remainingCount = json["remaining_count"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (result != null) {
      _data["result"] = result?.map((e) => e.toJson()).toList();
    }
    _data["total_count"] = totalCount;
    _data["remaining_count"] = remainingCount;
    return _data;
  }
}

class Result {
  int? id;
  bool? hasEpisodes;
  int? duration;
  int? views;
  String? viewCount;
  String? selectedType;
  int? episodeCount;
  String? mediaLanguage;
  String? authorName;
  String? audioFileUrl;
  String? audioCoverImageUrl;
  String? audioSrtFileUrl;
  String? title;
  String? description;

  Result(
      {this.id,
      this.hasEpisodes,
      this.duration,
      this.views,
      this.viewCount,
      this.selectedType,
      this.episodeCount,
      this.mediaLanguage,
      this.authorName,
      this.audioFileUrl,
      this.audioCoverImageUrl,
      this.audioSrtFileUrl,
      this.title,
      this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    hasEpisodes = json["has_episodes"] ?? false;
    duration = json["duration"] ?? 0;
    views = json["views"] ?? 0;
    viewCount = json["view_count"] ?? "";
    selectedType = json["selected_type"] ?? "";
    episodeCount = json["episodes_count"] ?? 0;
    mediaLanguage = json["media_language"] ?? "";
    authorName = json["author_name"] ?? "";
    audioFileUrl = json["audio_file_url"] ?? "";
    audioCoverImageUrl =
        json["audio_cover_image_url"] ?? json["satsang_cover_image_url"] ?? "";
    audioSrtFileUrl = json["audio_srt_file_url"] ?? "";
    title = json["title"] ?? "";
    description = json["description"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["has_episodes"] = hasEpisodes;
    _data["duration"] = duration;
    _data["views"] = views;
    _data["view_count"] = viewCount;
    _data["selected_type"] = selectedType;
    _data["episodes_count"] = episodeCount;
    _data["media_language"] = mediaLanguage;
    _data["author_name"] = authorName;
    _data["audio_file_url"] = audioFileUrl;
    _data["audio_cover_image_url"] = audioCoverImageUrl;
    _data["audio_srt_file_url"] = audioSrtFileUrl;
    _data["title"] = title;
    _data["description"] = description;
    return _data;
  }
}
