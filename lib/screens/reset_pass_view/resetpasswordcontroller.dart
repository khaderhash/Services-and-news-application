import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../core/services/api_service.dart';
import '../login_view/login.dart';

class ResetPassController extends GetxController {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();
  final String email;
  final String otp;

  ResetPassController({required this.email, required this.otp});

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isLoading = false.obs;

  void resetPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('خطأ', 'كلمتا المرور غير متطابقتين');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (response.statusCode == 200) {
        await _storage.deleteAll();
        print("Tokens cleared after password reset.");

        Get.snackbar(
          'نجاح',
          'تم تغيير كلمة المرور بنجاح. الرجاء تسجيل الدخول مرة أخرى.',
        );
        Get.offAll(() => const Login());
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تغيير كلمة المرور. حاول مرة أخرى.');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
