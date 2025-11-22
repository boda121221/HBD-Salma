import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors.dart';

class GameOverSheet extends StatefulWidget {
  final int score;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;

  const GameOverSheet({
    Key? key,
    required this.score,
    required this.onPlayAgain,
    required this.onClose,
  }) : super(key: key);

  @override
  State<GameOverSheet> createState() => _GameOverSheetState();
}

class _GameOverSheetState extends State<GameOverSheet>
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

  String _getPerformanceMessage() {
    if (widget.score >= 50) return 'Amazing! 🌟';
    if (widget.score >= 30) return 'Great Job! 🎉';
    if (widget.score >= 15) return 'Good Work! 👏';
    return 'Keep Trying! 💪';
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
                // Animated Balloon Trophy
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.myWhite.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('🎈', style: TextStyle(fontSize: 60.sp)),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // Title
                Text(
                  'Time\'s Up!',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.myWhite,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                // Performance Message
                Text(
                  _getPerformanceMessage(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.myWhite.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Score Display
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.myWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Final Score',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.myWhite,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: widget.score),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, child) {
                          return Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 48.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.myWhite,
                            ),
                          );
                        },
                      ),
                      Text(
                        'points',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.myWhite.withOpacity(0.8),
                        ),
                      ),
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
