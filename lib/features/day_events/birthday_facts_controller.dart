import 'package:flutter/material.dart';
import 'birthday_fact_model.dart';

class BirthdayFactsController extends ChangeNotifier {
  final List<BirthdayFactModel> _facts = BirthdayFactModel.getSampleFacts();
  int _currentIndex = 0;
  final PageController pageController = PageController(viewportFraction: 0.85);

  List<BirthdayFactModel> get facts => _facts;
  int get currentIndex => _currentIndex;
  BirthdayFactModel get currentFact => _facts[_currentIndex];

  void updateIndex(int index) {
    _currentIndex = index % _facts.length;
    notifyListeners();
  }

  void goToNext() {
    final nextIndex = (_currentIndex + 1) % _facts.length;
    pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goToPrevious() {
    final previousIndex = (_currentIndex - 1 + _facts.length) % _facts.length;
    pageController.animateToPage(
      previousIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
