// ---------------------------------------------------------------------------
// our_dreams_screen.dart
// Dedicated screen accessible ONLY from the final Our Story card.
// It is pushed onto the navigation stack (not a bottom-nav destination).
//
// NAVIGATION:
//  - Reached via Navigator.push from the Dreams card in our_story_screen.dart
//  - Back button / Android back gesture returns to Our Story.
//  - The music MiniPlayer is intentionally NOT shown here because this screen
//    is pushed full-screen over the shell (which already hosts the MiniPlayer
//    in the bottom nav). Including it here would create a duplicate.
//
// COLOUR LOGIC:
//  - DreamOwner.her  → pink card (MyColors.primaryColor palette)
//  - DreamOwner.mine → pastel blue card (MyColors.myPastelBlue palette)
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';

import 'dream_model.dart';
import 'dream_data.dart';
import 'floating_hearts_background.dart';

class OurDreamsScreen extends StatelessWidget {
  const OurDreamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.storyBackground,
      body: Stack(
        children: [
          // Floating hearts – same background used in Our Story
          const FloatingHeartsBackground(heartCount: 10),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                    itemCount: dreamEntries.length,
                    itemBuilder: (context, index) {
                      return _DreamCard(
                        entry: dreamEntries[index],
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Title & Subtitle
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Our Future Dreams',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lymbo',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryColorBold,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Things we said we\'ll do together ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: MyColors.myBlack,
                  ),
                ),
              ],
            ),
          ),

          // Back button on the left
          Positioned(
            left: 0,
            child: Semantics(
              label: 'Go back to Our Story',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18.sp,
                      color: MyColors.primaryColorBold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single dream card ─────────────────────────────────────────────────────
class _DreamCard extends StatefulWidget {
  final DreamEntry entry;
  final int index;

  const _DreamCard({required this.entry, required this.index});

  @override
  State<_DreamCard> createState() => _DreamCardState();
}

class _DreamCardState extends State<_DreamCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Staggered entrance: each card slides in slightly later than the previous
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fadeAnim = CurvedAnimation(
        parent: _enterController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _enterController, curve: Curves.easeOut));

    // Delay based on list index for a staggered effect
    Future.delayed(
      Duration(milliseconds: 60 * widget.index),
      () {
        if (mounted) _enterController.forward();
      },
    );
  }

  @override
  void dispose() {
    _enterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHer = widget.entry.owner == DreamOwner.her;

    // Colour values depend on ownership
    final Color cardBg = isHer
        ? MyColors.primaryColor.withOpacity(0.15)
        : MyColors.myPastelBlue.withOpacity(0.22);
    final Color borderColor = isHer
        ? MyColors.primaryColorBold.withOpacity(0.35)
        : MyColors.myPastelBlueBold.withOpacity(0.45);
    final Color labelBg = isHer
        ? MyColors.primaryColorBold.withOpacity(0.85)
        : MyColors.myPastelBlueBold.withOpacity(0.85);
    final Color textColor = isHer
        ? MyColors.primaryColorBold
        : MyColors.myPastelBlueBold;

    final String ownerLabel = isHer ? 'Salma' : 'Boda';

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: EdgeInsets.only(bottom: 14.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Emoji icon (centered vertically)
                if (widget.entry.emoji != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: Text(
                      widget.entry.emoji!,
                      style: TextStyle(fontSize: 26.sp),
                    ),
                  ),

                // Dream text + owner label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Owner label chip
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: labelBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          ownerLabel,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Dream description
                      Text(
                        widget.entry.dream,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textColor,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
