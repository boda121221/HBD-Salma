import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'features/countdown/countdown_screen.dart';
import 'features/splash/splash_screen.dart';
import 'package:hbd_salma/core/app_routes.dart';
import 'package:provider/provider.dart';
import 'features/music/music_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (_) => MusicController(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),

              // Countdown shell – initialIndex 0 is the Countdown tab
              AppRoutes.countdown: (context) =>
                  const CountdownScreen(initialIndex: 0),

              // Our Story tab (index 1) – replaces old /memories route
              AppRoutes.ourStory: (context) =>
                  const CountdownScreen(initialIndex: 1),

              // Games tab (index 2)
              AppRoutes.games: (context) =>
                  const CountdownScreen(initialIndex: 2),

              // Voice Notes tab (index 3) – new feature
              AppRoutes.voiceNotes: (context) =>
                  const CountdownScreen(initialIndex: 3),

              // Music tab (index 4)
              AppRoutes.music: (context) =>
                  const CountdownScreen(initialIndex: 4),
            },
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: MyColors.primaryColor,
              colorScheme: ColorScheme.light(
                primary: MyColors.primaryColor,
                onSurface: MyColors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}

// AppRoutes live in lib/core/app_routes.dart
