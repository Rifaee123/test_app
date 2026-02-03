import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AdminShimmerBase extends StatelessWidget {
  final Widget child;
  const AdminShimmerBase({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}

class AdminShimmerStatCard extends StatelessWidget {
  const AdminShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShimmerBase(
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
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
        margin: EdgeInsets.only(bottom: 4.h),
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
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
          Container(height: 10.h, width: 100.w, color: Colors.white),
          SizedBox(height: 4.h),
          Container(height: 15.h, width: 150.w, color: Colors.white),
          SizedBox(height: 4.h),
          Container(height: 10.h, width: 120.w, color: Colors.white),
        ],
      ),
    );
  }
}
