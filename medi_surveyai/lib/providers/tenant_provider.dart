import 'package:flutter/material.dart';
import '../models/tenant_model.dart';
import '../services/tenant_service.dart';

class TenantProvider extends ChangeNotifier {
  final TenantService _tenantService;
  TenantModel? _currentTenant;
  bool _isLoading = false;
  String? _errorMessage;

  TenantProvider(this._tenantService);

  TenantModel? get currentTenant => _currentTenant;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCurrentTenant() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentTenant = await _tenantService.getCurrentTenantInfo();
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

      final result = await _tenantService.login(email, password);
      if (result['status'] == 'success') {
        await loadCurrentTenant();
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

  Future<Map<String, dynamic>> updateTenant(
      String tenantId, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _tenantService.updateTenant(tenantId, data);
      if (result['status'] == 'success') {
        await loadCurrentTenant();
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

      await _tenantService.logout();
      _currentTenant = null;
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
