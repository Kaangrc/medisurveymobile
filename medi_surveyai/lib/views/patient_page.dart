// import 'package:flutter/material.dart';
// import '../components/custom_drawer.dart';
// import '../models/patient_filter.dart';
// import '../widgets/filter_dialog.dart';
// import 'add_patient.dart';
// import 'package:provider/provider.dart';
// import '../providers/patient_provider.dart';

// class PatientPage extends StatefulWidget {
//   const PatientPage({super.key});

//   @override
//   State<PatientPage> createState() => _PatientPageState();
// }

// class _PatientPageState extends State<PatientPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Hastaları yükle
//     // Provider.of<PatientProvider>(context, listen: false).fetchPatients();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hastalar'),
//         centerTitle: true,
//       ),
//       drawer: const CustomDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Üst kısım - Arama ve Butonlar
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               alignment: WrapAlignment.spaceBetween,
//               children: [
//                 // Arama kutusu
//                 SizedBox(
//                   width: screenWidth > 600 ? 300 : screenWidth - 32,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Hasta Ara...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Butonlar
//                 Wrap(
//                   spacing: 8,
//                   children: [
//                     SizedBox(
//                       height: 40,
//                       child: ElevatedButton.icon(
//                         onPressed: () async {
//                           final result =
//                               await showModalBottomSheet<PatientFilter>(
//                             context: context,
//                             isScrollControlled: true,
//                             builder: (context) => SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.9,
//                               child: FilterDialog(
//                                 initialFilter: PatientFilter(),
//                               ),
//                             ),
//                           );
//                           if (result != null) {
//                             setState(() {});
//                           }
//                         },
//                         icon: const Icon(Icons.filter_list, size: 18),
//                         label: const Text('Filtrele'),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 40,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const AddPatientPage()),
//                           );
//                         },
//                         icon: const Icon(Icons.person_add, size: 18),
//                         label: const Text('Yeni Hasta'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Hasta listesi
//             Expanded(
//               child: Consumer<PatientProvider>(
//                 builder: (context, patientProvider, child) {
//                   // if (patientProvider.isLoading) {
//                   //   return const Center(child: CircularProgressIndicator());
//                   // }
//                   // if (patientProvider.errorMessage != null) {
//                   //   return Center(child: Text(patientProvider.errorMessage!));
//                   // }
//                   if (patientProvider.patients.isEmpty) {
//                     return const Center(child: Text('Hasta bulunamadı.'));
//                   }
//                   return ListView.builder(
//                     itemCount: patientProvider.patients.length,
//                     itemBuilder: (context, index) {
//                       final patient = patientProvider.patients[index];
//                       return ListTile(
//                         title: Text(patient.firstName + ' ' + patient.lastName),
//                         subtitle: Text(patient.email),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
