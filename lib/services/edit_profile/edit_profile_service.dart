import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;


class EditProfileService{
  Future<dynamic> editUserProfile(token,name,phoneCode,phoneNumber,email,pinCode,state) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.profileUpdateApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {
        "name":name,
        "phone_code":phoneCode,
        "phone": phoneNumber,
        "email": email,
        "state": state,
        "pin_code":pinCode
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