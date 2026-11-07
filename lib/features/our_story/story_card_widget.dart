// ---------------------------------------------------------------------------
// story_card_widget.dart
// A 3-D flip card that shows an image on the front and story details on the
// back. For the special Dreams card (entry.isDreamsCard == true) no flip
// happens; instead the whole card navigates to Our Dreams.
//
// ANIMATION NOTES:
//  - The flip uses AnimationController + Transform with a perspective matrix.
//  - The front face shows  0° → 90°  (half of the flip).
//  - The back face shows  90° → 180° with a Y-axis mirror so text is not reversed.
//  - Rapid double-taps are ignored while the animation is running.
//  - The controller is disposed in State.dispose().
//
// ARABIC TEXT:
//  - Wrapped in Directionality(textDirection: TextDirection.rtl) so RTL layout
//    is applied to the entire back-face column.
//  - Uses the 'Tajawal' font if available; falls back to system sans-serif.
//    See pubspec.yaml NOTE below.
//
// FONT NOTE:
//  The Lymbo font bundled in assets/fonts/ does NOT support Arabic glyphs.
//  To get a proper Arabic typeface, download Tajawal (Open Font License) from
//  Google Fonts and add it to your project:
//    1. Put the .ttf file in  assets/fonts/Tajawal-Regular.ttf
//    2. Add to pubspec.yaml under flutter → fonts:
//         - family: Tajawal
//           fonts:
//             - asset: assets/fonts/Tajawal-Regular.ttf
//             - asset: assets/fonts/Tajawal-Medium.ttf
//               weight: 500
//    3. Replace 'Tajawal' below with the exact family name you chose.
//  Until the font is added, Flutter renders Arabic using the platform's built-in
//  Arabic-capable font (which works correctly on Android).
// ---------------------------------------------------------------------------

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'dart:ui' show ImageFilter;

import 'story_model.dart';

class StoryCardWidget extends StatefulWidget {
  final StoryEntry entry;
  final VoidCallback? onDreamsCardTap;

  const StoryCardWidget({
    Key? key,
    required this.entry,
    this.onDreamsCardTap,
  }) : super(key: key);

  @override
  State<StoryCardWidget> createState() => _StoryCardWidgetState();
}

class _StoryCardWidgetState extends State<StoryCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Dreams card: navigate, do not flip
    if (widget.entry.isDreamsCard) {
      widget.onDreamsCardTap?.call();
      return;
    }

    // Ignore taps while flip is animating
    if (_flipController.isAnimating) return;

    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entry.isDreamsCard) {
      return _buildDreamsCard(context);
    }

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * pi;

          // Choose which face to show based on rotation angle
          final showFront = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(angle),
            child: showFront ? _buildFront(context) : _buildBack(context),
          );
        },
      ),
    );
  }

  // ── Front face (image) ─────────────────────────────────────────────────
  Widget _buildFront(BuildContext context) {
    return _CardShell(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: _StoryImage(imagePath: widget.entry.imagePath),
          ),

          // Subtle gradient overlay for depth
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.35),
                ],
              ),
            ),
          ),

          // "Tap to flip" hint at the bottom
          // Positioned(
          //   bottom: 20.h,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(Icons.touch_app_rounded,
          //           size: 16.sp, color: Colors.white70),
          //       SizedBox(width: 6.w),
          //       Text(
          //         'Tap to read',
          //         style: TextStyle(
          //           fontSize: 12.sp,
          //           color: Colors.white70,
          //           fontStyle: FontStyle.italic,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // ── Back face (story details in Arabic) ───────────────────────────────
  Widget _buildBack(BuildContext context) {
    // Mirror the back face around the Y axis so text is not reversed
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: _CardShell(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColors.primaryColor.withOpacity(0.9),
                const Color(0xFFFFE4E0),
                MyColors.primaryColorBold.withOpacity(0.4),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            // Wrap entire column in RTL directionality for Arabic text
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Heart icon accent
                  Icon(Icons.favorite_rounded,
                      color: Colors.white, size: 32.sp),
                  SizedBox(height: 16.h),

                  // Title (LTR – switch directionality locally)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      widget.entry.title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ),

                  // Date (LTR)
                  if (widget.entry.date != null) ...[
                    SizedBox(height: 6.h),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.entry.date!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 20.h),

                  // Arabic note
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.entry.arabicNote,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          // TODO: Change 'Tajawal' to your chosen Arabic font family once added.
                          // Falls back to the device system Arabic font if the family is missing.
                          fontFamily: 'Tajawal',
                          fontSize: 17.sp,
                          color: Colors.white,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Tap-to-flip-back hint
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app_rounded,
                            size: 14.sp, color: Colors.white60),
                        SizedBox(width: 4.w),
                        Text(
                          'Tap to go back',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white60,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Dreams card (special, non-flippable) ──────────────────────────────
  Widget _buildDreamsCard(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: _CardShell(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: _StoryImage(imagePath: widget.entry.imagePath),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    MyColors.primaryColor.withOpacity(0.2),
                    MyColors.primaryColorBold.withOpacity(0.80),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(28.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Title
                  Text(
                    'Our story continues…',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lymbo',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    'Ready to dream with me?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),

                  const Spacer(),

                  // Call-to-action button
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 28.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.6), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_rounded,
                            color: Colors.white, size: 20.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'Our Dreams  →',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared card shell (shadow + rounded corners) ─────────────────────────
class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryColorBold.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Image widget with graceful fallback ──────────────────────────────────
class _StoryImage extends StatelessWidget {
  final String imagePath;
  const _StoryImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) {
        // Fallback shown when the placeholder image hasn't been added yet
        return Container(
          color: MyColors.primaryColor.withOpacity(0.3),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_rounded,
                    size: 60, color: MyColors.primaryColorBold),
                const SizedBox(height: 8),
                const Text(
                  'Add photo here',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
