import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../const/constants/constants.dart';
import '../../../const/header/headers.dart';

class UserLikedListService {
  Future<dynamic> userLikedListApi(
      {String? token,
      required String mediaType,
      Map<String, String>? body}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl2 + Constants.userLikedListApi);
      log(url.toString());

      log("User Liked List Type : $mediaType");
      var response = await http.post(url,
          headers: headers,
          body: body ??
              {
                "type": mediaType.toString(),
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
