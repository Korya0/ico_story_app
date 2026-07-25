import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaItem {
  const SocialMediaItem({
    required this.platform,
    required this.icon,
    required this.url,
  });
  final String platform;
  final String icon;
  final String url;
}

class SocialMediaRow extends StatelessWidget {
  const SocialMediaRow({required this.items, super.key, this.onTap});
  final void Function(String platform)? onTap;
  final List<SocialMediaItem> items;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Row(
      spacing: isTablet ? 40 : 20,
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map(
            (item) => GestureDetector(
              onTap: () {
                onTap?.call(item.platform);
                _openUrl(item.url);
              },
              child: SvgPicture.asset(item.icon, height: isTablet ? 70 : 40),
            ),
          )
          .toList(),
    );
  }
}
