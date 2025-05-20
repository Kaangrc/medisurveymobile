import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tenant_provider.dart';
import '../../widgets/custom_drawer.dart';

class TenantHomeView extends StatefulWidget {
  const TenantHomeView({super.key});

  @override
  State<TenantHomeView> createState() => _TenantHomeViewState();
}

class _TenantHomeViewState extends State<TenantHomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TenantProvider>().loadCurrentTenant();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      drawer: const CustomDrawer(),
      body: Consumer<TenantProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadCurrentTenant();
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          final tenant = provider.currentTenant;
          if (tenant == null) {
            return const Center(
              child: Text('Kiracı bilgileri yüklenemedi.'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hoş Geldiniz, ${tenant.name}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (tenant.address != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Adres: ${tenant.address}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                        if (tenant.phoneNumber != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Telefon: ${tenant.phoneNumber}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hızlı Erişim',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildQuickAccessButton(
                              context,
                              'Formlar',
                              Icons.assignment,
                              () => Navigator.pushNamed(context, '/forms'),
                            ),
                            _buildQuickAccessButton(
                              context,
                              'Profil',
                              Icons.person,
                              () => Navigator.pushNamed(
                                  context, '/tenant/profile'),
                            ),
                            _buildQuickAccessButton(
                              context,
                              'Ayarlar',
                              Icons.settings,
                              () => Navigator.pushNamed(context, '/settings'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAccessButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
