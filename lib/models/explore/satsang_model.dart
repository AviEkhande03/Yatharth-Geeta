import 'dart:convert';

SatsangModel SatsangModelFromJson(String str) =>
    SatsangModel.fromJson(json.decode(str));

class SatsangModel {
  int? success;
  String? message;
  Data? data;

  SatsangModel({this.success, this.message, this.data});

  SatsangModel.fromJson(Map<String, dynamic> json) {
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

  Data({this.result, this.totalCount});

  Data.fromJson(Map<String, dynamic> json) {
    result = json["result"] == null
        ? null
        : (json["result"] as List).map((e) => Result.fromJson(e)).toList();
    totalCount = json["total_count"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (result != null) {
      _data["result"] = result?.map((e) => e.toJson()).toList();
    }
    _data["total_count"] = totalCount;
    return _data;
  }
}

class Result {
  int? id;
  int? duration;
  String? selectedType;
  String? mediaLanguage;
  String? authorName;
  String? durationTime;
  String? satsangFileUrl;
  String? satsangCoverImageUrl;
  String? title;
  String? description;

  Result(
      {this.id,
      this.duration,
      this.selectedType,
      this.mediaLanguage,
      this.authorName,
      this.durationTime,
      this.satsangFileUrl,
      this.satsangCoverImageUrl,
      this.title,
      this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    duration = json["duration"] ?? 0;
    selectedType = json["selected_type"] ?? "";
    mediaLanguage = json["media_language"] ?? "";
    authorName = json["author_name"] ?? "";
    durationTime = json["duration_time"] ?? "";
    satsangFileUrl = json["satsang_file_url"] ?? "";
    satsangCoverImageUrl = json["satsang_cover_image_url"] ?? "";
    title = json["title"] ?? "";
    description = json["description"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["duration"] = duration;
    _data["selected_type"] = selectedType;
    _data["media_language"] = mediaLanguage;
    _data["author_name"] = authorName;
    _data["duration_time"] = durationTime;
    _data["satsang_file_url"] = satsangFileUrl;
    _data["satsang_cover_image_url"] = satsangCoverImageUrl;
    _data["title"] = title;
    _data["description"] = description;
    return _data;
  }
}
