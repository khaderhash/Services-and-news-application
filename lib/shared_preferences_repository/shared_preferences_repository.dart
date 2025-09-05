import 'dart:convert';
import '../../../main.dart';
import '../../enums/data_type.dart';

class SharedPreferencesRepository {
  static String FIRST_LOGIN = "first_login";
  static String PROFILE_IMAGE = "profile_image";
  static String APP_LANGUAGE = "app_language";
  static String TOKEN_INFO = "token_info";
  static String FIRST_LUNCH = "first_lunch";

  static setFirstLogin(bool value) {
    setPreference(DataType.BOOL, FIRST_LOGIN, value);
  }

  static bool getFirstLogin() {
    if (globalSharedPrefs!.containsKey(FIRST_LOGIN))
      return false;
    else
      return true;
  }

  static setFirstLunch(bool value) {
    setPreference(DataType.BOOL, FIRST_LUNCH, value);
  }

  static bool getFirstLunch() {
    if (globalSharedPrefs!.containsKey(FIRST_LUNCH))
      return false;
    else
      return true;
  }

  static setTokenInfo(TokenInfo value) {
    setPreference(DataType.STRING, TOKEN_INFO, jsonEncode(value));
  }

  static TokenInfo? getTokenInfo() {
    if (globalSharedPrefs!.containsKey(TOKEN_INFO))
      return TokenInfo.fromJson(jsonDecode(getPreference(TOKEN_INFO)));
    else
      return null;
  }

  static setProfileImage(String value) {
    setPreference(DataType.STRING, PROFILE_IMAGE, value);
  }

  static String? getProfileImage() {
    if (globalSharedPrefs!.containsKey(PROFILE_IMAGE))
      return getPreference(PROFILE_IMAGE);
    else
      null;
  }

  static setAppLanguage(String value) {
    setPreference(DataType.STRING, APP_LANGUAGE, value);
  }

  static String? getAppLanguage() {
    if (globalSharedPrefs!.containsKey(APP_LANGUAGE))
      return getPreference(APP_LANGUAGE);
    else
      return "ar";
  }

  static setPreference(DataType type, String key, dynamic value) {
    switch (type) {
      case DataType.STRING:
        globalSharedPrefs!.setString(key, value);
        break;

      case DataType.INT:
        globalSharedPrefs!.setInt(key, value);
        break;

      case DataType.BOOL:
        globalSharedPrefs!.setBool(key, value);
        break;

      case DataType.DOUBLE:
        globalSharedPrefs!.setDouble(key, value);
        break;

      case DataType.STRINGLIST:
        globalSharedPrefs!.setStringList(key, value);
        break;
    }
  }

  static dynamic getPreference(String key) {
    return globalSharedPrefs!.get(key);
  }
}

class TokenInfo {
  static TokenInfo? fromJson(jsonDecode) {}
}
