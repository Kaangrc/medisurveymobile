import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/tenant_provider.dart';
import '../models/user_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorProvider = context.watch<DoctorProvider>();
    final tenantProvider = context.watch<TenantProvider>();

    final doctor = doctorProvider.currentDoctor;
    final tenant = tenantProvider.currentTenant;

    final user = doctor ?? tenant;
    final role = user?.role ?? UserRole.tenant;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.name ?? 'Misafir',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role == UserRole.doctor ? 'Doktor' : 'Kiracı',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Ana Sayfa'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                role == UserRole.doctor ? '/doctor/home' : '/tenant/home',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                role == UserRole.doctor ? '/doctor/profile' : '/tenant/profile',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Formlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/forms');
            },
          ),
          if (role == UserRole.doctor)
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Takım'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/team');
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Çıkış Yap'),
            onTap: () async {
              Navigator.pop(context);
              if (role == UserRole.doctor) {
                await doctorProvider.logout();
              } else {
                await tenantProvider.logout();
              }
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
