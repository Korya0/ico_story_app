import 'package:flutter/material.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/custom_button.dart';

class OnboardingBottomNavigation extends StatelessWidget {
  const OnboardingBottomNavigation({
    required this.currentPage,
    required this.totalPages,
    super.key,
    this.onNext,
    this.onGetStarted,
  });
  final int currentPage;
  final int totalPages;
  final VoidCallback? onNext;
  final VoidCallback? onGetStarted;

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PageIndicator(currentPage: currentPage, totalPages: totalPages),
          const SizedBox(height: 24),
          if (isLastPage)
            _GetStartedButton(onGetStarted: onGetStarted)
          else
            _NextButton(onNext: onNext),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage, required this.totalPages});

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return CustomButton(text: AppStrings.next, onPressed: onNext);
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onGetStarted});

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) {
    return CustomButton(text: AppStrings.startNow, onPressed: onGetStarted);
  }
}
