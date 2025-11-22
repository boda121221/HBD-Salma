import 'dart:math';
import 'package:flutter/material.dart';

class BalloonModel {
  final String id;
  double x;
  double y;
  final double speed;
  final BalloonColor balloonColor;
  final bool isGolden;
  bool isPopped;
  double horizontalOffset;
  final double horizontalSpeed;

  BalloonModel({
    required this.id,
    required this.x,
    required this.y,
    required this.speed,
    required this.balloonColor,
    this.isGolden = false,
    this.isPopped = false,
    this.horizontalOffset = 0,
    required this.horizontalSpeed,
  });

  // Update balloon position with floating motion
  void update(double deltaTime) {
    if (!isPopped) {
      y -= speed * deltaTime;
      horizontalOffset += horizontalSpeed * deltaTime;
    }
  }

  int get points => isGolden ? 10 : 1;

  Color get color {
    switch (balloonColor) {
      case BalloonColor.red:
        return const Color(0xFFFF6B6B);
      case BalloonColor.pink:
        return const Color(0xFFFF69B4);
      case BalloonColor.purple:
        return const Color(0xFFBA68C8);
      case BalloonColor.blue:
        return const Color(0xFF4FC3F7);
      case BalloonColor.green:
        return const Color(0xFF81C784);
    }
  }

  // Factory method to create random balloon
  static BalloonModel createRandom({
    required String id,
    required double screenWidth,
    required double screenHeight,
  }) {
    final random = Random();
    final isGolden = random.nextInt(10) == 0; // 10% chance for golden

    return BalloonModel(
      id: id,
      x: random.nextDouble() * (screenWidth - 80),
      y: screenHeight + 20,
      speed:
          240 +
          random.nextDouble() * 80, // 140-220 pixels per second (increased)
      balloonColor:
          BalloonColor.values[random.nextInt(BalloonColor.values.length)],
      isGolden: isGolden,
      horizontalSpeed: (random.nextDouble() - 0.5) * 30, // -15 to +15
    );
  }
}

enum BalloonColor { red, pink, purple, blue, green }
