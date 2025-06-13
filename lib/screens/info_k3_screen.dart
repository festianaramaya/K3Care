import 'package:flutter/material.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/info_item.dart';

class InfoK3Screen extends StatelessWidget {
  const InfoK3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INFO K3'),
      ),
      body: ListView(
        children: const [
          InfoItem(
            title: 'Undang-Undang/PERPU terkait K3',
            icon: Icons.description,
          ),
          InfoItem(
            title: 'Norma, Standar, Pedoman, Kriteria (NSPK) K3 terkait Bidang MIGAS',
            icon: Icons.description,
          ),
          InfoItem(
            title: 'Norma, Standar, Pedoman, Kriteria (NSPK) K3 terkait Uap',
            icon: Icons.description,
          ),
          InfoItem(
            title: 'Norma, Standar, Pedoman, Kriteria (NSPK) K3 terkait PAA',
            icon: Icons.description,
          ),
          InfoItem(
            title: 'Norma, Standar, Pedoman, Kriteria (NSPK) K3 terkait bidang Konstruksi dan Bangunan',
            icon: Icons.description,
          ),
          InfoItem(
            title: 'Norma, Standar, Pedoman, Kriteria (NSPK) K3 terkait bidang Perusahaan Jasa K3',
            icon: Icons.description,
          ),
          InfoItem(
            title: 'Norma, Standar, Pedoman, Kriteria (NSPK) K3 terkait bidang Keahlian dan Keterampilan K3',
            icon: Icons.description,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }
}

