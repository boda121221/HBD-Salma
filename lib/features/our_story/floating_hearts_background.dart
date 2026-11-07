// ---------------------------------------------------------------------------
// floating_hearts_background.dart
// A lightweight canvas-based floating hearts background widget.
//
// Uses a single AnimationController looped forever. Each heart has its own
// randomised starting position, size, speed, and opacity so they feel natural.
//
// Important notes:
//  - All hearts are painted via CustomPaint, so there is ONE rebuild per frame
//    for the whole widget rather than N rebuilds for N hearts.
//  - The widget sits inside IgnorePointer so it never intercepts taps.
//  - The AnimationController is disposed in State.dispose().
// ---------------------------------------------------------------------------

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hbd_salma/core/theme/colors.dart';

// ── Data class for a single heart particle ─────────────────────────────────
class _Heart {
  double x;       // horizontal position (0..1 fraction of width)
  double y;       // vertical position   (0..1 fraction of height, grows upward)
  double speed;   // pixels-per-second the heart rises
  double size;    // radius in logical pixels
  double opacity; // 0..1
  double wobble;  // horizontal wobble amplitude (pixels)
  double phase;   // phase offset for wobble sine wave

  _Heart({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.wobble,
    required this.phase,
  });
}

// ── Widget ──────────────────────────────────────────────────────────────────
class FloatingHeartsBackground extends StatefulWidget {
  final int heartCount;

  const FloatingHeartsBackground({Key? key, this.heartCount = 14})
      : super(key: key);

  @override
  State<FloatingHeartsBackground> createState() =>
      _FloatingHeartsBackgroundState();
}

class _FloatingHeartsBackgroundState extends State<FloatingHeartsBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Heart> _hearts;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Build heart pool
    _hearts = List.generate(widget.heartCount, (_) => _randomHeart());

    // 60-ish FPS ticker that drives the CustomPainter repaint
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  /// Create a heart at a random initial position spread across the canvas.
  _Heart _randomHeart() {
    return _Heart(
      x:       _random.nextDouble(),
      y:       _random.nextDouble(),         // start anywhere vertically
      speed:   20 + _random.nextDouble() * 40, // 20–60 px/s
      size:    6  + _random.nextDouble() * 10, // 6–16 px
      opacity: 0.15 + _random.nextDouble() * 0.35, // 0.15–0.5
      wobble:  8  + _random.nextDouble() * 12,  // 8–20 px amplitude
      phase:   _random.nextDouble() * 2 * pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _HeartsPainter(
              hearts: _hearts,
              elapsed: DateTime.now().millisecondsSinceEpoch.toDouble(),
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

// ── Painter ─────────────────────────────────────────────────────────────────
class _HeartsPainter extends CustomPainter {
  final List<_Heart> hearts;
  final double elapsed; // ms timestamp – used to drive motion each paint

  // We track the last paint time so we can compute a delta-time for motion.
  static double _lastElapsed = 0;

  _HeartsPainter({required this.hearts, required this.elapsed});

  @override
  void paint(Canvas canvas, Size size) {
    final double dt = (_lastElapsed == 0)
        ? 0.016
        : ((elapsed - _lastElapsed) / 1000.0).clamp(0.005, 0.1);
    _lastElapsed = elapsed;

    for (final heart in hearts) {
      // Move heart upward
      heart.y -= (heart.speed * dt) / size.height;

      // Wrap around: when heart goes off the top respawn at the bottom
      if (heart.y < -0.05) {
        heart.y = 1.05;
        heart.x = Random().nextDouble();
      }

      // Horizontal wobble using sine
      final double xWobble =
          sin(heart.phase + heart.y * 10) * heart.wobble / size.width;
      final double px = (heart.x + xWobble) * size.width;
      final double py = heart.y * size.height;

      _drawHeart(canvas, Offset(px, py), heart.size,
          MyColors.primaryColor.withOpacity(heart.opacity));
    }
  }

  /// Draws a heart shape centred at [center] with the given [radius].
  void _drawHeart(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();

    // Heart path approximation using cubic beziers
    final double s = radius;
    path.moveTo(center.dx, center.dy + s * 0.6);
    path.cubicTo(
      center.dx - s * 2, center.dy - s * 0.5,
      center.dx - s * 2, center.dy + s * 0.2,
      center.dx, center.dy + s * 0.6,
    );
    path.cubicTo(
      center.dx + s * 2, center.dy + s * 0.2,
      center.dx + s * 2, center.dy - s * 0.5,
      center.dx, center.dy + s * 0.6,
    );
    // Simpler bezier heart: standard two-bezier approach
    final p = Path();
    final double x = center.dx;
    final double y = center.dy;
    p.moveTo(x, y + s * 0.25);
    p.cubicTo(x, y - s * 0.75, x - s * 1.5, y - s * 0.75, x - s * 1.5,
        y - s * 0.1);
    p.cubicTo(
        x - s * 1.5, y + s * 0.6, x, y + s * 1.2, x, y + s * 1.5);
    p.cubicTo(x, y + s * 1.2, x + s * 1.5, y + s * 0.6, x + s * 1.5,
        y - s * 0.1);
    p.cubicTo(
        x + s * 1.5, y - s * 0.75, x, y - s * 0.75, x, y + s * 0.25);

    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(_HeartsPainter old) => true; // always repaint on tick
}
