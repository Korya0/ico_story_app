import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/features/onboarding/model/onboarding_model.dart';

class OnboardingPages {
  OnboardingPages._();

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
