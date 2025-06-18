import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/styles/app_dimension.dart';
import 'package:my_sadari/app/styles/app_text_style.dart';

import '../../../styles/app_colors.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

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
                      "Login",
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
                            controller: controller.emailController,
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
                                  // icon: SvgPicture.asset(
                                  //   controller.hidePassword.value ? iconC.broEye : iconC.broEyeSlash,
                                  //   height: 24,
                                  //   colorFilter: ColorFilter.mode(
                                  //     AppColors.black,
                                  //     BlendMode.srcIn,
                                  //   ),
                                  // ),
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
                    SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppColors.black),
                        ),
                      ),
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
                        child: Text('LOGIN', style: AppTextStyle.buttonText1),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text('New User?'),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Register Here',
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
