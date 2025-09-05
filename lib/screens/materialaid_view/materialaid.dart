import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'materialaid_controller.dart';

class MaterialAidScreen extends StatelessWidget {
  MaterialAidScreen({Key? key}) : super(key: key);

  final MaterialAidController controller = Get.put(MaterialAidController());
  final Color primaryColor = const Color(0xFF4B2E83);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'طلب مساعدة عينية',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
                "حالة طلبك الحالي",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Divider(height: 20),
              _buildInfoRow(
                Icons.category,
                "نوع المساعدة:",
                request.aidTypeDisplay,
              ),
              _buildInfoRow(
                Icons.info_outline,
                "حالة الطلب:",
                request.statusDisplay,
              ),
              _buildInfoRow(
                Icons.date_range,
                "تاريخ الطلب:",
                request.requestDate ?? 'غير متوفر',
              ),
              _buildInfoRow(
                Icons.notes,
                "ملاحظاتك:",
                request.notes ?? 'لا يوجد',
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
            "إنشاء طلب مساعدة جديد",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildDropdown(
            "نوع المساعدة",
            controller.aidTypes.keys.toList(),
            controller.selectedAidType,
          ),
          const SizedBox(height: 20),
          _buildDatePickerField(
            Get.context!,
            "تاريخ التسليم المتوقع",
            controller.deliveryDateController,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            "ملاحظات إضافية (اختياري)",
            controller.notesController,
            maxLines: 4,
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
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    Rxn<String> selectedValue,
  ) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: selectedValue.value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        hint: const Text("اختر..."),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (val) => selectedValue.value = val,
        validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }

  Widget _buildDatePickerField(
    BuildContext context,
    String label,
    TextEditingController ctrl,
  ) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(Icons.calendar_today, color: primaryColor),
      ),
      onTap: () => controller.pickDeliveryDate(context),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
    );
  }
}
