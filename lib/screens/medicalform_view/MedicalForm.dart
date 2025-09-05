import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'medicalform_controller.dart';

class MedicalForm extends StatefulWidget {
  const MedicalForm({Key? key}) : super(key: key);

  @override
  State<MedicalForm> createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  final controller = Get.put(MedicalFormController());

  @override
  void dispose() {
    controller.notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF4B2E83);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(
                "يرجى ملء الاستمارة التالية:",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              Text(
                "ادراج صورة تقرير طبي :",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.018,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: primaryColor,
                                size: screenWidth * 0.06,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Flexible(
                                child: Text(
                                  controller.selectedImageName.value ??
                                      "إدراج صورة",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color:
                                        controller.selectedImageName.value ==
                                            null
                                        ? Colors.grey[700]
                                        : primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.pickFile,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.018,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_file,
                                color: primaryColor,
                                size: screenWidth * 0.06,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Flexible(
                                child: Text(
                                  controller.selectedFileName.value ??
                                      "رفع ملف PDF",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color:
                                        controller.selectedFileName.value ==
                                            null
                                        ? Colors.grey[700]
                                        : primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.04),

              Text(
                "ملاحظات إضافية:",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              Obx(
                () => TextField(
                  controller: controller.notesController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: controller.notesText.value.isEmpty
                        ? "أدخل ملاحظاتك هنا"
                        : controller.notesText.value,
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  style: TextStyle(fontSize: screenWidth * 0.037),
                  maxLines: 4,
                  onChanged: (val) => controller.notesText.value = val,
                ),
              ),

              SizedBox(height: screenHeight * 0.08),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 23, 116),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.12,
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
                      fontSize: screenWidth * 0.04,
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
}
