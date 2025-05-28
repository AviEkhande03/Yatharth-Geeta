import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class EbooksListingService {
  Future<dynamic> ebooksListingApi(
      {String? token, String? pageNo, String? limit, Map? body}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      body = body ?? {};
      body['page'] = pageNo;
      body['paginate'] = limit;
      var url = Uri.parse(Constants.baseUrl2 + Constants.ebooksListing);
      log(url.toString());
      var response = await http.post(url, headers: headers, body: body);
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return ' ';
    }
  }

  Future<dynamic> bookFilterApi(
      token, body, String? pageNo, String? limit) async {
    try {
      var headers = await getHeaders(token);
      body = body ?? {};
      if (pageNo != null && limit != null) {
        body['page'] = pageNo;
        body['paginate'] = limit;
      }
      var url = Uri.parse(Constants.baseUrl2 + Constants.ebooksListing);
      var response = await http.post(url, headers: headers, body: body ?? {});
      print(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }

  Future<dynamic> bookViewAllFilterApi(token, Map<String, String> body) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.exploreCollectionViewAllApi);
      var response = await http.post(url, headers: headers, body: body);
      print(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }

  Future<dynamic> bookViewAllHomeFilterApi(
      token, Map<String, String> body) async {
    try {
      var headers = await getHeaders(token);
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionViewAllApi);
      var response = await http.post(url, headers: headers, body: body);
      print(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }

  // Future<dynamic> bookViewAllHomeFilterApi(token, body) async {
  //   try {
  //     log(body);
  //     log(Constants.baseUrl + Constants.homeCollectionViewAllApi);
  //     var headers = await getHeaders(token);
  //     var url =
  //         Uri.parse(Constants.baseUrl + Constants.homeCollectionViewAllApi);
  //     var response = await http.post(url, headers: headers, body: body ?? {});
  //     print(response.body);
  //     return response;
  //   } catch (e) {
  //     return ' ';
  //   }
  // }

  Future<dynamic> homeCollectionListingMultipleFilterApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      log(url.toString());
      var response = await http.post(url, headers: headers, body: body ?? {});
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception in homeCollectionListingMultipleApi=========');
      log(e.toString());
      return ' ';
    }
  }

  //  "id": id.toString(),
  //       "type": type.toString(),
}
