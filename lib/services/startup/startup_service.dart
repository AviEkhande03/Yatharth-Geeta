import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class StartupService {
  Future<dynamic> startupApi(token) async {
    try {
      var headers = await getHeaders(token, isAccessLanguageRequired: false);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.startupApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {});
      log(response.body);
      return response;
    } catch (e) {
      print('=======This is exception startup=========');
      print(e);
      return ' ';
    }
  }
}
