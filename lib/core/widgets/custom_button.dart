import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    super.key,
    this.onPressed,
    this.backgroundColor = AppColors.white,
    this.fontWeight = FontWeight.bold,
    this.mobileFontSize = 16,
    this.tabletFontSize = 22,
    this.width,
    this.height,
    this.child,
    this.borderRadius,
  });
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final double mobileFontSize;
  final double tabletFontSize;
  final double? width;
  final double? height;
  final Widget? child;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final screenWidth = MediaQuery.of(context).size.width;

    final effectiveWidth =
        width ??
        (isTablet
            ? (screenWidth * 0.8 > 600 ? 600 : screenWidth * 0.8)
            : double.infinity);

    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          height: height ?? (isTablet ? 60 : 48),
          width: effectiveWidth,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              borderRadius ?? (isTablet ? 16 : 12),
            ),
          ),
          alignment: Alignment.center,
          child:
              child ??
              CustomText(
                text,
                fontSize: mobileFontSize,
                tabletFontSize: tabletFontSize,
                fontWeight: fontWeight,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
        ),
      ),
    );
  }
}
