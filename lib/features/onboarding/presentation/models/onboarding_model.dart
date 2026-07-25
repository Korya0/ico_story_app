import 'package:flutter/material.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/style/app_colors.dart';

class OnboardingModel {
  const OnboardingModel({
    required this.backgroundColor,
    required this.title,
    required this.description,
    required this.iconColor,
    this.imagePath,
    this.iconData,
  });
  final String title;
  final String description;
  final String? imagePath;
  final IconData? iconData;
  final Color backgroundColor;
  final Color iconColor;

  static final List<OnboardingModel> pages = [
    const OnboardingModel(
      title: AppStrings.onboardingAchievementTitle,
      description: AppStrings.onboardingAchievementDesc,
      imagePath: AppAssets.onboarding6,
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),
    const OnboardingModel(
      title: AppStrings.onboardingBrowseTitle,
      description: AppStrings.onboardingBrowseDesc,
      imagePath: AppAssets.onboarding2,
      backgroundColor: AppColors.secondary,
      iconColor: AppColors.white,
    ),
    const OnboardingModel(
      title: AppStrings.onboardingListenTitle,
      description: AppStrings.onboardingListenDesc,
      imagePath: AppAssets.onboarding3,
      backgroundColor: AppColors.accent,
      iconColor: AppColors.primary,
    ),
    const OnboardingModel(
      title: AppStrings.onboardingWelcomeTitle,
      description: AppStrings.onboardingWelcomeDesc,
      imagePath: AppAssets.onboarding1,
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),
  ];
}
