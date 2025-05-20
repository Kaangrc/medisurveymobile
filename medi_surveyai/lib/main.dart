import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/network/dio_client.dart';
import 'services/auth_service.dart';
import 'services/doctor_service.dart';
import 'services/tenant_service.dart';
import 'providers/doctor_provider.dart';
import 'providers/tenant_provider.dart';
import 'views/splash_view.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/doctor/doctor_home_view.dart';
import 'views/doctor/doctor_profile_view.dart';
import 'views/tenant/tenant_home_view.dart';
import 'views/tenant/tenant_profile_view.dart';
import 'views/forms_view.dart';
import 'views/settings_view.dart';
import 'views/team_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = const FlutterSecureStorage();
  final dioClient = DioClient(
    baseUrl: 'https://api.example.com', // API base URL'inizi buraya ekleyin
    storage: storage,
    isDebugMode: true,
  );

  final authService = AuthService(
    dioClient: dioClient,
    storage: storage,
    isDebugMode: true,
  );

  final doctorService = DoctorService(
    dioClient: dioClient,
    storage: storage,
    authService: authService,
    isDebugMode: true,
  );

  final tenantService = TenantService(
    dioClient: dioClient,
    storage: storage,
    authService: authService,
    isDebugMode: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DoctorProvider(doctorService),
        ),
        ChangeNotifierProvider(
          create: (_) => TenantProvider(tenantService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medi Survey AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      initialRoute: '/',
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Sayfa Bulunamadı')),
            body: const Center(
              child: Text('Aradığınız sayfa bulunamadı.'),
            ),
          ),
        );
      },
      routes: {
        '/': (context) => const SplashView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/doctor/home': (context) => const DoctorHomeView(),
        '/doctor/profile': (context) => const DoctorProfileView(),
        '/tenant/home': (context) => const TenantHomeView(),
        '/tenant/profile': (context) => const TenantProfileView(),
        '/forms': (context) => const FormsView(),
        '/settings': (context) => const SettingsView(),
        '/team': (context) => const TeamView(),
      },
    );
  }
}
