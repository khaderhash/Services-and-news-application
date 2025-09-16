import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../home_view/home.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  final key = GlobalKey<FormState>();

  final UsersController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  var isLooading = false.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var loginFailed = false.obs;

  Future<void> login() async {
    if (!key.currentState!.validate()) return;
    isLooading.value = true;
    loginFailed.value = false;
    try {
      final String? otp = await _apiService.storage.read(
        key: 'verified_otp_for_${UsersController.text.trim()}',
      );

      // if (otp == null || otp.isEmpty) {
      //   Get.snackbar(
      //     'خطأ',
      //     'الرجاء تأكيد حسابك أولاً عبر رمز OTP.',
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      //   isLooading.value = false;
      //   return;
      // }

      final response = await _apiService.login(
        email: UsersController.text.trim(),
        password: passwordController.text.trim(),
        // otp: otp,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAll(() => HomeScreen());
      } else {
        loginFailed.value = true;
        Get.snackbar(
          'خطأ في تسجيل الدخول',
          response.data.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      loginFailed.value = true;
      String message = 'حدث خطأ غير متوقع';
      if (e is DioException) {
        message =
            e.response?.data['detail'] ??
            'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      }
      Get.snackbar(
        'خطأ في تسجيل الدخول',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLooading.value = false;
    }
  }
}
