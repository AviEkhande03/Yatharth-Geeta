import 'dart:convert';

VideoListModel VideoListingModelFromJson(String str) =>
    VideoListModel.fromJson(json.decode(str));

String booksListingModelToJson(VideoListModel data) =>
    json.encode(data.toJson());

class VideoListModel {
  int? success;
  String? message;
  Data? data;

  VideoListModel({this.success, this.message, this.data});

  VideoListModel.fromJson(Map<String, dynamic> json) {
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
  int? totalCount;
  int? remainingCount;

  Data({this.result, this.totalCount, this.remainingCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    totalCount = json['total_count'];
    remainingCount = json['remaining_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['total_count'] = this.totalCount;
    data['remaining_count'] = this.remainingCount;
    return data;
  }
}

class Result {
  int? id;
  String? title;
  String? link;
  String? artistName;
  bool? visibleOnApp;
  bool? hasEpisodes;
  String? peopleAlsoViewIds;
  String? coverImageUrl;
  String? mediaLanguage;
  String? durationTime;
  int? videoEpisodes;
  String? viewCount;

  Result(
      {this.id,
      this.title,
      this.link,
      this.artistName,
      this.visibleOnApp,
      this.hasEpisodes,
      this.peopleAlsoViewIds,
      this.coverImageUrl,
      this.mediaLanguage,
      this.durationTime,
      this.videoEpisodes,
      this.viewCount});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    artistName = json['artist_name'];
    visibleOnApp = json['visible_on_app'];
    hasEpisodes = json['has_episodes'];
    peopleAlsoViewIds = json['people_also_view_ids'];
    coverImageUrl = json['cover_image_url'];
    mediaLanguage = json['media_language'];
    durationTime = json['duration_time'];
    videoEpisodes = json['video_episodes'] == "" ? 0 : json['video_episodes'];
    viewCount = json['view_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['link'] = this.link;
    data['artist_name'] = this.artistName;
    data['visible_on_app'] = this.visibleOnApp;
    data['has_episodes'] = this.hasEpisodes;
    data['people_also_view_ids'] = this.peopleAlsoViewIds;
    data['cover_image_url'] = this.coverImageUrl;
    data['media_language'] = this.mediaLanguage;
    data['duration_time'] = this.durationTime;
    data['video_episodes'] = this.videoEpisodes;
    data['view_count'] = this.viewCount;
    return data;
  }
}
