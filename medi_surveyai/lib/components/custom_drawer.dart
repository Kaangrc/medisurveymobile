import 'package:flutter/material.dart';
import 'package:medi_surveyai/core/network/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/doctor_service.dart';
import '../services/tenant_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isDoctorAuth = false;
  bool _isTenantAuth = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Servisleri al
    final doctorService = Provider.of<DoctorService>(context, listen: false);
    final tenantService = Provider.of<TenantService>(context, listen: false);

    // Oturum durumlarını kontrol et
    final isDoctorAuth = await doctorService.isAuthenticated();
    final isTenantAuth = await tenantService.isAuthenticated();

    if (mounted) {
      setState(() {
        _isDoctorAuth = isDoctorAuth;
        _isTenantAuth = isTenantAuth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);

    return Drawer(
      backgroundColor: isDarkMode
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MediSurveyAI',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isDoctorAuth && doctorProvider.currentDoctor != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${doctorProvider.currentDoctor!.name} ${doctorProvider.currentDoctor!.surname}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctorProvider.currentDoctor!.specialization ??
                            'Uzmanlık Belirtilmemiş',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  )
                else if (_isTenantAuth && tenantProvider.tenantInfo != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenantProvider.tenantInfo!['name'] ?? 'Kurum Adı',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Plan: ${tenantProvider.tenantInfo!['plan_type'] ?? 'Standart'}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Hoş Geldiniz',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Ana Sayfa',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Profil',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Ekip',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/team');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Ayarlar',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Hakkında',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Çıkış Yap',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () async {
              try {
                // Önce DioClient'daki token'ı temizle
                final dioClient =
                    Provider.of<DioClient>(context, listen: false);
                dioClient.clearToken();

                // Doktor veya kurum çıkışını yap
                if (_isDoctorAuth) {
                  await doctorProvider.logout();
                } else if (_isTenantAuth) {
                  await tenantProvider.logout();
                }

                // Login sayfasına yönlendir
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              } catch (e) {
                print('LOGOUT ERROR: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Çıkış yapılırken bir hata oluştu: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
