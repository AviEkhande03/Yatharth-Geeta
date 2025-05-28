import 'package:get/get.dart';
import '../../controllers/gallery/gallery_controller.dart';

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GalleryController());
  }
}
