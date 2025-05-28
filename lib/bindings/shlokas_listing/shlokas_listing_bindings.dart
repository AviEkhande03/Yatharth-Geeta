import 'package:get/get.dart';
import '../../controllers/shlokas_listing/shlokas_listing_controller.dart';

class ShlokasListingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShlokasListingController());
  }
}
