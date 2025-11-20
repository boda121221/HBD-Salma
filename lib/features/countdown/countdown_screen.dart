// Update countdown screen to include a stylish BottomNavigationBar
// and route-based navigation using AppRoutes. Backgrounds use MyColors.primaryColor
// and selected icons use MyColors.myBlue.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:hbd_salma/features/day_events/day_events_screen.dart';
import 'package:hbd_salma/features/games/games_screen.dart';
import 'package:hbd_salma/features/music/music_screen.dart';

import '../../core/widgets/bottom_navigation.dart';

class CountdownScreen extends StatefulWidget {
  final int initialIndex;
  const CountdownScreen({super.key, this.initialIndex = 0});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  // Centralized shell: keep a local index and swap the body only
  late int _selectedIndex;

  static final List<Widget> _pages = <Widget>[
    // Countdown content (inline simple content — replace with your real countdown widget if you have one)
    CountdownContent(),
    DayEventsScreen(),
    GamesScreen(),
    MusicScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        (widget.initialIndex >= 0 && widget.initialIndex < _pages.length)
        ? widget.initialIndex
        : 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Material(
        color: Colors.transparent,
        child: Container(
          color: MyColors.backgroundLight,
          child: SafeArea(child: _pages[_selectedIndex]),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CountdownContent extends StatelessWidget {
  const CountdownContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Responsive sizes using ScreenUtil (requires ScreenUtilInit in main.dart)
          Icon(Icons.timer, size: 100.spMax, color: MyColors.textPrimary),
          SizedBox(height: 12.h),
          Text(
            'Countdown',
            style: TextStyle(
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
              color: MyColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
