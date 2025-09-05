import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'activite_controller.dart';

class ActivityDetailsScreen extends StatelessWidget {
  ActivityDetailsScreen({Key? key}) : super(key: key);
  final ActivityController controller = Get.find();
  final Color primaryColor = const Color(0xFF4B2E83);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "تفاصيل النشاط",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isDetailsLoading.value ||
            controller.selectedActivity.value == null) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        final activityDetails = controller.selectedActivity.value!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (activityDetails.photoUrl != null &&
                  activityDetails.photoUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    activityDetails.photoUrl!,
                    fit: BoxFit.cover,
                    height: 220,
                    width: double.infinity,
                    errorBuilder: (context, error, stack) => Container(
                      color: primaryColor.withOpacity(0.1),
                      height: 220,
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                )
              else
                Container(
                  height: 220,
                  color: primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.image, size: 60, color: Colors.grey),
                ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activityDetails.shortDescription,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          activityDetails.fullDescription ??
                              'لا يوجد وصف تفصيلي لهذا النشاط.',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              activityDetails.createdAt?.substring(0, 10) ??
                                  'تاريخ غير متوفر',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
