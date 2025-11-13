import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/constants/app_constant.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';

class StoryListCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final void Function() onTap;
  final String categoryId;

  const StoryListCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    required this.categoryId,
  });

  String? get _storyTitle {
    if (categoryId == AppConstant.char) return null;
    if (categoryId == AppConstant.tarbawia) return null;
    if (categoryId == AppConstant.surah) return null;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomCardBacground(
            height: context.isTablet ? 520 : 220,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            borderRadius: 12,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const Gap(12),

          if (_storyTitle != null)
            CustomText(
              _storyTitle!,
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
