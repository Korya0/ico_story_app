import 'package:flutter/material.dart';
import 'package:ico_story_app/core/widgets/gap.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_keys.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/home_view/social_media_row.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_background.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCardBackground(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            const CustomText(
              AppStrings.followUs,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            SocialMediaRow(
              items: const [
                SocialMediaItem(
                  platform: AppKeys.twitter,
                  icon: AppAssets.x,
                  url: AppKeys.twitterLink,
                ),
                SocialMediaItem(
                  platform: AppKeys.insta,
                  icon: AppAssets.insta,
                  url: AppKeys.instaLink,
                ),
                SocialMediaItem(
                  platform: AppKeys.facebook,
                  icon: AppAssets.facebook,
                  url: AppKeys.facebookLink,
                ),
              ],
              onTap: (platform) {
                debugPrint('Clicked on $platform');
              },
            ),
          ],
        ),
      ),
    );
  }
}
