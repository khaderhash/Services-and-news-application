import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';
import 'package:my_app11/screens/home_view/home.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  final key = GlobalKey<FormState>();
  final UsersController = TextEditingController();
  final passwordController = TextEditingController();

  var isLooading = false.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var loginFailed = false.obs;

  void login() async {
    if (key.currentState!.validate()) {
      isLooading.value = true;
      loginFailed.value = false;
      try {
        final response = await _apiService.login(
          email: UsersController.text,
          password: passwordController.text,
        );

        if (response.statusCode == 200) {
          final accessToken = response.data['access'];
          final refreshToken = response.data['refresh'];
          await _storage.write(key: 'accessToken', value: accessToken);
          await _storage.write(key: 'refreshToken', value: refreshToken);

          Get.offAll(() => HomeScreen());
        }
      } catch (e) {
        loginFailed.value = true;
        Get.snackbar(
          'خطأ في تسجيل الدخول',
          'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      } finally {
        isLooading.value = false;
      }
    }
  }
}
