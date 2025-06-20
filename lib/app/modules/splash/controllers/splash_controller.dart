import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  late final AuthService _authService;
  final RxString appVersion = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _initApp();
  }

  Future<void> _initApp() async {
    await _initPackageInfo();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(const Duration(milliseconds: 2000), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    if (kDebugMode) {
      print('Splash: Checking user authentication...');
    }
    _checkUserAuthentication();
  }

  void _checkUserAuthentication() {
    final isLoggedIn = _authService.isLoggedIn;
    if (kDebugMode) {
      print('Splash: User logged in status: $isLoggedIn');
    }

    if (isLoggedIn) {
      // User is logged in, go to home
      Get.offAllNamed(Routes.home);
    } else {
      // User is not logged in, go to sign in
      Get.offAllNamed(Routes.signIn);
    }
  }

  Future<void> _initPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = 'v${packageInfo.version}';
    } catch (e) {
      appVersion.value = '1.0.0';
    }
  }
}
