import 'package:flutter/material.dart';

class PelaporanSuccessScreen extends StatelessWidget {
  const PelaporanSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1E8E3E), width: 3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.check,
                size: 100,
                color: Color(0xFF1E8E3E),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'FORMULIR PELAPORAN',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'INSIDEN ATAU',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'KESELAMATAN KERJA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'BERHASIL DIKIRIM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E8E3E),
                ),
                child: const Text('SELESAI'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

