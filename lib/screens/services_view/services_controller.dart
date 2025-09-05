import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../materialaid_view/materialaid.dart';
import '../medical_aid_view/mediical_aid.dart';
import '../project_request_view/project_request_view.dart';

class ServicesController extends GetxController {
  final List<Map<String, dynamic>> servicesList = [
    {
      "title": "طلب مشروع صغير",
      "image": "images/icons_services1.png",
      "onTap": () => Get.to(() => ProjectRequestScreen()),
    },
    {
      "title": "طلب مساعدة طبية",
      "image": "images/icons_services2.png",
      "onTap": () => Get.to(() => MedicalAidScreen()),
    },
    {
      "title": "طلب مساعدة عينية",
      "image": "images/icons_services3.png",
      "onTap": () => Get.to(() => MaterialAidScreen()),
    },
  ];
}
