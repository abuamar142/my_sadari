import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';

class SignInController extends GetxController {
  late AuthService _authService;

  var hidePassword = true.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  bool get isLoading => _authService.isLoading;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email dan password tidak boleh kosong",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    final success = await _authService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
      infiniteToken: true,
    );

    if (success) {
      // Navigate to home page
      Get.offAllNamed('/home');

      // Clear form
      emailController.clear();
      passwordController.clear();
    }
  }
}
