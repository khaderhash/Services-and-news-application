import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../UI/shared/custom_widgets/custom_button.dart';
import '../../UI/shared/custom_widgets/custom_text_form_fieled.dart';
import '../../UI/shared/utilities.dart';
import '../../translation/app_language.dart';
import '../forget_pass_view/forget_pass.dart';
import '../home_view/home.dart';
import '../landing_page_view/landing_page.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController controler = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: controler.key,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.purple,
                              ),
                              onPressed: () {
                                Get.offAll(() => const LandingPage());
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),

                          SizedBox(height: size.height * 0.1),
                          Padding(
                            padding: EdgeInsets.only(right: size.height * 0.05),
                            child: Image.asset(
                              'images/login.png',
                              height: size.height * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Obx(() {
                            if (!controler.loginFailed.value) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr("login_key"),
                                    style: TextStyle(
                                      fontSize: size.width * 0.05,
                                      color: const Color.fromARGB(
                                        255,
                                        63,
                                        23,
                                        116,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Text(
                                    'أهلاً بك في تطبيق \n"الجمعية السورية للتنمية الاجتماعية"',
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: size.height * 0.03),
                          CustomTextFormFieled(
                            hinText: tr("البريد الالكتروني"),
                            prefIcon: Icons.person_outline,
                            isSecure: false,
                            controller: controler.UsersController,
                            borderColor: Colors.purple.shade100,
                            validater: (val) {
                              if (val!.isEmpty) {
                                return "يرجى إدخال البريد الالكتروني";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: size.height * 0.012),
                          Obx(
                            () => CustomTextFormFieled(
                              hinText: "كلمة المرور",
                              prefIcon: Icons.key_outlined,
                              suffIcon: controler.isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              isSecure: !controler.isPasswordVisible.value,
                              controller: controler.passwordController,
                              onSuffixTap: () {
                                controler.isPasswordVisible.toggle();
                              },
                              borderColor: Colors.purple.shade100,
                              textColor: controler.loginFailed.value
                                  ? Colors.red
                                  : Colors.black,
                              validater: (val) {
                                if (val!.isEmpty) {
                                  return "يرجى إدخال كلمة المرور";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.007),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (controler.loginFailed.value)
                                  Text(
                                    'كلمة المرور خاطئة',
                                    style: TextStyle(
                                      fontSize: size.width * 0.03,
                                      color: Colors.red,
                                    ),
                                  )
                                else
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: controler.rememberMe.value,
                                        onChanged: (value) {
                                          controler.rememberMe.value = value!;
                                        },
                                        activeColor: Colors.purple,
                                      ),
                                      Text(
                                        'تذكرني',
                                        style: TextStyle(
                                          fontSize: size.width * 0.03,
                                          color: const Color.fromARGB(
                                            255,
                                            63,
                                            23,
                                            116,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    Get.off(ForgetPass());
                                  },
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'هل نسيت كلمة السر.. ',
                                          style: TextStyle(
                                            fontSize: size.width * 0.03,
                                            color: const Color.fromARGB(
                                              255,
                                              63,
                                              23,
                                              116,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'انقر هنا',
                                          style: TextStyle(
                                            fontSize: size.width * 0.03,
                                            color: const Color.fromARGB(
                                              255,
                                              206,
                                              169,
                                              255,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.only(top: size.height * 0.02),
                              child: controler.isLooading.value
                                  ? const SpinKitCircle(
                                      color: Color.fromARGB(255, 63, 23, 116),
                                    )
                                  : CustomButton(
                                      text: "تسجيل الدخول",
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
                                        controler.login();
                                      },
                                    ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
