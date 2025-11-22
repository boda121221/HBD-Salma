import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import '../../core/theme/colors.dart';

class BirthdayDialog extends StatefulWidget {
  const BirthdayDialog({Key? key}) : super(key: key);

  @override
  State<BirthdayDialog> createState() => _BirthdayDialogState();
}

class _BirthdayDialogState extends State<BirthdayDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late AudioPlayer _audioPlayer;
  // Loop controller drives continuous explosions and cake shake
  late AnimationController _loopController;
  final List<ExplosionParticle> explosionParticles = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Looping controller - repeats until dialog is disposed
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Generate explosion particles around the dialog
    _generateExplosions();

    // Play birthday sound with robust error handling
    _initializeAudio();
  }

  void _generateExplosions() {
    final random = Random();
    final emojis = ['🎉', '🎊', '✨', '🎈', '🎁', '🎂', '❤️', '💫', '⭐', '🌟'];

    // Create 35 explosion particles around the dialog
    for (int i = 0; i < 35; i++) {
      explosionParticles.add(
        ExplosionParticle(
          emoji: emojis[random.nextInt(emojis.length)],
          angle: (i / 35) * 2 * pi,
          // Increase the base distance so particles surround the dialog
          distance: 200 + random.nextDouble() * 250,
          duration: 2000 + random.nextInt(1000),
          startDelay: random.nextInt(400),
        ),
      );
    }
  }

  Future<void> _initializeAudio() async {
    try {
      debugPrint('Starting audio initialization...');

      // Set audio context for best playback
      await _audioPlayer.setAudioSource(
        AudioSource.asset('assets/sounds/birthday.mp3'),
      );

      debugPrint('Audio source set successfully');

      // Play immediately
      await _audioPlayer.play();
      debugPrint('Birthday sound is now playing');
    } on Exception catch (e) {
      debugPrint('Audio Error (non-critical): $e');
      // Try alternative: Play from file path directly
      _tryAlternativeAudioLoad();
    }
  }

  Future<void> _tryAlternativeAudioLoad() async {
    try {
      debugPrint('Attempting alternative audio loading method...');
      // This is a fallback - still uses asset but with different approach
      await _audioPlayer.setAsset('assets/sounds/birthday.mp3');
      await _audioPlayer.play();
      debugPrint('Alternative audio method successful');
    } catch (e) {
      debugPrint('Alternative audio loading also failed: $e');
      debugPrint(
        'App will continue without sound - make sure birthday.mp3 exists in assets/sounds/',
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _loopController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        // Allow particles to draw outside the dialog bounds
        clipBehavior: Clip.none,
        children: [
          // Explosion particles in the background
          ...explosionParticles
              .map((particle) => _buildExplosionParticle(particle))
              .toList(),

          // Main dialog content
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: EdgeInsets.all(28.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, const Color(0xFFFFB6C1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(254, 214, 208, 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Birthday Cake - replaced with continuous shake driven by _loopController
                    AnimatedBuilder(
                      animation: _loopController,
                      builder: (context, child) {
                        // Oscillating rotation and horizontal shake
                        final shakeAngle =
                            sin(_loopController.value * 2 * pi * 3) *
                            0.06; // radians
                        final shakeOffset =
                            sin((_loopController.value * 2 * pi * 4)) *
                            6.0; // pixels
                        final scale =
                            0.98 +
                            sin(_loopController.value * 2 * pi * 2) * 0.02;

                        return Transform.translate(
                          offset: Offset(shakeOffset, 0),
                          child: Transform.rotate(
                            angle: shakeAngle,
                            child: Transform.scale(scale: scale, child: child),
                          ),
                        );
                      },
                      child: Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('🎂', style: TextStyle(fontSize: 60.sp)),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Title
                    Text(
                      'Happy Birthday SALMA',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.myWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8.h),

                    // Subtitle
                    Text(
                      'Years have passed, but the celebration never ends!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 18.h),

                    // Message Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Wishing you a day filled with love, joy, and unforgettable moments.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.myWhite,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Button
                    _buildButton(
                      text: '❤🎉',
                      onPressed: () => Navigator.pop(context),
                      isPrimary: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplosionParticle(ExplosionParticle particle) {
    // Use Positioned.fill so particles are positioned relative to dialog center
    return Positioned.fill(
      // Ignore pointer events so particles don't block taps
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _loopController,
          builder: (context, child) {
            // Cycle length used to compute per-particle progress
            const cycleMs = 3000.0;
            final elapsedMs = _loopController.value * cycleMs;

            // Apply start delay and per-particle duration
            final adjustedValue =
                (elapsedMs - particle.startDelay) / particle.duration;
            final clampedValue = adjustedValue.clamp(0.0, 1.0);

            // Calculate position based on angle and distance, with easing
            final easeValue = Curves.easeOut.transform(clampedValue);
            final distance = particle.distance * easeValue;
            final dx = distance * cos(particle.angle);
            final dy = distance * sin(particle.angle);

            // Scale and fade out
            final scale = 1.0 - (clampedValue * 0.75);
            final opacity = 1.0 - (clampedValue * clampedValue);

            return Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(opacity: opacity, child: child),
                ),
              ),
            );
          },
          child: Text(particle.emoji, style: TextStyle(fontSize: 32.sp)),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.myWhite
                : const Color.fromRGBO(255, 255, 255, 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isPrimary ? AppColors.primaryColor : AppColors.myWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExplosionParticle {
  final String emoji;
  final double angle;
  final double distance;
  final int duration;
  final int startDelay;

  ExplosionParticle({
    required this.emoji,
    required this.angle,
    required this.distance,
    required this.duration,
    required this.startDelay,
  });
}
