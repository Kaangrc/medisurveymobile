import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../core/network/dio_client.dart';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final AuthService _authService;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _checkAuth();
  }

  void _initializeServices() {
    try {
      final storage = const FlutterSecureStorage();
      final dioClient = DioClient(storage: storage);
      _authService = AuthService(
        dioClient: dioClient,
        storage: storage,
        isDebugMode: true,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Servis başlatılırken bir hata oluştu';
      });
    }
  }

  Future<void> _checkAuth() async {
    if (!mounted) return;

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final isAuthenticated = await _authService.isAuthenticated();
      if (!isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final user = await _authService.getCurrentUser();
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        user.role == UserRole.doctor ? '/doctor-home' : '/tenant-home',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Kimlik doğrulama sırasında bir hata oluştu';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Column(
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      _checkAuth();
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
