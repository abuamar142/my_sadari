import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/utils/app_images.dart';

import '../../../styles/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body:  Center(
          child: Image.asset(AppImages.menu1),
        ),
      ),
    );
  }
}
