import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors.dart';
import 'memory_card_model.dart';

class MemoryCardWidget extends StatefulWidget {
  final MemoryCardModel card;
  final VoidCallback onTap;

  const MemoryCardWidget({Key? key, required this.card, required this.onTap})
    : super(key: key);

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool _wasFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _wasFlipped = widget.card.isFlipped;
  }

  @override
  void didUpdateWidget(MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the flip state has changed
    if (widget.card.isFlipped && !_wasFlipped) {
      // Card was flipped
      _controller.forward();
      _wasFlipped = true;
    } else if (!widget.card.isFlipped && _wasFlipped) {
      // Card was unflipped (no match)
      _controller.reverse();
      _wasFlipped = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * 3.14159;
          final isFlipped = _flipAnimation.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: AnimatedScale(
              scale: widget.card.isMatched ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFlipped
                        ? [AppColors.primaryColor, const Color(0xFFFFB6C1)]
                        : [const Color(0xFFFFE4E1), AppColors.primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: widget.card.isMatched
                          ? AppColors.primaryColor.withOpacity(0.5)
                          : AppColors.primaryColor.withOpacity(0.2),
                      blurRadius: widget.card.isMatched ? 20 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: widget.card.isMatched
                      ? Border.all(color: const Color(0xFFFFD700), width: 3)
                      : null,
                ),
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(isFlipped ? 3.14159 : 0),
                    child: Text(
                      isFlipped ? widget.card.emoji : '❓',
                      style: TextStyle(fontSize: isFlipped ? 40.sp : 36.sp),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
