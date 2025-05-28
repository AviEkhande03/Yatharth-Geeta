import 'package:get/get.dart';

import '../../controllers/registration/registartion_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrationController());
  }
}
