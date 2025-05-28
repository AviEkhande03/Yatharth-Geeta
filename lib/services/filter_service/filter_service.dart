import 'package:http/http.dart' as http;
import 'package:yatharthageeta/utils/utils.dart';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class FilterService {
  Future<dynamic> filterServiceApi() async {
    try {
      var token = await Utils.getToken();
      var headers = await getHeaders(token);
      print(headers);
      var url1 = Uri.parse(Constants.baseUrl2 + Constants.languageSort);
      var url2 = Uri.parse(Constants.baseUrl + Constants.authorSort);
      var url3 = Uri.parse(Constants.baseUrl2 + Constants.bookCategory);
      var url4 = Uri.parse(Constants.baseUrl2 + Constants.audioCategory);
      var url5 = Uri.parse(Constants.baseUrl2 + Constants.videoCategory);
      print(url1);
      print(url2);
      var response1 = await http.post(url1, headers: headers, body: {});
      var response2 = await http.post(url2, headers: headers, body: {});
      var response3 = await http.post(url3, headers: headers, body: {});
      var response4 =
          await http.post(url1, headers: headers, body: {"type": "Audio"});
      var response5 =
          await http.post(url1, headers: headers, body: {"type": "Video"});
      var response6 =
          await http.post(url1, headers: headers, body: {"type": "Book"});
      var response7 =
          await http.post(url1, headers: headers, body: {"type": "Shlok"});
      var response8 = await http.post(url4, headers: headers, body: {});
      var response9 = await http.post(url5, headers: headers, body: {});
      print(response7.body);
      print(response9.body);
      return [
        response1,
        response2,
        response3,
        response4,
        response5,
        response6,
        response7,
        response8,
        response9,
      ];
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}
