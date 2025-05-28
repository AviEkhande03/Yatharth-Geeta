import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class ProfileService {
  Future<dynamic> getProfileData(token) async {
    try {
      debugPrint("token:$token");
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.profileDataApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception ProfileService=========');
      print(e);
      return ' ';
    }
  }
}
