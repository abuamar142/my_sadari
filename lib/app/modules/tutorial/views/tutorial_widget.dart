import 'package:flutter/material.dart';
import 'package:my_sadari/app/styles/app_dimension.dart';
import 'package:my_sadari/app/styles/app_text_style.dart';

import '../../../styles/app_colors.dart';

class TutorialWidget extends StatelessWidget {
  final String description;
  final String image;

  const TutorialWidget({super.key, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(description, style: AppTextStyle.bodyMedium1, textAlign: TextAlign.center),
          SizedBox(height: AppDimensions.paddingLarge),
          Image.asset(image, width: 120),
        ],
      ),
    );
  }
}
