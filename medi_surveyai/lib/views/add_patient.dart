// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Hasta Ekle'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hasta Bilgileri',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // TC Kimlik No
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'TC Kimlik No',
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                maxLength: 11,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'TC Kimlik No gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ad Soyad
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad Soyad gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Doğum Tarihi
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Doğum Tarihi',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    // TODO: Tarihi forma ekle
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Doğum tarihi gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Telefon
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefon gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // E-posta
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta gerekli';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Geçerli bir e-posta giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Text(
                'Tedavi Bilgileri',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // İşlem Türü
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'İşlem Türü',
                  prefixIcon: Icon(Icons.medical_services),
                ),
                items: const [
                  DropdownMenuItem(value: 'total_diz', child: Text('Total Diz')),
                  DropdownMenuItem(value: 'total_kalca', child: Text('Total Kalça')),
                  DropdownMenuItem(value: 'artroskopi', child: Text('Artroskopi')),
                  DropdownMenuItem(value: 'diger', child: Text('Diğer')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Doktor
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Doktor',
                  prefixIcon: Icon(Icons.person),
                ),
                items: const [
                  DropdownMenuItem(value: 'dr_1', child: Text('Dr. Ahmet Yılmaz')),
                  DropdownMenuItem(value: 'dr_2', child: Text('Dr. Mehmet Öz')),
                  DropdownMenuItem(value: 'dr_3', child: Text('Dr. Ayşe Demir')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 32),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form verilerini kaydet
                      // Provider.of<PatientProvider>(context, listen: false).addPatient({
                      //   // Formdan alınan veriler
                      // });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
