import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ManageSafetyTipsScreen extends StatefulWidget {
  const ManageSafetyTipsScreen({super.key});

  @override
  State<ManageSafetyTipsScreen> createState() => _ManageSafetyTipsScreenState();
}

class _ManageSafetyTipsScreenState extends State<ManageSafetyTipsScreen> {
  List<Map<String, dynamic>> _safetyTips = [];
  bool _isLoading = true;

  final List<IconData> _availableIcons = [
    Icons.security,
    Icons.exit_to_app,
    Icons.report_problem,
    Icons.hotel,
    Icons.record_voice_over,
    Icons.warning,
    Icons.health_and_safety,
    Icons.construction,
    Icons.local_hospital,
    Icons.emergency,
    Icons.fire_extinguisher,
    Icons.visibility,
    Icons.hearing,
    Icons.psychology,
    Icons.medical_services,
  ];

  @override
  void initState() {
    super.initState();
    _loadSafetyTips();
  }

  Future<void> _loadSafetyTips() async {
    setState(() {
      _isLoading = true;
    });

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
        await _saveSafetyTips();
      } else {
        _safetyTips = decodedTips.map((tip) => Map<String, dynamic>.from(tip)).toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading safety tips: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSafetyTips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('safety_tips', jsonEncode(_safetyTips));
    } catch (e) {
      print('Error saving safety tips: $e');
    }
  }

  Future<void> _deleteTip(String id) async {
    try {
      setState(() {
        _safetyTips.removeWhere((tip) => tip['id'] == id);
      });
      
      await _saveSafetyTips();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tips keselamatan berhasil dihapus'),
          backgroundColor: Color(0xFF1E8E3E),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus tips: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddEditDialog({Map<String, dynamic>? tip}) {
    final isEditing = tip != null;
    final titleController = TextEditingController(text: tip?['title'] ?? '');
    final descriptionController = TextEditingController(text: tip?['description'] ?? '');
    IconData selectedIcon = tip != null 
        ? IconData(tip['icon'], fontFamily: 'MaterialIcons')
        : Icons.security;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Tips Keselamatan' : 'Tambah Tips Keselamatan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Tips',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    const Text('Pilih Icon:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _availableIcons.length,
                        itemBuilder: (context, index) {
                          final icon = _availableIcons[index];
                          final isSelected = icon.codePoint == selectedIcon.codePoint;
                          
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedIcon = icon;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF1E8E3E) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF1E8E3E) : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                icon,
                                color: isSelected ? Colors.white : Colors.grey[600],
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty || 
                        descriptionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon isi semua field'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final newTip = {
                      'id': tip?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      'title': titleController.text.trim(),
                      'description': descriptionController.text.trim(),
                      'icon': selectedIcon.codePoint,
                    };

                    setState(() {
                      if (isEditing) {
                        final index = _safetyTips.indexWhere((t) => t['id'] == tip!['id']);
                        if (index != -1) {
                          _safetyTips[index] = newTip;
                        }
                      } else {
                        _safetyTips.add(newTip);
                      }
                    });

                    await _saveSafetyTips();
                    
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing 
                            ? 'Tips keselamatan berhasil diperbarui' 
                            : 'Tips keselamatan berhasil ditambahkan'),
                        backgroundColor: const Color(0xFF1E8E3E),
                      ),
                    );
                  },
                  child: Text(isEditing ? 'Perbarui' : 'Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KELOLA TIPS KESELAMATAN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _safetyTips.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada tips keselamatan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap tombol + untuk menambah tips baru',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _safetyTips.length,
                  itemBuilder: (context, index) {
                    final tip = _safetyTips[index];
                    final icon = IconData(tip['icon'], fontFamily: 'MaterialIcons');
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E8E3E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon,
                            color: const Color(0xFF1E8E3E),
                            size: 24,
                          ),
                        ),
                        title: Text(
                          tip['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          tip['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showAddEditDialog(tip: tip);
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text('Apakah Anda yakin ingin menghapus tips ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _deleteTip(tip['id']);
                                        },
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Hapus', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF1E8E3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
