// To parse this JSON data, do
//
//     final bookDetailsModel = bookDetailsModelFromJson(jsonString);

import 'dart:convert';

BookDetailsModel bookDetailsModelFromJson(String str) =>
    BookDetailsModel.fromJson(json.decode(str));

String bookDetailsModelToJson(BookDetailsModel data) =>
    json.encode(data.toJson());

class BookDetailsModel {
  int? success;
  String? message;
  Data? data;

  BookDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  factory BookDetailsModel.fromJson(Map<String, dynamic> json) =>
      BookDetailsModel(
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
  Result? result;

  Data({
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
      };
}

class Result {
  int? id;
  int? pages;
  bool? downloadAllowed;
  String? viewCount;
  String? selectedType;
  String? coverImageUrl;
  String? pdfFileUrl;
  String? epubFileUrl;
  String? artistName;
  String? mediaLanguage;
  Video? video;
  Audio? audio;
  List<PeopleAlsoReadDatum>? peopleAlsoReadData;
  bool? wishList;
  String? epubWebviewUrl;
  String? name;
  String? shortDescription;
  String? description;

  Result({
    this.id,
    this.pages,
    this.downloadAllowed,
    this.viewCount,
    this.selectedType,
    this.coverImageUrl,
    this.pdfFileUrl,
    this.epubFileUrl,
    this.artistName,
    this.mediaLanguage,
    this.video,
    this.audio,
    this.peopleAlsoReadData,
    this.wishList,
    this.epubWebviewUrl,
    this.name,
    this.shortDescription,
    this.description,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        pages: json["pages"],
        downloadAllowed: json["download_allowed"],
        viewCount: json["view_count"],
        selectedType: json["selected_type"],
        coverImageUrl: json["cover_image_url"],
        pdfFileUrl: json["pdf_file_url"],
        epubFileUrl: json["epub_file_url"],
        artistName: json["artist_name"],
        mediaLanguage: json["media_language"],
        video: json["video"] == null ? null : Video.fromJson(json["video"]),
        audio: json["audio"] == null ? null : Audio.fromJson(json["audio"]),
        peopleAlsoReadData: json["people_also_read_data"] == null
            ? []
            : List<PeopleAlsoReadDatum>.from(json["people_also_read_data"]!
                .map((x) => PeopleAlsoReadDatum.fromJson(x))),
        wishList: json["wish_list"],
        epubWebviewUrl: json["epub_webview_url"],
        name: json["name"],
        shortDescription: json["short_description"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pages": pages,
        "download_allowed": downloadAllowed,
        "view_count": viewCount,
        "selected_type": selectedType,
        "cover_image_url": coverImageUrl,
        "pdf_file_url": pdfFileUrl,
        "epub_file_url": epubFileUrl,
        "artist_name": artistName,
        "media_language": mediaLanguage,
        "video": video?.toJson(),
        "audio": audio?.toJson(),
        "people_also_read_data": peopleAlsoReadData == null
            ? []
            : List<dynamic>.from(peopleAlsoReadData!.map((x) => x.toJson())),
        "wish_list": wishList,
        "epub_webview_url": epubWebviewUrl,
        "name": name,
        "short_description": shortDescription,
        "description": description,
      };
}

class Audio {
  int? id;
  bool? hasEpisodes;
  int? duration;
  int? views;
  String? viewCount;
  int? episodesCount;
  String? selectedType;
  String? mediaLanguage;
  String? authorName;
  String? audioFileUrl;
  String? audioCoverImageUrl;
  String? audioSrtFileUrl;
  String? durationTime;
  String? title;
  String? description;

  Audio({
    this.id,
    this.hasEpisodes,
    this.duration,
    this.views,
    this.viewCount,
    this.episodesCount,
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

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        id: json["id"],
        hasEpisodes: json["has_episodes"],
        duration: json["duration"],
        views: json["views"],
        viewCount: json["view_count"],
        episodesCount: json["episodes_count"],
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

class PeopleAlsoReadDatum {
  int? id;
  String? title;
  String? coverImageUrl;
  String? mediaLanguage;

  PeopleAlsoReadDatum({
    this.id,
    this.title,
    this.coverImageUrl,
    this.mediaLanguage,
  });

  factory PeopleAlsoReadDatum.fromJson(Map<String, dynamic> json) =>
      PeopleAlsoReadDatum(
        id: json["id"],
        title: json["title"],
        coverImageUrl: json["cover_image_url"],
        mediaLanguage: json["media_language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "cover_image_url": coverImageUrl,
        "media_language": mediaLanguage,
      };
}

class Video {
  int? id;
  dynamic views;
  int? duration;
  String? link;
  bool? visibleOnApp;
  dynamic peopleAlsoViewIds;
  String? viewCount;
  String? selectedType;
  String? coverImageUrl;
  String? mediaLanguage;
  String? artistName;
  String? durationTime;
  String? title;
  String? description;

  Video({
    this.id,
    this.views,
    this.duration,
    this.link,
    this.visibleOnApp,
    this.peopleAlsoViewIds,
    this.viewCount,
    this.selectedType,
    this.coverImageUrl,
    this.mediaLanguage,
    this.artistName,
    this.durationTime,
    this.title,
    this.description,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        views: json["views"],
        duration: json["duration"],
        link: json["link"],
        visibleOnApp: json["visible_on_app"],
        peopleAlsoViewIds: json["people_also_view_ids"],
        viewCount: json["view_count"],
        selectedType: json["selected_type"],
        coverImageUrl: json["cover_image_url"],
        mediaLanguage: json["media_language"],
        artistName: json["artist_name"],
        durationTime: json["duration_time"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "views": views,
        "duration": duration,
        "link": link,
        "visible_on_app": visibleOnApp,
        "people_also_view_ids": peopleAlsoViewIds,
        "view_count": viewCount,
        "selected_type": selectedType,
        "cover_image_url": coverImageUrl,
        "media_language": mediaLanguage,
        "artist_name": artistName,
        "duration_time": durationTime,
        "title": title,
        "description": description,
      };
}
