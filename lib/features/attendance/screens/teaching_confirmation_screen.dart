import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'face_scan_screen.dart';
import '../../teacher/models/teacher_schedule.dart';

// CLASS HALAMAN KONFIRMASI MENGAJAR
class TeachingConfirmationScreen extends StatelessWidget {
  final TeacherSchedule schedule;

  const TeachingConfirmationScreen({super.key, required this.schedule});

  // WIDGET UNTUK MENAMPILKAN BARIS DETAIL JADWAL
  Widget detailRow(String label, String value, {bool last = false}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 45),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE7EDF5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF71829D)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D2939),
            ),
          ),
        ],
      ),
    );
  }

  // FUNGSI UNTUK MEMBANGUN HALAMAN
  @override
  Widget build(BuildContext context) {
    final today = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          // HEADER HALAMAN
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Row(
                  children: [
                    Material(
                      color: const Color(0xFFEAF3FE),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(14),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: Color(0xFF1A6FCC),
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konfirmasi Mengajar',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Pastikan detail jadwal sudah benar',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // KONTEN UTAMA HALAMAN
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // KARTU MATA PELAJARAN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF196CC7), Color(0xFF278BE0)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.menu_book_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MATA PELAJARAN',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                schedule.subjectName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Kelas ${schedule.className}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // KARTU DETAIL JADWAL
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: const Color(0xFFDDE7F3)),
                      ),
                      child: Column(
                        children: [
                          detailRow('Mata Pelajaran', schedule.subjectName),
                          detailRow('Kelas', schedule.className),
                          detailRow('Jam', schedule.timeRange),
                          detailRow('Tanggal', today, last: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 17),

                    // INFORMASI SEBELUM MENGAJAR
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F2FF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF1971D0)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Siap memulai pembelajaran? '
                              'Status kehadiran Anda akan dicatat '
                              'saat dikonfirmasi.',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF286FC2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // TOMBOL KONFIRMASI MENUJU PAGE 7
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FaceScanScreen(schedule: schedule),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1971D0),
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
                              'Konfirmasi Mulai Mengajar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // STATUS GURU
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Guru Hadir  •  Pembelajaran Sedang Berlangsung',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
