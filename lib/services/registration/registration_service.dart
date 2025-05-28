import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class RegistrationService {
  Future<dynamic> registerUser(phoneNumber, fcmToken) async {
    try {
      var headers = await getHeaders("");
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.register);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        'phone': phoneNumber,
        'fcm_token':fcmToken
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
