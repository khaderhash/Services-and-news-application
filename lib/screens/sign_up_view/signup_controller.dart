import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';
import 'package:my_app11/screens/opt_code_view/opt_code.dart';

class SignupController extends GetxController {
  final ApiService _apiService = ApiService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  var isLoading = false.obs;

  void registerUser({required String gender}) async {
    List<String> nameParts = nameController.text.trim().split(' ');
    String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    String lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    isLoading.value = true;
    try {
      final response = await _apiService.register(
        firstName: firstName,
        lastName: lastName,
        email: emailController.text,
        phone: phoneController.text,
        password: passController.text,
        confirmPassword: confirmPassController.text,
        address: "homs",
        gender: gender.toLowerCase() == 'ذكر' ? 'male' : 'female',
        birthDate: birthController.text,
      );

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        Get.snackbar('نجاح', 'تم إرسال رمز التحقق إلى بريدك الإلكتروني');
        Get.to(
          () => OptCode(email: emailController.text, isRegistration: true),
        );
      }
    } catch (e) {
      String errorMessage = 'حدث خطأ ما. الرجاء المحاولة مرة أخرى.';
      if (e is DioException) {
        if (e.response != null) {
          print('Server Response Data: ${e.response?.data}');
          final responseData = e.response?.data;
          if (responseData is Map && responseData.containsKey('error')) {
            errorMessage = responseData['error'];
          } else if (responseData is Map) {
            errorMessage = responseData.entries.first.value.first.toString();
          } else {
            errorMessage = 'فشل التسجيل. تحقق من البيانات المدخلة.';
          }
        }
      }
      Get.snackbar('خطأ في التسجيل', errorMessage);
      print('Error during registration');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    birthController.dispose();
    phoneController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
