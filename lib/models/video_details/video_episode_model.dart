import 'dart:convert';

VideoEpisodeModel VideoEpisodeModelFromJson(String str) =>
    VideoEpisodeModel.fromJson(json.decode(str));

String VideoEpisodeModelToJson(VideoEpisodeModel data) =>
    json.encode(data.toJson());

class VideoEpisodeModel {
  int? success;
  String? message;
  Data? data;

  VideoEpisodeModel({this.success, this.message, this.data});

  VideoEpisodeModel.fromJson(Map<String, dynamic> json) {
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
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? id;
  String? title;
  String? description;
  String? artistName;
  String? link;
  String? viewCount;
  bool? visibleOnApp;
  bool? isEpisode;
  String? peopleAlsoViewIds;
  String? coverImageUrl;
  String? mediaLanguage;
  String? durationTime;
  bool? wishList;
  List<RestOfEpisode>? restOfEpisode;

  Result(
      {this.id,
      this.title,
      this.description,
      this.artistName,
      this.link,
      this.viewCount,
      this.visibleOnApp,
      this.isEpisode,
      this.peopleAlsoViewIds,
      this.coverImageUrl,
      this.mediaLanguage,
      this.durationTime,
      this.wishList,
      this.restOfEpisode});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    artistName = json['artist_name'];
    link = json['link'];
    viewCount = json['view_count'];
    visibleOnApp = json['visible_on_app'];
    isEpisode = json['is_episode'];
    peopleAlsoViewIds = json['people_also_view_ids'];
    coverImageUrl = json['cover_image_url'];
    mediaLanguage = json['media_language'];
    durationTime = json['duration_time'];
    wishList = json['wish_list'];
    if (json['rest_of_episode'] != null) {
      restOfEpisode = <RestOfEpisode>[];
      json['rest_of_episode'].forEach((v) {
        restOfEpisode!.add(new RestOfEpisode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['artist_name'] = this.artistName;
    data['link'] = this.link;
    data['view_count'] = this.viewCount;
    data['visible_on_app'] = this.visibleOnApp;
    data['is_episode'] = this.isEpisode;
    data['people_also_view_ids'] = this.peopleAlsoViewIds;
    data['cover_image_url'] = this.coverImageUrl;
    data['media_language'] = this.mediaLanguage;
    data['duration_time'] = this.durationTime;
    data['wish_list'] = this.wishList;
    if (this.restOfEpisode != null) {
      data['rest_of_episode'] =
          this.restOfEpisode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestOfEpisode {
  int? id;
  String? title;
  String? description;
  String? coverImageUrl;
  String? mediaLanguage;
  int? duration;
  String? durationTime;
  String? artistName;
  String? viewCount;

  RestOfEpisode(
      {this.id,
      this.title,
      this.description,
      this.coverImageUrl,
      this.mediaLanguage,
      this.duration,
      this.durationTime,
      this.artistName,
      this.viewCount});

  RestOfEpisode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    coverImageUrl = json['cover_image_url'];
    mediaLanguage = json['media_language'];
    duration = json['duration'];
    durationTime = json['duration_time'];
    artistName = json['artist_name'];
    viewCount = json['view_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['cover_image_url'] = this.coverImageUrl;
    data['media_language'] = this.mediaLanguage;
    data['duration'] = this.duration;
    data['duration_time'] = this.durationTime;
    data['artist_name'] = this.artistName;
    data['view_count'] = this.viewCount;
    return data;
  }
}
