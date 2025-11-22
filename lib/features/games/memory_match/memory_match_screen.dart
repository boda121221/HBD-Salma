import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/features/games/memory_match/victory_dialog.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import 'game_stats_bar.dart';
import 'memory_card_widget.dart';
import 'memory_match_controller.dart';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({Key? key}) : super(key: key);

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  bool _isShowingVictoryDialog = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryMatchController(),
      child: _MemoryMatchScreenContent(onGameComplete: _showVictoryDialog),
    );
  }

  Future<void> _showVictoryDialog({
    required int time,
    required int moves,
    required VoidCallback onPlayAgain,
    required VoidCallback onClose,
  }) async {
    if (_isShowingVictoryDialog) return;
    _isShowingVictoryDialog = true;

    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryDialog(
        time: time.toString(),
        moves: moves,
        onPlayAgain: onPlayAgain,
        onClose: onClose,
      ),
    );
    _isShowingVictoryDialog = false;
  }
}

class _MemoryMatchScreenContent extends StatefulWidget {
  final Future<void> Function({
    required int time,
    required int moves,
    required VoidCallback onPlayAgain,
    required VoidCallback onClose,
  })
  onGameComplete;

  const _MemoryMatchScreenContent({required this.onGameComplete});

  @override
  State<_MemoryMatchScreenContent> createState() =>
      _MemoryMatchScreenContentState();
}

class _MemoryMatchScreenContentState extends State<_MemoryMatchScreenContent> {
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    _hasShownDialog = false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MemoryMatchController>();

    // Show victory dialog when game completes
    if (controller.isGameComplete && !_hasShownDialog) {
      _hasShownDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await widget.onGameComplete(
          time: controller.elapsedTime.length,
          moves: controller.moves,
          onPlayAgain: () {
            Navigator.pop(context);
            setState(() => _hasShownDialog = false);
            controller.resetGame();
          },
          onClose: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      });
    }

    return Scaffold(
      backgroundColor: MyColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColorBold.withOpacity(0.85),
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Text(
          'Memory Match',
          style: TextStyle(
            color: AppColors.myWhite,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: AppColors.myWhite,
              size: 24.sp,
            ),
            onPressed: () {
              setState(() => _hasShownDialog = false);
              controller.resetGame();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          GameStatsBar(
            time: controller.elapsedTime,
            moves: controller.moves,
            matches: controller.matches,
            totalPairs: controller.totalPairs,
          ),

          SizedBox(height: 20.h),

          // Instructions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Find all matching pairs! 💝',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Game Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.cards.length,
                itemBuilder: (context, index) {
                  return MemoryCardWidget(
                    card: controller.cards[index],
                    onTap: () => controller.onCardTap(index),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
