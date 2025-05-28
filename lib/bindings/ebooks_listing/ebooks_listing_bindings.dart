import 'package:get/get.dart';
import '../../controllers/ebooks_listing/ebooks_listing_controller.dart';

class EbooksListingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EbooksListingController());
  }
}
