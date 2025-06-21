import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/routes/app_pages.dart';

import '../../../../core/models/response_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../styles/app_colors.dart';

class SignInController extends GetxController {
  late AuthService _authService;

  var hidePassword = true.obs;
  var isLoading = false.obs;
  var isForgotPasswordLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    forgotPasswordEmailController.dispose();
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
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Format email tidak valid",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password harus minimal 6 karakter",
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
        print('Login response body: ${response.body}');
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
          backgroundColor: AppColors.pink,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );

        // Navigate to home page
        Get.offAllNamed(Routes.home);

        // Clear form
        emailController.clear();
        passwordController.clear();
      } else {
        String errorMessage = 'Terjai kesalahan saat login';

        if (response.body['error']['message'] ==
            'Invalid email/telp or password') {
          errorMessage = 'Email atau password salah';
        }

        Get.snackbar(
          'Login Gagal',
          errorMessage,
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

  Future<void> sendForgotPasswordEmail() async {
    if (forgotPasswordEmailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Email tidak boleh kosong",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    if (!GetUtils.isEmail(forgotPasswordEmailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Format email tidak valid",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    try {
      isForgotPasswordLoading.value = true;

      final response = await GetConnect().post(
        'https://sadari.sdnusabali.online/api/auth/lupaPassword',
        {'email': forgotPasswordEmailController.text.trim()},
      );

      if (kDebugMode) {
        print('Forgot password response: ${response.statusCode.toString()}');
        print('Forgot password response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        Get.back(); // Close dialog
        Get.snackbar(
          'Email Terkirim',
          'Link reset password telah dikirim ke email Anda',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.pink,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        forgotPasswordEmailController.clear();
      } else {
        String errorMessage = 'Terjadi kesalahan saat mengirim email';

        if (response.body != null && response.body is Map) {
          errorMessage = response.body['error']['message'] ?? errorMessage;

          errorMessage =
              errorMessage == 'email is not verified'
                  ? 'Email belum diverifikasi. Silakan periksa email Anda untuk verifikasi.'
                  : errorMessage;
        }

        Get.snackbar(
          'Gagal Mengirim Email',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.orange,
          colorText: AppColors.white,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Mengirim Email',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }
}
