import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/dio_client.dart';
import '../models/doctor_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class DoctorService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage;
  final AuthService _authService;
  final bool _isDebugMode;

  DoctorService({
    required DioClient dioClient,
    required FlutterSecureStorage storage,
    required AuthService authService,
    bool isDebugMode = false,
  })  : _dioClient = dioClient,
        _storage = storage,
        _authService = authService,
        _isDebugMode = isDebugMode;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      return await _authService.login(
        email: email,
        password: password,
        role: UserRole.doctor,
      );
    } catch (e) {
      _logError('Login error', e);
      return _handleError(e);
    }
  }

  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final response = await _dioClient.get('doctors');
      return response.data is List
          ? (response.data as List)
              .map((json) => DoctorModel.fromJson(json))
              .toList()
          : [];
    } catch (e) {
      _logError('Get all doctors error', e);
      rethrow;
    }
  }

  Future<DoctorModel?> getCurrentDoctorInfo() async {
    try {
      final response = await _dioClient.get('doctors/me');
      return response.data is Map<String, dynamic>
          ? DoctorModel.fromJson(response.data)
          : null;
    } catch (e) {
      _logError('Get current doctor info error', e);
      return null;
    }
  }

  Future<Map<String, dynamic>> addDoctor(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post('doctors', data: data);
      return {
        'status': 'success',
        'message': 'Doktor başarıyla eklendi',
        'data': response.data
      };
    } catch (e) {
      _logError('Add doctor error', e);
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateDoctor(
      String doctorId, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.put('doctors/$doctorId', data: data);
      return {
        'status': 'success',
        'message': 'Doktor başarıyla güncellendi',
        'data': response.data
      };
    } catch (e) {
      _logError('Update doctor error', e);
      return _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      _logError('Logout error', e);
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      return await _authService.isAuthenticated();
    } catch (e) {
      _logError('Authentication check error', e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getTokenData() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) return null;
      return jsonDecode(token) as Map<String, dynamic>;
    } catch (e) {
      _logError('Get token data error', e);
      return null;
    }
  }

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
