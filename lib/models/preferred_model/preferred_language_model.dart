// To parse this JSON data, do
//
//     final preferredLanguageModel = preferredLanguageModelFromJson(jsonString);

import 'dart:convert';

PreferredLanguageModel preferredLanguageModelFromJson(String str) => PreferredLanguageModel.fromJson(json.decode(str));

String preferredLanguageModelToJson(PreferredLanguageModel data) => json.encode(data.toJson());

class PreferredLanguageModel {
  int? success;
  String? message;
  Data? data;

  PreferredLanguageModel({
    this.success,
    this.message,
    this.data,
  });

  factory PreferredLanguageModel.fromJson(Map<String, dynamic> json) => PreferredLanguageModel(
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

  Data({
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  String? value;
  String? countryCode;
  String? english;
  String? native;
  bool? resultDefault;

  Result({
    this.value,
    this.countryCode,
    this.english,
    this.native,
    this.resultDefault,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    value: json["value"],
    countryCode: json["country_code"],
    english: json["english"],
    native: json["native"],
    resultDefault: json["default"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "country_code": countryCode,
    "english": english,
    "native": native,
    "default": resultDefault,
  };
}
