import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class NotificationStatusService {
  Future<dynamic> updateNotificationStatus(token, status) async {
    try {
      debugPrint("status in Service:$status");
      var headers = await getHeaders(token);
      print(headers);
      var url =
          Uri.parse(Constants.baseUrl + Constants.updateNotificationStatusApi);
      print(url);
      var response = await http.post(url,
          headers: headers,
          body: status == true ? {"status": status.toString()} : {});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}
