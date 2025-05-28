import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class VideoDetailsService {
  Future<dynamic> videoDetailsApi(
      {String? token, int? videoId, bool? isNext}) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.videoDetails);
      print(url);
      var body = {"id": videoId!.toString(), "is_next": isNext.toString()};
      log("body ${body.toString()}");
      log("Video Details-Video id : $videoId");
      var response = await http.post(url, headers: headers, body: body);
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> episodeDetailsApi(
      {String? token, int? videoId, bool? isNext}) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.videoEpisode);
      print(url);
      var body = {"id": videoId!.toString()};
      log("body ${body.toString()}");
      log("Video Details-Video id : $videoId");
      var response = await http.post(url, headers: headers, body: body);
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> videoHomeCollectionDetailsApi(
      {String? token, required String videoId, required String type}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      log(url.toString());

      log("Video Home Details-Video id : $videoId");
      var response = await http.post(url, headers: headers, body: {
        "id": videoId.toString(),
        "type": type.toString(),
      });
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return ' ';
    }
  }
}
