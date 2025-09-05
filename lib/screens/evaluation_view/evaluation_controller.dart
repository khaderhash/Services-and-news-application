import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EvaluationController extends GetxController {
  final selectedStars = 0.obs;
  final receivedService = RxnBool();
  final wantToUseAgain = RxnBool();
  final noteController = TextEditingController();

  void submitEvaluation() {
    print("نجوم: ${selectedStars.value}");
    print("الخدمة مرضية: ${receivedService.value}");
    print("الاستخدام لاحقاً: ${wantToUseAgain.value}");
    print("ملاحظات: ${noteController.text}");

    Get.snackbar(
      "نجاح",
      "تم إرسال التقييم ✅",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF4B2E83),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
