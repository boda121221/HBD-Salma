import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hbd_salma/core/theme/colors.dart';

import 'music_controller.dart';
import 'player_bottom_sheet.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicController>(
      builder: (context, controller, child) {
        // Only show when player is visible and sheet is not open
        if (!controller.isPlayerVisible || controller.isSheetOpen)
          return const SizedBox.shrink();

        final song = controller.currentSong;

        return GestureDetector(
          onTap: () async {
            // Open full player sheet and mark sheet open
            controller.markSheetOpen();

            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (sheetContext) {
                return ChangeNotifierProvider.value(
                  value: controller,
                  child: PlayerBottomSheet(),
                );
              },
            );

            // When dismissed
            controller.markSheetClosed();
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                // Small album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    song.imageUrl,
                    width: 44.w,
                    height: 44.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 44.w,
                        height: 44.w,
                        color: MyColors.primaryColor.withAlpha(
                          (0.1 * 255).round(),
                        ),
                        child: Icon(Icons.music_note, size: 20.sp),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),

                // Title and slider
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   song.title,
                      //   style: TextStyle(
                      //     fontSize: 14.sp,
                      //     fontWeight: FontWeight.w700,
                      //     color: MyColors.myBlack,
                      //   ),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),

                      // Slider + time row
                      StreamBuilder<Duration>(
                        stream: controller.positionStream,
                        builder: (context, positionSnapshot) {
                          final position =
                              positionSnapshot.data ?? Duration.zero;

                          return StreamBuilder<Duration?>(
                            stream: controller.durationStream,
                            builder: (context, durationSnapshot) {
                              final duration =
                                  durationSnapshot.data ?? song.duration;
                              final maxSeconds = (duration.inSeconds > 0)
                                  ? duration.inSeconds.toDouble()
                                  : 1.0;
                              final value = position.inSeconds
                                  .clamp(0, duration.inSeconds)
                                  .toDouble();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 2.h,
                                      thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 6.r,
                                      ),
                                    ),
                                    child: Slider(
                                      value: value,
                                      max: maxSeconds,
                                      min: 0,
                                      activeColor: MyColors.primaryColor,
                                      inactiveColor: Colors.grey[300],
                                      onChanged: (v) {
                                        controller.seek(
                                          Duration(seconds: v.toInt()),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Play/Pause
                StreamBuilder<bool>(
                  stream: controller.playingStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      onPressed: () {
                        controller.togglePlayPause();
                      },
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: MyColors.primaryColor,
                        size: 28.sp,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
