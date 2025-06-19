import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(AppDimensions.paddingLarge),
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
              ),
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),

                  Text(
                    "Selamat Datang!",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Masuk untuk melanjutkan",
                    style: AppTextStyle.caption.copyWith(color: Colors.grey),
                  ),

                  SizedBox(height: 24),

                  // Email Input
                  TextField(
                    controller: controller.emailController,
                    style: AppTextStyle.bodyMedium1,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: AppTextStyle.caption,
                      filled: true,
                      fillColor: Colors.grey.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Password Input
                  Obx(
                    () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.hidePassword.value,
                      style: AppTextStyle.bodyMedium1,
                      decoration: InputDecoration(
                        hintText: 'Kata Sandi',
                        hintStyle: AppTextStyle.caption,
                        filled: true,
                        fillColor: Colors.grey.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          onPressed: controller.toggleVisibility,
                          icon: Icon(
                            controller.hidePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24), // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMedium,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (!controller.isLoading.value) {
                            controller.login();
                          }
                        },
                        child:
                            controller.isLoading.value
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                                : Text(
                                  'MASUK',
                                  style: AppTextStyle.buttonText1,
                                ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Register Section
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Pengguna Baru? ',
                          style: AppTextStyle.caption.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: 'Daftar Disini',
                          style: AppTextStyle.caption.copyWith(
                            color: AppColors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed('/sign-up');
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
