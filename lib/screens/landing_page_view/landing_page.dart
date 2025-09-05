import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../UI/shared/custom_widgets/custom_button.dart';
import 'landing_controller.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final LandingController controller = Get.put(LandingController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Stack(
            children: [
              Positioned(
                top: size.height * 0.03,
                right: size.width * 0.015,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.purple,
                  ),
                  onPressed: () => Get.back(),
                  iconSize: size.width * 0.1,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: size.height * 0.06),

                  Image.asset(
                    'images/LandingPage.png',
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),

                  Text(
                    'أهلاً بك في تطبيق\nالجمعية السورية للتنمية الاجتماعية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontFamily: 'lemonada',
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 63, 23, 116),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: CustomButton(
                      text: "تسجيل الدخول",
                      color: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 63, 23, 116),
                      borderColor: const Color.fromARGB(255, 63, 23, 116),
                      onPressed: controller.goToLogin,
                    ),
                  ),

                  SizedBox(height: size.height * 0.015),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          endIndent: size.width * 0.025,
                        ),
                      ),
                      Text(
                        'أول مرة على التطبيق',
                        style: TextStyle(
                          fontFamily: 'lemonada',
                          fontSize: size.width * 0.04,
                          color: const Color.fromARGB(255, 43, 12, 82),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: size.width * 0.025,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.015),

                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: CustomButton(
                      text: "إنشاء الحساب",
                      color: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 63, 23, 116),
                      borderColor: const Color.fromARGB(255, 63, 23, 116),
                      onPressed: controller.goToSignup,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(height: size.height * 0.08),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
