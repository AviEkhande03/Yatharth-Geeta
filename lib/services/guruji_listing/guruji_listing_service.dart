import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class GurujiListingService {
  Future<dynamic> gurujiListingApi({String? token}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl2 + Constants.gurujiListingApi);
      log(url.toString());
      var response = await http.post(url, headers: headers, body: {});
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return ' ';
    }
  }
}
