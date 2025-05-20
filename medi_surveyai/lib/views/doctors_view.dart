import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import '../services/auth_service.dart';
import '../core/network/dio_client.dart';
import '../models/doctor_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorsView extends StatefulWidget {
  const DoctorsView({super.key});

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  bool _isLoading = false;
  String? _errorMessage;
  List<DoctorModel> _doctors = [];

  late final DoctorService _doctorService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadDoctors();
  }

  void _initializeServices() {
    final storage = const FlutterSecureStorage();
    final dioClient = DioClient(storage: storage);
    final authService = AuthService(
      dioClient: dioClient,
      storage: storage,
      isDebugMode: true,
    );
    _doctorService = DoctorService(
      dioClient: dioClient,
      storage: storage,
      authService: authService,
      isDebugMode: true,
    );
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final doctors = await _doctorService.getAllDoctors();
      setState(() {
        _doctors = doctors;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Doktorlar yüklenirken bir hata oluştu';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAddDoctor() async {
    final result = await Navigator.pushNamed(context, '/add-doctor');
    if (result == true) {
      _loadDoctors();
    }
  }

  Future<void> _handleDeleteDoctor(String doctorId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Doktor Sil'),
        content: const Text('Bu doktoru silmek istediğinizden emin misiniz?'),
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
      final result = await _doctorService.deleteDoctor(doctorId);
      if (result['status'] == 'success') {
        _loadDoctors();
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Doktor silinirken bir hata oluştu';
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
        title: const Text('Doktorlarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _isLoading ? null : _handleAddDoctor,
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
                        onPressed: _loadDoctors,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _doctors.isEmpty
                  ? const Center(child: Text('Henüz doktor bulunmuyor'))
                  : RefreshIndicator(
                      onRefresh: _loadDoctors,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = _doctors[index];
                          return Card(
                            child: ListTile(
                              title: Text('${doctor.name} ${doctor.surname}'),
                              subtitle: Text(doctor.email),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _handleDeleteDoctor(doctor.id),
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/doctor-details',
                                arguments: doctor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
