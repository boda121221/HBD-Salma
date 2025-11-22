import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors.dart';

class GameStatsBar extends StatelessWidget {
  final String time;
  final int moves;
  final int matches;
  final int totalPairs;

  const GameStatsBar({
    Key? key,
    required this.time,
    required this.moves,
    required this.matches,
    required this.totalPairs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryColorBold.withOpacity(0.76),
            MyColors.primaryColorBold.withOpacity(0.76),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('⏱️', time),
          _buildStatItem('🎯', 'Moves: $moves'),
          _buildStatItem('✨', '$matches/$totalPairs'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: 20.sp)),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.myWhite,
          ),
        ),
      ],
    );
  }
}
