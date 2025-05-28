// To parse this JSON data, do
//
//     final eventDetailsModel = eventDetailsModelFromJson(jsonString);

import 'dart:convert';

EventDetailsModel eventDetailsModelFromJson(String str) =>
    EventDetailsModel.fromJson(json.decode(str));

String eventDetailsModelToJson(EventDetailsModel data) =>
    json.encode(data.toJson());

class EventDetailsModel {
  int? success;
  String? message;
  Data? data;

  EventDetailsModel({this.success, this.message, this.data});

  EventDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result = json["result"] == null ? null : Result.fromJson(json["result"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (result != null) {
      _data["result"] = result?.toJson();
    }
    return _data;
  }
}

class Result {
  int? id;
  String? eventCoverUrl;
  String? eventDate;
  String? startTime;
  String? endTime;
  String? artistImage;
  String? artistName;
  List<String>? eventImages;
  String? locationLatitude;
  String? locationLongitude;
  String? locationTitle;
  String? title;
  String? shortDescription;
  String? longDescription;

  Result(
      {this.id,
      this.eventCoverUrl,
      this.eventDate,
      this.startTime,
      this.endTime,
      this.artistImage,
      this.artistName,
      this.eventImages,
      this.locationLatitude,
      this.locationLongitude,
      this.locationTitle,
      this.title,
      this.shortDescription,
      this.longDescription});

  Result.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    eventCoverUrl = json["event_cover_url"];
    eventDate = json["event_date"];
    startTime = json["start_time"];
    endTime = json["end_time"];
    artistImage = json["artist_image"];
    artistName = json["artist_name"];
    eventImages = json["event_images"] == null
        ? null
        : List<String>.from(json["event_images"]);
    locationLatitude = json["location_latitude"];
    locationLongitude = json["location_longitude"];
    locationTitle = json["location_title"];
    title = json["title"];
    shortDescription = json["short_description"];
    longDescription = json["long_description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id ?? 0;
    _data["event_cover_url"] = eventCoverUrl ?? "";
    _data["event_date"] = eventDate ?? "";
    _data["start_time"] = startTime ?? "";
    _data["end_time"] = endTime ?? "";
    _data["artist_image"] = artistImage ?? "";
    _data["artist_name"] = artistName ?? "";
    if (eventImages != null) {
      _data["event_images"] = eventImages;
    } else {
      _data["event_images"] = [];
    }
    _data["location_latitude"] = locationLatitude ?? "";
    _data["location_longitude"] = locationLongitude ?? "";
    _data["location_title"] = locationTitle ?? "";
    _data["title"] = title ?? "";
    _data["short_description"] = shortDescription ?? "";
    _data["long_description"] = longDescription ?? "";
    return _data;
  }
}
