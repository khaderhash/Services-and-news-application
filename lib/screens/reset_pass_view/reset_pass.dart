import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_app11/screens/reset_pass_view/resetpasswordcontroller.dart';
import '../../../UI/shared/custom_widgets/custom_button.dart';
import '../../../UI/shared/custom_widgets/custom_text_form_fieled.dart';

class ResetPass extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPass({super.key, required this.email, required this.otp});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  late final ResetPassController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ResetPassController(email: widget.email, otp: widget.otp),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: screenHeight * 0.03,
                right: screenWidth * 0.02,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.purple,
                  ),
                  onPressed: () => Get.back(),
                  iconSize: screenWidth * 0.1,
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.18),
                      Text(
                        'تغيير كلمة المرور\nالرجاء إعادة تعيين كلمة المرور والاحتفاظ بها',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontFamily: 'lemonada',
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 63, 23, 116),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.06),
                      CustomTextFormFieled(
                        hinText: "كلمة المرور الجديدة",
                        prefIcon: Icons.key_outlined,
                        suffIcon: Icons.visibility,
                        isSecure: true,
                        controller: controller.newPasswordController,
                        validater: (val) {
                          if (val == null || val.isEmpty)
                            return "يرجى إدخال كلمة المرور";
                          if (val.length < 6) return "كلمة المرور قصيرة جداً";
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      CustomTextFormFieled(
                        hinText: "تأكيد كلمة المرور",
                        prefIcon: Icons.key_outlined,
                        suffIcon: Icons.visibility,
                        isSecure: true,
                        controller: controller.confirmPasswordController,
                        validater: (val) {
                          if (val == null || val.isEmpty)
                            return "يرجى تأكيد كلمة المرور";
                          if (val != controller.newPasswordController.text)
                            return "كلمتا المرور غير متطابقتين";
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.05),
                          child: controller.isLoading.value
                              ? const SpinKitCircle(
                                  color: Color.fromARGB(255, 63, 23, 116),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.065,
                                  child: CustomButton(
                                    text: "حفظ",
                                    color: Colors.white,
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      63,
                                      23,
                                      116,
                                    ),
                                    borderColor: const Color.fromARGB(
                                      255,
                                      63,
                                      23,
                                      116,
                                    ),
                                    onPressed: () {
                                      controller.resetPassword();
                                    },
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],
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
