import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../UI/shared/custom_widgets/custom_button.dart';
import 'optcode_controller.dart';

class OptCode extends StatelessWidget {
  final String email;
  final bool isRegistration;

  const OptCode({super.key, required this.email, required this.isRegistration});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final OptCodeController controller = Get.put(
      OptCodeController(email: email, isRegistration: isRegistration),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.06),
                Text(
                  "إدخال رمز تحقق",
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  "يتم إرسال الرمز إلى البريد الخاص بك",
                  style: TextStyle(fontSize: screenWidth * 0.045),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: screenHeight * 0.06),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(controller.fieldCount, (i) {
                      final index = i;
                      return Container(
                        width: screenWidth * 0.15,
                        margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                        ),
                        child: TextField(
                          controller: controller.codeControllers[index],
                          focusNode: controller.focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 206, 169, 255),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.02,
                              ),
                            ),
                          ),
                          onChanged: (value) =>
                              controller.handleInput(value, index, context),
                        ),
                      );
                    }).reversed.toList(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),

                CustomButton(
                  text: "إعادة تعيين",
                  color: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 63, 23, 116),
                  borderColor: const Color.fromARGB(255, 63, 23, 116),
                  onPressed: () {
                    final otp = controller.getOTP();
                    print("OTP: $otp");
                    controller.verifyOtp();
                  },
                ),

                SizedBox(height: screenHeight * 0.04),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "الرجوع",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: Colors.purple,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                          decorationStyle: TextDecorationStyle.solid,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
