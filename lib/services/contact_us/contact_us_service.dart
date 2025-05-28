import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class ContactUsService {
  Future<dynamic> contactUs(token, name, email, subject, message) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.contactUsApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message
      });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> contactUsDetails(token) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.contactUsDetailsApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}
