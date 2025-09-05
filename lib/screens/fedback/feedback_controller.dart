import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';
import '../../core/data/models/apis/feedback_model.dart';

class FeedbackController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var existingFeedback = Rxn<FeedbackModel>();

  var rating = 0.0.obs;
  var isSatisfied = true.obs;
  var willUseAgain = true.obs;
  final notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkExistingFeedback();
  }

  Future<void> checkExistingFeedback() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getFeedback();
      existingFeedback.value = FeedbackModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        existingFeedback.value = null;
      } else {
        Get.snackbar('خطأ', 'فشل في جلب التقييم السابق');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void submitFeedback() async {
    if (rating.value == 0.0) {
      Get.snackbar('خطأ', 'الرجاء تحديد تقييم من 1 إلى 10');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _apiService.createFeedback(
        rating: rating.value.toInt(),
        isSatisfied: isSatisfied.value,
        willUseAgain: willUseAgain.value,
        notes: notesController.text,
      );

      Get.back();
      Get.snackbar('شكراً لك!', 'تم إرسال تقييمك بنجاح');
      checkExistingFeedback();
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل إرسال التقييم');
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
