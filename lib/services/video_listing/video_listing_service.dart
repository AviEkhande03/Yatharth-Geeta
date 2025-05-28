import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class VideoListingService {
  Future<dynamic> videoListingApi(
      {String? token, String? pageNo, String? limit, Map? body}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      body = body ?? {};
      body['page'] = pageNo;
      body['paginate'] = limit;
      var url = Uri.parse(Constants.baseUrl2 + Constants.videoListing);
      print(url);
      var response = await http.post(url, headers: headers, body: body);
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> videoFilterApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.videoListing);
      print(url);
      var response = await http.post(url, headers: headers, body: body ?? {});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  // Future<dynamic> videoFilterViewAllApi(token, body) async {
  //   try {
  //     var headers = await getHeaders(token);
  //     print(headers);
  //     var url =
  //         Uri.parse(Constants.baseUrl + Constants.exploreCollectionViewAllApi);
  //     print(url);
  //     var response = await http.post(url, headers: headers, body: body ?? {});
  //     print(response.body);
  //     return response;
  //   } catch (e) {
  //     print('=======This is exception=========');
  //     print(e);
  //     return ' ';
  //   }
  // }

  Future<dynamic> videoHomeFilterViewAllApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionViewAllApi);
      print(url);
      var response = await http.post(url, headers: headers, body: body ?? {});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> videoHomeFilterMultipleTypeApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      print(url);
      var response = await http.post(url, headers: headers, body: body ?? {});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}
