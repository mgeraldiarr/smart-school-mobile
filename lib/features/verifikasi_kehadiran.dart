import 'package:flutter/material.dart';

import 'pemindai_wajah.dart';
import 'absensi_berhasil.dart';
import 'teacher/models/teacher_schedule.dart';

// CLASS HALAMAN VERIFIKASI KEHADIRAN
class VerifikasiKehadiranPage extends StatelessWidget {
  final TeacherSchedule schedule;

  const VerifikasiKehadiranPage({super.key, required this.schedule});

  // WIDGET UNTUK MENAMPILKAN DETAIL SISWA
  Widget detailRow(String label, String value, {bool last = false}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE8EDF5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF71829D), fontSize: 11),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1D2939),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // FUNGSI UNTUK MEMBANGUN HALAMAN VERIFIKASI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER HALAMAN
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verifikasi Kehadiran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D2939),
                        ),
                      ),
                      Text(
                        'Periksa kecocokan data siswa',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF71829D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // KONTEN HALAMAN
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    // FOTO PROFIL SISWA
                    Container(
                      width: 104,
                      height: 104,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF3698F5),
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/guru.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF328CE0),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 65,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 11),

                    // STATUS VERIFIKASI
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0DE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Menunggu Verifikasi Guru',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFFB85A00),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // NAMA DAN IDENTITAS SISWA
                    const Text(
                      'Ahmad Rizki',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1D2939),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'NIS 20260001 • Kelas 8A',
                      style: TextStyle(fontSize: 11, color: Color(0xFF71829D)),
                    ),

                    const SizedBox(height: 19),

                    // KARTU DETAIL KEHADIRAN
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: const Color(0xFFDCE6F3)),
                      ),
                      child: Column(
                        children: [
                          detailRow('Mata Pelajaran', schedule.subjectName),
                          detailRow('Kelas', schedule.className),
                          detailRow('Guru', 'Pak Ahmad'),
                          detailRow(
                            'Waktu Terdeteksi',
                            '07.15 WIB',
                            last: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 17),

                    // KARTU PERSENTASE KECOCOKAN WAJAH
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFDCE6F3)),
                      ),
                      child: Column(
                        children: [
                          // LABEL DAN PERSENTASE
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Kecocokan wajah',
                                style: TextStyle(fontSize: 11),
                              ),
                              Text(
                                '98%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0C9C65),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // PROGRESS BAR KECOCOKAN
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const LinearProgressIndicator(
                              value: 0.98,
                              minHeight: 6,
                              backgroundColor: Color(0xFFE4F0E9),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF32C184),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // TOMBOL VERIFIKASI MENUJU PAGE 9
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AbsensiBerhasilPage(schedule: schedule),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF168F5B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 18),
                            SizedBox(width: 10),
                            Text(
                              'Verifikasi Hadir',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // TOMBOL TOLAK ATAU SCAN ULANG MENUJU PAGE 7
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PemindaiWajahPage(schedule: schedule),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0869D5),
                          side: const BorderSide(color: Color(0xFFB5D1F8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: 18),
                            SizedBox(width: 10),
                            Text(
                              'Tolak / Scan Ulang',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
