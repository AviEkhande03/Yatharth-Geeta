import 'dart:developer';

import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class EbookDetailsService {
  Future<dynamic> ebookDetailsApi({String? token, required int bookId}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url = Uri.parse(Constants.baseUrl + Constants.ebookDetails);
      log(url.toString());

      log("Book Details-Book id : $bookId");
      var response = await http.post(url, headers: headers, body: {
        "id": bookId.toString(),
      });
      log(response.body);
      return response;
    } catch (e) {
      log('=======This is exception=========');
      log(e.toString());
      return ' ';
    }
  }

  Future<dynamic> ebookHomeCollectionDetailsApi(
      {String? token, required String bookId, required String type}) async {
    try {
      var headers = await getHeaders(token);
      log(headers.toString());
      var url =
          Uri.parse(Constants.baseUrl2 + Constants.homeCollectionDetailsApi);
      log(url.toString());

      log("Book Details-Book id : $bookId");
      var response = await http.post(url, headers: headers, body: {
        "id": bookId.toString(),
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
}
