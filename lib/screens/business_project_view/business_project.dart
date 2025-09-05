import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'businessproject_controller.dart';

class BusinessProject extends StatefulWidget {
  const BusinessProject({super.key});

  @override
  State<BusinessProject> createState() => _BusinessProjectState();
}

class _BusinessProjectState extends State<BusinessProject> {
  final controller = Get.put(BusinessProjectController());

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
            SizedBox(height: screenHeight * 0.04),
            Text(
              "يرجى ملئ الاستمارة التالية:",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.025),

            _buildQuestion("هل تمتلك محل ؟", screenWidth),
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

            SizedBox(height: screenHeight * 0.02),

            _buildQuestion("هل لديك خبرة تجارية سابقة؟", screenWidth),
            Obx(
              () => _buildCheckBoxRow(
                yesValue: controller.hasExperienceYes.value,
                noValue: controller.hasExperienceNo.value,
                onYesChanged: controller.toggleExperienceYes,
                onNoChanged: controller.toggleExperienceNo,
                screenWidth: screenWidth,
              ),
            ),
            _buildSubQuestion(
              "فكرة المواد التجارية التي تفكر بها ؟",
              screenWidth,
            ),
            _buildTextField(
              controller: controller.toolsController,
              screenWidth: screenWidth,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildQuestion("ملاحظات إضافية", screenWidth),
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
                    horizontal: screenWidth * 0.15,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
          fontSize: screenWidth * 0.042,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
      ),
    );
  }
}
