import 'dart:convert';

AudioDetailsModel AudioDetailsModelFromJson(String str) =>
    AudioDetailsModel.fromJson(json.decode(str));

String audioListingModelToJson(AudioDetailsModel data) =>
    json.encode(data.toJson());

class AudioDetailsModel {
  int? success;
  String? message;
  Data? data;

  AudioDetailsModel({this.success, this.message, this.data});

  AudioDetailsModel.fromJson(Map<String, dynamic> json) {
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
  List<PeopleAlsoReadData>? peopleAlsoReadData;
  Chapters? chapters;
  bool? wishList;
  String? title;
  String? description;

  Result(
      {this.id,
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
      this.peopleAlsoReadData,
      this.chapters,
      this.wishList,
      this.title,
      this.description});

  Result.fromJson(Map<String, dynamic> json) {
    print(json['chapters']);
    id = json['id'];
    hasEpisodes = json['has_episodes'];
    duration = json['duration'];
    views = json['views'];
    viewCount = json['view_count'];
    selectedType = json['selected_type'];
    mediaLanguage = json['media_language'];
    authorName = json['author_name'];
    audioFileUrl = json['audio_file_url'];
    audioCoverImageUrl = json['audio_cover_image_url'];
    audioSrtFileUrl = json['audio_srt_file_url'];
    durationTime = json['duration_time'];
    if (json['people_also_read_data'] != null) {
      peopleAlsoReadData = <PeopleAlsoReadData>[];
      json['people_also_read_data'].forEach((v) {
        peopleAlsoReadData!.add(new PeopleAlsoReadData.fromJson(v));
      });
    }
    chapters = json['chapters_v2'].runtimeType != List
        ? new Chapters.fromJson(json['chapters_v2'])
        : null;
    wishList = json['wish_list'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['has_episodes'] = this.hasEpisodes;
    data['duration'] = this.duration;
    data['views'] = this.views;
    data['view_count'] = this.viewCount;
    data['selected_type'] = this.selectedType;
    data['media_language'] = this.mediaLanguage;
    data['author_name'] = this.authorName;
    data['audio_file_url'] = this.audioFileUrl;
    data['audio_cover_image_url'] = this.audioCoverImageUrl;
    data['audio_srt_file_url'] = this.audioSrtFileUrl;
    data['duration_time'] = this.durationTime;
    if (this.peopleAlsoReadData != null) {
      data['people_also_read_data'] =
          this.peopleAlsoReadData!.map((v) => v.toJson()).toList();
    }
    if (this.chapters != null) {
      data['chapters'] = this.chapters!.toJson();
    }
    data['wish_list'] = this.wishList;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class PeopleAlsoReadData {
  int? id;
  String? title;
  String? audioCoverImageUrl;
  String? mediaLanguage;
  int? episodesCount;
  int? duration;
  bool? hasEpisodes;
  String? durationTime;
  String? authorName;
  String? viewCount;

  PeopleAlsoReadData(
      {this.id,
      this.title,
      this.audioCoverImageUrl,
      this.mediaLanguage,
      this.episodesCount,
      this.duration,
      this.hasEpisodes,
      this.durationTime,
      this.authorName,
      this.viewCount});

  PeopleAlsoReadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    audioCoverImageUrl = json['audio_cover_image_url'];
    mediaLanguage = json['media_language'];

    episodesCount = json['episodes_count'];
    duration = json['duration'];
    hasEpisodes = json['has_episodes'];
    durationTime = json['duration_time'];
    authorName = json['author_name'];
    viewCount = json['view_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['audio_cover_image_url'] = this.audioCoverImageUrl;
    data['media_language'] = this.mediaLanguage;
    data['episodes_count'] = this.episodesCount;
    data['duration'] = this.duration;
    data['has_episodes'] = this.hasEpisodes;
    data['duration_time'] = this.durationTime;
    data['author_name'] = this.authorName;
    data['view_count'] = this.viewCount;
    return data;
  }
}

class Chapters {
  List<ChaptersList>? chaptersList;
  int? totalChapters;
  int? totalVerses;

  Chapters({this.chaptersList, this.totalChapters, this.totalVerses});

  Chapters.fromJson(Map<String, dynamic> json) {
    if (json['chapters_list'] != null) {
      chaptersList = <ChaptersList>[];
      json['chapters_list'].forEach((v) {
        chaptersList!.add(new ChaptersList.fromJson(v));
      });
    }
    totalChapters = json['total_chapters'];
    totalVerses = json['total_verses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chaptersList != null) {
      data['chapters_list'] =
          this.chaptersList!.map((v) => v.toJson()).toList();
    }
    data['total_chapters'] = this.totalChapters;
    data['total_verses'] = this.totalVerses;
    return data;
  }
}

class ChaptersList {
  String? chapterName;
  dynamic chapterNumber;
  String? title;
  int? duration;
  String? audioFileUrl;
  String? audioSrtFileUrl;
  bool? wishList;
  String? explanationShlok;
  String? mainShlok;

  ChaptersList(
      {this.chapterName,
      this.chapterNumber,
      this.title,
      this.duration,
      this.audioFileUrl,
      this.audioSrtFileUrl,
      this.wishList,
      this.explanationShlok,
      this.mainShlok});

  ChaptersList.fromJson(Map<String, dynamic> json) {
    chapterName = json['chapter_name'];
    chapterNumber = json['chapter_number'];
    title = json['title'];
    duration = json['duration'];
    audioFileUrl = json['audio_file_url'];
    audioSrtFileUrl = json['audio_srt_file_url'];
    wishList = json['wish_list'];
    explanationShlok = json['explanation_shlok'];
    mainShlok = json['main_shlok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter_name'] = this.chapterName;
    data['chapter_number'] = this.chapterNumber;
    data['title'] = this.title;
    data['duration'] = this.duration;
    data['audio_file_url'] = this.audioFileUrl;
    data['audio_srt_file_url'] = this.audioSrtFileUrl;
    data['wish_list'] = this.wishList;
    data['explanation_shlok'] = this.explanationShlok;
    data['main_shlok'] = this.mainShlok;
    return data;
  }
}
