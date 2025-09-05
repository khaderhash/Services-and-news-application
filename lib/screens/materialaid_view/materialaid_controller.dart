import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/data/models/apis/material_aid_model.dart';
import '../../core/services/api_service.dart';

class MaterialAidController extends GetxController {
  final ApiService _apiService = ApiService();
  final deliveryDateController = TextEditingController();
  var isLoading = true.obs;
  var existingRequest = Rxn<MaterialAidModel>();

  final notesController = TextEditingController();

  var selectedAidType = Rxn<String>();
  final Map<String, String> aidTypes = {
    "غسالة": "washing_machine",
    "براد": "fridge",
    "فرن": "oven",
    "سخانة ليزرية": "laser heater",
    "بطارية": "battery",
    "خزان": "water_tank",
    "مدفئة": "heater",
    "سجادة": "carpet",
  };

  @override
  void onInit() {
    super.onInit();
    checkExistingRequest();
  }

  Future<void> checkExistingRequest() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getMaterialAid();
      existingRequest.value = MaterialAidModel.fromJson(response.data);
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
    if (selectedAidType.value == null) {
      Get.snackbar('خطأ', 'الرجاء اختيار نوع المساعدة');
      return;
    }
    final String aidTypeEnglish = aidTypes[selectedAidType.value]!;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _apiService.createMaterialAid(
        aidType: aidTypeEnglish,
        notes: notesController.text,
        deliveryDate: deliveryDateController.text,
      );
      Get.back();
      Get.snackbar('نجاح', 'تم إرسال طلبك بنجاح');
      checkExistingRequest();
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل إرسال الطلب');
    }
  }

  void deleteRequest() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _apiService.deleteMaterialAid();
      Get.back();
      Get.snackbar('نجاح', 'تم حذف طلبك بنجاح');
      checkExistingRequest();
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل حذف الطلب. قد لا يكون قيد المراجعة.');
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

  @override
  void onClose() {
    notesController.dispose();
    deliveryDateController.dispose();
    super.onClose();
  }
}
