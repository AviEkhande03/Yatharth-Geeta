// To parse this JSON data, do
//
//     final userMediaPlayedCreateModel = userMediaPlayedCreateModelFromJson(jsonString);

import 'dart:convert';

UserMediaPlayedCreateModel userMediaPlayedCreateModelFromJson(String str) =>
    UserMediaPlayedCreateModel.fromJson(json.decode(str));

String userMediaPlayedCreateModelToJson(UserMediaPlayedCreateModel data) =>
    json.encode(data.toJson());

class UserMediaPlayedCreateModel {
  int? success;
  String? message;
  Data? data;

  UserMediaPlayedCreateModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserMediaPlayedCreateModel.fromJson(Map<String, dynamic> json) =>
      UserMediaPlayedCreateModel(
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
  String? id;

  Result({
    this.id,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
