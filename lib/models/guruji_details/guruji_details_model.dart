// To parse this JSON data, do
//
//     final gurujiDetailsModel = gurujiDetailsModelFromJson(jsonString);

import 'dart:convert';

GurujiDetailsModel gurujiDetailsModelFromJson(String str) => GurujiDetailsModel.fromJson(json.decode(str));

String gurujiDetailsModelToJson(GurujiDetailsModel data) => json.encode(data.toJson());

class GurujiDetailsModel {
  int? success;
  String? message;
  Data? data;

  GurujiDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  factory GurujiDetailsModel.fromJson(Map<String, dynamic> json) => GurujiDetailsModel(
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
  Artist? artist;
  List<TopBook>? topBooks;
  List<TopVideo>? topVideos;

  Result({
    this.artist,
    this.topBooks,
    this.topVideos,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    artist: json["artist"] == null ? null : Artist.fromJson(json["artist"]),
    topBooks: json["top_books"] == null ? [] : List<TopBook>.from(json["top_books"]!.map((x) => TopBook.fromJson(x))),
    topVideos: json["top_videos"] == null ? [] : List<TopVideo>.from(json["top_videos"]!.map((x) => TopVideo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "artist": artist?.toJson(),
    "top_books": topBooks == null ? [] : List<dynamic>.from(topBooks!.map((x) => x.toJson())),
    "top_videos": topVideos == null ? [] : List<dynamic>.from(topVideos!.map((x) => x.toJson())),
  };
}

class Artist {
  int? id;
  String? designation;
  String? imageUrl;
  String? name;
  String? title;
  String? description;

  Artist({
    this.id,
    this.designation,
    this.imageUrl,
    this.name,
    this.title,
    this.description,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    id: json["id"],
    designation: json["designation"],
    imageUrl: json["image_url"],
    name: json["name"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "designation": designation,
    "image_url": imageUrl,
    "name": name,
    "title": title,
    "description": description,
  };
}

class TopBook {
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
  String? name;
  String? shortDescription;
  String? description;

  TopBook({
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
    this.name,
    this.shortDescription,
    this.description,
  });

  factory TopBook.fromJson(Map<String, dynamic> json) => TopBook(
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
    "name": name,
    "short_description": shortDescription,
    "description": description,
  };
}

class TopVideo {
  int? id;
  dynamic views;
  int? duration;
  String? link;
  bool? visibleOnApp;
  String? peopleAlsoViewIds;
  String? viewCount;
  String? selectedType;
  String? coverImageUrl;
  String? mediaLanguage;
  String? artistName;
  String? durationTime;
  String? title;
  String? description;

  TopVideo({
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

  factory TopVideo.fromJson(Map<String, dynamic> json) => TopVideo(
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
