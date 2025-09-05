import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:my_app11/core/services/api_service.dart';

import 'package:my_app11/screens/home_view/home.dart';
import 'package:my_app11/screens/intro_view/intro.dart';

class SplashController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    checkTokenAndNavigate();
  }

  void checkTokenAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final String? token = await _storage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      print("No token found, navigating to Intro screen.");
      Get.off(() => const Intro());
      return;
    }

    try {
      print("Token found, validating with API...");
      final response = await _apiService.getProfile();

      if (response.statusCode == 200) {
        print("Token is valid, navigating to Home screen.");
        Get.off(() => HomeScreen());
      } else {
        print(
          "Token validation failed with status code ${response.statusCode}, navigating to Intro.",
        );
        Get.off(() => const Intro());
      }
    } catch (e) {
      print("Token validation threw an error: $e. Navigating to Intro.");
      await _storage.deleteAll();
      Get.off(() => const Intro());
    }
  }
}
