import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

//This service class is used for keeping the methods for different sub section of the home module such as: home collection, view all, details/mutiple collection data
//This method fetches the home collection data from home collection API, no id needs to be passed in this.
class HomeCollectionService {
  Future<dynamic> homeCollectionListingApi({
    String? token,
    pageNo,
    limit,
  }) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl + Constants.homeCollectionListApi);
      log(url.toString());
      var response = await http.post(url, headers: headers, body: {
        'page': pageNo,
        'paginate': limit,
      });
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception in HomeCollectionListApi=========');
      log(e.toString());
      return ' ';
    }
  }

//This method fetches the home collection view all listing, home collection id needs to be passed in this
  Future<dynamic> homeCollectionViewAllApi({
    String? token,
    required String collectionId,
    Map? body,
    pageNo,
    limit,
  }) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      body = body ?? {};
      body['id'] = collectionId.toString();
      if (pageNo != null && limit != null) {
        body['page'] = pageNo;
        body['paginate'] = limit;
      }
      log("body:${body.toString()}");
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionViewAllApi);
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

//This method fetches the home collection view all listing, id and type: multiple needs to be passed in this, this will provide the list of multiple collection
  Future<dynamic> homeCollectionListingMultipleApi({
    String? token,
    required String id,
    required String type,
    Map<String, String>? body,
    pageNo,
    limit,
  }) async {
    try {
      var headers = await getHeaders(token);
      body = body ?? {};
      log(type);
      body["id"] = id;
      body["type"] = type;

      if (pageNo != null && limit != null) {
        body['page'] = pageNo;
        body['paginate'] = limit;
      }

      log(headers.toString());
      log("body:${body.toString()}");
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      log(url.toString());
      var response = await http.post(url, headers: headers, body: body);
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception in homeCollectionListingMultipleApi=========');
      log(e.toString());
      return ' ';
    }
  }

  // Future<dynamic> homeCollectionDetailsApi({
  //   String? token,
  //   String? type,
  //   String? id,
  // }) async {
  //   try {
  //     var headers = await getHeaders(token);
  //     log(headers.toString());
  //     var url =
  //         Uri.parse(Constants.baseUrl + Constants.homeCollectionDetailsApi);
  //     log(url.toString());
  //     var response = await http.post(
  //       url,
  //       headers: headers,
  //     );
  //     log(response.body);
  //     return response;
  //   } catch (e) {
  //     log('=======This is exception in HomeCollectionDetailsApi=========');
  //     log(e.toString());
  //     return ' ';
  //   }
  // }
}
