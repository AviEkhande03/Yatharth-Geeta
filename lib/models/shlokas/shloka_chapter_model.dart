import 'dart:convert';

ShlokaChapterModel shlokaChapterModelFromJson(String str) =>
    ShlokaChapterModel.fromJson(json.decode(str));

String shlokaChapterModelToJson(ShlokaChapterModel data) =>
    json.encode(data.toJson());

class ShlokaChapterModel {
  int? success;
  String? message;
  Data? data;

  ShlokaChapterModel({this.success, this.message, this.data});

  ShlokaChapterModel.fromJson(Map<String, dynamic> json) {
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
  List<Result>? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? chapterId;
  int? chapterNumber;

  Result({this.chapterId, this.chapterNumber});

  Result.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapter_id'];
    chapterNumber = json['chapter_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter_id'] = this.chapterId;
    data['chapter_number'] = this.chapterNumber;
    return data;
  }
}
