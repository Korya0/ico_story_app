import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_background.dart';

class StoryListCard extends StatelessWidget {
  const StoryListCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    super.key,
  });
  final String title;
  final String imagePath;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomCardBackground(
            height: context.isTablet ? 520 : 220,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        ],
      ),
    );
  }
}
