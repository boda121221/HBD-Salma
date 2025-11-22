import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late AnimationController _textController; // text ease in controller
  late Animation<double> _fadeAnimation;
  late Animation<double> _textAnimation;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();

    // Fade animation for the exit
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Text ease-in animation for subsequent launches
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    // Lottie controller: slower loop for background hearts
    _lottieController = AnimationController(
      vsync: this,
      duration: (_isFirstLaunch)
          ? const Duration(seconds: 13)
          : const Duration(seconds: 7), // slow full cycle
    );
    // Start the Lottie loop
    _lottieController.repeat();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenSplash = prefs.getBool('has_seen_splash') ?? false;

    setState(() {
      _isFirstLaunch = !hasSeenSplash;
    });

    // Set the flag for future launches
    if (!hasSeenSplash) {
      await prefs.setBool('has_seen_splash', true);
    }

    // Start text animation for subsequent launches
    if (!_isFirstLaunch) {
      _textController.forward();
    }

    // Navigate based on first launch or not
    final delay = _isFirstLaunch
        ? const Duration(seconds: 9) // Full animation on first launch
        : const Duration(seconds: 1); // Quick splash on subsequent launches

    Timer(delay, () async {
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
    _textController.dispose();
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
              ),
            ),

            // ✨ Animated text (only show on first launch)
            if (_isFirstLaunch)
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
                      TyperAnimatedText(
                        'Happy Birthday\nSalma',
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(height: 1.4),
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
              )
            else
              // Show static text with ease-in animation on subsequent launches
              Center(
                child: FadeTransition(
                  opacity: _textAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.8,
                      end: 1.0,
                    ).animate(_textAnimation),
                    child: Center(
                      child: Text(
                        'Happy Birthday\nSalma',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 46.sp,
                          color: Colors.white,
                          fontFamily: 'Lymbo',
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                          shadows: [
                            Shadow(
                              color: Color.fromRGBO(254, 214, 208, 0.08),
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
