import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors.dart';

class VictoryDialog extends StatefulWidget {
  final String time;
  final int moves;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;

  const VictoryDialog({
    Key? key,
    required this.time,
    required this.moves,
    required this.onPlayAgain,
    required this.onClose,
  }) : super(key: key);

  @override
  State<VictoryDialog> createState() => _VictoryDialogState();
}

class _VictoryDialogState extends State<VictoryDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, const Color(0xFFFFB6C1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Trophy
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Transform.rotate(
                        angle: (1 - value) * 6.28, // 2π radians = full rotation
                        child: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            color: AppColors.myWhite.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '🏆',
                              style: TextStyle(fontSize: 60.sp),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // Title
                Text(
                  'Congratulations! 🎉',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.myWhite,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                // Subtitle
                Text(
                  'You found all the pairs!',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.myWhite.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Stats Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.myWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow('⏱️ Time', widget.time),
                      SizedBox(height: 12.h),
                      _buildStatRow('🎯 Moves', '${widget.moves}'),
                    ],
                  ),
                ),

                SizedBox(height: 28.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        text: 'Close',
                        onPressed: widget.onClose,
                        isPrimary: false,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildButton(
                        text: 'Play Again',
                        onPressed: widget.onPlayAgain,
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.myWhite,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.myWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.myWhite
                : AppColors.myWhite.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isPrimary ? AppColors.primaryColor : AppColors.myWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
