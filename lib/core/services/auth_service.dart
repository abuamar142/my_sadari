import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../app/data/models/api_response.dart';
import '../../app/data/models/user_model.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  late ApiService _apiService;
  late GetStorage _storage;

  // Reactive variables
  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoggedIn = false.obs;
  final RxBool _isLoading = false.obs;

  // Getters
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isLoading => _isLoading.value;

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _infiniteTokenKey = 'infinite_token';

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    _storage = GetStorage();

    // Check if user is already logged in
    _loadStoredAuth();
  }

  /// Load stored authentication data
  void _loadStoredAuth() {
    final storedToken = _storage.read<String>(_tokenKey);
    final storedUserData = _storage.read<Map<String, dynamic>>(_userKey);

    if (storedToken != null && storedUserData != null) {
      try {
        _apiService.setAuthToken(storedToken);
        _currentUser.value = User.fromJson(storedUserData);
        _isLoggedIn.value = true;
      } catch (e) {
        // Clear invalid stored data
        _clearStoredAuth();
      }
    }
  }

  /// Clear stored authentication data
  void _clearStoredAuth() {
    _storage.remove(_tokenKey);
    _storage.remove(_userKey);
    _storage.remove(_infiniteTokenKey);
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
    bool infiniteToken = true,
  }) async {
    try {
      _isLoading.value = true;
      final response = await _apiService.post<LoginResponse>(
        '/api/login',
        body: {
          'email': email,
          'password': password,
          'infinite_token': infiniteToken,
        },
        fromJson: (json) => LoginResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        final loginData = response.data!;

        // Store auth data
        await _storage.write(_tokenKey, loginData.token);
        await _storage.write(_userKey, loginData.data.toJson());
        await _storage.write(_infiniteTokenKey, loginData.infiniteToken);

        // Set auth token in API service
        _apiService.setAuthToken(loginData.token);

        // Update reactive variables
        _currentUser.value = loginData.data;
        _isLoggedIn.value = true;

        // Show success message
        Get.snackbar(
          'Login Berhasil',
          'Selamat datang, ${loginData.data.name}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );

        return true;
      } else {
        // Error is already handled by API service (snackbar shown)
        return false;
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
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _isLoading.value = true;

      // Optional: Call logout API endpoint if available
      // await _apiService.post('/api/logout', requiresAuth: true);

      // Clear local auth data
      _clearStoredAuth();
      _apiService.clearAuthToken();

      // Reset reactive variables
      _currentUser.value = null;
      _isLoggedIn.value = false;

      // Show success message
      Get.snackbar(
        'Logout Berhasil',
        'Anda telah berhasil keluar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      Get.snackbar(
        'Logout Gagal',
        'Terjadi kesalahan saat logout: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Register new user (if API supports it)
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String username,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _isLoading.value = true;

      final requestBody = {
        'email': email,
        'password': password,
        'name': name,
        'username': username,
        ...?additionalData,
      };

      final response = await _apiService.post<User>(
        '/api/register',
        body: requestBody,
        fromJson: (json) => User.fromJson(json),
      );

      if (response.success) {
        Get.snackbar(
          'Registrasi Berhasil',
          'Akun berhasil dibuat. Silakan login.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return true;
      } else {
        return false;
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
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Check if token is valid (optional method for token validation)
  Future<bool> validateToken() async {
    if (!_isLoggedIn.value) return false;

    try {
      final response = await _apiService.get<User>(
        '/api/user/profile',
        fromJson: (json) => User.fromJson(json),
        requiresAuth: true,
      );

      if (response.success && response.data != null) {
        // Update user data if needed
        _currentUser.value = response.data!;
        await _storage.write(_userKey, response.data!.toJson());
        return true;
      } else {
        // Token is invalid, logout
        await logout();
        return false;
      }
    } catch (e) {
      // Token validation failed, logout
      await logout();
      return false;
    }
  }

  /// Refresh token (if API supports it)
  Future<bool> refreshToken() async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/refresh-token',
        requiresAuth: true,
      );

      if (response.success && response.token != null) {
        // Update stored token
        await _storage.write(_tokenKey, response.token!);
        _apiService.setAuthToken(response.token!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
