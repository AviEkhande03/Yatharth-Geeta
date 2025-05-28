import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class PlayerService {
  Future<dynamic> playerChapterApi(
      {String? token, int? audioId, dynamic chapterNo}) async {
    try {
      var headers = await getHeaders(token);
      // print(headers);
      var url = Uri.parse(Constants.baseUrl + Constants.playerChapterApi);
      // print(url);

      log("Audio id : $audioId");
      log("Chapter id : $chapterNo");
      var response = await http.post(url, headers: headers, body: {
        "audio_id": audioId!.toString(),
        "chapter_number": chapterNo.toString()
      });
      // print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }
}
