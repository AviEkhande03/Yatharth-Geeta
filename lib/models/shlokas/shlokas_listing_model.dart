// To parse this JSON data, do
//
//     final shlokasListingModel = shlokasListingModelFromJson(jsonString);

import 'dart:convert';

ShlokasListingModel shlokasListingModelFromJson(String str) =>
    ShlokasListingModel.fromJson(json.decode(str));

String shlokasListingModelToJson(ShlokasListingModel data) =>
    json.encode(data.toJson());

class ShlokasListingModel {
  int? success;
  String? message;
  Data? data;

  ShlokasListingModel({this.success, this.message, this.data});

  ShlokasListingModel.fromJson(Map<String, dynamic> json) {
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
  int? chapterNumber;
  int? verseNumber;
  String? mainShlok;
  String? explainationShlok;
  String? shlokAudioFileUrl;

  Result(
      {this.chapterNumber,
      this.verseNumber,
      this.mainShlok,
      this.explainationShlok,
      this.shlokAudioFileUrl});

  Result.fromJson(Map<String, dynamic> json) {
    chapterNumber = json['chapter_number'];
    verseNumber = json['verse_number'];
    mainShlok = json['main_shlok'];
    explainationShlok = json['explaination_shlok'];
    shlokAudioFileUrl = json['shlok_audio_file_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter_number'] = this.chapterNumber;
    data['verse_number'] = this.verseNumber;
    data['main_shlok'] = this.mainShlok;
    data['explaination_shlok'] = this.explainationShlok;
    data['shlok_audio_file_url'] = this.shlokAudioFileUrl;
    return data;
  }
}
