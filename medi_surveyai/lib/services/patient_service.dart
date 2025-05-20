import 'package:dio/dio.dart';
import 'dart:convert';
import '../core/network/dio_client.dart';
import '../models/patient_model.dart';

class PatientService {
  final DioClient _dioClient;
  final bool _isDebugMode;

  PatientService({
    required DioClient dioClient,
    bool isDebugMode = false,
  })  : _dioClient = dioClient,
        _isDebugMode = isDebugMode;

  // ================ HASTA İŞLEMLERİ ================

  Future<List<PatientModel>> getAllPatients() async {
    try {
      final response = await _dioClient.get('patients');
      return response.data is List
          ? (response.data as List)
              .map((json) => PatientModel.fromJson(json))
              .toList()
          : [];
    } catch (e) {
      _logError('Get all patients error', e);
      rethrow;
    }
  }

  Future<PatientModel?> getPatientInfo(String patientId) async {
    try {
      final response = await _dioClient.get('patients/$patientId');
      return response.data is Map<String, dynamic>
          ? PatientModel.fromJson(response.data)
          : null;
    } catch (e) {
      _logError('Get patient info error', e);
      return null;
    }
  }

  Future<Map<String, dynamic>> addPatient(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post('patients', data: data);
      return {
        'status': 'success',
        'message': 'Hasta başarıyla eklendi',
        'data': response.data
      };
    } catch (e) {
      _logError('Add patient error', e);
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updatePatient(
      String patientId, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.put('patients/$patientId', data: data);
      return {
        'status': 'success',
        'message': 'Hasta başarıyla güncellendi',
        'data': response.data
      };
    } catch (e) {
      _logError('Update patient error', e);
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deletePatient(String patientId) async {
    try {
      await _dioClient.delete('patients/$patientId');
      return {
        'status': 'success',
        'message': 'Hasta başarıyla silindi',
      };
    } catch (e) {
      _logError('Delete patient error', e);
      return _handleError(e);
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
