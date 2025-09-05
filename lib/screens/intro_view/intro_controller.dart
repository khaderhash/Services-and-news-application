import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../landing_page_view/landing_page.dart';

class IntroController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      "image": "images/intro1.png",
      "text":
          "اهلا بك في تطبيق الجمعية السورية\n للتنمية الاجتماعية\nوالذي يقدم مساعدات طبية وعينية",
    },
    {
      "image": "images/intro2.png",
      "text": "كما يقدم أيضًا خدمة\n تمويل مشاريع صغيرة",
    },
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Get.to(() => LandingPage());
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
