import 'dart:convert';

MantraModel mantraModelFromJson(String str) =>
    MantraModel.fromJson(json.decode(str));

String MantraModelToJson(MantraModel data) => json.encode(data.toJson());

class MantraModel {
  int? success;
  String? message;
  Data? data;

  MantraModel({this.success, this.message, this.data});

  MantraModel.fromJson(Map<String, dynamic> json) {
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
  List<Result>? result;
  int? totalCount;
  int? remainingCount;

  Data({this.result, this.totalCount, this.remainingCount});

  Data.fromJson(Map<String, dynamic> json) {
    result = json["result"] == null
        ? null
        : (json["result"] as List).map((e) => Result.fromJson(e)).toList();
    totalCount = json["total_count"];
    remainingCount = json["remaining_count"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (result != null) {
      _data["result"] = result?.map((e) => e.toJson()).toList();
    }
    _data["total_count"] = totalCount;
    _data["remaining_count"] = remainingCount;
    return _data;
  }
}

class Result {
  int? id;
  String? sanskritTitle;
  String? referenceName;
  String? referenceUrl;
  String? selectedType;
  String? meaning;

  Result(
      {this.id,
      this.sanskritTitle,
      this.referenceName,
      this.referenceUrl,
      this.selectedType,
      this.meaning});

  Result.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    sanskritTitle = json["sanskrit_title"] ?? "";
    referenceName = json["reference_name"] ?? "";
    referenceUrl = json["reference_url"] ?? "";
    selectedType = json["selected_type"] ?? "";
    meaning = json["meaning"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["sanskrit_title"] = sanskritTitle;
    _data["reference_name"] = referenceName;
    _data["reference_url"] = referenceUrl;
    _data["selected_type"] = selectedType;
    _data["meaning"] = meaning;
    return _data;
  }
}
