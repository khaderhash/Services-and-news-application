import 'package:get/get.dart';
import '../login_view/login.dart';
import '../sign_up_view/sign_up.dart';

class LandingController extends GetxController {
  void goToLogin() {
    Get.off(() => Login());
  }

  void goToSignup() {
    Get.to(() => SignupPage());
  }
}
