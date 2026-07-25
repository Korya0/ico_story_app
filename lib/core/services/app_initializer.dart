import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ico_story_app/core/services/shared_pref.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await SharedPref().instantiatePreferences();
  }
}
