import 'package:flutter/material.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';

class CustomIconBackground extends StatelessWidget {
  const CustomIconBackground({required this.child, super.key, this.onTap});
  final Widget child;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return GestureDetector(
      onTap: onTap,
      child: CustomCardBacground(
        borderRadius: 12,
        padding: EdgeInsets.all(isTablet ? 12 : 10),
        child: child,
      ),
    );
  }
}
