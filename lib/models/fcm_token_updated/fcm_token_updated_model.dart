// To parse this JSON data, do
//
//     final fcmTokenUpdatedModel = fcmTokenUpdatedModelFromJson(jsonString);

import 'dart:convert';

FcmTokenUpdatedModel fcmTokenUpdatedModelFromJson(String str) =>
    FcmTokenUpdatedModel.fromJson(json.decode(str));

String fcmTokenUpdatedModelToJson(FcmTokenUpdatedModel data) =>
    json.encode(data.toJson());

class FcmTokenUpdatedModel {
  int? success;
  String? message;
  Data? data;

  FcmTokenUpdatedModel({
    this.success,
    this.message,
    this.data,
  });

  factory FcmTokenUpdatedModel.fromJson(Map<String, dynamic> json) =>
      FcmTokenUpdatedModel(
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
  String? result;

  Data({
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
      };
}
