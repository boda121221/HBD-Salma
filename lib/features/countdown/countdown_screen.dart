// ---------------------------------------------------------------------------
// countdown_screen.dart
// Main app shell that hosts all bottom-navigation pages.
//
// PAGE ORDER (must match BottomNavigationWidget indices):
//  0 → CountdownContent  – Birthday countdown
//  1 → OurStoryScreen    – Our Story (replaces BirthdayFactsScreen)
//  2 → GamesScreen       – Mini-games hub
//  3 → VoiceNotesScreen  – Six voice-note categories (NEW)
//  4 → MusicScreen       – Curated song playlist
// ---------------------------------------------------------------------------

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:hbd_salma/features/games/games_screen.dart';
import 'package:hbd_salma/features/music/music_screen.dart';
import 'package:hbd_salma/features/music/mini_player.dart';
import 'package:hbd_salma/features/our_story/our_story_screen.dart';
import 'package:hbd_salma/features/voice_notes/voice_notes_screen.dart';

import '../../core/widgets/bottom_navigation.dart';
import 'birthday_dialog.dart';

class CountdownScreen extends StatefulWidget {
  final int initialIndex;
  const CountdownScreen({super.key, this.initialIndex = 0});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  // Centralised shell: swap body only; keep nav and MiniPlayer persistent.
  late int _selectedIndex;

  // Pages must be in the same order as the bottom navigation tab indices.
  // Use const constructors where possible to avoid unnecessary rebuilds.
  static final List<Widget> _pages = <Widget>[
    CountdownContent(),   // index 0 – Countdown
    OurStoryScreen(),     // index 1 – Our Story
    GamesScreen(),        // index 2 – Games
    VoiceNotesScreen(),   // index 3 – Voice Notes
    MusicScreen(),        // index 4 – Music
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mini player sits above the bottom navigation when music is active
            const MiniPlayer(),

            // The actual bottom navigation bar (now 5 destinations)
            BottomNavigationWidget(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Countdown content widget ──────────────────────────────────────────────
// (Unchanged from original except formatting)
class CountdownContent extends StatefulWidget {
  const CountdownContent({super.key});

  @override
  State<CountdownContent> createState() => _CountdownContentState();
}

class _CountdownContentState extends State<CountdownContent> {
  // Fixed target date: November 25th of the current (or next) year
  late DateTime targetDate;
  final ValueNotifier<Duration> durationNotifier = ValueNotifier<Duration>(
    Duration.zero,
  );
  Timer? timer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    targetDate = DateTime(now.year, 11, 24, 23, 59, 59);

    // If the date has already passed this year, aim for next year
    if (now.isAfter(targetDate)) {
      targetDate = DateTime(now.year + 1, 11, 24, 23, 59, 59);
    }

    durationNotifier.value = targetDate.difference(now);
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTime());
  }

  void updateTime() {
    final now = DateTime.now();
    final remaining = targetDate.difference(now);

    if (remaining.isNegative) {
      timer?.cancel();
      showEndMessage();
    } else {
      durationNotifier.value = remaining;
    }
  }

  void showEndMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const BirthdayDialog();
      },
    );
  }

  Widget buildTime(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeRow(days.toString().padLeft(2, '0'), 'Days'),
        SizedBox(height: 4.h),
        buildTimeRow(hours.toString().padLeft(2, '0'), 'Hours'),
        SizedBox(height: 4.h),
        buildTimeRow(minutes.toString().padLeft(2, '0'), 'Minutes'),
        SizedBox(height: 4.h),
        buildTimeRow(seconds.toString().padLeft(2, '0'), 'Seconds'),
        SizedBox(height: 10.h),
        Text(
          'Before ${getYearsSinceBirth()} Years\nThe World Was Darker',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Lymbo',
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: MyColors.textSecondary,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget buildTimeRow(String time, String label) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [for (int i = 0; i < time.length; i++) buildDigit(time[i])],
        ),
        SizedBox(height: 1.h),
        buildLabel(label),
      ],
    );
  }

  Widget buildDigit(String digit) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        key: ValueKey<String>(digit),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: MyColors.textPrimary.withAlpha((0.2 * 255).round()),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: MyColors.textSecondary.withAlpha((0.1 * 255).round()),
            width: 1,
          ),
        ),
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 54.sp,
            fontWeight: FontWeight.bold,
            color: MyColors.textSecondary,
            height: 1.07,
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: MyColors.textPrimary,
        fontSize: 11.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    );
  }

  int getYearsSinceBirth() {
    final now = DateTime.now();
    return now.year - 2009;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.cake, size: 140.sp, color: MyColors.textPrimary),
              Text(
                'November 25th',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: MyColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              ValueListenableBuilder<Duration>(
                valueListenable: durationNotifier,
                builder: (context, duration, child) {
                  return buildTime(duration);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
