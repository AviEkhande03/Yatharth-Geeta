import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

//This API service fetches the event liting data
class EventsListingService {
  Future<dynamic> eventsListingApi(
      {String? token, String? pageNo, String? limit, body}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl + Constants.eventsListing);
      log(url.toString());
      body['page'] = pageNo;
      body['paginate'] = limit;
      var response = await http.post(url, headers: headers, body: body);
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception in EventListing=========');
      log(e.toString());
      return ' ';
    }
  }
}
