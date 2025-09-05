import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MedicalFormController extends GetxController {
  var selectedImageName = RxnString();
  var selectedFileName = RxnString();
  var notesText = ''.obs;
  TextEditingController notesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImageName.value = image.name;
      }
    } catch (e) {
      print("خطأ عند اختيار الصورة ");
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty) {
        selectedFileName.value = result.files.first.name;
      }
    } catch (e) {
      print("خطأ عند اختيار الملف ");
    }
  }

  @override
  void onInit() {
    super.onInit();
    notesController.addListener(() {
      notesText.value = notesController.text;
    });
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
