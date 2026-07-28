import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ico_story_app/core/utils/app_bloc_observer.dart';
import 'package:ico_story_app/core/utils/app_logger.dart';
import 'package:ico_story_app/core/services/local_storage/shared_pref.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = AppBlocObserver();
    AppLogger.info('🚀 App starting...');

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await SharedPref().instantiatePreferences();
  }
}
