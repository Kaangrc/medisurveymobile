import 'package:flutter/material.dart';
import '../services/tenant_service.dart';
import '../services/auth_service.dart';
import '../core/network/dio_client.dart';
import '../models/tenant_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TenantsView extends StatefulWidget {
  const TenantsView({super.key});

  @override
  State<TenantsView> createState() => _TenantsViewState();
}

class _TenantsViewState extends State<TenantsView> {
  late TenantService _tenantService;
  bool _isLoading = false;
  String? _errorMessage;
  List<TenantModel> _tenants = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadTenants();
  }

  void _initializeServices() {
    final storage = const FlutterSecureStorage();
    final dioClient = DioClient(storage: storage);
    final authService = AuthService(
      dioClient: dioClient,
      storage: storage,
      isDebugMode: true,
    );
    _tenantService = TenantService(
      dioClient: dioClient,
      storage: storage,
      authService: authService,
      isDebugMode: true,
    );
  }

  Future<void> _loadTenants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tenants = await _tenantService.getAllTenants();
      setState(() {
        _tenants = tenants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addTenant() async {
    // TODO: Implement add tenant functionality
  }

  Future<void> _deleteTenant(String id) async {
    try {
      await _tenantService.deleteTenant(id);
      await _loadTenants();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTenant,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _tenants.length,
                  itemBuilder: (context, index) {
                    final tenant = _tenants[index];
                    return ListTile(
                      title: Text(tenant.name),
                      subtitle: Text(tenant.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTenant(tenant.id),
                      ),
                    );
                  },
                ),
    );
  }
}
