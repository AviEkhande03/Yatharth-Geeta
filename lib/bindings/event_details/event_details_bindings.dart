import 'package:get/get.dart';
import '../../controllers/event_details/event_details_controller.dart';

class EventDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventDetailsController());
  }
}
