import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../const/header/headers.dart';
import '../../models/response/response_data.dart';

class Services {
  static Future<ResponseData> postReq(String? token, Uri url, Map body) async {
    try {
      var header = await getHeaders(token);
      var response = await http.post(url, headers: header, body: body);
      var resBody = json.decode(response.body.toString());
      // print(response);
      return ResponseData(
          statusCode: response.statusCode,
          message: resBody['message'],
          data: resBody['data']);
    } catch (e) {
      return ResponseData(statusCode: 1000, message: "Runtime Error", data: {});
    }
  }

  static Future<ResponseData> getReq(String? token, Uri url) async {
    try {
      var header = await getHeaders(token);
      var response = await http.get(url, headers: header);
      var resBody = json.decode(response.body.toString());
      // print(response);
      return ResponseData(
          statusCode: response.statusCode,
          message: resBody['message'],
          data: resBody['data']);
    } catch (e) {
      return ResponseData(statusCode: 1000, message: "Runtime Error", data: {});
    }
  }
}
