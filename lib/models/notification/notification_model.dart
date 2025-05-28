// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  int? success;
  String? message;
  Data? data;

  NotificationModel({
    this.success,
    this.message,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
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
  List<Result>? result;
  int? totalCount;

  Data({
    this.result,
    this.totalCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    totalCount: json["total_count"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "total_count": totalCount,
  };
}

class Result {
  DateTime? date;
  List<Value>? value;

  Result({
    this.date,
    this.value,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    value: json["value"] == null ? [] : List<Value>.from(json["value"]!.map((x) => Value.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x.toJson())),
  };
}

class Value {
  int? id;
  String? title;
  String? body;
  String? notificationImageUrl;
  String? notificationType;
  String? collectionType;
  String? collectionTitle;
  int? selectedId;

  Value({
    this.id,
    this.title,
    this.body,
    this.notificationImageUrl,
    this.notificationType,
    this.collectionType,
    this.collectionTitle,
    this.selectedId,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    notificationImageUrl: json["notification_image_url"],
    notificationType: json["notification_type"]!,
    collectionType: json["collection_type"],
    collectionTitle: json["collection_title"],
    selectedId: json["selected_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "notification_image_url": notificationImageUrl,
    "notification_type": notificationType,
    "collection_type": collectionType,
    "collection_title": collectionTitle,
    "selected_id": selectedId,
  };
}

