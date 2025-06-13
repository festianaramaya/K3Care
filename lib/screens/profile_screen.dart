import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> _certifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCertifications();
  }

  Future<void> _loadCertifications() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String certificationsJson = prefs.getString('k3_certifications') ?? '[]';
      
      List<dynamic> decodedCertifications = jsonDecode(certificationsJson);
      
      // Convert to the format needed for our UI
      List<Map<String, dynamic>> formattedCertifications = [];
      
      for (var cert in decodedCertifications) {
        // Parse expiry date
        DateTime expiryDate = DateTime.parse(cert['expiryDate']);
        String formattedExpiryDate = DateFormat('dd MMM yyyy', 'id_ID').format(expiryDate);
        
        formattedCertifications.add({
          'id': cert['id'],
          'title': cert['title'],
          'issuedBy': cert['issuedBy'],
          'certificateNumber': cert['certificateNumber'],
          'issueDate': cert['issueDate'],
          'expiryDate': cert['expiryDate'],
          'validity': 'Berlaku hingga $formattedExpiryDate',
        });
      }
      
      // If no user certifications, add default ones
      if (formattedCertifications.isEmpty) {
        formattedCertifications = [
          {
            'id': '1',
            'title': 'Sertifikasi K3 Umum',
            'validity': 'Berlaku hingga 12 Des 2025',
          },
          {
            'id': '2',
            'title': 'Pelatihan P3K',
            'validity': 'Berlaku hingga 05 Mar 2024',
          },
          {
            'id': '3',
            'title': 'Pelatihan Tanggap Darurat',
            'validity': 'Berlaku hingga 20 Jun 2024',
          },
        ];
      }
      
      setState(() {
        _certifications = formattedCertifications;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading certifications: $e');
      setState(() {
        _isLoading = false;
        _certifications = [
          {
            'id': '1',
            'title': 'Sertifikasi K3 Umum',
            'validity': 'Berlaku hingga 12 Des 2025',
          },
          {
            'id': '2',
            'title': 'Pelatihan P3K',
            'validity': 'Berlaku hingga 05 Mar 2024',
          },
          {
            'id': '3',
            'title': 'Pelatihan Tanggap Darurat',
            'validity': 'Berlaku hingga 20 Jun 2024',
          },
        ];
      });
    }
  }

  Future<void> _deleteCertification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String certificationsJson = prefs.getString('k3_certifications') ?? '[]';
      
      List<dynamic> certifications = jsonDecode(certificationsJson);
      certifications.removeWhere((cert) => cert['id'] == id);
      
      await prefs.setString('k3_certifications', jsonEncode(certifications));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sertifikasi berhasil dihapus'),
          backgroundColor: Color(0xFF1E8E3E),
        ),
      );
      
      _loadCertifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus sertifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFIL'),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background with gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E8E3E),
                  Color(0xFF34A853),
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile card
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          'Festiana',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E8E3E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.work_outline, color: Color(0xFF1E8E3E), size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Pekerja',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1E8E3E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'festianamaya@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Stats row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(context, 'Laporan', '12'),
                              _buildDivider(),
                              _buildStatItem(context, 'Pelatihan', '8'),
                              _buildDivider(),
                              _buildStatItem(context, 'Sertifikat', '${_certifications.length}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Edit profile button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit_profile');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E8E3E),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Edit Profil',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  
                  // Personal Information
                  _buildSectionCard(
                    context,
                    'Informasi Pribadi',
                    [
                      _buildInfoItem(Icons.phone, 'Nomor Telepon', '+62 812 3456 7890'),
                      _buildInfoItem(Icons.location_on, 'Alamat', 'Jl. Keselamatan No. 123, Jakarta'),
                      _buildInfoItem(Icons.calendar_today, 'Tanggal Lahir', '15 Mei 1990'),
                      _buildInfoItem(Icons.person, 'Jenis Kelamin', 'Perempuan'),
                    ],
                  ),
                  
                  // Work Information
                  _buildSectionCard(
                    context,
                    'Informasi Pekerjaan',
                    [
                      _buildInfoItem(Icons.business, 'Perusahaan', 'PT Migas Selamat Sentosa'),
                      _buildInfoItem(Icons.work, 'Jabatan', 'Safety Officer'),
                      _buildInfoItem(Icons.badge, 'ID Karyawan', 'K3-2023-0456'),
                      _buildInfoItem(Icons.location_city, 'Lokasi Kerja', 'Area Produksi B'),
                    ],
                  ),
                  
                  // K3 Certifications
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sertifikasi K3',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E8E3E),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(context, '/add_certification');
                                  if (result == true) {
                                    _loadCertifications();
                                  }
                                },
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Tambah'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E8E3E),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _certifications.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Belum ada sertifikasi. Tambahkan sertifikasi baru.',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : Column(
                                      children: _certifications.map((cert) {
                                        return Dismissible(
                                          key: Key(cert['id']),
                                          background: Container(
                                            color: Colors.red,
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(right: 20),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                          direction: DismissDirection.endToStart,
                                          confirmDismiss: (direction) async {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Konfirmasi'),
                                                  content: const Text('Apakah Anda yakin ingin menghapus sertifikasi ini?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: const Text('Batal'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: const Text('Hapus'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          onDismissed: (direction) {
                                            _deleteCertification(cert['id']);
                                          },
                                          child: _buildCertificationItem(cert['title'], cert['validity']),
                                        );
                                      }).toList(),
                                    ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Settings
                  _buildSectionCard(
                    context,
                    'Pengaturan',
                    [
                      _buildSettingItem(Icons.notifications, 'Notifikasi', true),
                      _buildSettingItem(Icons.language, 'Bahasa', false, value: 'Indonesia'),
                      _buildSettingItem(Icons.dark_mode, 'Mode Gelap', false),
                      _buildSettingItem(Icons.security, 'Keamanan', false),
                    ],
                  ),
                  
                  // Logout button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Show logout confirmation
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Keluar'),
                              content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                  },
                                  child: const Text('Keluar', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Version info
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      'K3Care v1.0.3',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Profile picture (Sticky Profile Picture)
          Positioned(
            top: 120, // Posisi tetap dari atas
            left: 0,
            right: 0,
            child: Center(
              child: Container(                
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }
  
  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E8E3E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E8E3E),
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E8E3E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E8E3E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCertificationItem(String title, String validity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1E8E3E).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E8E3E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified,
              color: Color(0xFF1E8E3E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  validity,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingItem(IconData icon, String title, bool isSwitch, {String? value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E8E3E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E8E3E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isSwitch)
            Switch(
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF1E8E3E),
            )
          else if (value != null)
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            )
          else
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}
