import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';

import 'birthday_fact_model.dart';

class FactCard extends StatelessWidget {
  final BirthdayFactModel fact;
  final VoidCallback onTap;

  const FactCard({Key? key, required this.fact, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(fact.gradientColors[0]),
              Color(fact.gradientColors[1]),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Color(fact.gradientColors[0]).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              // Background Image
              if (fact.imageUrl != null)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: Image.network(
                      fact.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.transparent);
                      },
                    ),
                  ),
                ),

              // Content
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header with icon and year
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: MyColors.backgroundLight.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            fact.iconEmoji,
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        ),
                        if (fact.year != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.backgroundLight.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '${fact.year}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: MyColors.backgroundLight,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Title
                    Text(
                      fact.title,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: MyColors.backgroundLight,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 12.h),

                    // Description
                    Text(
                      fact.description,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: MyColors.backgroundLight,
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 16.h),

                    // Tap indicator
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 16.sp,
                          color: MyColors.backgroundLight.withOpacity(0.9),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Tap to learn more',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: MyColors.backgroundLight.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
