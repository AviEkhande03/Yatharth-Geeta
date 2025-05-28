import 'dart:developer';

import '../../../const/constants/constants.dart';
import '../../../const/header/headers.dart';
import 'package:http/http.dart' as http;

//This API adds the media(book, audio, video) to the liked list of the user, it takes two parameters primarily i.e. mediaType: 'book', likedMediaId: '1'
class UserMediaLikedCreateApi {
  Future<dynamic> userMediaLikedCreateApi(
      {String? token,
      required String mediaType,
      required String likedMediaId}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.userMediaLikedCreateApi);
      log(url.toString());

      log("User Media Liked Type : $mediaType");
      log("User Media Liked Id : $likedMediaId");
      var response = await http.post(url, headers: headers, body: {
        "wishlist_id": likedMediaId.toString(),
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
