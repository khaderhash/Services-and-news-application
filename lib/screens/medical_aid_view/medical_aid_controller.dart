import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app11/core/services/api_service.dart';

import '../../core/data/models/apis/medical_aid_model.dart';

class MedicalAidController extends GetxController {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  var isLoading = true.obs;
  var existingRequest = Rxn<MedicalAidModel>();
  final notesController = TextEditingController();
  final deliveryDateController = TextEditingController();

  var selectedAidType = Rxn<String>();
  var selectedReportFile = Rxn<File>();

  final Map<String, String> aidTypes = {
    'جهاز رذاذ': 'nebulizer',
    'جهاز سكري': 'diabetes_device',
    'جهاز ضغط': 'pressure_device',
    'جهاز مشي': 'walker',
    'كرسي متحرك': 'wheelchair',
    'إسفنجة طبية': 'medical_mattress',
  };

  @override
  void onInit() {
    super.onInit();
    checkExistingRequest();
  }

  Future<void> checkExistingRequest() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getMedicalAid();
      existingRequest.value = MedicalAidModel.fromJson(response.data);
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

  void pickMedicalReport() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedReportFile.value = File(image.path);
    }
  }

  void pickDeliveryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      deliveryDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  void createRequest() async {
    if (selectedAidType.value == null) {
      Get.snackbar('خطأ', 'الرجاء اختيار نوع المساعدة');
      return;
    }
    if (selectedReportFile.value == null) {
      Get.snackbar('خطأ', 'الرجاء إرفاق صورة التقرير الطبي');
      return;
    }
    if (deliveryDateController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء تحديد تاريخ التسليم المتوقع');
      return;
    }

    final String aidTypeEnglish = aidTypes[selectedAidType.value]!;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _apiService.createMedicalAid(
        aidType: aidTypeEnglish,
        notes: notesController.text,
        medicalReportPath: selectedReportFile.value!.path,
        deliveryDate: deliveryDateController.text,
      );
      Get.back();
      Get.snackbar('نجاح', 'تم إرسال طلبك بنجاح');
      checkExistingRequest();
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل إرسال الطلب: ');
    }
  }

  void deleteRequest() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _apiService.deleteMedicalAid();
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
    notesController.dispose();
    deliveryDateController.dispose();
    super.onClose();
  }
}
