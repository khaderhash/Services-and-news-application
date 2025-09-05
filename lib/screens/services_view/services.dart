import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services_controller.dart';

class ServicesScreen extends StatelessWidget {
  ServicesScreen({Key? key}) : super(key: key);

  final ServicesController controller = Get.put(ServicesController());
  final Color primaryColor = const Color(0xFF4B2E83);
  final Color secondaryColor = const Color.fromARGB(255, 206, 169, 255);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text(
            "خدمات الجمعية",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "اختر الخدمة التي تود طلبها:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.servicesList.length,
                  itemBuilder: (context, index) {
                    final service = controller.servicesList[index];
                    return _buildServiceCard(
                      title: service['title'],
                      imagePath: service['image'],
                      onTap: service['onTap'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: Get.height * 0.1,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.miscellaneous_services,
                    size: Get.height * 0.1,
                    color: primaryColor.withOpacity(0.7),
                  );
                },
              ),
              const Spacer(),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
