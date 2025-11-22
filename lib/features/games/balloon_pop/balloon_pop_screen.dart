import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import 'balloon_pop_controller.dart';
import 'balloon_widget.dart';
import 'game_over_sheet.dart';

class BalloonPopScreen extends StatefulWidget {
  const BalloonPopScreen({Key? key}) : super(key: key);

  @override
  State<BalloonPopScreen> createState() => _BalloonPopScreenState();
}

class _BalloonPopScreenState extends State<BalloonPopScreen> {
  // Create controller here so we can use it in lifecycle methods before the
  // provider is inserted into the widget tree.
  late final BalloonPopController _controller;
  bool _isShowingGameOverSheet = false;

  @override
  void initState() {
    super.initState();
    _controller = BalloonPopController();
    // Listen to controller changes so we can show the game over sheet once
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (!_isShowingGameOverSheet && _controller.isGameComplete && mounted) {
      _isShowingGameOverSheet = true;
      // Use addPostFrameCallback to ensure UI is stable when showing the dialog
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GameOverSheet(
            score: _controller.score,
            onPlayAgain: () {
              Navigator.pop(context);
              _controller.resetGame();
            },
            onClose: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
        // Dialog closed - allow future dialogs to appear
        _isShowingGameOverSheet = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    // Use the controller instance directly instead of context.read which would
    // fail if the provider isn't inserted yet.
    _controller.setScreenSize(size.width, size.height);

    // Mark game as ready (waiting for user to tap)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.isGameActive &&
          !_controller.isGameComplete &&
          !_controller.isGameReady) {
        _controller.markGameReady();
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the controller that this state owns. Use ChangeNotifierProvider.value
    // to avoid re-creating the controller during rebuilds.
    return ChangeNotifierProvider.value(
      value: _controller,
      child: const _BalloonPopScreenContent(),
    );
  }
}

class _BalloonPopScreenContent extends StatelessWidget {
  const _BalloonPopScreenContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BalloonPopController>();

    // The game-over sheet is shown from the controller listener in the parent
    // state to avoid repeated show calls during build which could cause flicker.

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE3F2FD),
              const Color(0xFFBBDEFB),
              AppColors.primaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Balloons
              ...controller.balloons.map((balloon) {
                return BalloonWidget(
                  key: ValueKey(balloon.id),
                  balloon: balloon,
                  onPop: () => controller.popBalloon(balloon),
                );
              }).toList(),

              // Top Stats Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.85),
                        AppColors.primaryColor.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Timer
                      Row(
                        children: [
                          Text('⏱️', style: TextStyle(fontSize: 24.sp)),
                          SizedBox(width: 8.w),
                          Text(
                            '${controller.timeLeft}s',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: controller.timeLeft <= 5
                                  ? Colors.red
                                  : AppColors.myWhite,
                            ),
                          ),
                        ],
                      ),

                      // Score
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.myWhite.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Text('🎯', style: TextStyle(fontSize: 20.sp)),
                            SizedBox(width: 6.w),
                            Text(
                              '${controller.score}',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.myWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Instructions - Show before game starts
              if (!controller.isGameActive &&
                  controller.isGameReady &&
                  !controller.isGameComplete)
                GestureDetector(
                  onTap: () => controller.startGame(),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🎈', style: TextStyle(fontSize: 80.sp)),
                        SizedBox(height: 16.h),
                        Text(
                          'Tap balloons to pop them!',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.myBlack,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Golden balloons = 10 points! ⭐',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.myBlack.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(.95),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'START',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.myWhite,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
