import 'package:flutter/material.dart';

import '../../../styles/app_colors.dart';

class MenuWidget extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback route;
  final Color color;

  const MenuWidget({
    super.key,
    required this.title,
    required this.image,
    required this.route,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: route,
      child: Container(
        padding: EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Image.asset(image, width: 120),
          ],
        ),
      ),
    );
  }
}
