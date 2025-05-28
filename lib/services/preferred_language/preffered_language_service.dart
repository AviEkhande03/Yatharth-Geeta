import 'package:http/http.dart' as http;

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';

class PrefferedLanguageService {
  Future<dynamic> getPreferredLanguage() async {
    try {
      var headers = await getHeaders('', isAccessLanguageRequired: false);
      print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.preferredLanguageApi);
      print(url);
      var response = await http.post(url, headers: headers, body: {});
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception in PrefferedLanguageService=========');
      print(e);
      return ' ';
    }
  }
}
