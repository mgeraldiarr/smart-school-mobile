import 'package:flutter/material.dart';

// Model Data Siswa Daftar Kehadiran
class AttendanceStudent {
  final int id;
  final String name;
  final String nis;
  String status; // 'Hadir', 'Tidak Hadir', 'Belum Absen'

  AttendanceStudent({
    required this.id,
    required this.name,
    required this.nis,
    required this.status,
  });
}

class DaftarKehadiranPage extends StatefulWidget {
  const DaftarKehadiranPage({super.key});

  @override
  State<DaftarKehadiranPage> createState() => _DaftarKehadiranPageState();
}

class _DaftarKehadiranPageState extends State<DaftarKehadiranPage> {
  // Data Dummy sesuai gambar
  final List<AttendanceStudent> _students = [
    AttendanceStudent(id: 1, name: "Ahmad Rizki", nis: "20260001", status: "Hadir"),
    AttendanceStudent(id: 2, name: "Budi Santoso", nis: "20260002", status: "Hadir"),
    AttendanceStudent(id: 3, name: "Dinda Putri", nis: "20260003", status: "Belum Absen"),
    AttendanceStudent(id: 4, name: "Rizki Fajar", nis: "20260004", status: "Tidak Hadir"),
  ];

  String _searchQuery = "";
  bool _isAscending = true; // Untuk fitur urutkan

  // Helper Warna Badge Status Kehadiran
  Color _getStatusBgColor(String status) {
    switch (status) {
      case "Hadir":
        return const Color(0xFFE8F5E9);
      case "Belum Absen":
        return const Color(0xFFFFF3E0);
      case "Tidak Hadir":
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "Hadir":
        return const Color(0xFF2E7D32);
      case "Belum Absen":
        return const Color(0xFFE65100);
      case "Tidak Hadir":
        return const Color(0xFFC62828);
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung Statistik Otomatis
    int totalHadir = _students.where((s) => s.status == "Hadir").length;
    int totalTidakHadir = _students.where((s) => s.status == "Tidak Hadir").length;
    int totalBelumAbsen = _students.where((s) => s.status == "Belum Absen").length;

    // Filter & Urutkan Data Siswa
    var filteredStudents = _students.where((student) {
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.nis.contains(_searchQuery);
    }).toList();

    filteredStudents.sort((a, b) {
      return _isAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEBF3FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E88E5), size: 18),
              onPressed: () {},
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Daftar Kehadiran",
              style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 2),
            Text(
              "Matematika • Kelas 8A",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1E88E5), size: 20),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Informasi Waktu & Tanggal (Warna Biru)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2575FC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "07.00 - 08.30",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Senin, 5 Oktober 2026",
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3 Kotak Statistik (Hadir, Tidak Hadir, Belum Absen)
                    Row(
                      children: [
                        Expanded(child: _buildStatCard(totalHadir.toString(), "Hadir", const Color(0xFF1E88E5))), // Bisa pakai variabel totalHadir
                        const SizedBox(width: 10),
                        Expanded(child: _buildStatCard(totalTidakHadir.toString(), "Tidak Hadir", Colors.black87)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildStatCard(totalBelumAbsen.toString(), "Belum Absen", Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Kotak Pencarian (Search Bar)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: const InputDecoration(
                          hintText: "Cari nama atau NIS siswa",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header Daftar Siswa & Tombol Urutkan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_students.length} Siswa",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAscending = !_isAscending;
                            });
                          },
                          child: Row(
                            children: const [
                              Text(
                                "Urutkan",
                                style: TextStyle(fontSize: 12, color: Color(0xFF1E88E5), fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.swap_vert, size: 16, color: Color(0xFF1E88E5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // List Container Daftar Siswa
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: filteredStudents.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: Text("Siswa tidak ditemukan", style: TextStyle(color: Colors.grey, fontSize: 13)),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredStudents.length,
                              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                              itemBuilder: (context, index) {
                                final student = filteredStudents[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  child: Row(
                                    children: [
                                      // Nomor Urut / ID Badge
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEBF3FA),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${student.id}",
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Nama & NIS Siswa
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "NIS ${student.nis}",
                                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Badge Status Kehadiran
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusBgColor(student.status),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          student.status,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: _getStatusTextColor(student.status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar Tombol "Selesai Absensi"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Absensi selesai disimpan!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Selesai Absensi",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Kotak Statistik di Atas
  Widget _buildStatCard(String count, String label, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}