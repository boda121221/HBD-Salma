import 'dart:async';
import 'package:flutter/material.dart';
import 'memory_card_model.dart';

class MemoryMatchController extends ChangeNotifier {
  List<MemoryCardModel> _cards = [];
  List<int> _selectedIndices = [];
  int _moves = 0;
  int _matches = 0;
  bool _isChecking = false;
  bool _isGameComplete = false;

  late Stopwatch _stopwatch;
  Timer? _timer;
  String _elapsedTime = '00:00';

  // Getters
  List<MemoryCardModel> get cards => _cards;
  int get moves => _moves;
  int get matches => _matches;
  String get elapsedTime => _elapsedTime;
  bool get isGameComplete => _isGameComplete;
  int get totalPairs => _cards.length ~/ 2;

  MemoryMatchController() {
    initGame();
  }

  void initGame({int pairs = 8}) {
    _cards = MemoryCardModel.generateDeck(pairs: pairs);
    _selectedIndices.clear();
    _moves = 0;
    _matches = 0;
    _isChecking = false;
    _isGameComplete = false;

    _stopwatch = Stopwatch()..start();
    _startTimer();

    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final seconds = _stopwatch.elapsed.inSeconds;
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      _elapsedTime =
          '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
      notifyListeners();
    });
  }

  void onCardTap(int index) {
    // Prevent tapping if checking, already flipped, matched, or 2 cards selected
    if (_isChecking ||
        _cards[index].isFlipped ||
        _cards[index].isMatched ||
        _selectedIndices.length >= 2) {
      return;
    }

    // Flip the card
    _cards[index].isFlipped = true;
    _selectedIndices.add(index);
    notifyListeners();

    // Check if two cards are selected
    if (_selectedIndices.length == 2) {
      _moves++;
      _isChecking = true;
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    final index1 = _selectedIndices[0];
    final index2 = _selectedIndices[1];
    final card1 = _cards[index1];
    final card2 = _cards[index2];

    if (card1.emoji == card2.emoji) {
      // Match found!
      Future.delayed(const Duration(milliseconds: 400), () {
        _cards[index1].isMatched = true;
        _cards[index2].isMatched = true;
        _matches++;
        _selectedIndices.clear();
        _isChecking = false;
        notifyListeners();

        // Check if game is complete
        if (_matches == totalPairs) {
          _completeGame();
        }
      });
    } else {
      // No match - flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        _cards[index1].isFlipped = false;
        _cards[index2].isFlipped = false;
        _selectedIndices.clear();
        _isChecking = false;
        notifyListeners();
      });
    }
  }

  void _completeGame() {
    _stopwatch.stop();
    _timer?.cancel();
    _isGameComplete = true;
    notifyListeners();
  }

  void resetGame() {
    _timer?.cancel();
    initGame(pairs: totalPairs);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
