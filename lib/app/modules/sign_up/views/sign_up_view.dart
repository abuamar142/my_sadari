import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                margin: EdgeInsets.all(AppDimensions.paddingLarge),
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Column(
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                        color: AppColors.pink,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: [
                        SizedBox(width: 16),
                        Flexible(
                          child: TextField(
                            controller: controller.nameController,
                            style: AppTextStyle.bodyMedium1,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: AppTextStyle.caption,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Flexible(
                          child: TextField(
                            controller: controller.ageController,
                            keyboardType: TextInputType.number,
                            style: AppTextStyle.bodyMedium1,
                            decoration: InputDecoration(
                              hintText: 'Age',
                              hintStyle: AppTextStyle.caption,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Flexible(
                          child: TextField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            style: AppTextStyle.bodyMedium1,
                            decoration: InputDecoration(
                              hintText: 'Phone',
                              hintStyle: AppTextStyle.caption,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Flexible(
                          child: TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: AppTextStyle.bodyMedium1,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: AppTextStyle.caption,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Flexible(
                          child: Obx(
                            () => TextField(
                              controller: controller.passwordController,
                              obscureText: controller.hidePassword.value,
                              decoration: InputDecoration(
                                hintText: '********',
                                hintStyle: AppTextStyle.caption,
                                suffixIcon: IconButton(
                                  onPressed: controller.toggleVisibility,
                                  icon: Icon(
                                    controller.hidePassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              style: AppTextStyle.bodyMedium1,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('REGISTER', style: AppTextStyle.buttonText1),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text('Already have an account?'),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Login',
                        style: TextStyle(color: AppColors.pink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
