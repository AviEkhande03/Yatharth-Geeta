// To parse this JSON data, do
//
//     final userMediaWishlistCreateModel = userMediaWishlistCreateModelFromJson(jsonString);

import 'dart:convert';

UserMediaWishlistCreateModel userMediaWishlistCreateModelFromJson(String str) =>
    UserMediaWishlistCreateModel.fromJson(json.decode(str));

String userMediaWishlistCreateModelToJson(UserMediaWishlistCreateModel data) =>
    json.encode(data.toJson());

class UserMediaWishlistCreateModel {
  int? success;
  String? message;
  Data? data;

  UserMediaWishlistCreateModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserMediaWishlistCreateModel.fromJson(Map<String, dynamic> json) =>
      UserMediaWishlistCreateModel(
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
