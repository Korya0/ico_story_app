import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ico_story_app/core/constants/app_constant.dart';
import 'package:ico_story_app/core/router/app_router.dart';
import 'package:ico_story_app/core/services/app_initializer.dart';
import 'package:ico_story_app/core/style/app_theme.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        routerConfig: AppRouter.router,
        locale: const Locale(AppConstant.ar, AppConstant.arCode),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      ),
    );
  }
}
