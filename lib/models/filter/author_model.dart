class AuthorModel {
  int? success;
  String? message;
  Data? data;

  AuthorModel({this.success, this.message, this.data});

  AuthorModel.fromJson(Map<String, dynamic> json) {
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
  String? name;

  Result({this.id, this.name});

  Result.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}
