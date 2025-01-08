import 'package:flutter/material.dart';
import 'constant_colors.dart';
import 'font_size.dart';

class AppTextStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: FontSizes.large,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryTextColor,
  );

  static const TextStyle errorStyle = TextStyle(
    fontSize: FontSizes.medium,
    color: AppColors.errorColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );
}
