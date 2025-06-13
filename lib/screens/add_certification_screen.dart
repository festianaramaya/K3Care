import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class AddCertificationScreen extends StatefulWidget {
  const AddCertificationScreen({super.key});

  @override
  State<AddCertificationScreen> createState() => _AddCertificationScreenState();
}

class _AddCertificationScreenState extends State<AddCertificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _issuedByController = TextEditingController();
  final _certificateNumberController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  
  @override
  void dispose() {
    _titleController.dispose();
    _issuedByController.dispose();
    _certificateNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isExpiryDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isExpiryDate ? _expiryDate : _selectedDate,
      firstDate: isExpiryDate ? DateTime.now() : DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E8E3E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isExpiryDate) {
          _expiryDate = picked;
        } else {
          _selectedDate = picked;
        }
      });
    }
  }

  Future<void> _saveCertification() async {
    if (_formKey.currentState!.validate()) {
      try {
        final prefs = await SharedPreferences.getInstance();
        
        // Get existing certifications or create empty list
        List<dynamic> certifications = jsonDecode(prefs.getString('k3_certifications') ?? '[]');
        
        // Create new certification
        final newCertification = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': _titleController.text,
          'issuedBy': _issuedByController.text,
          'certificateNumber': _certificateNumberController.text,
          'issueDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'expiryDate': DateFormat('yyyy-MM-dd').format(_expiryDate),
        };
        
        // Add to list
        certifications.add(newCertification);
        
        // Save back to shared preferences
        await prefs.setString('k3_certifications', jsonEncode(certifications));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sertifikasi berhasil ditambahkan'),
              backgroundColor: Color(0xFF1E8E3E),
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan sertifikasi: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedIssueDate = DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDate);
    String formattedExpiryDate = DateFormat('d MMMM yyyy', 'id_ID').format(_expiryDate);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TAMBAH SERTIFIKASI K3'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Nama Sertifikasi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Sertifikasi K3 Umum',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.verified),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama sertifikasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Issued By
              const Text(
                'Dikeluarkan Oleh',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _issuedByController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Kementerian Ketenagakerjaan RI',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penerbit sertifikasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Certificate Number
              const Text(
                'Nomor Sertifikat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _certificateNumberController,
                decoration: InputDecoration(
                  hintText: 'Contoh: K3/2023/12345',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor sertifikat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Issue Date
              const Text(
                'Tanggal Penerbitan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        formattedIssueDate,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Expiry Date
              const Text(
                'Tanggal Kadaluarsa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_busy, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        formattedExpiryDate,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveCertification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E8E3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'SIMPAN SERTIFIKASI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
