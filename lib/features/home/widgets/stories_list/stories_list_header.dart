import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_back_button.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

class StoriesListHeader extends StatelessWidget {
  const StoriesListHeader({required this.categoryTitle, super.key});
  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Row(
      children: [
        AppAnimations.slideInRight(
          const CustomBackButton(),
          delay: const Duration(milliseconds: 100),
        ),
        Gap(isTablet ? 20 : 16),
        Expanded(
          child: AppAnimations.fadeInLeft(
            CustomText(
              categoryTitle,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
            delay: const Duration(milliseconds: 200),
          ),
        ),
      ],
    );
  }
}
