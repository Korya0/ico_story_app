import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ico_story_app/core/widgets/gap.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

class HomeStoryCard extends StatelessWidget {
  const HomeStoryCard({
    required this.imagePath,
    required this.title,
    super.key,
    this.onTap,
  });
  final String imagePath;
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imagePath,
                width: isTablet ? 250 : 0.18.sh,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Gap(12),
          CustomText(
            title,
            fontSize: isTablet ? 20 : 18.h,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
