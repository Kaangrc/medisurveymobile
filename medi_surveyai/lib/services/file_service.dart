// lib/services/file_service.dart
/*
import '../core/network/dio_client.dart';
import '../models/file_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
*/

import 'package:dio/dio.dart';
import 'dart:convert';
import '../core/network/dio_client.dart';
import '../models/file_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_service.dart';

class FileService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage;
  final AuthService _authService;
  final bool _isDebugMode;

  FileService({
    required DioClient dioClient,
    required FlutterSecureStorage storage,
    required AuthService authService,
    bool isDebugMode = false,
  })  : _dioClient = dioClient,
        _storage = storage,
        _authService = authService,
        _isDebugMode = isDebugMode;

  // ================ DOSYA İŞLEMLERİ ================

  Future<Map<String, dynamic>> addFile(String name) async {
    try {
      final response = await _dioClient.post('files', data: {'name': name});
      return {
        'status': 'success',
        'message': 'Dosya başarıyla eklendi',
        'data': response.data
      };
    } catch (e) {
      _logError('Add file error', e);
      return _handleError(e);
    }
  }

  Future<List<FileModel>> getAllFiles() async {
    try {
      final response = await _dioClient.get('files');
      return response.data is List
          ? (response.data as List)
              .map((file) => FileModel.fromJson(file))
              .toList()
          : [];
    } catch (e) {
      _logError('Get all files error', e);
      rethrow;
    }
  }

  Future<List<FileModel>> getAllFileTenant() async {
    try {
      final response = await _dioClient.get('files/tenant/all');
      return response.data is List
          ? (response.data as List)
              .map((file) => FileModel.fromJson(file))
              .toList()
          : [];
    } catch (e) {
      _logError('Get all tenant files error', e);
      rethrow;
    }
  }

  Future<FileModel?> getFileInfo(String fileId) async {
    try {
      final response = await _dioClient.get('files/$fileId');
      return response.data is Map<String, dynamic>
          ? FileModel.fromJson(response.data)
          : null;
    } catch (e) {
      _logError('Get file info error', e);
      return null;
    }
  }

  Future<FileModel?> getFileInfoTenant(String fileId) async {
    try {
      final response = await _dioClient.get('files/tenant/$fileId');
      return response.data is Map<String, dynamic>
          ? FileModel.fromJson(response.data)
          : null;
    } catch (e) {
      _logError('Get tenant file info error', e);
      return null;
    }
  }

  Future<void> deleteFile(String fileId) async {
    try {
      await _dioClient.delete('files/$fileId');
    } catch (e) {
      _logError('Delete file error', e);
      rethrow;
    }
  }

  // ================ YARDIMCI FONKSİYONLAR ================

  void _logError(String message, dynamic error) {
    if (_isDebugMode) {
      print('[log] $message: $error');
    }
  }

  Map<String, dynamic> _handleError(dynamic e) {
    if (e is! DioException) {
      return {'status': 'error', 'message': 'Beklenmeyen bir hata oluştu'};
    }

    final responseData = e.response?.data;
    String errorMessage = 'İşlem sırasında bir hata oluştu';

    if (responseData is Map<String, dynamic>) {
      errorMessage =
          responseData['message'] ?? responseData['error'] ?? errorMessage;
    } else if (responseData is String) {
      try {
        final decodedData = jsonDecode(responseData) as Map<String, dynamic>;
        errorMessage =
            decodedData['message'] ?? decodedData['error'] ?? errorMessage;
      } catch (_) {
        errorMessage = responseData;
      }
    }

    return {'status': 'error', 'message': errorMessage};
  }
}
