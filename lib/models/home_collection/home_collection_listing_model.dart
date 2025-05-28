// To parse this JSON data, do
//
//     final homeCollectionListingModel = homeCollectionListingModelFromJson(jsonString);

import 'dart:convert';

HomeCollectionListingModel homeCollectionListingModelFromJson(String str) =>
    HomeCollectionListingModel.fromJson(json.decode(str));

String homeCollectionListingModelToJson(HomeCollectionListingModel data) =>
    json.encode(data.toJson());

class HomeCollectionListingModel {
  int? success;
  String? message;
  Data? data;

  HomeCollectionListingModel({this.success, this.message, this.data});

  HomeCollectionListingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Result>? result;
  int? totalCount;

  Data({this.result, this.totalCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['total_count'] = totalCount;
    return data;
  }
}

class Result {
  int? id;
  String? type;
  bool? isScrollable;
  int? displayInColumn;
  String? singleCollectionImage;
  List<CollectionDatum>? collectionData;
  int? isClickable;
  String? title;
  String? description;

  Result(
      {this.id,
      this.type,
      this.isScrollable,
      this.displayInColumn,
      this.singleCollectionImage,
      this.collectionData,
      this.isClickable,
      this.title,
      this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    isScrollable = json['is_scrollable'];
    displayInColumn = json['display_in_column'];
    singleCollectionImage = json['single_collection_image'];
    if (json['collection_data'] != null) {
      collectionData = <CollectionDatum>[];
      json['collection_data'].forEach((v) {
        collectionData!.add(CollectionDatum.fromJson(v));
      });
    }
    isClickable = json['is_clickable'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['is_scrollable'] = isScrollable;
    data['display_in_column'] = displayInColumn;
    data['single_collection_image'] = singleCollectionImage;
    if (collectionData != null) {
      data['collection_data'] = collectionData!.map((v) => v.toJson()).toList();
    }
    data['is_clickable'] = isClickable;
    data['title'] = title;
    data['description'] = description;
    return data;
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
  String? chapterName;
  dynamic chapterNumber;
  dynamic versesNumber;
  String? versesName;
  String? explanationShlok;
  String? mainShlok;
  String? durationTime;
  bool? isClickable;
  String? mappedTo;
  String? multipleCollectionImage;
  String? designation;
  String? imageUrl;
  String? title;
  bool? hasEpisodes;
  int? duration;
  int? views;
  String? authorName;
  String? audioFileUrl;
  String? audioCoverImageUrl;
  String? audioSrtFileUrl;
  String? link;
  bool? visibleOnApp;
  String? peopleAlsoViewIds;

  CollectionDatum(
      {this.id,
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
      this.chapterName,
      this.chapterNumber,
      this.versesNumber,
      this.versesName,
      this.explanationShlok,
      this.mainShlok,
      this.durationTime,
      this.isClickable,
      this.mappedTo,
      this.multipleCollectionImage,
      this.designation,
      this.imageUrl,
      this.title,
      this.hasEpisodes,
      this.duration,
      this.views,
      this.authorName,
      this.audioFileUrl,
      this.audioCoverImageUrl,
      this.audioSrtFileUrl,
      this.link,
      this.visibleOnApp,
      this.peopleAlsoViewIds});

  CollectionDatum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pages = json['pages'];
    downloadAllowed = json['download_allowed'];
    viewCount = json['view_count'];
    selectedType = json['selected_type'];
    coverImageUrl = json['cover_image_url'];
    pdfFileUrl = json['pdf_file_url'];
    epubFileUrl = json['epub_file_url'];
    artistName = json['artist_name'];
    mediaLanguage = json['media_language'];
    name = json['name'];
    shortDescription = json['short_description'];
    description = json['description'];
    chapterName = json['chapter_name'];
    chapterNumber = json['chapter_number'];
    versesNumber = json['verses_number'];
    versesName = json['verses_name'];
    explanationShlok = json['explanation_shlok'];
    mainShlok = json['main_shlok'];
    durationTime = json['duration_time'];
    isClickable = json['is_clickable'];
    mappedTo = json['mapped_to'];
    multipleCollectionImage = json['multiple_collection_image'];
    designation = json['designation'];
    imageUrl = json['image_url'];
    title = json['title'];
    hasEpisodes = json['has_episodes'];
    duration = json['duration'];
    views = json['views'];
    authorName = json['author_name'];
    audioFileUrl = json['audio_file_url'];
    audioCoverImageUrl = json['audio_cover_image_url'];
    audioSrtFileUrl = json['audio_srt_file_url'];
    link = json['link'];
    visibleOnApp = json['visible_on_app'];
    peopleAlsoViewIds = json['people_also_view_ids'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pages'] = pages;
    data['download_allowed'] = downloadAllowed;
    data['view_count'] = viewCount;
    data['selected_type'] = selectedType;
    data['cover_image_url'] = coverImageUrl;
    data['pdf_file_url'] = pdfFileUrl;
    data['epub_file_url'] = epubFileUrl;
    data['artist_name'] = artistName;
    data['media_language'] = mediaLanguage;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['chapter_name'] = chapterName;
    data['chapter_number'] = chapterNumber;
    data['verses_number'] = versesNumber;
    data['verses_name'] = versesName;
    data['explanation_shlok'] = explanationShlok;
    data['main_shlok'] = mainShlok;
    data['duration_time'] = durationTime;
    data['is_clickable'] = isClickable;
    data['mapped_to'] = mappedTo;
    data['multiple_collection_image'] = multipleCollectionImage;
    data['designation'] = designation;
    data['image_url'] = imageUrl;
    data['title'] = title;
    data['has_episodes'] = hasEpisodes;
    data['duration'] = duration;
    data['views'] = views;
    data['author_name'] = authorName;
    data['audio_file_url'] = audioFileUrl;
    data['audio_cover_image_url'] = audioCoverImageUrl;
    data['audio_srt_file_url'] = audioSrtFileUrl;
    data['link'] = link;
    data['visible_on_app'] = visibleOnApp;
    data['people_also_view_ids'] = peopleAlsoViewIds;
    return data;
  }
}
