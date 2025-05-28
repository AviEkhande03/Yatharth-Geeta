// To parse this JSON data, do
//
//     final termsAndConditionsModel = termsAndConditionsModelFromJson(jsonString);

import 'dart:convert';

TermsAndConditionsModel termsAndConditionsModelFromJson(String str) =>
    TermsAndConditionsModel.fromJson(json.decode(str));

String termsAndConditionsModelToJson(TermsAndConditionsModel data) =>
    json.encode(data.toJson());

class TermsAndConditionsModel {
  int? success;
  String? message;
  Data? data;

  TermsAndConditionsModel({
    this.success,
    this.message,
    this.data,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionsModel(
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
  String? content;

  Result({
    this.content,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
      };
}
