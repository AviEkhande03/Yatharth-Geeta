// To parse this JSON data, do
//
//     final eventsListingModel = eventsListingModelFromJson(jsonString);

import 'dart:convert';

EventsListingModel eventsListingModelFromJson(String str) => EventsListingModel.fromJson(json.decode(str));

String eventsListingModelToJson(EventsListingModel data) => json.encode(data.toJson());

class EventsListingModel {
  int? success;
  String? message;
  Data? data;

  EventsListingModel({
    this.success,
    this.message,
    this.data,
  });

  factory EventsListingModel.fromJson(Map<String, dynamic> json) => EventsListingModel(
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
  Events? pastEvents;
  Events? upcomingEvents;

  Result({
    this.pastEvents,
    this.upcomingEvents,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pastEvents: json["past_events"] == null ? null : Events.fromJson(json["past_events"]),
    upcomingEvents: json["upcoming_events"] == null ? null : Events.fromJson(json["upcoming_events"]),
  );

  Map<String, dynamic> toJson() => {
    "past_events": pastEvents?.toJson(),
    "upcoming_events": upcomingEvents?.toJson(),
  };
}

class Events {
  List<ListElement>? list;
  int? totalCount;
  int? remainingCount;

  Events({
    this.list,
    this.totalCount,
    this.remainingCount,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
    totalCount: json["total_count"],
    remainingCount: json["remaining_count"],
  );

  Map<String, dynamic> toJson() => {
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
    "total_count": totalCount,
    "remaining_count": remainingCount,
  };
}

class ListElement {
  int? id;
  String? eventCoverUrl;
  String? eventDate;
  String? startTime;
  String? endTime;
  String? artistImage;
  String? artistName;
  String? title;
  String? shortDescription;
  String? longDescription;

  ListElement({
    this.id,
    this.eventCoverUrl,
    this.eventDate,
    this.startTime,
    this.endTime,
    this.artistImage,
    this.artistName,
    this.title,
    this.shortDescription,
    this.longDescription,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    eventCoverUrl: json["event_cover_url"],
    eventDate: json["event_date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    artistImage: json["artist_image"],
    artistName: json["artist_name"],
    title: json["title"],
    shortDescription: json["short_description"],
    longDescription: json["long_description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_cover_url": eventCoverUrl,
    "event_date": eventDate,
    "start_time": startTime,
    "end_time": endTime,
    "artist_image": artistImage,
    "artist_name": artistName,
    "title": title,
    "short_description": shortDescription,
    "long_description": longDescription,
  };
}
