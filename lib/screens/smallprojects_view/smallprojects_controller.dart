import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../agriculture_project_view/agriculture_project.dart';
import '../business_project_view/business_project.dart';

class SmallProjectsController extends GetxController {
  final Color violetColor = const Color(0xFF4B2E83);

  late List<Map<String, dynamic>> buttons;

  @override
  void onInit() {
    super.onInit();
    buttons = [
      {"title": "مشروع زراعي", "page": () => AgriculturalProject()},
      {"title": "مشروع تجاري", "page": () => BusinessProject()},
    ];
  }
}
