import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'features/countdown/countdown_screen.dart';
import 'features/splash/splash_screen.dart';
import 'package:hbd_salma/core/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2340),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.countdown: (context) =>
                const CountdownScreen(initialIndex: 0),
            AppRoutes.memories: (context) =>
                const CountdownScreen(initialIndex: 1),
            AppRoutes.games: (context) =>
                const CountdownScreen(initialIndex: 2),
            AppRoutes.music: (context) =>
                const CountdownScreen(initialIndex: 3),
          },
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: MyColors.primaryColor,
            colorScheme: ColorScheme.light(
              primary: MyColors.primaryColor,
              onSurface: MyColors.textPrimary,
            ),
          ),
        );
      },
    );
  }
}

// AppRoutes now live in lib/core/app_routes.dart
