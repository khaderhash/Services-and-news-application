import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AgriculturalProjectController extends GetxController {
  var hasLandYes = false.obs;
  var hasLandNo = false.obs;
  var hasExperienceYes = false.obs;
  var hasExperienceNo = false.obs;
  var hasToolsYes = false.obs;
  var hasToolsNo = false.obs;
  final TextEditingController landSizeController = TextEditingController();
  final TextEditingController toolsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void toggleLandYes(bool? val) {
    hasLandYes.value = val ?? false;
    if (val == true) hasLandNo.value = false;
  }

  void toggleLandNo(bool? val) {
    hasLandNo.value = val ?? false;
    if (val == true) hasLandYes.value = false;
  }

  void toggleExperienceYes(bool? val) {
    hasExperienceYes.value = val ?? false;
    if (val == true) hasExperienceNo.value = false;
  }

  void toggleExperienceNo(bool? val) {
    hasExperienceNo.value = val ?? false;
    if (val == true) hasExperienceYes.value = false;
  }

  void toggleToolsYes(bool? val) {
    hasToolsYes.value = val ?? false;
    if (val == true) hasToolsNo.value = false;
  }

  void toggleToolsNo(bool? val) {
    hasToolsNo.value = val ?? false;
    if (val == true) hasToolsYes.value = false;
  }

  @override
  void onClose() {
    landSizeController.dispose();
    toolsController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
