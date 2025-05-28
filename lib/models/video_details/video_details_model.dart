import 'dart:convert';

VideoDetailsModel VideoDetailsModelFromJson(String str) =>
    VideoDetailsModel.fromJson(json.decode(str));

String videoListingModelToJson(VideoDetailsModel data) =>
    json.encode(data.toJson());

class VideoDetailsModel {
  int? success;
  String? message;
  Data? data;

  VideoDetailsModel({this.success, this.message, this.data});

  VideoDetailsModel.fromJson(Map<String, dynamic> json) {
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
  bool? hasEpisodes;
  String? peopleAlsoViewIds;
  String? coverImageUrl;
  String? mediaLanguage;
  String? durationTime;
  List<PeopleAlsoViewData>? peopleAlsoViewData;
  VideoEpisodes? videoEpisodes;
  bool? wishList;

  Result(
      {this.id,
      this.title,
      this.description,
      this.artistName,
      this.link,
      this.viewCount,
      this.visibleOnApp,
      this.hasEpisodes,
      this.peopleAlsoViewIds,
      this.coverImageUrl,
      this.mediaLanguage,
      this.durationTime,
      this.peopleAlsoViewData,
      this.videoEpisodes,
      this.wishList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    artistName = json['artist_name'];
    link = json['link'];
    viewCount = json['view_count'];
    visibleOnApp = json['visible_on_app'];
    hasEpisodes = json['has_episodes'];
    peopleAlsoViewIds = json['people_also_view_ids'];
    coverImageUrl = json['cover_image_url'];
    mediaLanguage = json['media_language'];
    durationTime = json['duration_time'];
    if (json['people_also_view_data'] != null) {
      peopleAlsoViewData = <PeopleAlsoViewData>[];
      json['people_also_view_data'].forEach((v) {
        peopleAlsoViewData!.add(new PeopleAlsoViewData.fromJson(v));
      });
    } else {
      peopleAlsoViewData = [];
    }
    videoEpisodes = json['video_episodes'].runtimeType != List
        ? new VideoEpisodes.fromJson(json['video_episodes'])
        : null;
    wishList = json['wish_list'];
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
    data['has_episodes'] = this.hasEpisodes;
    data['people_also_view_ids'] = this.peopleAlsoViewIds;
    data['cover_image_url'] = this.coverImageUrl;
    data['media_language'] = this.mediaLanguage;
    data['duration_time'] = this.durationTime;
    if (this.peopleAlsoViewData != null) {
      data['people_also_view_data'] =
          this.peopleAlsoViewData!.map((v) => v.toJson()).toList();
    }
    if (this.videoEpisodes != null) {
      data['video_episodes'] = this.videoEpisodes!.toJson();
    }
    data['wish_list'] = this.wishList;
    return data;
  }
}

class PeopleAlsoViewData {
  int? id;
  String? title;
  String? description;
  String? coverImageUrl;
  String? mediaLanguage;
  int? duration;
  String? durationTime;
  String? artistName;
  String? viewCount;

  PeopleAlsoViewData(
      {this.id,
      this.title,
      this.description,
      this.coverImageUrl,
      this.mediaLanguage,
      this.duration,
      this.durationTime,
      this.artistName,
      this.viewCount});

  PeopleAlsoViewData.fromJson(Map<String, dynamic> json) {
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

class VideoEpisodes {
  List<EpisodesList>? episodesList;
  int? totalEpisodes;

  VideoEpisodes({this.episodesList, this.totalEpisodes});

  VideoEpisodes.fromJson(Map<String, dynamic> json) {
    if (json['episodes_list'] != null) {
      episodesList = <EpisodesList>[];
      json['episodes_list'].forEach((v) {
        episodesList!.add(new EpisodesList.fromJson(v));
      });
    }
    totalEpisodes = json['total_episodes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.episodesList != null) {
      data['episodes_list'] =
          this.episodesList!.map((v) => v.toJson()).toList();
    }
    data['total_episodes'] = this.totalEpisodes;
    return data;
  }
}

class EpisodesList {
  int? id;
  String? title;
  String? description;
  String? coverImageUrl;
  String? mediaLanguage;
  int? duration;
  String? durationTime;

  EpisodesList(
      {this.id,
      this.title,
      this.description,
      this.coverImageUrl,
      this.mediaLanguage,
      this.duration,
      this.durationTime});

  EpisodesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    coverImageUrl = json['cover_image_url'];
    mediaLanguage = json['media_language'];
    duration = json['duration'];
    durationTime = json['duration_time'];
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
    return data;
  }
}
