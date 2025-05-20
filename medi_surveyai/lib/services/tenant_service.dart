import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import '../core/network/dio_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_service.dart';
import '../models/tenant_model.dart';
import '../models/user_model.dart';

class TenantService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage;
  final AuthService _authService;
  final bool _isDebugMode;

  TenantService({
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
        role: UserRole.tenant,
      );
    } catch (e) {
      _logError('Login error', e);
      return _handleError(e);
    }
  }

  Future<TenantModel?> getCurrentTenantInfo() async {
    try {
      final response = await _dioClient.get('tenants/me');
      return response.data is Map<String, dynamic>
          ? TenantModel.fromJson(response.data)
          : null;
    } catch (e) {
      _logError('Get current tenant info error', e);
      return null;
    }
  }

  Future<Map<String, dynamic>> updateTenant(
      String tenantId, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.put('tenants/$tenantId', data: data);
      return {
        'status': 'success',
        'message': 'Kiracı bilgileri başarıyla güncellendi',
        'data': response.data
      };
    } catch (e) {
      _logError('Update tenant error', e);
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

  // ================ TENANT İŞLEMLERİ ================

  Future<List<TenantModel>> getAllTenants() async {
    try {
      final response = await _dioClient.get('tenants');
      return response.data is List
          ? (response.data as List)
              .map((json) => TenantModel.fromJson(json))
              .toList()
          : [];
    } catch (e) {
      _logError('Get all tenants error', e);
      rethrow;
    }
  }

  Future<TenantModel?> getTenantInfo(String tenantId) async {
    try {
      final response = await _dioClient.get('tenants/$tenantId');
      return response.data is Map<String, dynamic>
          ? TenantModel.fromJson(response.data)
          : null;
    } catch (e) {
      _logError('Get tenant info error', e);
      return null;
    }
  }

  Future<Map<String, dynamic>> deleteTenant(String tenantId) async {
    try {
      await _dioClient.delete('tenants/$tenantId');
      return {
        'status': 'success',
        'message': 'Tenant başarıyla silindi',
      };
    } catch (e) {
      _logError('Delete tenant error', e);
      return _handleError(e);
    }
  }

  // ================ ABONELİK İŞLEMLERİ ================

  Future<Map<String, dynamic>?> getTenantSubscription() async {
    try {
      final tokenData = await _authService.getTokenData();
      if (tokenData == null) return null;

      final role = _authService.getRoleFromToken(tokenData);
      if (role != UserRole.tenant) return null;

      final userId = tokenData['id'];
      if (userId == null) return null;

      final response = await _dioClient.get('tenants/$userId/subscription');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      _logError('Get tenant subscription error', e);
      return null;
    }
  }

  Future<Map<String, dynamic>> updateTenantSubscription(
      Map<String, dynamic> data) async {
    try {
      final tokenData = await _authService.getTokenData();
      if (tokenData == null) {
        throw Exception('Oturum bilgisi bulunamadı');
      }

      final role = _authService.getRoleFromToken(tokenData);
      if (role != UserRole.tenant) {
        throw Exception('Bu işlem için kurumsal yetki gerekiyor');
      }

      final userId = tokenData['id'];
      if (userId == null) {
        throw Exception('Kurum ID bulunamadı');
      }

      final response =
          await _dioClient.put('tenants/$userId/subscription', data: data);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      _logError('Update tenant subscription error', e);
      return _handleSubscriptionError(e);
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

  Map<String, dynamic> _handleSubscriptionError(dynamic e) {
    if (e is DioException) {
      final responseData = e.response?.data as Map<String, dynamic>?;
      return {
        'status': 'error',
        'message': responseData?['message'] ??
            'Abonelik güncellenirken bir hata oluştu'
      };
    }
    return {
      'status': 'error',
      'message': 'Abonelik güncellenirken beklenmeyen bir hata oluştu'
    };
  }
}
