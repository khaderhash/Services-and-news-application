import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';

import '../../core/data/models/apis/activity_model.dart';
import 'activite.dart';

class ActivityController extends GetxController {
  final ApiService _apiService = ApiService();

  var selectedActivity = Rxn<ActivityModel>();
  var isDetailsLoading = false.obs;

  void fetchActivityDetailsAndNavigate(int activityId) async {
    try {
      isDetailsLoading.value = true;
      Get.to(() => ActivityDetailsScreen());

      final response = await _apiService.getActivityDetails(activityId);
      if (response.statusCode == 200) {
        selectedActivity.value = ActivityModel.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب تفاصيل النشاط');
      print(e);
      Get.back();
    } finally {
      isDetailsLoading.value = false;
    }
  }
}
