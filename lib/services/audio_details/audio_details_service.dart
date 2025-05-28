import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class AudioDetailsService {
  Future<dynamic> audioDetailsApi({String? token, int? audioId}) async {
    try {
      var headers = await getHeaders(token);
      print(headers);
      var url = Uri.parse(Constants.baseUrl2 + Constants.audioDetails);
      print(url);

      log("Audio Details-Book id : $audioId");
      var response = await http.post(url, headers: headers, body: {
        "id": audioId!.toString(),
      });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception=========');
      print(e);
      return ' ';
    }
  }

  Future<dynamic> audioHomeCollectionDetailsApi(
      {String? token, required String audioId, required String type}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      log(url.toString());

      log("Audio Home Details-Audio id : $audioId");
      var response = await http.post(url, headers: headers, body: {
        "id": audioId.toString(),
        "type": type.toString(),
      });
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return ' ';
    }
  }

  /*
  * Phase 2 api calls here
  * --------------------------------
  */

  static Future<dynamic> increaseCountApi(
      {required String token,
      required String id,
      required String master}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl2 + Constants.count);
      log(url.toString());
      var response = await http.post(url, headers: headers, body: {
        "master_id": id.toString(),
        "master": master.toString(),
      });
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return '';
    }
  }

  /*
   * ----------------------------------------------------------------
   * Phase 2 API calls End Here 
   */
}
