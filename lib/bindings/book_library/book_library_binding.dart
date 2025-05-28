import 'package:get/get.dart';
import 'package:yatharthageeta/controllers/book_library/book_library_controller.dart';

class BookLibraryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookLibraryController());
  }
}
