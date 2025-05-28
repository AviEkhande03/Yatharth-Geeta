import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class AdminPoliciesService {
  Future<dynamic> adminInfoApi({String? token, required String type}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl + Constants.adminPolicies);
      log(url.toString());

      log("Admin Info Type : $type");
      var response = await http.post(url, headers: headers, body: {
        "type": type,
      });
      log("this is the policy response = ${response.body}");
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return ' ';
    }
  }
}
