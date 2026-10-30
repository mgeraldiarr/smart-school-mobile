import 'package:flutter/material.dart';

import 'pemindai_wajah.dart';
import 'teacher/models/teacher_schedule.dart';

// CLASS HALAMAN ABSENSI BERHASIL
class AbsensiBerhasilPage extends StatelessWidget {
  final TeacherSchedule schedule;

  const AbsensiBerhasilPage({super.key, required this.schedule});

  // FUNGSI UNTUK MENAMPILKAN PESAN NOTIFIKASI
  void tampilkanPesan(BuildContext context, String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), behavior: SnackBarBehavior.floating),
    );
  }

  // FUNGSI UNTUK MEMBANGUN HALAMAN
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

              // IKON CENTANG BERHASIL
              Container(
                width: 110,
                height: 110,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFB7F0D7)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10159968),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF31C783), Color(0xFF119968)],
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),

              const SizedBox(height: 23),

              // JUDUL ABSENSI BERHASIL
              const Text(
                'Absensi Berhasil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1D2939),
                ),
              ),

              const SizedBox(height: 11),

              // DESKRIPSI ABSENSI
              Text(
                'Ahmad Rizki telah diverifikasi hadir pada '
                'mata pelajaran ${schedule.subjectName}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.65,
                  color: Color(0xFF71829D),
                ),
              ),

              const SizedBox(height: 15),

              // WAKTU ABSENSI
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F1FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFF1971D0),
                      size: 17,
                    ),
                    SizedBox(width: 9),
                    Text(
                      '07.15 WIB',
                      style: TextStyle(
                        color: Color(0xFF1971D0),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 29),

              // INFORMASI NOTIFIKASI TERKIRIM
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F7EF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 21,
                      color: Color(0xFF128653),
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifikasi terkirim',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF087D4B),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Wali murid telah menerima informasi '
                            'kehadiran.',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF21835B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              // TOMBOL SCAN SISWA BERIKUTNYA MENUJU PAGE 7
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PemindaiWajahPage(schedule: schedule),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1971D0),
                    foregroundColor: Colors.white,
                    elevation: 7,
                    shadowColor: const Color(0x351971D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.center_focus_strong_rounded, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Scan Siswa Berikutnya',
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

              // TOMBOL LIHAT DAFTAR KEHADIRAN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    tampilkanPesan(
                      context,
                      'Fitur daftar kehadiran belum dibuat.',
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
                  child: const Text(
                    'Lihat Daftar Kehadiran',
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
