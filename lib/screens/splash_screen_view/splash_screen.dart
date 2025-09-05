import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app11/screens/splash_screen_view/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'images/splas_screen.png',
                width: size.width * 0.9,
              ),
            ),
            SizedBox(height: size.height * 0.1),

            SizedBox(
              width: size.width * 0.15,
              height: size.width * 0.15,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                strokeWidth: 6.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
