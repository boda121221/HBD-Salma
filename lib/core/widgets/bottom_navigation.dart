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
    final double size = selected ? 28 : 25;
    if (selected) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // subtle top indicator
          Container(
            width: 26,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.navIndicatorOverlay,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          // circular background for the icon
          Container(
            padding: const EdgeInsets.all(8),
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

    // unselected
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(0),
              child: _navIcon(Icons.timer, currentIndex == 0),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(1),
              child: _navIcon(Icons.calendar_today, currentIndex == 1),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(2),
              child: _navIcon(Icons.videogame_asset, currentIndex == 2),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(3),
              child: _navIcon(Icons.music_note, currentIndex == 3),
            ),
          ],
        ),
      ),
    );
  }
}
