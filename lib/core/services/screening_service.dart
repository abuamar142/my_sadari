import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../app/modules/screening/models/screening_data_model.dart';
import '../../app/modules/screening/models/screening_list_model.dart';
import '../models/api_response_model.dart';

class ScreeningService extends GetxService {
  final GetConnect _connect = GetConnect();
  final GetStorage _storage = GetStorage();

  static const String _baseUrl = 'https://sadari.sdnusabali.online/api';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${_storage.read('auth_token')}',
    'Content-Type': 'application/json',
  };

  /// Get existing screening data for current user
  Future<ApiResponseModel<ScreeningListResponse>> getScreeningList({
    required String userId,
    int page = 1,
    int pageSize = 1,
  }) async {
    try {
      final response = await _connect.request(
        '$_baseUrl/screening_cancer',
        'GET',
        body: {
          'page': page,
          'pageSize': pageSize,
          'filter': {'id_user': userId},
        },
        headers: _headers,
      );

      if (kDebugMode) {
        print('Get screening list response: ${response.statusCode}');
        print('Get screening list body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final screeningListResponse = ScreeningListResponse.fromJson(
          response.body,
        );
        return ApiResponseModel<ScreeningListResponse>(
          success: screeningListResponse.success,
          message: 'Data berhasil diambil',
          data: screeningListResponse,
        );
      } else {
        return ApiResponseModel<ScreeningListResponse>(
          success: false,
          message: 'Gagal mengambil data: ${response.statusText}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting screening list: $e');
      }
      return ApiResponseModel<ScreeningListResponse>(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  /// Create new screening data
  Future<ApiResponseModel<ScreeningDataModel>> createScreening(
    ScreeningDataModel data,
  ) async {
    try {
      final response = await _connect.post(
        '$_baseUrl/screening_cancer',
        data.toJson(),
        headers: _headers,
      );

      if (kDebugMode) {
        print('Create screening response: ${response.statusCode}');
        print('Create screening body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponseModel<ScreeningDataModel>.fromJson(
          response.body,
          (data) => ScreeningDataModel.fromJson(data),
        );
        return apiResponse;
      } else {
        return ApiResponseModel<ScreeningDataModel>(
          success: false,
          message: 'Gagal mengirim data: ${response.statusText}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating screening: $e');
      }
      return ApiResponseModel<ScreeningDataModel>(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  /// Update existing screening data
  Future<ApiResponseModel<ScreeningDataModel>> updateScreening(
    String screeningId,
    ScreeningDataModel data,
  ) async {
    try {
      final response = await _connect.put(
        '$_baseUrl/screening_cancer/$screeningId',
        data.toJson(),
        headers: _headers,
      );

      if (kDebugMode) {
        print('Update screening response: ${response.statusCode}');
        print('Update screening body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final apiResponse = ApiResponseModel<ScreeningDataModel>.fromJson(
          response.body,
          (data) => ScreeningDataModel.fromJson(data),
        );
        return apiResponse;
      } else {
        return ApiResponseModel<ScreeningDataModel>(
          success: false,
          message: 'Gagal memperbarui data: ${response.statusText}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating screening: $e');
      }
      return ApiResponseModel<ScreeningDataModel>(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  /// Submit screening data (create or update based on existing data)
  Future<ApiResponseModel<ScreeningDataModel>> submitScreening({
    required ScreeningDataModel data,
    String? existingScreeningId,
  }) async {
    if (existingScreeningId != null) {
      return await updateScreening(existingScreeningId, data);
    } else {
      return await createScreening(data);
    }
  }
}
