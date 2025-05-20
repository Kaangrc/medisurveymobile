import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/patient_service.dart';
import '../core/network/dio_client.dart';
import '../models/patient_model.dart';

class PatientsView extends StatefulWidget {
  const PatientsView({super.key});

  @override
  State<PatientsView> createState() => _PatientsViewState();
}

class _PatientsViewState extends State<PatientsView> {
  bool _isLoading = false;
  String? _errorMessage;
  List<PatientModel> _patients = [];

  late final PatientService _patientService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadPatients();
  }

  void _initializeServices() {
    final dioClient = DioClient(storage: const FlutterSecureStorage());
    _patientService = PatientService(
      dioClient: dioClient,
      isDebugMode: true,
    );
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final patients = await _patientService.getAllPatients();
      setState(() {
        _patients = patients;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Hastalar yüklenirken bir hata oluştu';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAddPatient() async {
    final result = await Navigator.pushNamed(context, '/add-patient');
    if (result == true) {
      _loadPatients();
    }
  }

  Future<void> _handleDeletePatient(String patientId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hasta Sil'),
        content: const Text('Bu hastayı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _patientService.deletePatient(patientId);
      if (result['status'] == 'success') {
        _loadPatients();
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Hasta silinirken bir hata oluştu';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastalarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _isLoading ? null : _handleAddPatient,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPatients,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _patients.isEmpty
                  ? const Center(child: Text('Henüz hasta bulunmuyor'))
                  : RefreshIndicator(
                      onRefresh: _loadPatients,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _patients.length,
                        itemBuilder: (context, index) {
                          final patient = _patients[index];
                          return Card(
                            child: ListTile(
                              title: Text('${patient.name} ${patient.surname}'),
                              subtitle: Text(patient.email),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _handleDeletePatient(patient.id),
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/patient-details',
                                arguments: patient,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
