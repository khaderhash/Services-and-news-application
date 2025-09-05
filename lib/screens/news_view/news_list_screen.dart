import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'news_controller.dart';

class NewsListScreen extends StatelessWidget {
  NewsListScreen({Key? key}) : super(key: key);

  final NewsController controller = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأخبار والنشاطات'),
        backgroundColor: const Color(0xFF4B2E83),
      ),
      body: Obx(() {
        if (controller.isListLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4B2E83)),
          );
        }
        if (controller.newsList.isEmpty) {
          return const Center(child: Text('لا توجد أخبار حالياً'));
        }
        return ListView.builder(
          itemCount: controller.newsList.length,
          itemBuilder: (context, index) {
            final newsItem = controller.newsList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  newsItem.shortDescription,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF4B2E83),
                ),
                onTap: () {
                  controller.fetchNewsDetailsAndNavigate(newsItem.id);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
