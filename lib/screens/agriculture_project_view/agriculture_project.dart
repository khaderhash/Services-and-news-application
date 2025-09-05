import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'agriculturalproject_controller.dart';

class AgriculturalProject extends StatefulWidget {
  const AgriculturalProject({super.key});

  @override
  State<AgriculturalProject> createState() => _AgriculturalProjectState();
}

class _AgriculturalProjectState extends State<AgriculturalProject> {
  final controller = Get.put(AgriculturalProjectController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Text(
              "يرجى ملئ الاستمارة التالية:",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            _buildQuestion("هل تمتلك أرض زراعية؟", screenWidth),
            Obx(
              () => _buildCheckBoxRow(
                yesValue: controller.hasLandYes.value,
                noValue: controller.hasLandNo.value,
                onYesChanged: controller.toggleLandYes,
                onNoChanged: controller.toggleLandNo,
                screenWidth: screenWidth,
              ),
            ),
            _buildSubQuestion("في حال كان الجواب نعم كم مساحتها؟", screenWidth),
            _buildTextField(
              controller: controller.landSizeController,
              screenWidth: screenWidth,
            ),
            _buildQuestion("هل لديك خبرة زراعية سابقة؟", screenWidth),
            Obx(
              () => _buildCheckBoxRow(
                yesValue: controller.hasExperienceYes.value,
                noValue: controller.hasExperienceNo.value,
                onYesChanged: controller.toggleExperienceYes,
                onNoChanged: controller.toggleExperienceNo,
                screenWidth: screenWidth,
              ),
            ),

            _buildQuestion("هل تمتلك أدوات زراعية؟", screenWidth),
            Obx(
              () => _buildCheckBoxRow(
                yesValue: controller.hasToolsYes.value,
                noValue: controller.hasToolsNo.value,
                onYesChanged: controller.toggleToolsYes,
                onNoChanged: controller.toggleToolsNo,
                screenWidth: screenWidth,
              ),
            ),
            _buildSubQuestion(
              "في حال كان الجواب نعم ما هي الأدوات؟",
              screenWidth,
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              controller: controller.toolsController,
              screenWidth: screenWidth,
            ),
            _buildQuestion("ملاحظات إضافية", screenWidth),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              controller: controller.notesController,
              screenWidth: screenWidth,
            ),

            SizedBox(height: screenHeight * 0.04),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 63, 23, 116),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم إرسال الاستمارة بنجاح ✅"),
                      backgroundColor: Color.fromARGB(255, 63, 23, 116),
                    ),
                  );
                },
                child: Text(
                  "إرسال",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Text(
        "● $text",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  Widget _buildSubQuestion(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Text(text, style: TextStyle(fontSize: screenWidth * 0.04)),
    );
  }

  Widget _buildCheckBoxRow({
    required bool yesValue,
    required bool noValue,
    required Function(bool?) onYesChanged,
    required Function(bool?) onNoChanged,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Text("نعم", style: TextStyle(fontSize: screenWidth * 0.04)),
        Checkbox(value: yesValue, onChanged: onYesChanged),
        Text("لا", style: TextStyle(fontSize: screenWidth * 0.04)),
        Checkbox(value: noValue, onChanged: onNoChanged),
      ],
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required double screenWidth,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
        hintText: "",
      ),
      style: TextStyle(fontSize: screenWidth * 0.04),
    );
  }
}
