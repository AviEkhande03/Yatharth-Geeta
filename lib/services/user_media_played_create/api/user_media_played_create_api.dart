import 'dart:developer';

import '../../../const/constants/constants.dart';
import '../../../const/header/headers.dart';
import 'package:http/http.dart' as http;

//This API adds the media(book, audio, video) to the played list of the user, it takes two parameters primarily i.e. mediaType: 'book', playedId: '1'
class UserMediaPlayedCreateApi {
  Future<dynamic> userMediaPlayedCreateApi(
      {String? token,
      required String mediaType,
      required String playedId}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.userMediaPlayedCreateApi);
      log(url.toString());

      log("User Media Played Type : $mediaType");
      var response = await http.post(url, headers: headers, body: {
        "played_id": playedId.toString(),
        "type": mediaType.toString(),
      });
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return ' ';
    }
  }
}
