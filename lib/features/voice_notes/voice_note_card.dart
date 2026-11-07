// ---------------------------------------------------------------------------
// voice_note_card.dart
// Card widget for a single voice note category.
//
// STATE DISPLAY:
//  VnState.idle          → play button
//  VnState.loading       → spinner
//  VnState.playing       → pause button + progress slider
//  VnState.paused        → play button + progress slider
//  VnState.unconfigured  → lock icon + "Voice note not configured yet" message
//  VnState.error         → error icon + errorMessage
//
// COLOUR: Each card uses a soft pastel tint derived from MyColors.primaryColor
// to keep the screen visually calm. Only the active card shows the slider.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:provider/provider.dart';

import 'voice_note_model.dart';
import 'voice_notes_controller.dart';
import '../music/music_controller.dart';

class VoiceNoteCard extends StatelessWidget {
  final VoiceNoteModel note;

  const VoiceNoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceNotesController>(
      builder: (context, ctrl, _) {
        final bool isActive = ctrl.activeId == note.id;
        final VnState state = isActive ? ctrl.state : VnState.idle;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.only(bottom: 14.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isActive
                ? MyColors.primaryColor.withOpacity(0.22)
                : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isActive
                  ? MyColors.primaryColorBold.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.12),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? MyColors.primaryColorBold.withOpacity(0.12)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Top row: emoji, title/subtitle, play button ──────────
              Row(
                children: [
                  // Emoji icon container
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        note.emoji,
                        style: TextStyle(fontSize: 28.sp),
                      ),
                    ),
                  ),

                  SizedBox(width: 14.w),

                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: MyColors.primaryColorBold,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          note.subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: MyColors.myBlack.withOpacity(0.7),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Play/Pause / Spinner button
                  _buildPlayButton(context, ctrl, state),
                ],
              ),

              // ── Progress slider (only when active & has data) ────────
              if (isActive &&
                  (state == VnState.playing || state == VnState.paused))
                _buildProgressRow(ctrl),

              // ── Unconfigured message ─────────────────────────────────
              if (isActive && state == VnState.unconfigured)
                _buildStatusMessage(
                  icon: Icons.lock_outline_rounded,
                  message: 'Voice note not configured yet.',
                  color: Colors.orange,
                ),

              // ── Error message ────────────────────────────────────────
              if (isActive && state == VnState.error)
                _buildStatusMessage(
                  icon: Icons.error_outline_rounded,
                  message: ctrl.errorMessage ?? 'Playback error.',
                  color: Colors.red,
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Play button ─────────────────────────────────────────────────────────
  Widget _buildPlayButton(
    BuildContext context,
    VoiceNotesController ctrl,
    VnState state,
  ) {
    // While loading: spinner
    if (state == VnState.loading) {
      return SizedBox(
        width: 44.w,
        height: 44.w,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: MyColors.primaryColorBold,
          ),
        ),
      );
    }

    final IconData icon =
        state == VnState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded;

    return Semantics(
      label: state == VnState.playing ? 'Pause ${note.title}' : 'Play ${note.title}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            try {
              final musicCtrl =
                  Provider.of<MusicController>(context, listen: false);
              if (musicCtrl.isPlaying) {
                musicCtrl.togglePlayPause();
              }
            } catch (_) {}
            ctrl.toggleNote(note.id, note.audioUrl);
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: MyColors.primaryColorBold.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22.sp),
          ),
        ),
      ),
    );
  }

  // ── Progress row ─────────────────────────────────────────────────────────
  Widget _buildProgressRow(VoiceNotesController ctrl) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: StreamBuilder<Duration>(
        stream: ctrl.positionStream,
        builder: (context, posSnap) {
          final position = posSnap.data ?? ctrl.position;

          return StreamBuilder<Duration?>(
            stream: ctrl.durationStream,
            builder: (context, durSnap) {
              final duration = durSnap.data ?? ctrl.duration;
              final maxSec = duration.inSeconds > 0
                  ? duration.inSeconds.toDouble()
                  : 1.0;
              final curSec =
                  position.inSeconds.clamp(0, duration.inSeconds).toDouble();

              return Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2.5.h,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 5.r),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 12.r),
                    ),
                    child: Slider(
                      value: curSec,
                      max: maxSec,
                      min: 0,
                      activeColor: MyColors.primaryColorBold,
                      inactiveColor: Colors.grey[300],
                      onChanged: (v) =>
                          ctrl.seek(Duration(seconds: v.toInt())),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ctrl.formatDuration(position),
                          style: TextStyle(
                              fontSize: 11.sp, color: Colors.grey[600]),
                        ),
                        Text(
                          ctrl.formatDuration(duration),
                          style: TextStyle(
                              fontSize: 11.sp, color: Colors.grey[600]),
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
    );
  }

  // ── Status / error message ───────────────────────────────────────────────
  Widget _buildStatusMessage({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
