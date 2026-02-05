import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AdminShimmerBase extends StatelessWidget {
  final Widget child;
  const AdminShimmerBase({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading content...',
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: child,
      ),
    );
  }
}

class AdminShimmerStatCard extends StatelessWidget {
  const AdminShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShimmerBase(
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class AdminShimmerStudentCard extends StatelessWidget {
  const AdminShimmerStudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShimmerBase(
      child: Container(
        margin: EdgeInsets.only(bottom: 6.h),
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class AdminShimmerWelcomeHeader extends StatelessWidget {
  const AdminShimmerWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShimmerBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 8.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            height: 18.h,
            width: 160.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            height: 12.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
