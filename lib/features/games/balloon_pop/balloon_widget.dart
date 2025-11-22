import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'balloon_model.dart';

class BalloonWidget extends StatefulWidget {
  final BalloonModel balloon;
  final VoidCallback onPop;

  const BalloonWidget({Key? key, required this.balloon, required this.onPop})
    : super(key: key);

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _popScale;
  late Animation<double> _popOpacity;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _popScale = Tween<double>(
      begin: 1.0,
      end: 1.8,
    ).animate(CurvedAnimation(parent: _popController, curve: Curves.easeOut));

    _popOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _popController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(BalloonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.balloon.isPopped && !oldWidget.balloon.isPopped) {
      _popController.forward();
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.balloon.x + (widget.balloon.horizontalOffset * 0.5),
      top: widget.balloon.y,
      child: GestureDetector(
        onTap: widget.onPop,
        child: AnimatedBuilder(
          animation: _popController,
          builder: (context, child) {
            return Transform.scale(
              scale: _popScale.value,
              child: Opacity(
                opacity: _popOpacity.value,
                child: widget.balloon.isPopped
                    ? _buildPopEffect()
                    : _buildBalloon(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalloon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(scale: 0.95 + (0.05 * value), child: child);
      },
      child: SizedBox(
        width: 70.w,
        height: 95.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Balloon body
            Container(
              width: 70.w,
              height: 85.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.4),
                  radius: 0.8,
                  colors: widget.balloon.isGolden
                      ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                      : [
                          widget.balloon.color.withOpacity(0.9),
                          widget.balloon.color,
                        ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(35.r),
                  bottom: Radius.circular(35.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.balloon.color.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.balloon.isGolden ? '⭐' : '🎈',
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
            ),

            // String
            Positioned(
              bottom: -10.h,
              left: 35.w,
              child: Container(
                width: 1.5,
                height: 15.h,
                color: Colors.white.withOpacity(0.6),
              ),
            ),

            // Highlight effect
            Positioned(
              top: 15.h,
              left: 15.w,
              child: Container(
                width: 20.w,
                height: 25.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopEffect() {
    return SizedBox(
      width: 70.w,
      height: 95.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Star burst effect
          ...List.generate(8, (index) {
            final angle = (index * 45) * 3.14159 / 180;
            return Transform.rotate(
              angle: angle,
              child: Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: widget.balloon.color,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          }),
          // Pop text
          Text(
            'POP!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: widget.balloon.color,
            ),
          ),
        ],
      ),
    );
  }
}
