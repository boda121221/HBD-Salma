// ---------------------------------------------------------------------------
// bottom_navigation.dart
// App-wide bottom navigation bar.
//
// TAB INDICES (must match CountdownScreen._pages order):
//  0 → Countdown    (timer icon)
//  1 → Our Story    (auto_stories / book icon)
//  2 → Games        (videogame icon)
//  3 → Voice Notes  (mic icon)
//  4 → Music        (music note icon)
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:hbd_salma/core/theme/colors.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _navIcon(IconData icon, bool selected) {
    final double size = selected ? 27 : 24;
    if (selected) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtle top indicator bar
          Container(
            width: 24,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.navIndicatorOverlay,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 5),
          // Circular highlighted background
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: MyColors.navShadow,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: size, color: MyColors.navIconSelected),
          ),
        ],
      );
    }

    // Unselected state
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        Icon(icon, size: size, color: MyColors.navIconUnselected),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: MyColors.navContainerBg,
        boxShadow: [
          BoxShadow(
            color: MyColors.navShadow,
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 0 – Countdown
            Semantics(
              label: 'Countdown',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(0),
                child: _navIcon(Icons.timer, currentIndex == 0),
              ),
            ),

            // 1 – Our Story
            Semantics(
              label: 'Our Story',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(1),
                child: _navIcon(Icons.auto_stories_rounded, currentIndex == 1),
              ),
            ),

            // 2 – Games
            Semantics(
              label: 'Games',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(2),
                child: _navIcon(Icons.videogame_asset, currentIndex == 2),
              ),
            ),

            // 3 – Voice Notes (new)
            Semantics(
              label: 'Voice Notes',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(3),
                child: _navIcon(Icons.mic_rounded, currentIndex == 3),
              ),
            ),

            // 4 – Music
            Semantics(
              label: 'Music',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(4),
                child: _navIcon(Icons.music_note, currentIndex == 4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
