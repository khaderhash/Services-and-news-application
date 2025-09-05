import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';

import '../../core/data/models/apis/activity_model.dart';
import '../../core/data/models/apis/news_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  var selectedIndex = 0.obs;
  var isLoading = true.obs;
  var newsList = <NewsModel>[].obs;
  var activitiesList = <ActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllHomePageData();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> refreshData() async {
    await fetchAllHomePageData(isRefresh: true);
  }

  Future<void> fetchAllHomePageData({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading.value = true;
    }

    try {
      await Future.wait([fetchNews(), fetchActivities()]);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل بيانات الصفحة الرئيسية');
    } finally {
      if (!isRefresh) {
        isLoading.value = false;
      }
    }
  }

  Future<void> fetchNews() async {
    try {
      final response = await _apiService.getNewsList();
      if (response.statusCode == 200) {
        var list = (response.data as List)
            .map((item) => NewsModel.fromJson(item))
            .toList();
        newsList.assignAll(list);
      }
    } catch (e) {
      print("Failed to fetch news");
    }
  }

  Future<void> fetchActivities() async {
    try {
      final response = await _apiService.getActivitiesList();
      if (response.statusCode == 200) {
        var list = (response.data as List)
            .map((item) => ActivityModel.fromJson(item))
            .toList();
        activitiesList.assignAll(list);
      }
    } catch (e) {
      print("Failed to fetch activities");
    }
  }
}
