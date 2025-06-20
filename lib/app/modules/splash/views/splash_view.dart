import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_text_style.dart';
import '../../../utils/app_images.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.background1),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Main content area
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Icon
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          AppImages.splash,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App Name
                      Text(
                        'SADARI',
                        style: AppTextStyle.headingHuge2.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pink,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // App Tagline
                      Text(
                        'Periksa Payudara Sendiri',
                        style: AppTextStyle.headingMedium1.copyWith(
                          color: AppColors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Bottom section
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Supported by text
                      Text(
                        'Supported by',
                        style: AppTextStyle.bodySmall1.copyWith(
                          color: AppColors.black.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Institution logos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                              AppImages.unisa,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Image.asset(
                              AppImages.kampusMerdeka,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // App version
                      Obx(
                        () => Text(
                          controller.appVersion.value,
                          style: AppTextStyle.bodySmall1.copyWith(
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
