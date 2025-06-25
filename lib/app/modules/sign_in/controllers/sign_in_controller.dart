import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/routes/app_pages.dart';

import '../../../../core/models/response_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../widgets/app_snackbar.dart';

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
      AppSnackbar.error(
        title: "Error",
        message: "Email dan password tidak boleh kosong",
      );
      return;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      AppSnackbar.error(title: "Error", message: "Format email tidak valid");
      return;
    }
    if (passwordController.text.length < 6) {
      AppSnackbar.error(
        title: "Error",
        message: "Password harus minimal 6 karakter",
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
        AppSnackbar.success(
          title: 'Login Berhasil',
          message: 'Selamat datang, ${userModel.name}!',
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

        AppSnackbar.error(title: 'Login Gagal', message: errorMessage);
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Login Gagal',
        message: 'Terjadi kesalahan saat login: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendForgotPasswordEmail() async {
    if (forgotPasswordEmailController.text.trim().isEmpty) {
      AppSnackbar.error(title: "Error", message: "Email tidak boleh kosong");
      return;
    }

    if (!GetUtils.isEmail(forgotPasswordEmailController.text.trim())) {
      AppSnackbar.error(title: "Error", message: "Format email tidak valid");
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
        AppSnackbar.success(
          title: 'Email Terkirim',
          message: 'Link reset password telah dikirim ke email Anda',
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

        AppSnackbar.warning(
          title: 'Gagal Mengirim Email',
          message: errorMessage,
        );
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Gagal Mengirim Email',
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }
}
