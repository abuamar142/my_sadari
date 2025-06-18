import 'package:flutter/material.dart';
import 'package:my_sadari/app/styles/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle headingHuge1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle headingLarge1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle headingMedium1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle headingSmall1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle bodyLarge1 = TextStyle(
    fontSize: 16,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyMedium1 = TextStyle(fontSize: 14, color: AppColors.black);

  static const TextStyle bodySmall1 = TextStyle(fontSize: 12, color: AppColors.black);

  static TextStyle headingHuge2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle headingLarge2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle headingMedium2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle headingSmall2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle bodyLarge2 = TextStyle(
    fontSize: 16,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyMedium2 = TextStyle(fontSize: 14, color: AppColors.white);

  static const TextStyle bodySmall2 = TextStyle(fontSize: 12, color: AppColors.white);

  static const TextStyle caption = TextStyle(fontSize: 12, color: AppColors.pink);

  static const TextStyle buttonText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}
