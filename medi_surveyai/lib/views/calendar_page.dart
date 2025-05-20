// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import '../components/custom_drawer.dart';
// import 'package:provider/provider.dart';
// import '../providers/event_provider.dart';

// class CalendarPage extends StatefulWidget {
//   const CalendarPage({super.key});

//   @override
//   State<CalendarPage> createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   late DateTime _selectedDay;
//   late DateTime _focusedDay;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = DateTime.now();
//     _focusedDay = DateTime.now();
//     _initializeCalendar();
//   }

//   Future<void> _initializeCalendar() async {
//     await initializeDateFormatting('tr_TR', null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Takvim'),
//         centerTitle: true,
//       ),
//       drawer: const CustomDrawer(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TableCalendar(
//               locale: 'tr_TR',
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               calendarFormat: CalendarFormat.month,
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//                 // Eventleri yükle
//                 // Provider.of<EventProvider>(context, listen: false)
//                 //     .fetchEventsForDay(selectedDay);
//               },
//               onPageChanged: (focusedDay) {
//                 _focusedDay = focusedDay;
//               },
//             ),
//             const SizedBox(height: 16),
//             // Randevular
//             Consumer<EventProvider>(
//               builder: (context, eventProvider, child) {
//                 if (eventProvider.isLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (eventProvider.errorMessage != null) {
//                   return Center(child: Text(eventProvider.errorMessage!));
//                 }
//                 return ListView.builder(
//                   itemCount: eventProvider.events.length,
//                   itemBuilder: (context, index) {
//                     final event = eventProvider.events[index];
//                     return ListTile(
//                       title: Text(event.title),
//                       subtitle: Text(event.description),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
