import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_app11/shared_preferences_repository/shared_preferences_repository.dart';
import 'package:my_app11/translation/app_language.dart';
import 'screens/splash_screen_view/splash_screen.dart';
import 'my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? globalSharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalSharedPrefs = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppLanguage(),
      locale: getlocale(),
      fallbackLocale: getlocale(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => const MyApp(),
      },
    );
  }
}

Locale getlocale() {
  if (SharedPreferencesRepository.getAppLanguage() == "en")
    return Locale("en", "US");
  else
    return Locale("ar", "SA");
}
