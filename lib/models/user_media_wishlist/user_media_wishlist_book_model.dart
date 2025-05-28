// To parse this JSON data, do
//
//     final userMediaWishlistBookModel = userMediaWishlistBookModelFromJson(jsonString);

import 'dart:convert';

UserMediaWishlistBookModel userMediaWishlistBookModelFromJson(String str) =>
    UserMediaWishlistBookModel.fromJson(json.decode(str));

String userMediaWishlistBookModelToJson(UserMediaWishlistBookModel data) =>
    json.encode(data.toJson());

class UserMediaWishlistBookModel {
  int? success;
  String? message;
  Data? data;

  UserMediaWishlistBookModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserMediaWishlistBookModel.fromJson(Map<String, dynamic> json) =>
      UserMediaWishlistBookModel(
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
  String? type;
  List<WishlistDatum>? wishlistData;

  Result({
    this.id,
    this.type,
    this.wishlistData,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        type: json["type"],
        wishlistData: json["wishlist_data"] == null
            ? []
            : List<WishlistDatum>.from(
                json["wishlist_data"]!.map((x) => WishlistDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "wishlist_data": wishlistData == null
            ? []
            : List<dynamic>.from(wishlistData!.map((x) => x.toJson())),
      };
}

class WishlistDatum {
  int? id;
  int? pages;
  bool? downloadAllowed;
  String? viewCount;
  String? selectedType;
  String? coverImageUrl;
  String? pdfFileUrl;
  String? epubFileUrl;
  String? artistName;
  String? mediaLanguage;
  String? name;
  String? shortDescription;
  String? description;

  WishlistDatum({
    this.id,
    this.pages,
    this.downloadAllowed,
    this.viewCount,
    this.selectedType,
    this.coverImageUrl,
    this.pdfFileUrl,
    this.epubFileUrl,
    this.artistName,
    this.mediaLanguage,
    this.name,
    this.shortDescription,
    this.description,
  });

  factory WishlistDatum.fromJson(Map<String, dynamic> json) => WishlistDatum(
        id: json["id"],
        pages: json["pages"],
        downloadAllowed: json["download_allowed"],
        viewCount: json["view_count"],
        selectedType: json["selected_type"],
        coverImageUrl: json["cover_image_url"],
        pdfFileUrl: json["pdf_file_url"],
        epubFileUrl: json["epub_file_url"],
        artistName: json["artist_name"],
        mediaLanguage: json["media_language"],
        name: json["name"],
        shortDescription: json["short_description"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pages": pages,
        "download_allowed": downloadAllowed,
        "view_count": viewCount,
        "selected_type": selectedType,
        "cover_image_url": coverImageUrl,
        "pdf_file_url": pdfFileUrl,
        "epub_file_url": epubFileUrl,
        "artist_name": artistName,
        "media_language": mediaLanguage,
        "name": name,
        "short_description": shortDescription,
        "description": description,
      };
}
