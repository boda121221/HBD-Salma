import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:provider/provider.dart';

import 'birthday_facts_controller.dart';
import 'fact_card.dart';
import 'fact_detail_sheet.dart';

class BirthdayFactsScreen extends StatelessWidget {
  const BirthdayFactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BirthdayFactsController(),
      child: Scaffold(
        backgroundColor: MyColors.backgroundLight,
        body: SafeArea(
          child: Center(
            child: Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColorBold,
              ),
            ),
          ),
          // Column(
          //   children: [
          //     // Header
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          //       child: Column(
          //         children: [
          //           Text(
          //             'Did You Know? 🎉',
          //             style: TextStyle(
          //               fontSize: 32.sp,
          //               fontWeight: FontWeight.bold,
          //               color: MyColors.primaryColorBold,
          //             ),
          //           ),
          //           SizedBox(height: 8.h),
          //           Text(
          //             'Swipe to discover amazing facts\nabout your birthday',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               fontSize: 15.sp,
          //               color: Colors.grey[500],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //
          //     // Carousel
          //     Expanded(
          //       child: Consumer<BirthdayFactsController>(
          //         builder: (context, controller, child) {
          //           return Column(
          //             children: [
          //               // Page Indicator
          //               // SizedBox(height: 4.h),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: List.generate(
          //                   controller.facts.length,
          //                   (index) => AnimatedContainer(
          //                     duration: const Duration(milliseconds: 300),
          //                     margin: EdgeInsets.symmetric(horizontal: 4.w),
          //                     width: controller.currentIndex == index
          //                         ? 24.w
          //                         : 8.w,
          //                     height: 8.h,
          //                     decoration: BoxDecoration(
          //                       color: controller.currentIndex == index
          //                           ? Color(
          //                               controller
          //                                   .currentFact
          //                                   .gradientColors[0],
          //                             )
          //                           : Colors.grey[300],
          //                       borderRadius: BorderRadius.circular(4.r),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(height: 20.h),
          //
          //               // Card Carousel
          //               Expanded(
          //                 child: PageView.builder(
          //                   controller: controller.pageController,
          //                   onPageChanged: controller.updateIndex,
          //                   itemCount:
          //                       controller.facts.length *
          //                       1000, // Infinite scroll
          //                   itemBuilder: (context, index) {
          //                     final factIndex = index % controller.facts.length;
          //                     final fact = controller.facts[factIndex];
          //
          //                     return AnimatedBuilder(
          //                       animation: controller.pageController,
          //                       builder: (context, child) {
          //                         double value = 1.0;
          //                         if (controller
          //                             .pageController
          //                             .position
          //                             .haveDimensions) {
          //                           value =
          //                               controller.pageController.page! - index;
          //                           value = (1 - (value.abs() * 0.3)).clamp(
          //                             0.7,
          //                             1.0,
          //                           );
          //                         }
          //
          //                         return Center(
          //                           child: Transform.scale(
          //                             scale: value,
          //                             child: Opacity(
          //                               opacity: value,
          //                               child: child,
          //                             ),
          //                           ),
          //                         );
          //                       },
          //                       child: FactCard(
          //                         fact: fact,
          //                         onTap: () =>
          //                             FactDetailSheet.show(context, fact),
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               ),
          //
          //               // Navigation Hints
          //               // Padding(
          //               //   padding: EdgeInsets.symmetric(
          //               //     horizontal: 40.w,
          //               //     vertical: 20.h,
          //               //   ),
          //               //   child: Row(
          //               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               //     children: [
          //               //       IconButton(
          //               //         onPressed: controller.goToPrevious,
          //               //         icon: Icon(
          //               //           Icons.arrow_back_ios_rounded,
          //               //           color: Colors.grey[400],
          //               //           size: 24.sp,
          //               //         ),
          //               //       ),
          //               //       Text(
          //               //         'Swipe or tap arrows',
          //               //         style: TextStyle(
          //               //           fontSize: 13.sp,
          //               //           color: Colors.grey[500],
          //               //         ),
          //               //       ),
          //               //       IconButton(
          //               //         onPressed: controller.goToNext,
          //               //         icon: Icon(
          //               //           Icons.arrow_forward_ios_rounded,
          //               //           color: Colors.grey[400],
          //               //           size: 24.sp,
          //               //         ),
          //               //       ),
          //               //     ],
          //               //   ),
          //               // ),
          //             ],
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
