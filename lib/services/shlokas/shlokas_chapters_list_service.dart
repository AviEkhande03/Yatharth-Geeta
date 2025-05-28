import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../const/constants/constants.dart';
import '../../../const/header/headers.dart';

class ShlokasChaptersListService {
  Future<dynamic> shlokasChaptersListApi({
    String? token,
    required String languageId,
  }) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.shlokasChaptersListApi);
      log(url.toString());

      log("Shlokas Chapters Language Id : $languageId");

      var response = await http.post(url, headers: headers, body: {
        "language_id": languageId.toString(),
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
