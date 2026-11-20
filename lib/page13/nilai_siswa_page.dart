import 'package:flutter/material.dart';
import 'package:smart_school_mobile/page12/jadwal_pelajaran.dart'; // Menghubungkan ke page12 Jadwal Pelajaran

// Model Data Nilai Siswa
class StudentGrade {
  final int id;
  final String name;
  int uts;
  int uas;

  StudentGrade({
    required this.id,
    required this.name,
    required this.uts,
    required this.uas,
  });
}

class NilaiSiswaPage extends StatefulWidget {
  const NilaiSiswaPage({super.key});

  @override
  State<NilaiSiswaPage> createState() => _NilaiSiswaPageState();
}

class _NilaiSiswaPageState extends State<NilaiSiswaPage> {
  int _bottomNavIndex = 2; // Default tab Nilai aktif (indeks 2)

  // Data Dummy Siswa & Nilainya sesuai gambar
  final List<StudentGrade> _students = [
    StudentGrade(id: 1, name: "Ahmad Rizki", uts: 85, uas: 90),
    StudentGrade(id: 2, name: "Budi Santoso", uts: 78, uas: 84),
    StudentGrade(id: 3, name: "Dinda Putri", uts: 92, uas: 95),
    StudentGrade(id: 4, name: "Rizki Fajar", uts: 80, uas: 82),
  ];

  // Fungsi untuk menampilkan Dialog Edit Nilai
  void _showEditDialog(StudentGrade student) {
    TextEditingController utsController = TextEditingController(text: student.uts.toString());
    TextEditingController uasController = TextEditingController(text: student.uas.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Edit Nilai - ${student.name}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: utsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nilai UTS", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: uasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nilai UAS", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2)),
              onPressed: () {
                setState(() {
                  student.uts = int.tryParse(utsController.text) ?? student.uts;
                  student.uas = int.tryParse(uasController.text) ?? student.uas;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Nilai ${student.name} berhasil diperbarui!")),
                );
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header Atas
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Nilai Siswa",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Kelola hasil belajar siswa",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF1976D2)),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 3 Kotak Filter Informasi (Kelas, Mapel, Semester)
                    Row(
                      children: [
                        Expanded(child: _buildInfoCard("Kelas", "8A")),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInfoCard("Mapel", "Matematika")),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 5,
                                  child: Text("Siswa", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(
                                  width: 45,
                                  child: Text("UTS", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(width: 16),
                                SizedBox(
                                  width: 45,
                                  child: Text("UAS", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
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
                            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                            itemBuilder: (context, index) {
                              final student = _students[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${student.id}",
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1976D2), fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              student.name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
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
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1976D2), fontSize: 13),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Nilai UAS
                                    SizedBox(
                                      width: 45,
                                      child: Text(
                                        "${student.uas}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1976D2), fontSize: 13),
                                      ),
                                    ),

                                    // Tombol Edit (Ikon Pensil)
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF1976D2)),
                                      onPressed: () => _showEditDialog(student),
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
      ),

      // Bottom Navigation Bar yang Menyambung ke Halaman Jadwal (page12)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });

          // Jika tab Jadwal (index 1) diklik, pindah halaman ke JadwalPelajaranPage
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const JadwalPelajaranPage()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: "Jadwal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: "Nilai",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profil",
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
            style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}