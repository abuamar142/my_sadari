import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    if (nameController.text.trim().isEmpty &&
        ageController.text.trim().isEmpty &&
        phoneController.text.trim().isEmpty &&
        emailController.text.trim().isEmpty &&
        passwordController.text.isEmpty &&
        passwordConfirmController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field harus diisi",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return false;
    }

    // Validasi format email
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
      return false;
    }

    // Validasi umur harus berupa angka
    if (int.tryParse(ageController.text.trim()) == null) {
      Get.snackbar(
        "Error",
        "Umur harus berupa angka",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return false;
    }

    // Cek apakah password dan konfirmasi password sama
    if (passwordController.text != passwordConfirmController.text) {
      Get.snackbar(
        "Error",
        "Password dan konfirmasi password tidak sama",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return false;
    }

    // Validasi panjang password minimal
    if (passwordController.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password minimal 6 karakter",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
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
          Get.snackbar(
            'Registrasi Berhasil',
            'Akun berhasil dibuat! Silakan login dengan akun Anda.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );

          // Clear form
          _clearForm();

          // Navigate to sign in page
          Get.offNamed('/sign-in');
        } else {
          Get.snackbar(
            'Registrasi Gagal',
            response.body['message'] ?? 'Terjadi kesalahan saat registrasi',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
        }
      } else {
        String errorMessage = 'Terjadi kesalahan saat registrasi';

        if (response.body != null && response.body is Map) {
          errorMessage = response.body['message'] ?? errorMessage;
        }

        Get.snackbar(
          'Registrasi Gagal',
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
        'Registrasi Gagal',
        'Terjadi kesalahan saat registrasi: ${e.toString()}',
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

  void _clearForm() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
  }
}
