import 'package:flutter/material.dart';

class PelaporanFormScreen extends StatefulWidget {
  const PelaporanFormScreen({super.key});

  @override
  State<PelaporanFormScreen> createState() => _PelaporanFormScreenState();
}

class _PelaporanFormScreenState extends State<PelaporanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _otherChecked = false;
  bool _fireChecked = false;
  bool _environmentChecked = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FORMULIR LAPORAN'),
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
              // Header
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Perusahaan:'),
                      Text('Nama Pelapor (Karyawan):'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nomor Telepon:'),
                      Text('Nama:'),
                      Text('Posisi:'),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'FORMULIR LAPORAN AWAL KECELAKAAN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text(
                  '(Injury & Illness Notification Report)',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              
              const SizedBox(height: 24),
              const Text('No. Laporan:'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Masukkan No. Laporan',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Email/Whatsapp/Gmail:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Dengan hormat,'),
              const Text('Saya yang bertanda tangan di bawah ini :'),
              
              const SizedBox(height: 16),
              const Text('Nama:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Perusahaan:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Melaporkan bahwa telah terjadi kecelakaan kerja, insiden & penyakit akibat kerja (cedera & penyakit akibat kerja) yang terjadi pada :'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Hari:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Jam:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Sifat Kecelakaan telah "mengakibatkan" (pilihan boleh lebih dari satu):'),
              
              CheckboxListTile(
                title: const Text('Cidera'),
                value: _otherChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _otherChecked = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              
              CheckboxListTile(
                title: const Text('Penyakit'),
                value: _fireChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _fireChecked = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              
              CheckboxListTile(
                title: const Text('Lingkungan'),
                value: _environmentChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _environmentChecked = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 16),
              const Text('Tindakan Cepat/Keputusan Penanganan/Tindakan Tanggap Darurat:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 16),
              const Text('Gambaran Kejadian Secara Singkat (Kronologis) menggunakan metode 5W+1H:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 16),
              const Text('Saksi-saksi Kejadian:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Nama:'),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Navigate directly to history screen without using named route
                        // This ensures we go directly to the history screen
                        Navigator.pushNamedAndRemoveUntil(
                          context, 
                          '/pelaporan_history', 
                          (route) => route.isFirst
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E8E3E),
                    ),
                    child: const Text('KIRIM'),
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
