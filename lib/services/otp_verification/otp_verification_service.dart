import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class OTPVerificationService {
  /*Future<dynamic> validateOTP(phoneNumber, otpCode, workFlow, fcmToken) async {
    try {
      var headers = await getHeaders("");
      print(headers);

      var url = Uri.parse(Constants.baseUrl + Constants.validateOTP);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        'mobile_number': phoneNumber,
        'otp_code': otpCode,
        'workflow': workFlow,
        'fcm_token': fcmToken
      });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }*/

  Future<dynamic> loginUser(phoneNumber, countryCode, isVerified, fcmToken) async {
    try {
      var headers = await getHeaders("");
      print(headers);

      var url = Uri.parse(Constants.baseUrl2 + Constants.login);
      print(url);
      print('phone: $phoneNumber, phone_code: $countryCode, is_verified:$isVerified, fcm_token: $fcmToken');
      var response = await http.post(url,
          headers: headers,
          body: {'phone': phoneNumber, 'phone_code': countryCode, 'is_verified':isVerified, 'fcm_token': fcmToken});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> resendOTP(phoneNumber, workFlow) async {
    try {
      var headers = await getHeaders("");
      print(headers);

      var url = Uri.parse(Constants.baseUrl + Constants.resendOtpApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        'phone': phoneNumber,
        'workflow': workFlow,
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
