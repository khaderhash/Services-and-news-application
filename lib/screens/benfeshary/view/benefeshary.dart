import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'benefeshary_controller.dart';

class BeneficiaryScreen extends StatelessWidget {
  BeneficiaryScreen({Key? key}) : super(key: key);

  final BeneficiaryController controller = Get.put(BeneficiaryController());
  final Color primaryColor = const Color(0xFF4B2E83);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'بيانات المستفيد',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard("المعلومات الشخصية", [
                    _buildTextField(
                      "الاسم الكامل",
                      controller.nameCtrl,
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      "البريد الإلكتروني",
                      controller.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                    ),
                    _buildTextField(
                      "رقم الهاتف",
                      controller.phoneCtrl,
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone,
                    ),
                    _buildDateField(
                      context,
                      "تاريخ الميلاد",
                      controller.birthDateCtrl,
                    ),
                    _buildDropdown(
                      "الجنس",
                      controller.genderList,
                      'gender',
                      icon: Icons.wc,
                    ),
                  ]),
                  _buildCard("المعلومات الاجتماعية", [
                    _buildTextField(
                      "العنوان الحالي",
                      controller.currentAddressCtrl,
                      icon: Icons.home_filled,
                    ),
                    _buildTextField(
                      "العنوان السابق",
                      controller.prevAddressCtrl,
                      icon: Icons.history,
                    ),
                    _buildDropdown(
                      "الحالة المعيشية (الخلفية)",
                      controller.livingStatusList,
                      'livingStatus',
                      icon: Icons.people_alt,
                    ),
                    _buildDropdown(
                      "طبيعة الإقامة",
                      controller.residenceTypeList,
                      'residenceType',
                      icon: Icons.location_city,
                    ),
                    _buildDropdown(
                      "الحالة الاجتماعية",
                      controller.maritalStatusList,
                      'maritalStatus',
                      icon: Icons.family_restroom,
                    ),
                    _buildDropdown(
                      "الحالة الصحية",
                      controller.disabilityList,
                      'weaknesses_disabilities',
                      icon: Icons.health_and_safety,
                    ),
                    _buildDropdown(
                      "التحصيل العلمي",
                      controller.educationList,
                      'education',
                      icon: Icons.school,
                    ),
                    _buildTextField(
                      "العمل الحالي",
                      controller.jobCtrl,
                      icon: Icons.work,
                    ),
                    _buildTextField(
                      "عدد أفراد الأسرة",
                      controller.familyMembersCtrl,
                      keyboardType: TextInputType.number,
                      icon: Icons.group,
                    ),
                    _buildTextField(
                      "ملاحظات إضافية",
                      controller.notesCtrl,
                      maxLines: 3,
                      icon: Icons.note_alt_outlined,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    TextInputType? keyboardType,
    int? maxLines = 1,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    TextEditingController ctrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: ctrl,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today, color: primaryColor),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onTap: () => controller.pickDate(context),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String mapKey, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.dropdownValues[mapKey],
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          hint: const Text("اختر..."),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => controller.updateDropdownValue(mapKey, value),
          validator: (value) => (value == null) ? 'هذا الحقل مطلوب' : null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: controller.submitForm,
      icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
      label: Obx(
        () => Text(
          controller.isUpdateMode.value ? "حفظ التعديلات" : "إرسال البيانات",
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}
