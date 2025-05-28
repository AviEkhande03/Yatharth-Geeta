
import 'notification_item_model.dart';

class DayWiseNotificationModel {
  final String date;
  final List<NotificationItemModel> dayWiseNotificationList;

  DayWiseNotificationModel(
      {required this.date, required this.dayWiseNotificationList});
}
