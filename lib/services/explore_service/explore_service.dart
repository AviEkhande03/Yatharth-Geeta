import 'dart:developer';

import 'package:http/http.dart' as http;
import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class ExploreService {
  Future<dynamic> quotesApi({
    String? token,
    pageNo,
    limit,
  }) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.quoteApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        'page': pageNo,
        'paginate': limit,
      });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> mantrasApi({
    String? token,
    pageNo,
    limit,
  }) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.mantraApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        'page': pageNo,
        'paginate': limit,
      });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> exploreApi({
    String? token,
    pageNo,
    limit,
  }) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.exploreApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        'page': pageNo,
        'paginate': limit,
      });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> satsangApi(
      {String? token, pageNo, limit, Map<String, String>? body}) async {
    try {
      var headers = await getHeaders(token);
      body = body ?? {};
      if (pageNo != null && limit != null) {
        body['paginate'] = limit;
        body['page'] = pageNo;
      }
      print(body);
      var url = Uri.parse(Constants.baseUrl + Constants.satsangApi);
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

  Future<dynamic> exploreCollectionViewAllApi({
    String? token,
    required String collectionId,
    Map? body,
    pageNo,
    limit,
  }) async {
    try {
      body = body ?? {};
      body['id'] = collectionId.toString();
      if (pageNo != null && limit != null) {
        body['page'] = pageNo;
        body['paginate'] = limit;
      }
      log(body.toString());
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl + Constants.exploreCollectionViewAllApi);
      log(url.toString());
      var response = await http.post(url, headers: headers, body: body);
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception in HomeCollectionViewAllApi=========');
      log(e.toString());
      return ' ';
    }
  }
}
