import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Ayarlar sayfası yapım aşamasında...'),
      ),
    );
  }
}
