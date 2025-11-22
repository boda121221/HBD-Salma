import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/colors.dart';
import 'birthday_fact_model.dart';

class FactDetailSheet extends StatelessWidget {
  final BirthdayFactModel fact;

  const FactDetailSheet({Key? key, required this.fact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.backgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Image
              if (fact.imageUrl != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(fact.gradientColors[0]).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      children: [
                        Image.network(
                          fact.imageUrl!,
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(
                                fact.gradientColors[0],
                              ).withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  fact.iconEmoji,
                                  style: TextStyle(fontSize: 60.sp),
                                ),
                              ),
                            );
                          },
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 24.h),

              // Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and Type
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(fact.gradientColors[0]),
                                Color(fact.gradientColors[1]),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            fact.iconEmoji,
                            style: TextStyle(fontSize: 24.sp),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fact.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(fact.gradientColors[0]),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              if (fact.year != null)
                                Text(
                                  'Year ${fact.year}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Title
                    Text(
                      fact.title,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: MyColors.myBlack,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Description
                    Text(
                      fact.description,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Close button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(fact.gradientColors[0]),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Got it!',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, BirthdayFactModel fact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FactDetailSheet(fact: fact),
    );
  }
}
