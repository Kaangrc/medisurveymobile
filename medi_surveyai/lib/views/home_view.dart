import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../core/network/dio_client.dart';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AuthService _authService;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadUser();
  }

  void _initializeServices() {
    final storage = const FlutterSecureStorage();
    final dioClient = DioClient(storage: storage);
    _authService = AuthService(
      dioClient: dioClient,
      storage: storage,
      isDebugMode: true,
    );
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoş geldiniz, ${_user!.name ?? _user!.email}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kullanıcı Tipi: ${_user!.role == UserRole.doctor ? 'Doktor' : 'Kiracı'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  if (_user!.role == UserRole.doctor) ...[
                    _buildMenuCard(
                      title: 'Hastalar',
                      icon: Icons.people,
                      onTap: () => Navigator.pushNamed(context, '/patients'),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuCard(
                      title: 'Formlar',
                      icon: Icons.assignment,
                      onTap: () => Navigator.pushNamed(context, '/forms'),
                    ),
                  ] else ...[
                    _buildMenuCard(
                      title: 'Doktorlar',
                      icon: Icons.medical_services,
                      onTap: () => Navigator.pushNamed(context, '/doctors'),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuCard(
                      title: 'Dosyalar',
                      icon: Icons.folder,
                      onTap: () => Navigator.pushNamed(context, '/files'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
