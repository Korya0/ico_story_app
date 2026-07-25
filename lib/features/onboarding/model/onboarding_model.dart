import 'package:flutter/material.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/style/app_colors.dart';

class OnboardingModel {
  OnboardingModel({
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
    OnboardingModel(
      title: AppStrings.onbTitle1,
      description: AppStrings.onbDesc1,
      imagePath: AppAssets.onboarding6,
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),
    OnboardingModel(
      title: AppStrings.onbTitle2,
      description: AppStrings.onbDesc2,
      imagePath: AppAssets.onboarding2,
      backgroundColor: AppColors.secondary,
      iconColor: AppColors.white,
    ),
    OnboardingModel(
      title: AppStrings.onbTitle3,
      description: AppStrings.onbDesc3,
      imagePath: AppAssets.onboarding3,
      backgroundColor: AppColors.accent,
      iconColor: AppColors.primary,
    ),
    OnboardingModel(
      title: AppStrings.onbTitle4,
      description: AppStrings.onbDesc4,
      imagePath: AppAssets.onboarding1,
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),
  ];
}
