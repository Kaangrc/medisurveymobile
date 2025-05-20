import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../services/doctor_service.dart';

class DoctorProvider extends ChangeNotifier {
  final DoctorService _doctorService;
  List<DoctorModel> _doctors = [];
  DoctorModel? _currentDoctor;
  bool _isLoading = false;
  String? _errorMessage;

  DoctorProvider(this._doctorService);

  List<DoctorModel> get doctors => _doctors;
  DoctorModel? get currentDoctor => _currentDoctor;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDoctors() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _doctors = await _doctorService.getAllDoctors();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCurrentDoctor() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentDoctor = await _doctorService.getCurrentDoctorInfo();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _doctorService.login(email, password);
      if (result['status'] == 'success') {
        await loadCurrentDoctor();
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return {'status': 'error', 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addDoctor(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _doctorService.addDoctor(data);
      if (result['status'] == 'success') {
        await loadDoctors();
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return {'status': 'error', 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateDoctor(
      String doctorId, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _doctorService.updateDoctor(doctorId, data);
      if (result['status'] == 'success') {
        await loadDoctors();
        if (_currentDoctor?.id == doctorId) {
          await loadCurrentDoctor();
        }
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return {'status': 'error', 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _doctorService.logout();
      _currentDoctor = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
