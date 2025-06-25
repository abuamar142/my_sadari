import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_snackbar.dart';

class SignUpController extends GetxController {
  var hidePassword = true.obs;
  var hidePasswordConfirm = true.obs;
  var isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void togglePasswordConfirmVisibility() {
    hidePasswordConfirm.value = !hidePasswordConfirm.value;
  }

  bool _validateFields() {
    // Cek apakah semua field sudah terisi
    if (nameController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      AppSnackbar.error(title: "Error", message: "Semua field harus diisi");
      return false;
    }

    // Validasi format email
    if (!GetUtils.isEmail(emailController.text.trim())) {
      AppSnackbar.error(title: "Error", message: "Format email tidak valid");
      return false;
    }

    // Validasi umur harus berupa angka
    if (int.tryParse(ageController.text.trim()) == null) {
      AppSnackbar.error(title: "Error", message: "Umur harus berupa angka");
      return false;
    }

    // Cek apakah password dan konfirmasi password sama
    if (passwordController.text != passwordConfirmController.text) {
      AppSnackbar.error(
        title: "Error",
        message: "Password dan konfirmasi password tidak sama",
      );
      return false;
    }

    // Validasi panjang password minimal
    if (passwordController.text.length < 6) {
      AppSnackbar.error(title: "Error", message: "Password minimal 6 karakter");
      return false;
    }

    return true;
  }

  Future<void> signUp() async {
    if (!_validateFields()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await GetConnect()
          .post('https://sadari.sdnusabali.online/api/users/create', {
            'name': nameController.text.trim(),
            'age': int.parse(ageController.text.trim()),
            'phone': phoneController.text.trim(),
            'email': emailController.text.trim(),
            'password': passwordController.text,
          });

      if (kDebugMode) {
        print('Sign up response: ${response.statusCode.toString()}');
        print('Sign up response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          // Show success message
          AppSnackbar.success(
            title: 'Registrasi Berhasil',
            message: 'Akun berhasil dibuat! Silakan login dengan akun Anda.',
            duration: const Duration(seconds: 3),
          );

          // Clear form
          _clearForm();

          // Navigate to sign in page
          Get.offNamed('/sign-in');
        } else {
          AppSnackbar.error(
            title: 'Registrasi Gagal',
            message:
                response.body['message'] ?? 'Terjadi kesalahan saat registrasi',
            duration: const Duration(seconds: 4),
          );
        }
      } else {
        String errorMessage = 'Terjadi kesalahan saat registrasi';

        if (response.body != null && response.body is Map) {
          errorMessage = response.body['message'] ?? errorMessage;
        }

        AppSnackbar.error(
          title: 'Registrasi Gagal',
          message: errorMessage,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Registrasi Gagal',
        message: 'Terjadi kesalahan saat registrasi: ${e.toString()}',
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
  }
}
