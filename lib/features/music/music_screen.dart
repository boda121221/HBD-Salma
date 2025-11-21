import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:provider/provider.dart';
import 'music_card.dart';
import 'music_controller.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Songs we love',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: MyColors.myBlack,
                ),
              ),
            ),

            // Song List
            Expanded(
              child: Consumer<MusicController>(
                builder: (context, controller, child) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 16.h),
                    itemCount: controller.songs.length,
                    itemBuilder: (context, index) {
                      return MusicCard(
                        song: controller.songs[index],
                        index: index,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
