import '../../const/constants/constants.dart';
import '../../const/header/headers.dart';
import 'package:http/http.dart' as http;

class NotificationListingService{
  Future<dynamic> fetchNotificationListing(token,String? pageNo, String? limit) async {
    try {
      var headers = await getHeaders(token);
      // print("pageNo:$pageNo");
      // print("limit:$limit");
      print(headers);

      var url = Uri.parse(Constants.baseUrl + Constants.notificationListingApi);
      print(url);
      var response = await http.post(
          url,
          headers: headers,
          body: {
            "page":pageNo,
            "paginate":limit
          });
      print(response.body);
      return response;
    } catch (e) {
      print('=======This is exception in NotificationListing=========');
      print(e);
      return ' ';
    }
  }
}