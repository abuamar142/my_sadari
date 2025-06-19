import 'user_model.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? token;
  final bool? infiniteToken;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.token,
    this.infiniteToken,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null && fromJsonT != null
              ? fromJsonT(json['data'])
              : json['data'],
      token: json['token'],
      infiniteToken: json['infinite_token'],
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'token': token,
      'infinite_token': infiniteToken,
      'errors': errors,
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final bool infiniteToken;
  final String token;
  final User data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.infiniteToken,
    required this.token,
    required this.data,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      return LoginResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        infiniteToken: json['infinite_token'] ?? false,
        token: json['token'] ?? '',
        data: User.fromJson(json['data'] ?? {}),
      );
    } catch (e) {
      print('Error parsing LoginResponse: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'infinite_token': infiniteToken,
      'token': token,
      'data': data.toJson(),
    };
  }
}
