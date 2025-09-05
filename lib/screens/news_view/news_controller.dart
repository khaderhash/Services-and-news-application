import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';

import '../../core/data/models/apis/news_model.dart';
import 'news.dart';

class NewsController extends GetxController {
  final ApiService _apiService = ApiService();

  var newsList = <NewsModel>[].obs;
  var selectedNews = Rxn<NewsModel>();

  var isListLoading = false.obs;
  var isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsList();
  }

  void fetchNewsList() async {
    try {
      isListLoading.value = true;
      final response = await _apiService.getNewsList();
      if (response.statusCode == 200) {
        var list = (response.data as List)
            .map((item) => NewsModel.fromJson(item))
            .toList();
        newsList.assignAll(list);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب الأخبار');
      print(e);
    } finally {
      isListLoading.value = false;
    }
  }

  void fetchNewsDetailsAndNavigate(int newsId) async {
    try {
      isDetailsLoading.value = true;
      Get.to(() => NewsDetailsScreen());

      final response = await _apiService.getNewsDetails(newsId);
      if (response.statusCode == 200) {
        selectedNews.value = NewsModel.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب تفاصيل الخبر');
      print(e);
      Get.back();
    } finally {
      isDetailsLoading.value = false;
    }
  }
}
