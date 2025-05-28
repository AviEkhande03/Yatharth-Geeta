import 'dart:convert';

AudioChapterModel audioChapterModelFromJson(String str) =>
    AudioChapterModel.fromJson(json.decode(str));

String AudioChapterModelToJson(AudioChapterModel data) =>
    json.encode(data.toJson());

class AudioChapterModel {
  int? success;
  String? message;
  Data? data;

  AudioChapterModel({this.success, this.message, this.data});

  AudioChapterModel.fromJson(Map<String, dynamic> json) {
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
  dynamic chapterNumber;
  dynamic versesNumber;
  String? versesName;
  String? audioFileUrl;
  String? audioSrtFileUrl;
  int? duration;
  String? explanationShlok;
  String? mainShlok;
  bool? wishList;

  Result(
      {this.chapterNumber,
      this.versesNumber,
      this.versesName,
      this.audioFileUrl,
      this.audioSrtFileUrl,
      this.duration,
      this.explanationShlok,
      this.mainShlok,
      this.wishList});

  Result.fromJson(Map<String, dynamic> json) {
    chapterNumber = json["chapter_number"] ?? "";
    versesNumber = json["verses_number"] ?? "";
    versesName = json["verses_name"] ?? "";
    audioFileUrl = json["audio_file_url"] ?? "";
    audioSrtFileUrl = json["audio_srt_file_url"] ?? "";
    duration = json["duration"] ?? 0;
    explanationShlok = json["explanation_shlok"] ?? "";
    mainShlok = json["main_shlok"] ?? "";
    wishList = json["wish_list"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["chapter_number"] = chapterNumber;
    _data["verses_number"] = versesNumber;
    _data["verses_name"] = versesName;
    _data["audio_file_url"] = audioFileUrl;
    _data["audio_srt_file_url"] = audioSrtFileUrl;
    _data["duration"] = duration;
    _data["explanation_shlok"] = explanationShlok;
    _data["main_shlok"] = mainShlok;
    _data["wish_list"] = wishList;
    return _data;
  }
}
