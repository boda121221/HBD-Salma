import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/colors.dart';
import 'memory_match/memory_match_screen.dart';
import 'balloon_pop/balloon_pop_screen.dart';

// New: Games selection screen
class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 4.h),
              child: Center(
                child: Text(
                  'Games 🎮',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lymbo',
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryColorBold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MemoryMatchScreen(),
                        ),
                      ),
                      child: Container(
                        // Match MusicCard spacing & shadow
                        margin: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 2.w,
                        ),
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
                            // Emoji styled like the music image placeholder
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                width: 70.w,
                                height: 70.w,
                                color: MyColors.primaryColor.withOpacity(0.1),
                                child: Center(
                                  child: Text(
                                    '🧠',
                                    style: TextStyle(fontSize: 36.sp),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Memory Match',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: MyColors.primaryColorBold,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Find all matching pairs to win!',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Circular accent icon like in MusicCard
                            Container(
                              padding: EdgeInsets.all(8.w),
                              // decoration: BoxDecoration(
                              //   color: MyColors.primaryColor.withOpacity(0.1),
                              //   shape: BoxShape.circle,
                              // ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: MyColors.primaryColorBold,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BalloonPopScreen(),
                        ),
                      ),
                      child: Container(
                        // Match MusicCard spacing & shadow
                        margin: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 2.w,
                        ),
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
                            // Emoji styled like the music image placeholder
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                width: 70.w,
                                height: 70.w,
                                color: MyColors.primaryColor.withOpacity(0.1),
                                child: Center(
                                  child: Text(
                                    '🎈',
                                    style: TextStyle(fontSize: 36.sp),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Balloon Pop',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: MyColors.primaryColorBold,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Tap balloons to pop and score points!',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Circular accent icon like in MusicCard
                            Container(
                              padding: EdgeInsets.all(8.w),
                              // decoration: BoxDecoration(
                              //   color: MyColors.primaryColor.withOpacity(0.1),
                              //   shape: BoxShape.circle,
                              // ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: MyColors.primaryColorBold,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Optionally add more games here in the future
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
