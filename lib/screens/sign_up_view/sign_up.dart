import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app11/screens/sign_up_view/signup_controller.dart';
import '../../UI/shared/custom_widgets/custom_button.dart';
import '../../UI/shared/custom_widgets/custom_text_form_fieled.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupController controler = SignupController();
  int currentStep = 0;
  String selectedGender = 'ذكر';

  void goToStep(int step) {
    setState(() {
      currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.purple,
                          ),
                          onPressed: () => Get.back(),
                          iconSize: screenWidth * 0.06,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "إنشاء حساب جديد",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                              Text(
                                currentStep == 0
                                    ? "الرجاء إدخال معلوماتك الشخصية هنا"
                                    : "الرجاء إدخال معلومات الحماية",
                                style: TextStyle(fontSize: screenWidth * 0.05),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Center(
                    child: Image.asset(
                      currentStep == 0
                          ? 'images/signup_security.png'
                          : 'images/signup_personal.png',
                      height: screenHeight * 0.25,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => goToStep(0),
                            child: CircleAvatar(
                              radius: screenWidth * 0.035,
                              backgroundColor: currentStep == 0
                                  ? Colors.purple
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            "المعلومات الشخصية",
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => goToStep(1),
                            child: CircleAvatar(
                              radius: screenWidth * 0.035,
                              backgroundColor: currentStep == 1
                                  ? Colors.purple
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            "القفل/الحماية",
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  IndexedStack(
                    index: currentStep,
                    children: [
                      _buildPersonalInfoForm(screenHeight, screenWidth),
                      _buildSecurityForm(screenHeight, screenWidth),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoForm(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormFieled(
            hinText: "الاسم الكامل",
            prefIcon: Icons.person_outline,
            controller: controler.nameController,
            isSecure: false,
            validater: (val) {
              if (val == null || val.isEmpty) return "يرجى إدخال الاسم الكامل";
            },
          ),
          SizedBox(height: screenHeight * 0.015),
          CustomTextFormFieled(
            hinText: "البريد الإلكتروني",
            prefIcon: Icons.email_outlined,
            controller: controler.emailController,
            isSecure: false,
            validater: (val) {
              if (val == null || val.isEmpty)
                return "يرجى إدخال البريد الإلكتروني";
            },
          ),
          SizedBox(height: screenHeight * 0.015),
          CustomTextFormFieled(
            hinText: "تاريخ الميلاد",
            prefIcon: Icons.calendar_today,
            controller: controler.birthController,
            validater: (val) {
              if (val == null || val.isEmpty) return "يرجى إدخال تاريخ الميلاد";
              return null;
            },
            isDate: true,
            textColor: const Color.fromARGB(255, 63, 23, 116),
            prefIconColor: const Color.fromARGB(255, 63, 23, 116),
          ),
          SizedBox(height: screenHeight * 0.015),
          CustomTextFormFieled(
            hinText: "+963-111-111-111",
            prefIcon: Icons.phone,
            controller: controler.phoneController,
            isSecure: false,
            validater: (val) {
              if (val == null || val.isEmpty) return "يرجى إدخال رقم الهاتف";
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'أنثى';
                  });
                },
                child: Row(
                  children: [
                    const Text("أنثى"),
                    SizedBox(width: screenWidth * 0.02),
                    CircleAvatar(
                      radius: screenWidth * 0.017,
                      backgroundColor: selectedGender == 'أنثى'
                          ? Colors.purple
                          : Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.07),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'ذكر';
                  });
                },
                child: Row(
                  children: [
                    const Text("ذكر"),
                    SizedBox(width: screenWidth * 0.02),
                    CircleAvatar(
                      radius: screenWidth * 0.017,
                      backgroundColor: selectedGender == 'ذكر'
                          ? Colors.purple
                          : Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          CustomButton(
            text: "التالي",
            color: Colors.white,
            backgroundColor: const Color.fromARGB(255, 63, 23, 116),
            borderColor: const Color.fromARGB(255, 63, 23, 116),
            onPressed: () {
              goToStep(1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityForm(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Column(
        children: [
          CustomTextFormFieled(
            hinText: "كلمة المرور",
            prefIcon: Icons.lock_outline,
            suffIcon: Icons.visibility,
            controller: controler.passController,
            isSecure: true,
            validater: (val) {
              if (val == null || val.isEmpty) return "يرجى إدخال كلمة المرور";
              if (val.length < 6) return "كلمة المرور قصيرة جداً";
            },
          ),
          SizedBox(height: screenHeight * 0.015),
          CustomTextFormFieled(
            hinText: "تأكيد كلمة المرور",
            prefIcon: Icons.lock_outline,
            suffIcon: Icons.visibility,
            controller: controler.confirmPassController,
            isSecure: true,
            validater: (val) {
              if (val == null || val.isEmpty) return "يرجى تأكيد كلمة المرور";
              if (val != controler.passController.text) {
                return "كلمتا المرور غير متطابقتين";
              }
            },
          ),
          SizedBox(height: screenHeight * 0.03),
          CustomButton(
            text: "إنشاء الحساب",
            color: Colors.white,
            backgroundColor: const Color.fromARGB(255, 63, 23, 116),
            borderColor: const Color.fromARGB(255, 63, 23, 116),
            onPressed: () {
              controler.registerUser(gender: selectedGender);
            },
          ),
        ],
      ),
    );
  }
}
