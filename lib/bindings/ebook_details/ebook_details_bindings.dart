import 'package:get/get.dart';

import '../../controllers/ebook_details/ebook_details_controller.dart';

class EbookDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EbookDetailsController());
  }
}
