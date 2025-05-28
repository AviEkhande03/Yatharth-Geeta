import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class ChangePasswordService {
  Future<dynamic> changePassword(token, newPswd, confirmPswd) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.changePasswordApi);
      print(url);
      var response = await http.post(url,
          headers: headers,
          body: {"password": newPswd, "password_confirmation": confirmPswd});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}
