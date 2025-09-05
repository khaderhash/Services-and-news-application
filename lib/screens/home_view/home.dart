import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:my_app11/screens/news_view/news_controller.dart';
import 'package:my_app11/screens/news_view/news_list_screen.dart';
import 'package:my_app11/screens/services_view/services.dart';
import '../../core/data/models/apis/activity_model.dart';
import '../../core/data/models/apis/news_model.dart';
import '../activite_view/activite_controller.dart';
import '../benfeshary/view/benefeshary.dart';
import '../fedback/feedback_view.dart';
import '../profile_view/profile.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());
  final NewsController newsController = Get.put(NewsController());
  final ActivityController activityController = Get.put(ActivityController());

  final Color primaryColor = const Color(0xFF4B2E83);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(context),
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              _buildMainContent(context),
              ServicesScreen(),
              BeneficiaryScreen(),
              FeedbackScreen(),
              Profile(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  AppBar? _buildAppBar(BuildContext context) {
    if (controller.selectedIndex.value != 0) return null;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        "الجمعية السورية للتنمية الإجتماعية",
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: Get.width * 0.05,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: primaryColor));
      }
      return RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        color: primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("أحدث النشاطات", () {
                  Get.snackbar("قيد الإنشاء", "سيتم عرض كل الأنشطة هنا");
                }),
                _buildActivitiesList(),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  "آخر الأخبار",
                  () => Get.to(() => NewsListScreen()),
                ),
                _buildNewsList(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildActivitiesList() {
    return SizedBox(
      height: Get.height * 0.25,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.activitiesList.length,
          itemBuilder: (context, index) {
            final activity = controller.activitiesList[index];
            return _buildActivityCard(activity);
          },
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return Obx(
      () => controller.newsList.isEmpty
          ? const Center(child: Text("لا توجد أخبار حالياً"))
          : Column(
              children: controller.newsList.take(3).map((newsItem) {
                return _buildNewsCard(newsItem);
              }).toList(),
            ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(ActivityModel activity) {
    return GestureDetector(
      onTap: () {
        activityController.fetchActivityDetailsAndNavigate(activity.id);
      },
      child: Container(
        width: Get.width * 0.45,
        margin: const EdgeInsets.only(left: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child:
                    (activity.photoUrl != null && activity.photoUrl!.isNotEmpty)
                    ? Image.network(
                        activity.photoUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: primaryColor.withOpacity(0.1),
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: primaryColor.withOpacity(0.08),
                        child: Center(
                          child: Icon(
                            Icons.local_activity,
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  activity.shortDescription,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(NewsModel newsItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          newsController.fetchNewsDetailsAndNavigate(newsItem.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.article_outlined,
                color: primaryColor.withOpacity(0.8),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  newsItem.shortDescription,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryColor.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Obx(
      () => BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[600],
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services_outlined),
            activeIcon: Icon(Icons.miscellaneous_services),
            label: 'الخدمات',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications_outlined),
          //   activeIcon: Icon(Icons.notifications),
          //   label: 'الإشعارات',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'الاستمارة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            activeIcon: Icon(Icons.star),
            label: 'التقييم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
