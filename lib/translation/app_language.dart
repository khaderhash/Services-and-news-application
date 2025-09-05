import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'languages/ar_language.dart';
import 'languages/en_language.dart';

class AppLanguage extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    "en_US": ENLanguage.map,
    "ar_SA": ARLanguage.map,
  };
}

tr(String key) => key.tr;
