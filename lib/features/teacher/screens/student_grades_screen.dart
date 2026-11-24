import 'package:flutter/material.dart';

import '../models/student_grade.dart';
import 'input_grade_screen.dart';

class StudentGradesScreen extends StatefulWidget {
  const StudentGradesScreen({super.key});

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  // TODO(api): ganti dengan data dari ApiConstants.teacherGrades
  static const String _className = '8A';
  static const String _subject = 'Matematika';
  static const String _semester = 'Ganjil 2026/2027';

  // Data dummy siswa & nilainya
  final List<StudentGrade> _students = [
    const StudentGrade(
      id: 1,
      name: 'Ahmad Rizki',
      nis: '20260001',
      className: _className,
      uts: 85,
      uas: 90,
    ),
    const StudentGrade(
      id: 2,
      name: 'Budi Santoso',
      nis: '20260002',
      className: _className,
      uts: 78,
      uas: 84,
    ),
    const StudentGrade(
      id: 3,
      name: 'Dinda Putri',
      nis: '20260003',
      className: _className,
      uts: 92,
      uas: 95,
    ),
    const StudentGrade(
      id: 4,
      name: 'Rizki Fajar',
      nis: '20260004',
      className: _className,
      uts: 80,
      uas: 82,
    ),
  ];

  /// Buka halaman Input Nilai, lalu perbarui daftar dengan hasil yang dikembalikan.
  Future<void> _openInputGrade(int index) async {
    final updated = await Navigator.of(context).push<StudentGrade>(
      MaterialPageRoute(
        builder: (_) => InputGradeScreen(
          grade: _students[index],
          subject: _subject,
          semester: _semester,
          // TODO(api): kirim updated.toJson() ke ApiConstants.teacherGrades di sini.
          // Bila request melempar error, halaman Input Nilai menampilkan pesan gagal.
        ),
      ),
    );

    if (updated == null || !mounted) return; // Pengguna menekan kembali

    setState(() => _students[index] = updated);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nilai ${updated.name} berhasil diperbarui!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header Atas
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nilai Siswa",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Kelola hasil belajar siswa",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3FE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.bar_chart_rounded,
                        color: Color(0xFF1A6FCC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 3 Kotak Filter Informasi (Kelas, Mapel, Semester)
                    Row(
                      children: [
                        Expanded(child: _buildInfoCard("Kelas", _className)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInfoCard("Mapel", _subject)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInfoCard("Semester", "Ganjil")),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Header Daftar Nilai & Jumlah Siswa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Daftar Nilai",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "32 siswa",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tabel / Container Daftar Nilai Siswa
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          // Header Kolom Tabel (Siswa, UTS, UAS)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Siswa",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 45,
                                  child: Text(
                                    "UTS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                SizedBox(
                                  width: 45,
                                  child: Text(
                                    "UAS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 32),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey.shade200),

                          // List Item Siswa
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _students.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1, color: Colors.grey.shade200),
                            itemBuilder: (context, index) {
                              final student = _students[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    // Nomor Absen & Nama Siswa
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE3F2FD),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${student.id}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1976D2),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              student.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Color(0xFF1E293B),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Nilai UTS
                                    SizedBox(
                                      width: 45,
                                      child: Text(
                                        "${student.uts}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1976D2),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Nilai UAS
                                    SizedBox(
                                      width: 45,
                                      child: Text(
                                        "${student.uas}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1976D2),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),

                                    // Tombol Edit (Ikon Pensil)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: Color(0xFF1976D2),
                                      ),
                                      onPressed: () => _openInputGrade(index),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.only(left: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  // Helper Widget untuk Kotak Info Atas
  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
