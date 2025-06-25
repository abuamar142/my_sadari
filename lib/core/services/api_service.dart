import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../app/data/models/api_response.dart';
import '../../../app/widgets/app_snackbar.dart';
import 'environment_service.dart';

enum HttpMethod { get, post, put, patch, delete }

class ApiService extends GetxService {
  late EnvironmentService _environmentService;
  late http.Client _client;

  // Auth token
  String? _authToken;

  @override
  void onInit() {
    super.onInit();
    _environmentService = Get.find<EnvironmentService>();
    _client = http.Client();
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  /// Get current auth token
  String? get authToken => _authToken;

  /// Generic method for making API calls
  Future<ApiResponse<T>> makeRequest<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = false,
    Duration? timeout,
  }) async {
    try {
      // Build URL
      final baseUrl = _environmentService.baseUrl;
      final uri = Uri.parse('$baseUrl$endpoint');
      final finalUri =
          queryParameters != null
              ? uri.replace(queryParameters: queryParameters)
              : uri;

      // Build headers
      final finalHeaders = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      // Add auth token if required or available
      if (requiresAuth || _authToken != null) {
        if (_authToken == null) {
          throw Exception('Authentication token required but not available');
        }
        finalHeaders['Authorization'] = 'Bearer $_authToken';
      }

      // Log request if enabled
      if (_environmentService.enableLogging) {
        _logRequest(method, finalUri, finalHeaders, body);
      }

      // Make request
      late http.Response response;
      final requestTimeout = timeout ?? const Duration(seconds: 30);

      switch (method) {
        case HttpMethod.get:
          response = await _client
              .get(finalUri, headers: finalHeaders)
              .timeout(requestTimeout);
          break;
        case HttpMethod.post:
          response = await _client
              .post(
                finalUri,
                headers: finalHeaders,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(requestTimeout);
          break;
        case HttpMethod.put:
          response = await _client
              .put(
                finalUri,
                headers: finalHeaders,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(requestTimeout);
          break;
        case HttpMethod.patch:
          response = await _client
              .patch(
                finalUri,
                headers: finalHeaders,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(requestTimeout);
          break;
        case HttpMethod.delete:
          response = await _client
              .delete(finalUri, headers: finalHeaders)
              .timeout(requestTimeout);
          break;
      }

      // Log response if enabled
      if (_environmentService.enableLogging) {
        _logResponse(response);
      }

      // Parse response
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      _showErrorSnackbar('Tidak ada koneksi internet');
      return ApiResponse<T>(
        success: false,
        message: 'Tidak ada koneksi internet',
      );
    } on HttpException catch (e) {
      _showErrorSnackbar('HTTP Error: ${e.message}');
      return ApiResponse<T>(
        success: false,
        message: 'HTTP Error: ${e.message}',
      );
    } on FormatException {
      _showErrorSnackbar('Format response tidak valid');
      return ApiResponse<T>(
        success: false,
        message: 'Format response tidak valid',
      );
    } catch (e) {
      final errorMessage = e.toString();
      _showErrorSnackbar('Terjadi kesalahan: $errorMessage');
      return ApiResponse<T>(
        success: false,
        message: 'Terjadi kesalahan: $errorMessage',
      );
    }
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final statusCode = response.statusCode;

    // Debug: Log response body
    if (_environmentService.enableLogging) {
      print('Response Status: $statusCode');
      print('Response Body: ${response.body}');
    }

    try {
      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      if (statusCode >= 200 && statusCode < 300) {
        // Success response
        return ApiResponse<T>.fromJson(responseBody, fromJson);
      } else {
        // Error response
        final errorMessage = responseBody['message'] ?? 'Terjadi kesalahan';
        _showErrorSnackbar(errorMessage);

        return ApiResponse<T>(
          success: false,
          message: errorMessage,
          errors: responseBody['errors'],
        );
      }
    } catch (e) {
      // If response body is not valid JSON
      final errorMessage = 'JSON parsing error: $e (HTTP $statusCode)';
      if (_environmentService.enableLogging) {
        print('JSON Parse Error: $e');
        print('Response Body: ${response.body}');
      }
      _showErrorSnackbar(errorMessage);

      return ApiResponse<T>(success: false, message: errorMessage);
    }
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    AppSnackbar.error(title: 'Error', message: message);
  }

  /// Log request details
  void _logRequest(
    HttpMethod method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    if (kDebugMode) {
      print('🚀 API Request:');
      print('   Method: ${method.name.toUpperCase()}');
      print('   URL: $uri');
      print('   Headers: $headers');
      if (body != null) {
        print('   Body: ${json.encode(body)}');
      }
      print('');
    }
  }

  /// Log response details
  void _logResponse(http.Response response) {
    if (kDebugMode) {
      print('📥 API Response:');
      print('   Status: ${response.statusCode}');
      print('   Headers: ${response.headers}');
      print('   Body: ${response.body}');
      print('');
    }
  }

  // Convenience methods for common HTTP operations

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = false,
    Duration? timeout,
  }) {
    return makeRequest<T>(
      endpoint: endpoint,
      method: HttpMethod.get,
      headers: headers,
      queryParameters: queryParameters,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
      timeout: timeout,
    );
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = false,
    Duration? timeout,
  }) {
    return makeRequest<T>(
      endpoint: endpoint,
      method: HttpMethod.post,
      body: body,
      headers: headers,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
      timeout: timeout,
    );
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = false,
    Duration? timeout,
  }) {
    return makeRequest<T>(
      endpoint: endpoint,
      method: HttpMethod.put,
      body: body,
      headers: headers,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
      timeout: timeout,
    );
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = false,
    Duration? timeout,
  }) {
    return makeRequest<T>(
      endpoint: endpoint,
      method: HttpMethod.patch,
      body: body,
      headers: headers,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
      timeout: timeout,
    );
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = false,
    Duration? timeout,
  }) {
    return makeRequest<T>(
      endpoint: endpoint,
      method: HttpMethod.delete,
      headers: headers,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
      timeout: timeout,
    );
  }
}
