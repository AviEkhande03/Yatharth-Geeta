import 'package:flutter/material.dart';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class GurujiDetailsService {
  Future<dynamic> fetchGurujiDetails(token, id) async {
    debugPrint("Inside fetchGurujiDetailsSrvic");
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.gurujiDetailsApi);
      print(url);
      var response =
          await http.post(url, headers: headers, body: {"id": id.toString()});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception GurujiDetailsService=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> fetchGurujiHomeDetails(
      {String? token, required String artistId, required String type}) async {
    debugPrint("Inside fetchGurujiHomeDetailsSrvic");
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        "id": artistId.toString(),
        "type": type.toString(),
      });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception GurujiDetailsService=========');
      print(e);
      return ' ';
    }
  }
}
