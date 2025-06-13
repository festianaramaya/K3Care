import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class PengingatK3Screen extends StatefulWidget {
  const PengingatK3Screen({super.key});

  @override
  State<PengingatK3Screen> createState() => _PengingatK3ScreenState();
}

class _PengingatK3ScreenState extends State<PengingatK3Screen> {
  final List<ReminderItem> _reminders = [
    ReminderItem(
      title: 'Jam Kerja',
      time: '08.30',
      day: 'Senin',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Istirahat',
      time: '12.00',
      day: 'Senin',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Kerja',
      time: '12.30',
      day: 'Senin',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Batas Jam Kerja',
      time: '16.30',
      day: 'Senin',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Kerja',
      time: '08.00',
      day: 'Selasa-Kamis',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Istirahat',
      time: '12.00',
      day: 'Selasa-Kamis',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Kerja',
      time: '12.30',
      day: 'Selasa-Kamis',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Batas Jam Kerja',
      time: '16.30',
      day: 'Selasa-Kamis',
      isChecked: true,
    ),
    // Additional time entries
    ReminderItem(
      title: 'Jam Kerja',
      time: '07.30',
      day: 'Jumat',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Briefing K3',
      time: '08.00',
      day: 'Jumat',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Istirahat',
      time: '11.30',
      day: 'Jumat',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Kerja',
      time: '13.00',
      day: 'Jumat',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Batas Jam Kerja',
      time: '16.00',
      day: 'Jumat',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Inspeksi K3',
      time: '09.00',
      day: 'Senin',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Inspeksi K3',
      time: '09.00',
      day: 'Rabu',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Pelatihan K3',
      time: '14.00',
      day: 'Kamis (Minggu ke-2)',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Evaluasi K3',
      time: '15.00',
      day: 'Jumat (Minggu ke-4)',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Jam Lembur',
      time: '17.00',
      day: 'Senin-Kamis',
      isChecked: false,
    ),
    ReminderItem(
      title: 'Batas Jam Lembur',
      time: '20.00',
      day: 'Senin-Kamis',
      isChecked: false,
    ),
    ReminderItem(
      title: 'Shift Malam',
      time: '22.00',
      day: 'Senin-Jumat',
      isChecked: false,
    ),
    ReminderItem(
      title: 'Istirahat Shift Malam',
      time: '02.00',
      day: 'Selasa-Sabtu',
      isChecked: false,
    ),
    ReminderItem(
      title: 'Batas Shift Malam',
      time: '06.00',
      day: 'Selasa-Sabtu',
      isChecked: false,
    ),
    ReminderItem(
      title: 'Jam Kerja',
      time: '08.00',
      day: 'Sabtu (Minggu ke-1 & ke-3)',
      isChecked: false,
    ),
    ReminderItem(
      title: 'Batas Jam Kerja',
      time: '13.00',
      day: 'Sabtu (Minggu ke-1 & ke-3)',
      isChecked: false,
    ),
    // 4 New time entries
    ReminderItem(
      title: 'Pengecekan APD',
      time: '07.45',
      day: 'Setiap Hari Kerja',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Rapat Keselamatan',
      time: '10.30',
      day: 'Selasa (Mingguan)',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Simulasi Tanggap Darurat',
      time: '13.30',
      day: 'Rabu (Bulanan)',
      isChecked: true,
    ),
    ReminderItem(
      title: 'Inspeksi Peralatan',
      time: '15.00',
      day: 'Kamis (Mingguan)',
      isChecked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PENGINGAT K3'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          return _buildReminderCard(_reminders[index]);
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildReminderCard(ReminderItem reminder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          reminder.title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF555555),
          ),
        ),
        subtitle: Text(
          reminder.day,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        trailing: Checkbox(
          value: reminder.isChecked,
          activeColor: const Color(0xFF1E8E3E),
          shape: const CircleBorder(),
          onChanged: (bool? value) {
            setState(() {
              reminder.isChecked = value!;
            });
          },
        ),
        leading: Text(
          reminder.time,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ReminderItem {
  final String title;
  final String time;
  final String day;
  bool isChecked;

  ReminderItem({
    required this.title,
    required this.time,
    required this.day,
    required this.isChecked,
  });
}
