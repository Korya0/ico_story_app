import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  factory SharedPref() {
    return preferences;
  }

  SharedPref._internal();
  static final SharedPref preferences = SharedPref._internal();

  static late SharedPreferences sharedPreferences;

  Future<dynamic> instantiatePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  

  Future<dynamic> setBoolean(String key, {required bool booleanValue}) async {
    await sharedPreferences.setBool(key, booleanValue);
  }

  bool? getBoolean(String key) {
    return sharedPreferences.getBool(key);
  }
}
