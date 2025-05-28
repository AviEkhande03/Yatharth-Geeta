import 'dart:convert';

ContactUsDetailsModel ContactUsDetailsModelFromJson(String str) =>
    ContactUsDetailsModel.fromJson(json.decode(str));

String AudioListingModelToJson(ContactUsDetailsModel data) =>
    json.encode(data.toJson());

class ContactUsDetailsModel {
  int? success;
  String? message;
  Data? data;

  ContactUsDetailsModel({this.success, this.message, this.data});

  ContactUsDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? systemEmail;
  String? systemContactNo;
  String? address;
  String? latitude;
  String? longitude;

  Result(
      {this.systemEmail,
      this.systemContactNo,
      this.address,
      this.latitude,
      this.longitude});

  Result.fromJson(Map<String, dynamic> json) {
    systemEmail = json['system_email'];
    systemContactNo = json['system_contact_no'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['system_email'] = systemEmail;
    data['system_contact_no'] = systemContactNo;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
