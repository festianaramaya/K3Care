import 'package:flutter/material.dart';

class PelaporanHistoryScreen extends StatelessWidget {
  const PelaporanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RIWAYAT PELAPORAN'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildReportCategory(
            'Laporan Kecelakaan Kerja',
            [
              _buildReportItem(
                'Laporan Kecelakaan Kerja',
                '1 Mei 2023',
                'PT Kimia Biru gd No.21/RT/01/RW/02, Kel. Seketari, Kec. Tajur, Kota Depok',
                'Laporan Selesai',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReportCategory(
            'Laporan Investigasi Kecelakaan',
            [
              _buildReportItem(
                'Laporan Investigasi Kecelakaan',
                '25 Maret 2023',
                'PT Kimia Biru gd No.21/RT/01/RW/02, Kel. Seketari, Kec. Tajur, Kota Depok',
                'Laporan Diproses',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildReportItem(String title, String date, String location, String status) {
    final isCompleted = status == 'Laporan Selesai';
    
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFE0F2E9) : Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(date),
          const SizedBox(height: 8),
          Text(location),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  status,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

