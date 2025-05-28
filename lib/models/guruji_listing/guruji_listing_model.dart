// To parse this JSON data, do
//
//     final gurujisListingModel = gurujisListingModelFromJson(jsonString);

import 'dart:convert';

GurujisListingModel gurujisListingModelFromJson(String str) =>
    GurujisListingModel.fromJson(json.decode(str));

String gurujisListingModelToJson(GurujisListingModel data) =>
    json.encode(data.toJson());

class GurujisListingModel {
  int? success;
  String? message;
  Data? data;

  GurujisListingModel({
    this.success,
    this.message,
    this.data,
  });

  factory GurujisListingModel.fromJson(Map<String, dynamic> json) =>
      GurujisListingModel(
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
  int? remainingCount;

  Data({
    this.result,
    this.totalCount,
    this.remainingCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        totalCount: json["total_count"],
        remainingCount: json["remaining_count"],
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "total_count": totalCount,
        "remaining_count": remainingCount,
      };
}

class Result {
  int? id;
  String? designation;
  String? imageUrl;
  String? name;
  String? title;
  String? description;

  Result({
    this.id,
    this.designation,
    this.imageUrl,
    this.name,
    this.title,
    this.description,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
