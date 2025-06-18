import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controllers/auth_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/graphql_provider.dart';
import '../../../routes/app_pages.dart';

class SignInController extends GetxController {
  var hidePassword = true.obs;
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var user = Rxn<User>();

  void toggleVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  final String loginMutation = """
    mutation Login(\$input: LoginInput) {
      Login(input: \$input) {
        token
        user {
          name
          sisa_cuti
        }
      }
    }
  """;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email dan password tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading(true);

    try {
      final result = await GraphQLService.mutate(
        loginMutation,
        variables: {
          "input": {
            "password": passwordController.text,
            "email_or_username": emailController.text,
            "access_via": "mobile_app",
          },
        },
      ).timeout(Duration(seconds: 15));

      isLoading(false);

      if (result.hasException) {
        final errorMessage =
            result.exception?.graphqlErrors.first.message ??
            "Terjadi kesalahan saat login";
        Get.snackbar("Error", errorMessage, snackPosition: SnackPosition.BOTTOM);
        // if (kDebugMode) {
        //   print("Exception: ${result.exception}");
        // }
      } else {
        final data = result.data?['Login'];
        if (data != null) {
          final token = data['token'] as String;
          final userData = data['user'] as Map<String, dynamic>;
          final user = User.fromJson(userData);

          // Simpan token dan user ke GetStorage
          final box = GetStorage();
          box.write('token', token);

          // Setel user di AuthController
          AuthController.to.setUser(user);

          // if (kDebugMode) {
          //   print('LoginController: token saved: $token');
          //   print('LoginController: user saved: ${user.toJson()}');
          //   print('LoginController: storage user: ${box.read('user')}');
          // }

          Get.snackbar("Success", "Login Berhasil!", snackPosition: SnackPosition.BOTTOM);

          Get.offAllNamed(Routes.home);
        } else {
          Get.snackbar(
            "Error",
            "Data login tidak ditemukan",
            snackPosition: SnackPosition.BOTTOM,
          );
          // if (kDebugMode) {
          //   print("Data login null");
          // }
        }
      }
    } on TimeoutException catch (_) {
      isLoading(false);
      Get.snackbar(
        "Error",
        "Permintaan ke server timeout, coba lagi nanti",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading(false);
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      // if (kDebugMode) {
      //   print("Caught error: $e");
      // }
    }
  }
}
