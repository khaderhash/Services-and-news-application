import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';

import '../../core/data/models/apis/project_request_model.dart';

class ProjectRequestController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var existingRequest = Rxn<ProjectRequestModel>();

  final ownershipController = TextEditingController();
  final areaController = TextEditingController();
  final experienceController = TextEditingController();
  final toolsController = TextEditingController();
  final notesController = TextEditingController();
  var selectedProjectType = Rxn<String>();
  final Map<String, String> projectTypes = {
    'مشروع تجاري': 'commercial',
    'مشروع زراعي': 'agricultural',
  };
  @override
  void onInit() {
    super.onInit();
    checkExistingRequest();
  }

  Future<void> checkExistingRequest() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getProjectRequest();
      existingRequest.value = ProjectRequestModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        existingRequest.value = null;
      } else {
        Get.snackbar('خطأ', 'فشل في التحقق من حالة الطلب');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void createRequest() async {
    if (selectedProjectType.value == null) {
      Get.snackbar('خطأ', 'الرجاء اختيار نوع المشروع');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _apiService.createProjectRequest(
        projectType: selectedProjectType.value!,
        ownership: ownershipController.text,
        area: areaController.text,
        experience: experienceController.text,
        tools: toolsController.text,
        notes: notesController.text,
      );
      Get.back();
      Get.snackbar('نجاح', 'تم إرسال طلبك بنجاح');
      checkExistingRequest();
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل إرسال الطلب: ');
      print(e);
    }
  }

  void deleteRequest() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _apiService.deleteProjectRequest();
      Get.back();
      Get.snackbar('نجاح', 'تم حذف طلبك بنجاح');
      checkExistingRequest();
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل حذف الطلب. قد لا يكون قيد المراجعة.');
    }
  }

  @override
  void onClose() {
    ownershipController.dispose();
    areaController.dispose();
    experienceController.dispose();
    toolsController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
