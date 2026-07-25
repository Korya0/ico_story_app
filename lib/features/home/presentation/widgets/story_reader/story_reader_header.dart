import 'package:flutter/material.dart';
import 'package:ico_story_app/core/widgets/gap.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_back_button.dart';
import 'package:ico_story_app/core/widgets/custom_icon_cackground.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

class StoryReaderHeader extends StatelessWidget {
  const StoryReaderHeader({
    required this.storyTitle,
    super.key,
    this.onAudioToggle,
    this.storyType,
    this.isAudioVisible = false,
  });
  final String storyTitle;
  final String? storyType;
  final VoidCallback? onAudioToggle;
  final bool isAudioVisible;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.slideInDown(
      Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          children: [
            AppAnimations.fadeInRight(
              delay: const Duration(milliseconds: 250),
              const CustomBackButton(),
            ),
            Gap(isTablet ? 16 : 12),
            Expanded(
              child: Center(
                child: CustomText(
                  storyTitle,
                  fontSize: isTablet ? 22 : 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (storyType != null && storyType!.isNotEmpty)
              Row(
                children: [
                  CustomText(
                    '${AppStrings.listenTo}$storyType',
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap(isTablet ? 16 : 12),
                  AppAnimations.fadeInLeft(
                    delay: const Duration(milliseconds: 350),
                    CustomIconBackground(
                      onTap: onAudioToggle,
                      child: Icon(
                        isAudioVisible ? Icons.close : Icons.volume_up,
                        color: isAudioVisible
                            ? Colors.red
                            : AppColors.textPrimary,
                        size: isTablet ? 26 : 22,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
