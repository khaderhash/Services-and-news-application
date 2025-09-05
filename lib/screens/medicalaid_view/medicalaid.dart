import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../MedicalForm_view/MedicalForm.dart';
import 'medicalaid_controller.dart';

class MedicalAid extends StatelessWidget {
  final String imagePath;

  const MedicalAid({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicalAidController());
    final Color primaryColor = const Color(0xFF4B2E83);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.45,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              Transform.translate(
                offset: Offset(0, -screenHeight * 0.04),
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(screenWidth * 0.07),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: screenWidth * 0.03,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مساعدات طبية:",
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          children: controller.items
                              .map(
                                (item) => buildCheckRow(
                                  item,
                                  screenWidth,
                                  controller,
                                  primaryColor,
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.03,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => const MedicalForm());
                            },
                            child: Text(
                              "املأ الاستمارة",
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckRow(
    String label,
    double screenWidth,
    MedicalAidController controller,
    Color primaryColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      child: GestureDetector(
        onTap: () => controller.toggleItem(label),
        child: Row(
          children: [
            Obx(() {
              final selected = controller.selectedItems.contains(label);
              return Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: primaryColor,
                size: screenWidth * 0.07,
              );
            }),
            SizedBox(width: screenWidth * 0.03),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
