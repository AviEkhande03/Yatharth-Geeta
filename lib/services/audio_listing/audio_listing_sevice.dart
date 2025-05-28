import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class AudioListingService {
  Future<dynamic> audioListingApi(
      {String? token,
      String? pageNo,
      String? limit,
      Map? body,
      http.Client? client}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      body = body ?? {};
      body['page'] = pageNo;
      body['paginate'] = limit;
      var url = Uri.parse(Constants.baseUrl2 + Constants.audioListing);
      var response = await client!.post(url, headers: headers, body: body);
      log(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }

  Future<dynamic> audioFilterApi(
      token, body, String? pageNo, String? limit) async {
    try {
      body = body ?? {};
      if (pageNo != null && limit != null) {
        body['page'] = pageNo;
        body['paginate'] = limit;
      }
      var headers = await getHeaders(token);
      var url = Uri.parse(Constants.baseUrl2 + Constants.audioListing);
      var response = await http.post(url, headers: headers, body: body ?? {});
      log(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }

  Future<dynamic> audioViewAllFilterApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      var url =
          Uri.parse(Constants.baseUrl + Constants.exploreCollectionViewAllApi);
      var response = await http.post(url, headers: headers, body: body ?? {});
      log(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }

  Future<dynamic> audioHomeViewAllFilterApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionViewAllApi);
      var response = await http.post(url, headers: headers, body: body ?? {});
      log(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }

  Future<dynamic> audioHomeMultipleTypeFilterApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      var response = await http.post(url, headers: headers, body: body ?? {});
      log(response.body);
      return response;
    } catch (e) {
      return ' ';
    }
  }
}
