import 'package:flutter/material.dart';

// Model Data Siswa
class Student {
  final int id;
  final String name;
  final String nis;
  String? status; // 'Hadir', 'Sakit', 'Izin', 'Alpha', atau null

  Student({
    required this.id,
    required this.name,
    required this.nis,
    this.status,
  });
}

class AbsensiManualPage extends StatefulWidget {
  const AbsensiManualPage({Key? key}) : super(key: key);

  @override
  State<AbsensiManualPage> createState() => _AbsensiManualPageState();
}

class _AbsensiManualPageState extends State<AbsensiManualPage> {
  // Data Dummy Siswa
  final List<Student> _students = [
    Student(id: 1, name: "Ahmad Rizki", nis: "20260001", status: "Hadir"),
    Student(id: 2, name: "Budi Santoso", nis: "20260002", status: null),
    Student(id: 3, name: "Dinda Putri", nis: "20260003", status: "Izin"),
    Student(id: 4, name: "Rizki Fajar", nis: "20260004", status: "Sakit"),
  ];

  String _searchQuery = "";
  int _selectedFilterIndex = 0; // 0: Semua, 1: Belum Absen (termasuk Alpha & null), 2: Sudah Absen

  // Helper Warna Status
  Color _getStatusBgColor(String? status) {
    switch (status) {
      case "Hadir":
        return const Color(0xFFE8F5E9);
      case "Sakit":
        return const Color(0xFFF3E5F5);
      case "Izin":
        return const Color(0xFFFFF3E0);
      case "Alpha":
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusBorderColor(String? status) {
    switch (status) {
      case "Hadir":
        return const Color(0xFFA5D6A7);
      case "Sakit":
        return const Color(0xFFCE93D8);
      case "Izin":
        return const Color(0xFFFFCC80);
      case "Alpha":
        return const Color(0xFFEF9A9A);
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getStatusTextColor(String? status) {
    switch (status) {
      case "Hadir":
        return const Color(0xFF2E7D32);
      case "Sakit":
        return const Color(0xFF7B1FA2);
      case "Izin":
        return const Color(0xFFE65100);
      case "Alpha":
        return const Color(0xFFC62828);
      default:
        return Colors.grey.shade700;
    }
  }

  String _getStatusInitial(String? status) {
    if (status == null || status.isEmpty) return "-";
    return status[0].toUpperCase();
  }

  // Helper untuk mengecek apakah siswa termasuk kategori "Belum Absen" (null atau Alpha)
  bool _isBelumAbsen(String? status) {
    return status == null || status == "Alpha";
  }

  @override
  Widget build(BuildContext context) {
    // Perhitungan Angka Dinamis Real-Time
    int totalSiswa = _students.length;
    int belumAbsenCount = _students.where((s) => _isBelumAbsen(s.status)).length;
    int sudahAbsenCount = _students.where((s) => !_isBelumAbsen(s.status)).length;

    // Filter List berdasarkan pencarian dan tab filter
    final filteredStudents = _students.where((student) {
      final matchesSearch = student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.nis.contains(_searchQuery);
      
      if (_selectedFilterIndex == 1) {
        // Tab Belum Absen: Menampilkan yang null atau Alpha
        return matchesSearch && _isBelumAbsen(student.status);
      } else if (_selectedFilterIndex == 2) {
        // Tab Sudah Absen: Menampilkan Hadir, Sakit, atau Izin
        return matchesSearch && !_isBelumAbsen(student.status);
      }
      return matchesSearch;
    }).toList();

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
              "Absensi Manual",
              style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 2),
            Text(
              "Matematika • Kelas 8A",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
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
                    // Card Informasi Kelas
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2575FC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Matematika",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "07.00 - 08.30 • Pak Ahmad",
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Berlangsung",
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Info Box Status Kehadiran
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF3FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFF1565C0), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Pilih status kehadiran siswa",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1565C0)),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Gunakan absensi manual jika pemindaian wajah tidak dapat dilakukan.",
                                  style: TextStyle(fontSize: 11, color: Color(0xFF5C6BC0)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form Pencarian
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
                    const SizedBox(height: 12),

                    // Filter Chip Dinamis
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(0, "Semua $totalSiswa"),
                          const SizedBox(width: 8),
                          _buildFilterChip(1, "Belum Absen $belumAbsenCount"),
                          const SizedBox(width: 8),
                          _buildFilterChip(2, "Sudah Absen $sudahAbsenCount"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header Daftar Siswa & Perubahan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Daftar Siswa",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                        ),
                        Text(
                          "$sudahAbsenCount perubahan",
                          style: const TextStyle(fontSize: 12, color: Color(0xFF1565C0), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // List Siswa
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
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: [
                                      // Nomor Urut
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

                                      // ComboBox Status Kehadiran
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getStatusBgColor(student.status),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: _getStatusBorderColor(student.status)),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: student.status,
                                            hint: const Text("Pilih", style: TextStyle(fontSize: 12)),
                                            isDense: true,
                                            icon: Icon(Icons.keyboard_arrow_down, color: _getStatusTextColor(student.status), size: 18),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                student.status = newValue;
                                              });
                                            },
                                            items: <String>['Hadir', 'Sakit', 'Izin', 'Alpha'].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Badge Inisial
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: _getStatusBgColor(value),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        _getStatusInitial(value),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11,
                                                          color: _getStatusTextColor(value),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      value,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: _getStatusTextColor(value),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
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

            // Bottom Bar Simpan Absensi
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
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Perubahan",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        "$sudahAbsenCount siswa",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Absensi $sudahAbsenCount siswa berhasil disimpan!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.check, color: Colors.white, size: 18),
                          SizedBox(height: 2),
                          Text(
                            "Simpan Absensi",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget Filter Chip
  Widget _buildFilterChip(int index, String label) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}