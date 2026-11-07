// ---------------------------------------------------------------------------
// our_story_screen.dart
// The "Our Story" screen – replaces the old BirthdayFactsScreen.
//
// ARCHITECTURE:
//  - Data comes from lib/features/our_story/story_data.dart (storyEntries).
//  - Each card is rendered by StoryCardWidget which handles its own flip anim.
//  - The floating hearts background lives behind the card in a Stack.
//  - Navigation between cards uses an animated PageView-free approach:
//    we keep a currentIndex and rebuild with AnimatedSwitcher so the card
//    slides in/out instead of the whole screen rebuilding.
//  - Prev/Next buttons are disabled at the boundaries:
//      • Previous is disabled on card index 0.
//      • Next on the last card (Dreams card) is disabled – the Dreams card
//        navigates to OurDreamsScreen instead.
//
// FONT NOTE:
//  Arabic text in StoryCardWidget uses 'Tajawal'. See story_card_widget.dart
//  for instructions on adding the font asset.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';

import 'story_data.dart';
import 'story_card_widget.dart';
import 'floating_hearts_background.dart';
import 'our_dreams_screen.dart';

class OurStoryScreen extends StatefulWidget {
  const OurStoryScreen({Key? key}) : super(key: key);

  @override
  State<OurStoryScreen> createState() => _OurStoryScreenState();
}

class _OurStoryScreenState extends State<OurStoryScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // Used to determine slide direction for AnimatedSwitcher
  bool _goingForward = true;

  // Prevent double-tapping nav buttons during transition
  bool _isTransitioning = false;

  /// Navigate to [newIndex]. [forward] controls slide direction.
  void _navigateTo(int newIndex, {required bool forward}) {
    if (_isTransitioning) return;
    if (newIndex < 0 || newIndex >= storyEntries.length) return;

    setState(() {
      _isTransitioning = true;
      _goingForward = forward;
      _currentIndex = newIndex;
    });

    // Unlock after a short delay to prevent rapid taps
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _isTransitioning = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final entry = storyEntries[_currentIndex];
    final bool isFirst = _currentIndex == 0;
    final bool isLast = _currentIndex == storyEntries.length - 1;

    return Scaffold(
      backgroundColor: MyColors.storyBackground,
      body: Stack(
        children: [
          // ── Floating hearts (behind everything) ──────────────────────
          const FloatingHeartsBackground(),

          // ── Main content ─────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Card area – takes all available space
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        final offset = _goingForward
                            ? const Offset(1.0, 0.0)
                            : const Offset(-1.0, 0.0);
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: offset,
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                              parent: animation, curve: Curves.easeOutCubic)),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        // Key changes when index changes so AnimatedSwitcher
                        // treats it as a new widget and runs the transition.
                        key: ValueKey(_currentIndex),
                        child: StoryCardWidget(
                          entry: entry,
                          onDreamsCardTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OurDreamsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Compact navigation row
                _buildNavRow(isFirst: isFirst, isLast: isLast),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 2.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Our Story',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lymbo',
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColorBold,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Tap a card to read our memory ❤',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: MyColors.myBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Navigation row ──────────────────────────────────────────────────────
  Widget _buildNavRow({required bool isFirst, required bool isLast}) {
    final storyCount = storyEntries.where((e) => !e.isDreamsCard).length;
    final isDreams = storyEntries[_currentIndex].isDreamsCard;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          Semantics(
            label: 'Previous memory',
            child: _NavButton(
              icon: Icons.arrow_back_ios_rounded,
              onTap: isFirst
                  ? null // disabled on first card
                  : () => _navigateTo(_currentIndex - 1, forward: false),
              enabled: !isFirst,
            ),
          ),

          // Card counter text (compact phone size)
          Text(
            isDreams
                ? '✨ Our Dreams'
                : 'Memory ${_currentIndex + 1} / $storyCount',
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: MyColors.primaryColorBold,
              letterSpacing: 0.3,
            ),
          ),

          // Next button – disabled on the Dreams card (last card)
          Semantics(
            label: 'Next memory',
            child: _NavButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: isLast
                  ? null // no card after Dreams card
                  : () => _navigateTo(_currentIndex + 1, forward: true),
              enabled: !isLast,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Circular navigation button ────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _NavButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.3,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: enabled
                  ? MyColors.primaryColor.withOpacity(0.25)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: enabled
                    ? MyColors.primaryColorBold.withOpacity(0.4)
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 13.sp,
                color: enabled ? MyColors.primaryColorBold : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
