import 'package:flutter/material.dart';
import 'package:ico_story_app/core/widgets/gap.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/presentation/widgets/common/custom_card_background.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return CustomCardBackground(
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 20,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.cardBackground,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    AppAssets.icoLogoAlt,
                    width: isTablet ? 200 : 100,
                    height: isTablet ? 200 : 100,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.cardBackground,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    AppAssets.directAid,
                    width: isTablet ? 220 : 100,
                    height: isTablet ? 200 : 100,
                  ),
                ),
              ],
            ),
            Gap(isTablet ? 24 : 18),
            CustomText(
              AppStrings.welcomeTitle,
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w800,
              textAlign: TextAlign.center,
            ),
            Gap(isTablet ? 16 : 8),
            CustomText(
              AppStrings.welcomeSubtitle,
              fontSize: isTablet ? 18 : 16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
