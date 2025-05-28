import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../const/constants/constants.dart';
import '../../../const/header/headers.dart';

class ShlokasListingService {
  Future<dynamic> shlokasListingApi(
      {String? token,
      required String languageId,
      required String chapterNumber,
      String? pageNo,
      String? limit,
      Map<String, String>? body}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl2 + Constants.shlokasListingApi);
      log(url.toString());
      log("Shlokas List Language Id : $languageId");
      log("Shlokas List Chapter No. : $chapterNumber");
      Map<String, String> callBody = {};
      if (body != null) {
        callBody = body;
      } else {
        callBody['chapter_id'] = chapterNumber.toString();
        callBody['language_id'] = languageId.toString();
      }
      if (pageNo != null && limit != null) {
        callBody['page'] = pageNo;
        callBody['paginate'] = limit;
      }

      log("callBody:$callBody");

      var response = await http.post(url,
          headers: headers,
          /*body: body ??
              {
                "chapter_number": chapterNumber.toString(),
                "language_id": languageId.toString(),
              }*/
          body: callBody);

      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception in ShlokasListing=========');
      log(e.toString());
      return ' ';
    }
  }

  Future<dynamic> shlokaFilterApi(token, body) async {
    try {
      var headers = await getHeaders(token);
      var url = Uri.parse(Constants.baseUrl2 + Constants.shlokasListingApi);
      var response = await http.post(url, headers: headers, body: body ?? {});
      return response;
    } catch (e) {
      return ' ';
    }
  }
}
