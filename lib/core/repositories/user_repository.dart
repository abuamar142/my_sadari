import 'package:get/get.dart';

import '../../app/data/models/api_response.dart';
import '../../app/data/models/user_model.dart';
import '../services/api_service.dart';

/// User Repository - Contoh penggunaan API Service
class UserRepository extends GetxService {
  late ApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
  }

  /// Get user profile (requires authentication)
  Future<ApiResponse<User>> getUserProfile() async {
    return await _apiService.get<User>(
      '/api/user/profile',
      fromJson: (json) => User.fromJson(json),
      requiresAuth: true,
    );
  }

  /// Update user profile
  Future<ApiResponse<User>> updateUserProfile(
    Map<String, dynamic> userData,
  ) async {
    return await _apiService.put<User>(
      '/api/user/profile',
      body: userData,
      fromJson: (json) => User.fromJson(json),
      requiresAuth: true,
    );
  }

  /// Get all users (admin only)
  Future<ApiResponse<List<User>>> getAllUsers({
    int? page,
    int? limit,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    return await _apiService.get<List<User>>(
      '/api/users',
      queryParameters: queryParams,
      fromJson: (json) {
        if (json['data'] is List) {
          return (json['data'] as List)
              .map((userJson) => User.fromJson(userJson))
              .toList();
        }
        return [];
      },
      requiresAuth: true,
    );
  }

  /// Delete user account
  Future<ApiResponse<Map<String, dynamic>>> deleteUserAccount(
    String userId,
  ) async {
    return await _apiService.delete<Map<String, dynamic>>(
      '/api/user/$userId',
      requiresAuth: true,
    );
  }

  /// Upload user avatar
  Future<ApiResponse<Map<String, dynamic>>> uploadAvatar(
    String filePath,
  ) async {
    // Note: For file upload, you might need to modify the API service
    // or create a separate method for multipart requests
    return await _apiService.post<Map<String, dynamic>>(
      '/api/user/avatar',
      body: {'avatar_path': filePath},
      requiresAuth: true,
    );
  }

  /// Change password
  Future<ApiResponse<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/api/user/change-password',
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
      requiresAuth: true,
    );
  }

  /// Reset password (forgot password)
  Future<ApiResponse<Map<String, dynamic>>> resetPassword(String email) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/api/auth/reset-password',
      body: {'email': email},
    );
  }

  /// Verify email
  Future<ApiResponse<Map<String, dynamic>>> verifyEmail(String token) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/api/auth/verify-email',
      body: {'token': token},
    );
  }
}
