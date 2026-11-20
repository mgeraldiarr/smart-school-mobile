import 'package:flutter/material.dart';

class InformasiBerhasilPage extends StatelessWidget {
  final String subjectName;
  final String className;

  const InformasiBerhasilPage({
    super.key,
    required this.subjectName,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 4),

              // IKON INFORMASI
              Container(
                width: 110,
                height: 110,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDCE6F2)),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF55A5F0), Color(0xFF1971D0)],
                    ),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // JUDUL HALAMAN
              const Text(
                'Laporan Berhalangan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1D2939),
                ),
              ),

              const SizedBox(height: 12),

              // DESKRIPSI HALAMAN
              const Text(
                'Ringkasan jadwal ditampilkan. Pengiriman laporan ke server '
                'belum tersedia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: Color(0xFF71829D),
                ),
              ),

              const SizedBox(height: 35),

              // KARTU INFORMASI MATA PELAJARAN
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFDCE6F2)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      color: Color(0xFF243248),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$subjectName • Kelas $className',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF243248),
                        ),
                      ),
                    ),
                    const Text(
                      'Berhalangan',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFB85A00),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 38),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1971D0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
