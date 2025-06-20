import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

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
                    "Daftar Akun Baru",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Silahkan lengkapi data dibawah ini",
                    style: AppTextStyle.caption.copyWith(color: Colors.grey),
                  ),

                  SizedBox(height: 24), // Name Input
                  AppTextField(
                    controller: controller.nameController,
                    hintText: 'Nama Lengkap',
                    prefixIcon: Icons.person,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  // Age Input
                  AppTextField(
                    controller: controller.ageController,
                    hintText: 'Umur',
                    prefixIcon: Icons.cake,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  // Phone Input
                  AppTextField(
                    controller: controller.phoneController,
                    hintText: 'Nomor Telepon',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  // Email Input
                  AppTextField(
                    controller: controller.emailController,
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  // Password Input
                  AppPasswordTextField(
                    controller: controller.passwordController,
                    hintText: 'Kata Sandi',
                    hidePassword: controller.hidePassword,
                    onToggleVisibility: controller.togglePasswordVisibility,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  // Password Confirmation Input
                  AppPasswordTextField(
                    controller: controller.passwordConfirmController,
                    hintText: 'Konfirmasi Kata Sandi',
                    hidePassword: controller.hidePasswordConfirm,
                    onToggleVisibility:
                        controller.togglePasswordConfirmVisibility,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.signUp(),
                  ),

                  SizedBox(height: 24), // Register Button
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
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : controller.signUp,
                        child:
                            controller.isLoading.value
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  'DAFTAR',
                                  style: AppTextStyle.buttonText1,
                                ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Login Section
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sudah punya akun? ',
                          style: AppTextStyle.caption.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: 'Masuk Disini',
                          style: AppTextStyle.caption.copyWith(
                            color: AppColors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
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
