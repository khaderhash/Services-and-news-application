import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:my_app11/core/services/api_service.dart';
import 'package:my_app11/screens/login_view/login.dart';
import 'package:my_app11/screens/reset_pass_view/reset_pass.dart';

class OptCodeController extends GetxController {
  final ApiService _apiService = ApiService();
  final String email;
  final bool isRegistration;

  OptCodeController({required this.email, required this.isRegistration});

  final int fieldCount = 4;
  late List<TextEditingController> codeControllers;
  late List<FocusNode> focusNodes;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    codeControllers = List.generate(fieldCount, (_) => TextEditingController());
    focusNodes = List.generate(fieldCount, (_) => FocusNode());
  }

  void handleInput(String value, int index, BuildContext context) {
    if (value.isNotEmpty && index < fieldCount - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  String getOTP() {
    return codeControllers.map((controller) => controller.text).join();
  }

  void verifyOtp() async {
    final otp = getOTP();
    if (otp.length != 4) {
      Get.snackbar('خطأ', 'الرجاء إدخال الرمز المكون من 4 أرقام');
      return;
    }

    isLoading.value = true;

    try {
      Response response;
      if (isRegistration) {
        print('[OTP Verification] Email: $email, OTP: $otp');
        response = await _apiService.confirmRegisterOtp(email: email, otp: otp);
      } else {
        print('[OTP Verification] Email: $email, OTP: $otp');
        response = await _apiService.confirmForgotPasswordOtp(
          email: email,
          otp: otp,
        );
      }

      print('[Server Response] StatusCode: ${response.statusCode}');
      print('[Server Response] Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isRegistration) {
          await _apiService.confirmRegisterOtp(email: email, otp: otp);
          Get.snackbar(
            'نجاح',
            'تم تأكيد الحساب بنجاح. يمكنك الآن تسجيل الدخول.',
          );
          Get.offAll(() => const Login());
        } else {
          Get.snackbar('نجاح', 'تم التحقق من الرمز.');
          Get.off(() => ResetPass(email: email, otp: otp));
        }
      } else {
        Get.snackbar(
          'استجابة غير متوقعة',
          'استجاب السيرفر بكود: ${response.statusCode}',
        );
      }
    } catch (e) {
      String errorMessage = 'الرمز الذي أدخلته غير صحيح أو انتهت صلاحيته.';
      if (e is DioException) {
        if (e.response != null) {
          print('[Error StatusCode]: ${e.response?.statusCode}');
          print('[Error Data]: ${e.response?.data}');
          final responseData = e.response?.data;
          if (responseData is Map && responseData.containsKey('error')) {
            errorMessage = responseData['error'];
          } else if (responseData is Map) {
            errorMessage = responseData.toString();
          }
        } else {
          print(e.message);
          errorMessage = 'خطأ في الاتصال بالشبكة.';
        }
      } else {
        print(e.toString());
      }
      Get.snackbar('خطأ', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
