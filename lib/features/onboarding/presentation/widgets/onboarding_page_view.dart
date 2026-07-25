import 'package:flutter/material.dart';
import 'package:ico_story_app/features/onboarding/presentation/models/onboarding_model.dart';
import 'package:ico_story_app/features/onboarding/presentation/widgets/onboarding_widget.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    required this.controller,
    required this.pages,
    required this.currentPage,
    required this.onPageChanged,
    super.key,
  });
  final PageController controller;
  final List<OnboardingModel> pages;
  final int currentPage;
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return OnboardingWidget(
          page: pages[index],
          animationDelay: index * 200,
        );
      },
    );
  }
}
