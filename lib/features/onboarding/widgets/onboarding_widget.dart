import 'package:flutter/material.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';
import 'package:ico_story_app/features/onboarding/model/onboarding_model.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    required this.page,
    super.key,
    this.animationDelay = 0,
  });
  final OnboardingModel page;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    Widget iconOrImage;

    if (page.imagePath != null) {
      iconOrImage = Image.asset(
        page.imagePath!,
        height: isTablet ? 280 : 180,
        width: isTablet ? 280 : 180,
      );
    } else if (page.iconData != null) {
      iconOrImage = Icon(
        page.iconData,
        size: isTablet ? 280 : 100,
        color: page.iconColor,
      );
    } else {
      iconOrImage = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAnimations.fadeInUp(
            CustomCardBacground(
              borderRadius: 10000,
              padding: const EdgeInsets.all(16),
              child: iconOrImage,
            ),
            delay: Duration(milliseconds: animationDelay),
          ),
          const SizedBox(height: 24),
          AppAnimations.fadeInUp(
            CustomText(
              page.title,
              textAlign: TextAlign.center,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            delay: Duration(milliseconds: animationDelay + 200),
          ),
          const SizedBox(height: 6),
          AppAnimations.fadeInUp(
            CustomText(
              page.description,
              textAlign: TextAlign.center,
              fontSize: 18,
            ),
            delay: Duration(milliseconds: animationDelay + 400),
          ),
        ],
      ),
    );
  }
}
