import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/response_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';

class SignInController extends GetxController {
  late AuthService _authService;

  var hidePassword = true.obs;
  var isLoading = false.obs;
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

    try {
      isLoading.value = true;

      final response = await GetConnect()
          .post('https://sadari.sdnusabali.online/api/login', {
            'email': emailController.text.trim(),
            'password': passwordController.text,
            'infinite_token': true,
          });

      if (kDebugMode) {
        print('Login response: ${response.statusCode.toString()}');
        print('Login response success: ${response.body['success']}');
      }

      if (response.statusCode == 200 && response.body['success'] == true) {
        final responseModel = ResponseModel.fromJson(response.body);
        final userModel = UserModel.fromJson(responseModel.data);

        // Save user data through AuthService
        await _authService.saveUserData(responseModel.token, userModel);

        // Show success message
        Get.snackbar(
          'Login Berhasil',
          'Selamat datang, ${userModel.name}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );

        // Navigate to home page
        Get.offAllNamed('/home');

        // Clear form
        emailController.clear();
        passwordController.clear();
      } else {
        Get.snackbar(
          'Login Gagal',
          response.body['message'] ?? 'Terjadi kesalahan saat login',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        'Terjadi kesalahan saat login: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
