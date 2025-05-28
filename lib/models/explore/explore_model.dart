import 'dart:convert';

ExploreModel ExploreModelFromJson(String str) =>
    ExploreModel.fromJson(json.decode(str));

// String ExploreModelToJson(ExploreModel data) => json.encode(data.toJson());

class ExploreModel {
  int? success;
  String? message;
  Data? data;

  ExploreModel({
    this.success,
    this.message,
    this.data,
  });
  factory ExploreModel.fromJson(Map<String, dynamic> json) {
    return ExploreModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json["data"]));
  }
}

class Data {
  List<Result>? result;
  int? totalCount;
  int? remainingCount;

  Data({
    this.result,
    this.totalCount,
    this.remainingCount,
  });
  Data.fromJson(Map<String, dynamic> json) {
    result = (json['result'] as List).map((e) => Result.fromJson(e)).toList();
    totalCount = json["total_count"];
    remainingCount = json["remaining_count"];
  }
}

class Result {
  int? id;
  String? type;
  bool? isScrollable;
  int? displayInColumn;
  List<CollectionDatum>? collectionData;
  String? title;
  String? description;

  Result({
    this.id,
    this.type,
    this.isScrollable,
    this.displayInColumn,
    this.collectionData,
    this.title,
    this.description,
  });
  Result.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    type = json["type"] ?? "";
    isScrollable = json["is_scrollable"] ?? false;
    displayInColumn = json["display_in_column"] ?? 1;
    title = json["title"] ?? "";
    description = json["description"] ?? "";
    collectionData = (json["collection_data"] as List)
        .map((e) => CollectionDatum.fromJson(e))
        .toList();
  }
}

class CollectionDatum {
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
  String? title;
  String? quoteImageUrl;
  bool? hasEpisodes;
  int? duration;
  int? views;
  String? authorName;
  String? audioFileUrl;
  String? audioCoverImageUrl;
  String? audioSrtFileUrl;
  String? durationTime;
  String? sanskritTitle;
  String? referenceName;
  String? referenceUrl;
  String? meaning;

  CollectionDatum({
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
    this.title,
    this.quoteImageUrl,
    this.hasEpisodes,
    this.duration,
    this.views,
    this.authorName,
    this.audioFileUrl,
    this.audioCoverImageUrl,
    this.audioSrtFileUrl,
    this.durationTime,
    this.sanskritTitle,
    this.referenceName,
    this.referenceUrl,
    this.meaning,
  });

  CollectionDatum.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    pages = json['pages'] ?? 0;
    downloadAllowed = json['download_allowed'] ?? false;
    viewCount = json["view_count"] ?? "";
    selectedType = json["selected_type"] ?? "";
    coverImageUrl = json["cover_image_url"] ?? "";
    pdfFileUrl = json["pdf_file_url"] ?? "";
    epubFileUrl = json["epub_file_url"] ?? "";
    artistName = json["artist_name"] ?? "";
    mediaLanguage = json["media_language"] ?? "";
    name = json["name"] ?? "";
    shortDescription = json["short_description"] ?? "";
    description = json["description"] ?? "";
    title = json["title"] ?? "";
    quoteImageUrl = json["quote_image_url"] ?? "";
    hasEpisodes = json["has_episodes"] ?? false;
    duration = json["duration"] ?? 0;
    views = json["view"] ?? 0;
    authorName = json["author_name"] ?? "";
    audioFileUrl = json["audio_file_url"] ?? "";
    audioCoverImageUrl = json["audio_cover_image_url"] ?? "";
    audioSrtFileUrl = json["audio_srt_file_url"] ?? "";
    durationTime = json["duration_time"] ?? "";
    sanskritTitle = json["sanskrit_title"] ?? "";
    referenceName = json["reference_name"] ?? "";
    referenceUrl = json["reference_url"] ?? "";
    meaning = json["meaning"] ?? "";
  }
}
