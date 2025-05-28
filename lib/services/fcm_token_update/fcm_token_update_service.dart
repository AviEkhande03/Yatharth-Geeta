import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class FcmTokenUpdateService {
  Future<dynamic> fcmTokenUpdateApi(
      {String? token, required String fcmToken}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl + Constants.updateFcmTokenApi);
      log(url.toString());

      log("FCM Token in API call : $fcmToken");
      var response = await http.post(url, headers: headers, body: {
        "fcm_token": fcmToken.toString(),
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
