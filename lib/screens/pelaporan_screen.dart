import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class PelaporanScreen extends StatelessWidget {
  const PelaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PELAPORAN INSIDEN'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/report_icon.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  context,
                  'PELAPORAN',
                  () => Navigator.pushNamed(context, '/pelaporan_form'),
                ),
                const SizedBox(width: 16),
                _buildButton(
                  context,
                  'RIWAYAT',
                  () => Navigator.pushNamed(context, '/pelaporan_history'),
                  hasNotification: true,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildButton(BuildContext context, String label, VoidCallback onPressed, {bool hasNotification = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2E9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1E8E3E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

