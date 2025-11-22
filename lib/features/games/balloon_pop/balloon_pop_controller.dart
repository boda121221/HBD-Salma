import 'dart:async';
import 'package:flutter/material.dart';
import 'balloon_model.dart';

class BalloonPopController extends ChangeNotifier {
  List<BalloonModel> _balloons = [];
  int _score = 0;
  int _timeLeft = 20;
  bool _isGameActive = false;
  bool _isGameComplete = false;
  bool _isGameReady = false;

  Timer? _gameTimer;
  Timer? _spawnTimer;
  Timer? _updateTimer;

  double _screenWidth = 0;
  double _screenHeight = 0;

  // Getters
  List<BalloonModel> get balloons => _balloons;
  int get score => _score;
  int get timeLeft => _timeLeft;
  bool get isGameActive => _isGameActive;
  bool get isGameComplete => _isGameComplete;
  bool get isGameReady => _isGameReady;

  void setScreenSize(double width, double height) {
    _screenWidth = width;
    _screenHeight = height;
  }

  void markGameReady() {
    _isGameReady = true;
    notifyListeners();
  }

  void startGame() {
    _balloons.clear();
    _score = 0;
    _timeLeft = 20;
    _isGameActive = true;
    _isGameComplete = false;
    _isGameReady = false;

    notifyListeners();

    // Countdown timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _endGame();
      }
    });

    // Spawn balloons
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (_isGameActive && _screenWidth > 0) {
        _spawnBalloon();
      }
    });

    // Update balloon positions (60 FPS)
    _updateTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_isGameActive) {
        _updateBalloons();
      }
    });
  }

  void _spawnBalloon() {
    final balloon = BalloonModel.createRandom(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      screenWidth: _screenWidth,
      screenHeight: _screenHeight,
    );

    _balloons.add(balloon);
    notifyListeners();
  }

  void _updateBalloons() {
    // Update positions
    for (var balloon in _balloons) {
      balloon.update(0.016); // 16ms = 60 FPS
    }

    // Remove balloons that went off screen or are popped
    _balloons.removeWhere(
      (balloon) =>
          balloon.y < -150 ||
          (balloon.isPopped &&
              DateTime.now().millisecondsSinceEpoch % 1000 > 200),
    );

    notifyListeners();
  }

  void popBalloon(BalloonModel balloon) {
    if (balloon.isPopped) return;

    balloon.isPopped = true;
    _score += balloon.points;
    notifyListeners();

    // Remove popped balloon after animation
    Future.delayed(const Duration(milliseconds: 300), () {
      _balloons.remove(balloon);
      notifyListeners();
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _updateTimer?.cancel();
    _isGameActive = false;
    _isGameComplete = true;
    notifyListeners();
  }

  void resetGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _updateTimer?.cancel();
    startGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }
}
