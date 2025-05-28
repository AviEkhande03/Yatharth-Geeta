import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class EventDetailsService {
  Future<dynamic> eventDetailsApi(
      {String? token, required String eventId}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl + Constants.eventDetails);
      log(url.toString());

      log("Event Details id : $eventId");
      var response = await http.post(url, headers: headers, body: {
        "id": eventId.toString(),
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
