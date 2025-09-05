import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'feedback_controller.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  final FeedbackController controller = Get.put(FeedbackController());
  final Color primaryColor = const Color(0xFF4B2E83);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('التقييم', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.existingFeedback.value != null) {
          return _buildFeedbackDetailsView();
        } else {
          return _buildCreateFeedbackForm();
        }
      }),
    );
  }

  Widget _buildFeedbackDetailsView() {
    final feedback = controller.existingFeedback.value!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 16),
                const Text(
                  "شكراً لك، لقد قمت بتقييم خدماتنا مسبقاً",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 30),
                Text(
                  "تقييمك كان: ${feedback.rating} من 10",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "ملاحظاتك: ${feedback.notes ?? 'لا يوجد'}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateFeedbackForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "نقدر تقييمك لخدماتنا",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            "ما هو تقييمك العام للخدمة؟ (من 1 إلى 10)",
            style: TextStyle(fontSize: 16),
          ),
          Obx(
            () => Slider(
              value: controller.rating.value,
              min: 0,
              max: 10,
              divisions: 10,
              label: controller.rating.value.toInt().toString(),
              activeColor: primaryColor,
              onChanged: (value) => controller.rating.value = value,
            ),
          ),

          const SizedBox(height: 24),
          Obx(
            () => SwitchListTile.adaptive(
              title: const Text("هل أنت راضٍ عن الخدمة؟"),
              value: controller.isSatisfied.value,
              onChanged: (val) => controller.isSatisfied.value = val,
              activeColor: primaryColor,
            ),
          ),

          Obx(
            () => SwitchListTile.adaptive(
              title: const Text("هل ستستخدم خدماتنا مرة أخرى؟"),
              value: controller.willUseAgain.value,
              onChanged: (val) => controller.willUseAgain.value = val,
              activeColor: primaryColor,
            ),
          ),

          const SizedBox(height: 24),
          TextField(
            controller: controller.notesController,
            decoration: InputDecoration(
              labelText: "ملاحظات إضافية (اختياري)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 4,
          ),

          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: controller.submitFeedback,
              icon: const Icon(Icons.send),
              label: const Text("إرسال التقييم"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
