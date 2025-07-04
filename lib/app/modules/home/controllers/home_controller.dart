import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';

class HomeController extends GetxController {
  late AuthService _authService;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  /// Logout user and navigate to sign in
  Future<void> logout() async {
    await _authService.logout();

    // Show success message
    AppSnackbar.success(
      title: 'Logout Berhasil',
      message: 'Anda telah berhasil keluar',
      duration: const Duration(seconds: 2),
    );

    // Navigate to sign in page after logout
    Get.offAllNamed(Routes.signIn);
  }

  /// Check if user is logged in
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Get current user data
  String get userName => _authService.userName;
  String get userEmail => _authService.userEmail;

  void increment() => count.value++;
}
