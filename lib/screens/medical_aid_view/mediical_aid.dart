import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'medical_aid_controller.dart';

class MedicalAidScreen extends StatelessWidget {
  MedicalAidScreen({Key? key}) : super(key: key);

  final MedicalAidController controller = Get.put(MedicalAidController());
  final Color primaryColor = const Color(0xFF4B2E83);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'طلب مساعدة طبية',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.existingRequest.value != null) {
          return _buildRequestDetailsView();
        } else {
          return _buildCreateRequestForm(context);
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
                "حالة طلبك الطبي",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Divider(height: 30),
              _buildInfoRow(
                Icons.medical_services,
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
                request.requestDate ?? 'N/A',
              ),
              _buildInfoRow(
                Icons.notes,
                "ملاحظاتك:",
                request.notes ?? 'لا يوجد',
              ),
              if (request.medicalReportUrl != null) ...[
                const SizedBox(height: 10),
                Text(
                  "التقرير الطبي المرفق:",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Image.network(
                    request.medicalReportUrl!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 30),
              if (request.status == 'pending')
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _showDeleteConfirmation,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text("حذف الطلب"),
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

  Widget _buildCreateRequestForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "إنشاء طلب مساعدة طبية",
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
            context,
            "تاريخ التسليم المتوقع",
            controller.deliveryDateController,
          ),
          const SizedBox(height: 20),
          _buildImagePicker(),
          const SizedBox(height: 20),
          _buildTextField(
            "ملاحظات إضافية",
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
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إرفاق التقرير الطبي:",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Obx(
          () => GestureDetector(
            onTap: controller.pickMedicalReport,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: controller.selectedReportFile.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.file(
                        controller.selectedReportFile.value!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                        const Text("اضغط هنا لاختيار صورة"),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 10),
          Text("$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
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
    return Obx(() {
      return DropdownButtonFormField<String>(
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
      );
    });
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
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1920),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) {
          ctrl.text =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        }
      },
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
