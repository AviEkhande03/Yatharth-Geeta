import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class LoginWithOTPService {
  /*Future<dynamic> loginUser(phoneNumber, fcmToken) async {
    try {
      var headers = await getHeaders("");
      print(headers);

      var url = Uri.parse(Constants.baseUrl + Constants.login);
      print(url);
      var response = await http.post(url,
          headers: headers,
          body: {'phone': phoneNumber, 'fcm_token': fcmToken});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }*/
  Future<dynamic> socialLoginUser(email, isVerified, fcmToken, loginType, loginId, name) async {
    try {
      var headers = await getHeaders("");
      print(headers);
      //print("email social login:$email loginId: $loginId");
      print('email: $email, is_verified : $isVerified, fcm_token: $fcmToken, social_login_type:$loginType, social_login_id:$loginId, name:$name');
      var url = Uri.parse(Constants.baseUrl2 + Constants.socialLoginApi);
      print(url);
      var response = await http.post(
          url,
          headers: headers,
          body: {'email': email, 'is_verified' : isVerified, 'fcm_token': fcmToken, 'social_login_type':loginType, 'social_login_id':loginId, 'name':name}
      );
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}
