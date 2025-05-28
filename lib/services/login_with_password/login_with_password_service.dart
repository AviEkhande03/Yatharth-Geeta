import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class LoginWithPasswordService{
  Future<dynamic> loginUserWithPassword(phoneNumber,password,fcmToken) async {
    try {
      var headers = await getHeaders("");
      print(headers);

      var url = Uri.parse(Constants.baseUrl + Constants.loginPasswordApi);
      print(url);
      var response = await http.post(
          url,
          headers: headers,
          body: {
            'phone': phoneNumber,
            'password': password,
            'fcm_token' : fcmToken
          });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}