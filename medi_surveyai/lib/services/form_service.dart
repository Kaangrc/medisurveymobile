// lib/services/form_service.dart
/*
import '../core/network/dio_client.dart';
import '../models/form_model.dart';
import '../models/form_answer_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FormService {
  final DioClient _dioClient;

  FormService() : _dioClient = DioClient(storage: const FlutterSecureStorage());

  // Form Ekleme (Token gerektirir)
  Future<bool> addForm(FormModel form, String token) async {
    try {
      final response = await _dioClient.post(
        'forms',
        data: form.toJson(),
      );
      return response['status'] == 'success';
    } catch (e) {
      print('Form eklenirken hata: $e');
      return false;
    }
  }

  // Tüm Formları Getir (Token gerektirir)
  Future<List<FormModel>?> getAllForms(String token) async {
    try {
      final response = await _dioClient.get('forms');
      return (response['data'] as List)
          .map((form) => FormModel.fromJson(form))
          .toList();
    } catch (e) {
      print('Tüm formlar alınırken hata: $e');
      return null;
    }
  }

  // Tenant'a Ait Tüm Formları Getir (Token gerektirir)
  Future<List<FormModel>?> getAllFormTenant(String token) async {
    try {
      final response = await _dioClient.get('forms/tenant/all');
      return (response['data'] as List)
          .map((form) => FormModel.fromJson(form))
          .toList();
    } catch (e) {
      print('Tenant form bilgileri alınırken hata: $e');
      return null;
    }
  }

  // Form Bilgisi Getir (Token gerektirir)
  Future<FormModel?> getFormInfo(String formId, String token) async {
    try {
      final response = await _dioClient.get('forms/$formId');
      return FormModel.fromJson(response['data']);
    } catch (e) {
      print('Form bilgisi alınırken hata: $e');
      return null;
    }
  }

  // Tenant'a Ait Form Bilgisi Getir (Token gerektirir)
  Future<FormModel?> getFormInfoTenant(String formId, String token) async {
    try {
      final response = await _dioClient.get('forms/tenant/$formId');
      return FormModel.fromJson(response['data']);
    } catch (e) {
      print('Tenant form bilgisi alınırken hata: $e');
      return null;
    }
  }

  // Form Cevaplarını Getir (Token gerektirir)
  Future<List<FormAnswerModel>?> getAllFormAnswers(String token) async {
    try {
      final response = await _dioClient.get('form-answers');
      return (response['data'] as List)
          .map((answer) => FormAnswerModel.fromJson(answer))
          .toList();
    } catch (e) {
      print('Form cevapları alınırken hata: $e');
      return null;
    }
  }

  // Tenant'a Ait Tüm Form Cevaplarını Getir (Token gerektirir)
  Future<List<FormAnswerModel>?> getAllFormAnswersTenant(String token) async {
    try {
      final response = await _dioClient.get('form-answers/tenant/all');
      return (response['data'] as List)
          .map((answer) => FormAnswerModel.fromJson(answer))
          .toList();
    } catch (e) {
      print('Tenant form cevapları alınırken hata: $e');
      return null;
    }
  }

  // Form Cevap Bilgisi Getir (Token gerektirir)
  Future<FormAnswerModel?> getFormAnswerInfo(
      String answerId, String token) async {
    try {
      final response = await _dioClient.get('form-answers/$answerId');
      return FormAnswerModel.fromJson(response['data']);
    } catch (e) {
      print('Form cevabı bilgisi alınırken hata: $e');
      return null;
    }
  }

  // Tenant'a Ait Form Cevap Bilgisi Getir (Token gerektirir)
  Future<FormAnswerModel?> getFormAnswerInfoTenant(
      String answerId, String token) async {
    try {
      final response = await _dioClient.get('form-answers/tenant/$answerId');
      return FormAnswerModel.fromJson(response['data']);
    } catch (e) {
      print('Tenant form cevabı bilgisi alınırken hata: $e');
      return null;
    }
  }

  // Form Cevabı Ekleme (Token gerektirir)
  Future<bool> addFormAnswer(FormAnswerModel answer, String token) async {
    try {
      final response = await _dioClient.post(
        'form-answers',
        data: answer.toJson(),
      );
      return response['status'] == 'success';
    } catch (e) {
      print('Form cevabı eklenirken hata: $e');
      return false;
    }
  }
}
*/