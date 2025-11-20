import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:provider/provider.dart';

import 'music_controller.dart';

class PlayerBottomSheet extends StatelessWidget {
  const PlayerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicController>(
      builder: (context, controller, child) {
        if (!controller.isPlayerVisible) {
          return const SizedBox.shrink();
        }

        final song = controller.currentSong;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 6.sp),
                      Row(
                        spacing: 20.sp,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Song Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.network(
                              song.imageUrl,
                              width: 70.w,
                              height: 70.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 120.w,
                                  height: 120.w,
                                  color: MyColors.primaryColor.withOpacity(0.1),
                                  child: Icon(Icons.music_note, size: 50.sp),
                                );
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Song Title
                              Text(
                                song.title,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: MyColors.primaryColorBold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),

                              // Artist Name
                              Text(
                                song.artist ?? 'Unknown Artist',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Progress Slider
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

                              return Column(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 3.h,
                                      thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 6.r,
                                      ),
                                      overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 14.r,
                                      ),
                                    ),
                                    child: Slider(
                                      value: position.inSeconds.toDouble(),
                                      max: duration.inSeconds.toDouble(),
                                      activeColor: MyColors.primaryColor,
                                      inactiveColor: Colors.grey[300],
                                      onChanged: (value) {
                                        controller.seek(
                                          Duration(seconds: value.toInt()),
                                        );
                                      },
                                    ),
                                  ),

                                  // Time indicators
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller.formatDuration(position),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          controller.formatDuration(duration),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 6.h),

                      // Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Previous Button
                          IconButton(
                            onPressed: controller.previous,
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 36.sp,
                              color: MyColors.textSecondary,
                            ),
                          ),

                          // Play/Pause Button
                          StreamBuilder<bool>(
                            stream: controller.playingStream,
                            builder: (context, snapshot) {
                              final isPlaying = snapshot.data ?? false;

                              return Container(
                                decoration: BoxDecoration(
                                  color: MyColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: controller.togglePlayPause,
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 36.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Next Button
                          IconButton(
                            onPressed: controller.next,
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: 36.sp,
                              color: MyColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
