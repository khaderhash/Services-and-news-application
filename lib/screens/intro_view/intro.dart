import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../UI/shared/custom_widgets/custom_button.dart';
import 'intro_controller.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final IntroController controller = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView.builder(
        controller: controller.pageController,
        itemCount: controller.pages.length,
        onPageChanged: controller.onPageChanged,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(height: size.height * 0.08),
              Image.asset(
                controller.pages[index]["image"]!,
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.02),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: List.generate(
                    controller.pages.length,
                    (dotIndex) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.012,
                      ),
                      height: size.height * 0.012,
                      width: size.width * 0.17,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == dotIndex
                            ? Colors.deepPurple
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(size.width * 0.015),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: size.height * 0.45,
                width: double.infinity,
                padding: EdgeInsets.all(size.width * 0.06),
                decoration: BoxDecoration(
                  color: const Color(0xFFCEA9FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.18),
                    topRight: Radius.circular(size.width * 0.18),
                  ),
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: size.width * 0.003,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      controller.pages[index]["text"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width * 0.065,
                        fontFamily: 'lemonada',
                        color: const Color(0xFF3D0066),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(flex: 3),
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.065,
                      child: CustomButton(
                        text: "التالي",
                        color: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 63, 23, 116),
                        borderColor: const Color.fromARGB(255, 63, 23, 116),
                        onPressed: controller.nextPage,
                      ),
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
