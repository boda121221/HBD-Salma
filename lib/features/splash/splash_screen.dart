import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:lottie/lottie.dart';

import 'package:hbd_salma/core/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller; // fade controller
  late AnimationController
  _lottieController; // lottie progress controller (slower)
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation for the exit
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Lottie controller: slower loop for background hearts
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 13), // slow full cycle
    );
    // Start the Lottie loop
    _lottieController.repeat();

    // Move to next screen after delay
    Timer(const Duration(seconds: 10), () async {
      await _controller.forward(); // fade out before navigation
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.countdown);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(_fadeAnimation),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 🌈 Animated pink background with hearts (reduced opacity)
            Opacity(
              opacity: 0.9, // reduced opacity for subtle background
              child: Lottie.asset(
                'assets/animations/hearts_feedback.json',
                fit: BoxFit.fitWidth,
                controller: _lottieController,
                onLoaded: (composition) {
                  // ensure controller duration matches composition if you want 1x speed,
                  // but we keep a long duration for slower animation
                },
              ),
            ),

            // 🌸 Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyColors.primaryColor, Color(0xE4F3E6E4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ) /**/,
            ),

            // ✨ Animated text
            Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 46.sp,
                  color: Colors.white,
                  fontFamily: 'Lymbo',
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Color.fromRGBO(254, 214, 208, 0.08),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    // ineed salma to be under happy birthday in the center
                    TyperAnimatedText(
                      'Happy Birthday Salma',
                      speed: const Duration(milliseconds: 145),
                    ),
                    TyperAnimatedText(
                      'I made this app',
                      speed: const Duration(milliseconds: 135),
                    ),
                    TyperAnimatedText(
                      'Just for you 💕',
                      speed: const Duration(milliseconds: 160),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
