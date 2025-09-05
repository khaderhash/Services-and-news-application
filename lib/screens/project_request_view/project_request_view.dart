import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'project_request_controller.dart';

class ProjectRequestScreen extends StatelessWidget {
  ProjectRequestScreen({Key? key}) : super(key: key);

  final ProjectRequestController controller = Get.put(
    ProjectRequestController(),
  );
  final Color primaryColor = const Color(0xFF4B2E83);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'طلب مشروع صغير',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.existingRequest.value != null) {
          return _buildRequestDetailsView();
        } else {
          return _buildCreateRequestForm();
        }
      }),
    );
  }

  Widget _buildRequestDetailsView() {
    final request = controller.existingRequest.value!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تفاصيل طلب المشروع",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Divider(height: 30),
              _buildInfoRow(
                Icons.confirmation_number,
                "رقم الطلب:",
                request.id.toString(),
              ),
              _buildInfoRow(
                Icons.business_center,
                "نوع المشروع:",
                request.projectType,
              ),
              _buildInfoRow(
                Icons.person_pin,
                "ملكية مكان العمل:",
                request.ownership,
              ),
              _buildInfoRow(Icons.texture, "مساحة المكان:", request.area),
              _buildInfoRow(Icons.star, "الخبرات:", request.experience),
              _buildInfoRow(Icons.build, "الأدوات المتوفرة:", request.tools),
              _buildInfoRow(Icons.info, "حالة الطلب:", request.statusDisplay),
              _buildInfoRow(
                Icons.date_range,
                "تاريخ الطلب:",
                (request.createdAt.length >= 10)
                    ? request.createdAt.substring(0, 10)
                    : request.createdAt,
              ),
              const SizedBox(height: 30),
              if (request.status == 'pending')
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _showDeleteConfirmation,
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    label: const Text(
                      "حذف الطلب",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateRequestForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "إنشاء طلب مشروع جديد",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildDropdown(
            "نوع المشروع",
            controller.projectTypes,
            controller.selectedProjectType,
          ),
          const SizedBox(height: 16),
          _buildTextField("ملكية مكان العمل", controller.ownershipController),
          const SizedBox(height: 16),
          _buildTextField("مساحة مكان العمل", controller.areaController),
          const SizedBox(height: 16),
          _buildTextField(
            "الخبرات السابقة",
            controller.experienceController,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            "الأدوات والمعدات المتوفرة",
            controller.toolsController,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            "ملاحظات إضافية",
            controller.notesController,
            maxLines: 3,
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: controller.createRequest,
              icon: const Icon(Icons.send),
              label: const Text("إرسال الطلب"),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDropdown(
    String label,
    Map<String, String> items,
    Rxn<String> selectedItem,
  ) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: selectedItem.value,
        hint: Text(label),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.entries.map((entry) {
          return DropdownMenuItem(value: entry.value, child: Text(entry.key));
        }).toList(),
        onChanged: (value) => selectedItem.value = value,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.defaultDialog(
      buttonColor: primaryColor,
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد أنك تريد حذف هذا الطلب؟",
      textConfirm: "نعم",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.deleteRequest();
      },
    );
  }
}
