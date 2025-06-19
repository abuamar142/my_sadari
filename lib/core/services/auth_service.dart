import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';

class AuthService extends GetxService {
  late GetStorage _storage;

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoggedIn = false.obs;

  // Getters
  UserModel? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get userName => _currentUser.value?.name ?? 'Sahabat SADARI';
  String get userEmail => _currentUser.value?.email ?? 'guest@sadari.com';

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
    _loadStoredAuth();
  }

  /// Load stored authentication data
  void _loadStoredAuth() {
    final storedToken = _storage.read<String>(_tokenKey);
    final storedUserJson = _storage.read<String>(_userKey);

    if (storedToken != null && storedUserJson != null) {
      try {
        final Map<String, dynamic> userMap = json.decode(storedUserJson);
        _currentUser.value = UserModel.fromJson(userMap);
        _isLoggedIn.value = true;

        if (kDebugMode) {
          print('User loaded from storage: ${_currentUser.value?.name}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error loading user data: $e');
        }
        _clearStoredAuth();
      }
    }
  }

  /// Save user data after login
  Future<void> saveUserData(String token, UserModel user) async {
    await _storage.write(_tokenKey, token);
    await _storage.write(_userKey, json.encode(user.toJson()));

    _currentUser.value = user;
    _isLoggedIn.value = true;

    if (kDebugMode) {
      print('User data saved: ${user.name}');
    }
  }

  /// Clear stored authentication data
  Future<void> _clearStoredAuth() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);

    _currentUser.value = null;
    _isLoggedIn.value = false;
  }

  /// Logout user
  Future<void> logout() async {
    await _clearStoredAuth();
    if (kDebugMode) {
      print('User logged out');
    }
  }
}
