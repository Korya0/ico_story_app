import 'package:flutter/material.dart';

class OnboardingModel {
  const OnboardingModel({
    required this.backgroundColor,
    required this.title,
    required this.description,
    required this.iconColor,
    this.imagePath,
    this.iconData,
  });
  final String title;
  final String description;
  final String? imagePath;
  final IconData? iconData;
  final Color backgroundColor;
  final Color iconColor;
}
