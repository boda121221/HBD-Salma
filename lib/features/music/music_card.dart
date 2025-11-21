import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:provider/provider.dart';

import 'music_controller.dart';
import 'music_model.dart';
import 'player_bottom_sheet.dart';

class MusicCard extends StatelessWidget {
  final MusicModel song;
  final int index;

  const MusicCard({Key? key, required this.song, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MusicController>(context, listen: false);

    return GestureDetector(
      onTap: () {
        debugPrint(
          'MusicCard tapped index=$index sheetOpen=${controller.isSheetOpen}',
        );

        // If sheet isn't open, open it immediately so it shows on first tap
        if (!controller.isSheetOpen) {
          controller.markSheetOpen();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) {
              debugPrint(
                'showModalBottomSheet.builder called for index=$index',
              );
              // Provide the same controller instance to the sheet and pass onBuilt to start playback
              return ChangeNotifierProvider.value(
                value: controller,
                child: PlayerBottomSheet(
                  onBuilt: () {
                    debugPrint(
                      'PlayerBottomSheet built callback for index=$index',
                    );
                    controller.playSong(index);
                  },
                ),
              );
            },
          ).whenComplete(() {
            // Mark sheet closed when dismissed
            debugPrint('Modal bottom sheet dismissed for index=$index');
            controller.markSheetClosed();
          });
        } else {
          // If sheet already open, just switch the track
          debugPrint('Sheet already open - switching to index=$index');
          controller.playSong(index);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: MyColors.myBlack.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Song Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                song.imageUrl,
                width: 70.w,
                height: 70.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70.w,
                    height: 70.w,
                    color: MyColors.primaryColor.withOpacity(0.1),
                    child: Icon(Icons.music_note, size: 30.sp),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),

            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: MyColors.primaryColorBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    song.artist ?? 'Unknown Artist',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    controller.formatDuration(song.duration),
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),

            // Play Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: MyColors.primaryColor,
                size: 28.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
