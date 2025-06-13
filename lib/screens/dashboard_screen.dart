import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _safetyTips = [];
  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.wait([
      _loadSafetyTips(),
      _loadActivities(),
    ]);
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadSafetyTips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String tipsJson = prefs.getString('safety_tips') ?? '[]';
      
      List<dynamic> decodedTips = jsonDecode(tipsJson);
      
      if (decodedTips.isEmpty) {
        // Load default tips if none exist
        _safetyTips = [
          {
            'id': '1',
            'title': 'Periksa APD Sebelum Bekerja',
            'description': 'Selalu periksa APD (Alat Pelindung Diri) sebelum memulai pekerjaan. Pastikan semua peralatan dalam kondisi baik dan sesuai standar keselamatan.',
            'icon': Icons.security.codePoint,
          },
          {
            'id': '2',
            'title': 'Kenali Jalur Evakuasi',
            'description': 'Pastikan Anda mengetahui lokasi jalur evakuasi terdekat dan titik kumpul di area kerja Anda. Ini penting saat terjadi keadaan darurat.',
            'icon': Icons.exit_to_app.codePoint,
          },
          {
            'id': '3',
            'title': 'Laporkan Kondisi Tidak Aman',
            'description': 'Jika Anda melihat kondisi atau perilaku tidak aman, segera laporkan kepada supervisor. Pencegahan lebih baik daripada penanganan.',
            'icon': Icons.report_problem.codePoint,
          },
          {
            'id': '4',
            'title': 'Istirahat yang Cukup',
            'description': 'Kelelahan dapat menyebabkan kecelakaan kerja. Pastikan Anda mendapatkan istirahat yang cukup dan tetap terhidrasi selama bekerja.',
            'icon': Icons.hotel.codePoint,
          },
          {
            'id': '5',
            'title': 'Komunikasi yang Jelas',
            'description': 'Gunakan komunikasi yang jelas saat bekerja dalam tim, terutama saat mengoperasikan peralatan berat atau bekerja di ketinggian.',
            'icon': Icons.record_voice_over.codePoint,
          },
        ];
      } else {
        _safetyTips = decodedTips.map((tip) => Map<String, dynamic>.from(tip)).toList();
      }
    } catch (e) {
      print('Error loading safety tips: $e');
    }
  }

  Future<void> _loadActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String activitiesJson = prefs.getString('k3_activities') ?? '[]';
      
      List<dynamic> decodedActivities = jsonDecode(activitiesJson);
      
      // Convert to the format needed for our UI
      List<Map<String, dynamic>> formattedActivities = [];
      
      for (var activity in decodedActivities) {
        // Parse time
        List<String> timeParts = activity['time'].split(':');
        String formattedTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')} WIB';
        
        // Parse date for day name
        DateTime date = DateTime.parse(activity['date']);
        String dayName = DateFormat('EEEE', 'id_ID').format(date);
        
        formattedActivities.add({
          'id': activity['id'],
          'title': activity['title'],
          'time': formattedTime,
          'location': activity['location'],
          'icon': _getIconForActivity(activity['title']),
          'color': Color(activity['color']),
          'day': dayName,
        });
      }
      
      // Sort by date and time
      formattedActivities.sort((a, b) {
        return a['time'].compareTo(b['time']);
      });
      
      // If no user activities, add default ones
      if (formattedActivities.isEmpty) {
        formattedActivities = [
          {
            'id': '1',
            'title': 'Briefing K3 Mingguan',
            'time': 'Jumat, 08:00 WIB',
            'location': 'Ruang Rapat Utama',
            'icon': Icons.groups,
            'color': Colors.blue,
            'day': 'Jumat',
          },
          {
            'id': '2',
            'title': 'Inspeksi Peralatan',
            'time': 'Kamis, 15:00 WIB',
            'location': 'Area Produksi',
            'icon': Icons.build,
            'color': Colors.orange,
            'day': 'Kamis',
          },
          {
            'id': '3',
            'title': 'Simulasi Tanggap Darurat',
            'time': 'Rabu, 13:30 WIB',
            'location': 'Seluruh Area',
            'icon': Icons.warning_amber,
            'color': Colors.red,
            'day': 'Rabu',
          },
        ];
      }
      
      _activities = formattedActivities;
    } catch (e) {
      print('Error loading activities: $e');
      _activities = [
        {
          'id': '1',
          'title': 'Briefing K3 Mingguan',
          'time': 'Jumat, 08:00 WIB',
          'location': 'Ruang Rapat Utama',
          'icon': Icons.groups,
          'color': Colors.blue,
          'day': 'Jumat',
        },
        {
          'id': '2',
          'title': 'Inspeksi Peralatan',
          'time': 'Kamis, 15:00 WIB',
          'location': 'Area Produksi',
          'icon': Icons.build,
          'color': Colors.orange,
          'day': 'Kamis',
        },
        {
          'id': '3',
          'title': 'Simulasi Tanggap Darurat',
          'time': 'Rabu, 13:30 WIB',
          'location': 'Seluruh Area',
          'icon': Icons.warning_amber,
          'color': Colors.red,
          'day': 'Rabu',
        },
      ];
    }
  }

  IconData _getIconForActivity(String title) {
    if (title.toLowerCase().contains('briefing') || title.toLowerCase().contains('rapat')) {
      return Icons.groups;
    } else if (title.toLowerCase().contains('inspeksi') || title.toLowerCase().contains('peralatan')) {
      return Icons.build;
    } else if (title.toLowerCase().contains('darurat') || title.toLowerCase().contains('simulasi')) {
      return Icons.warning_amber;
    } else if (title.toLowerCase().contains('pelatihan') || title.toLowerCase().contains('training')) {
      return Icons.school;
    } else if (title.toLowerCase().contains('evaluasi') || title.toLowerCase().contains('assessment')) {
      return Icons.assessment;
    } else {
      return Icons.event;
    }
  }

  Future<void> _deleteActivity(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String activitiesJson = prefs.getString('k3_activities') ?? '[]';
      
      List<dynamic> activities = jsonDecode(activitiesJson);
      activities.removeWhere((activity) => activity['id'] == id);
      
      await prefs.setString('k3_activities', jsonEncode(activities));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aktivitas berhasil dihapus'),
          backgroundColor: Color(0xFF1E8E3E),
        ),
      );
      
      _loadActivities();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus aktivitas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header with logo and title
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'K3CARE',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profile');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/profile_pic.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'KESELAMATAN KESEHATAN\nKERJA [K3] MIGAS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/worker.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/warning1.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/warning2.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Safety Status Card
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E8E3E), Color(0xFF34A853)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status Keselamatan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Hari Tanpa Kecelakaan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Text(
                                '145',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'hari',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Terakhir update: Hari ini, 08:00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Layanan section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Layanan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          'Layanan dan Fitur K3Care',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildServiceItem(
                              context,
                              'Info K3',
                              Icons.info,
                              '/info_k3',
                            ),
                            _buildServiceItem(
                              context,
                              'Pengingat K3',
                              Icons.access_time,
                              '/pengingat_k3',
                              color: Colors.green,
                            ),
                            _buildServiceItem(
                              context,
                              'Pelaporan',
                              Icons.description,
                              '/pelaporan',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Safety Tips - Horizontal Scrollable
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb,
                                    color: Color(0xFF1E8E3E),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tips Keselamatan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(context, '/manage_safety_tips');
                                      _loadSafetyTips();
                                    },
                                    child: const Text(
                                      'Kelola',
                                      style: TextStyle(
                                        color: Color(0xFF1E8E3E),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Lihat Semua',
                                      style: TextStyle(
                                        color: Color(0xFF1E8E3E),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 220,
                          child: _safetyTips.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Belum ada tips keselamatan',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  itemCount: _safetyTips.length,
                                  itemBuilder: (context, index) {
                                    final tip = _safetyTips[index];
                                    final icon = IconData(tip['icon'], fontFamily: 'MaterialIcons');
                                    return _buildSafetyTipCard(
                                      tip['title'],
                                      tip['description'],
                                      icon,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Upcoming Activities
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Aktivitas K3 Mendatang',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.pushNamed(context, '/add_activity');
                                if (result == true) {
                                  _loadActivities();
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
                        _activities.isEmpty
                            ? const Center(
                                child: Text(
                                  'Belum ada aktivitas. Tambahkan aktivitas baru.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : Column(
                                children: _activities.map((activity) {
                                  return Dismissible(
                                    key: Key(activity['id']),
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
                                            content: const Text('Apakah Anda yakin ingin menghapus aktivitas ini?'),
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
                                      _deleteActivity(activity['id']);
                                    },
                                    child: _buildActivityCard(
                                      activity['title'],
                                      activity['time'],
                                      activity['location'],
                                      activity['icon'],
                                      activity['color'],
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                  
                  // Recent Incidents
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Laporan Insiden Terbaru',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: Color(0xFF1E8E3E),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildIncidentCard(
                          'Tumpahan Bahan Kimia',
                          'Area Lab - 2 hari yang lalu',
                          'Selesai Ditangani',
                          Colors.green,
                        ),
                        _buildIncidentCard(
                          'Kebocoran Gas Ringan',
                          'Area Produksi - 5 hari yang lalu',
                          'Selesai Ditangani',
                          Colors.green,
                        ),
                      ],
                    ),
                  ),
                  
                  // Version info
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    color: const Color(0xFF1E8E3E),
                    width: double.infinity,
                    child: const Column(
                      children: [
                        Text(
                          'K3CARE',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Version 1.0.3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    String title,
    IconData icon,
    String route, {
    Color color = Colors.blue,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSafetyTipCard(String title, String description, IconData icon) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2E9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFF1E8E3E), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E8E3E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E8E3E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Selengkapnya',
                        style: TextStyle(
                          color: Color(0xFF1E8E3E),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: Color(0xFF1E8E3E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActivityCard(
    String title,
    String time,
    String location,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
  
  Widget _buildIncidentCard(
    String title,
    String info,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
