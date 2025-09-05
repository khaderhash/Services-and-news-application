import 'package:get/get.dart';

class MedicalAidController extends GetxController {
  final List<String> items = [
    "جهاز ضغط",
    "جهاز سكر",
    "جهاز رذاذ",
    "كرسي متحرك",
    "نظارة طبية",
  ];

  final RxSet<String> selectedItems = <String>{}.obs;

  void toggleItem(String label) {
    if (selectedItems.contains(label)) {
      selectedItems.remove(label);
    } else {
      selectedItems.add(label);
    }
  }
}
