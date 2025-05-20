import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final String _baseUrl;
  final bool _isDebugMode;

  DioClient({
    required String baseUrl,
    required FlutterSecureStorage storage,
    bool isDebugMode = false,
  })  : _baseUrl = baseUrl,
        _storage = storage,
        _isDebugMode = isDebugMode,
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
  }

  Future<void> _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        final tokenData = jsonDecode(token) as Map<String, dynamic>;
        options.headers['Authorization'] = 'Bearer ${tokenData['token']}';
      }
      handler.next(options);
    } catch (e) {
      if (_isDebugMode) {
        print('[log] Request error: $e');
      }
      handler.next(options);
    }
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isDebugMode) {
      print('[log] Response: ${response.statusCode} - ${response.data}');
    }
    handler.next(response);
  }

  void _onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isDebugMode) {
      print('[log] Error: ${err.message}');
      if (err.response != null) {
        print('[log] Error response: ${err.response?.data}');
      }
    }
    handler.next(err);
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      _logError('GET request error', e);
      rethrow;
    }
  }

  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path,
          data: data, queryParameters: queryParameters);
    } catch (e) {
      _logError('POST request error', e);
      rethrow;
    }
  }

  Future<Response> put(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      _logError('PUT request error', e);
      rethrow;
    }
  }

  Future<Response> delete(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path,
          data: data, queryParameters: queryParameters);
    } catch (e) {
      _logError('DELETE request error', e);
      rethrow;
    }
  }

  void _logError(String message, dynamic error) {
    if (_isDebugMode) {
      print('[log] $message: $error');
    }
  }
}
