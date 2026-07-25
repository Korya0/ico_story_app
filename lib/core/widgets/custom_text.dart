import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';

class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    required this.fontSize,
    super.key,
    this.tabletFontSize,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.textPrimary,
    this.textAlign = TextAlign.start,
  });
  final String text;
  final double fontSize;
  final double? tabletFontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final effectiveFontSize = isTablet
        ? (tabletFontSize ?? fontSize * 1.6)
        : fontSize;

    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: effectiveFontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
