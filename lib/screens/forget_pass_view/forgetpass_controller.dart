import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';
import 'package:my_app11/screens/opt_code_view/opt_code.dart';

class ForgetPassController extends GetxController {
  final ApiService _apiService = ApiService();
  final emailController = TextEditingController();
  var isLooading = false.obs;

  void sendResetCode() async {
    isLooading.value = true;
    try {
      final response = await _apiService.forgotPassword(
        email: emailController.text,
      );
      if (response.statusCode == 200) {
        Get.snackbar('نجاح', 'تم إرسال رمز التحقق إلى بريدك الإلكتروني');
        Get.to(
          () => OptCode(email: emailController.text, isRegistration: false),
        );
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إرسال الرمز. تأكد من البريد الإلكتروني.');
    } finally {
      isLooading.value = false;
    }
  }
}
