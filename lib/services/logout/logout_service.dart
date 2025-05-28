import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class LogoutService {
  Future<dynamic> logoutUser(token) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.logOutApi);
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
