import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/dio_client.dart';
import '../models/user_model.dart';

class AuthService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage;
  final bool _isDebugMode;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_info';
  static const Duration _tokenExpiration = Duration(days: 7);

  AuthService({
    required DioClient dioClient,
    required FlutterSecureStorage storage,
    bool isDebugMode = false,
  })  : _dioClient = dioClient,
        _storage = storage,
        _isDebugMode = isDebugMode;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email ve şifre boş olamaz');
      }

      final response = await _dioClient.post(
        'auth/login',
        data: {
          'email': email.trim(),
          'password': password.trim(),
          'role': role.toString().split('.').last,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Geçersiz yanıt formatı');
      }

      final token = response.data['token'] as String?;
      if (token == null) {
        throw Exception('Token alınamadı');
      }

      await _saveToken(token, role);
      await _saveUser(response.data['user'] as Map<String, dynamic>);

      return {
        'status': 'success',
        'message': 'Giriş başarılı',
        'data': response.data,
      };
    } catch (e) {
      _logError('Login error', e);
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw Exception('Tüm alanlar doldurulmalıdır');
      }

      if (password.length < 6) {
        throw Exception('Şifre en az 6 karakter olmalıdır');
      }

      final response = await _dioClient.post(
        'auth/register',
        data: {
          'email': email.trim(),
          'password': password.trim(),
          'name': name.trim(),
          'role': role.toString().split('.').last,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Geçersiz yanıt formatı');
      }

      final token = response.data['token'] as String?;
      if (token == null) {
        throw Exception('Token alınamadı');
      }

      await _saveToken(token, role);
      await _saveUser(response.data['user'] as Map<String, dynamic>);

      return {
        'status': 'success',
        'message': 'Kayıt başarılı',
        'data': response.data,
      };
    } catch (e) {
      _logError('Register error', e);
      return _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } catch (e) {
      _logError('Logout error', e);
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final tokenData = await getTokenData();
      if (tokenData == null) return false;

      final response = await _dioClient.get('auth/verify');
      return response.statusCode == 200;
    } catch (e) {
      _logError('Authentication check error', e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getTokenData() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null) return null;
      return jsonDecode(token) as Map<String, dynamic>;
    } catch (e) {
      _logError('Get token data error', e);
      return null;
    }
  }

  UserRole getRoleFromToken(Map<String, dynamic> tokenData) {
    try {
      final role = tokenData['role'] as String?;
      if (role == null) return UserRole.tenant;

      return UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == role,
        orElse: () => UserRole.tenant,
      );
    } catch (e) {
      _logError('Get role from token error', e);
      return UserRole.tenant;
    }
  }

  Future<void> _saveToken(String token, UserRole role) async {
    try {
      final tokenData = {
        'token': token,
        'role': role.toString().split('.').last,
        'expires_at': DateTime.now().add(_tokenExpiration).toIso8601String(),
      };
      await _storage.write(
        key: _tokenKey,
        value: jsonEncode(tokenData),
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
    } catch (e) {
      _logError('Save token error', e);
      rethrow;
    }
  }

  Future<void> _saveUser(Map<String, dynamic> userData) async {
    try {
      await _storage.write(
        key: _userKey,
        value: jsonEncode(userData),
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
    } catch (e) {
      _logError('Save user error', e);
      rethrow;
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
