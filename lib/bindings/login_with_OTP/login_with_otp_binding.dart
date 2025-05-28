import 'package:get/get.dart';

import '../../controllers/login_with_OTP/login_with_otp_controller.dart';

class LoginWithOTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginWithOTPController());
  }
}
