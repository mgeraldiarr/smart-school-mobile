import 'package:flutter/material.dart';
// Import halaman Nilai Siswa dari page13 (sesuaikan jalur folder/file kamu)
import 'package:smart_school_mobile/page13/nilai_siswa_page.dart';

// Model untuk Data Mata Pelajaran
class Lesson {
  final String time;
  final String subject;
  final String teacher;
  final String status; // 'Mengajar', 'Berhalangan', 'Terjadwal'

  Lesson({
    required this.time,
    required this.subject,
    required this.teacher,
    required this.status,
  });
}

// Model untuk Hari & Jadwalnya
class DayScheduleModel {
  final String dayName;
  final String dateNum;
  final List<Lesson> lessons;

  DayScheduleModel({
    required this.dayName,
    required this.dateNum,
    required this.lessons,
  });
}

class JadwalPelajaranPage extends StatefulWidget {
  const JadwalPelajaranPage({Key? key}) : super(key: key);

  @override
  State<JadwalPelajaranPage> createState() => _JadwalPelajaranPageState();
}

class _JadwalPelajaranPageState extends State<JadwalPelajaranPage> {
  int _selectedDayIndex = 0;
  int _bottomNavIndex = 1; // Tab Jadwal aktif (indeks 1)

  // Data Dummy Berbeda Tiap Hari
  final List<DayScheduleModel> _weeklySchedules = [
    DayScheduleModel(
      dayName: "Sen",
      dateNum: "5",
      lessons: [
        Lesson(time: "07.00 - 08.30", subject: "Matematika", teacher: "Pak Ahmad", status: "Mengajar"),
        Lesson(time: "08.30 - 09.30", subject: "Bahasa Indonesia", teacher: "Pak Budi", status: "Mengajar"),
      ],
    ),
    DayScheduleModel(
      dayName: "Sel",
      dateNum: "6",
      lessons: [
        Lesson(time: "07.00 - 08.30", subject: "PPKn", teacher: "Pak Joko", status: "Mengajar"),
        Lesson(time: "08.30 - 10.00", subject: "IPS Terpadu", teacher: "Bu Ani", status: "Mengajar"),
      ],
    ),
    DayScheduleModel(
      dayName: "Rab",
      dateNum: "7",
      lessons: [
        Lesson(time: "07.00 - 08.30", subject: "Bahasa Inggris", teacher: "Bu Rina", status: "Mengajar"),
        Lesson(time: "08.30 - 10.00", subject: "Seni Budaya", teacher: "Pak Dedi", status: "Terjadwal"),
      ],
    ),
    DayScheduleModel(
      dayName: "Kam",
      dateNum: "8",
      lessons: [
        Lesson(time: "07.00 - 08.30", subject: "Informatika", teacher: "Bu Maya", status: "Mengajar"),
        Lesson(time: "08.30 - 10.00", subject: "Agama Islam", teacher: "Pak Ustadz", status: "Mengajar"),
      ],
    ),
    DayScheduleModel(
      dayName: "Jum",
      dateNum: "9",
      lessons: [
        Lesson(time: "07.00 - 08.30", subject: "Matematika", teacher: "Pak Ahmad", status: "Mengajar"),
        Lesson(time: "08.30 - 09.30", subject: "Bahasa Indonesia", teacher: "Pak Budi", status: "Mengajar"),
      ],
    ),
  ];

  Color _getStatusBgColor(String status) {
    switch (status) {
      case "Mengajar":
        return const Color(0xFFE8F5E9);
      case "Berhalangan":
        return const Color(0xFFFFF3E0);
      case "Terjadwal":
        return const Color(0xFFE3F2FD);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "Mengajar":
        return const Color(0xFF2E7D32);
      case "Berhalangan":
        return const Color(0xFFE65100);
      case "Terjadwal":
        return const Color(0xFF1565C0);
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDayData = _weeklySchedules[_selectedDayIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Jadwal Pelajaran",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Kelas 8A • Oktober 2026",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _weeklySchedules.length,
                itemBuilder: (context, index) {
                  final dayModel = _weeklySchedules[index];
                  final isSelected = index == _selectedDayIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      width: 62,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1976D2) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.shade200,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF1976D2).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayModel.dayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white70 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dayModel.dateNum,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: currentDayData.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = currentDayData.lessons[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            lesson.time,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1976D2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (index < currentDayData.lessons.length - 1)
                              Container(
                                width: 2,
                                height: 75,
                                color: Colors.blue.shade100,
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _getStatusTextColor(lesson.status),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lesson.subject,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        lesson.teacher,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusBgColor(lesson.status),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    lesson.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusTextColor(lesson.status),
                                    ),
                                  ),
                                ),
                              ],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });

          // Jika tab Nilai (index 2) diklik, arahkan ke halaman Nilai Siswa
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NilaiSiswaPage()),
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
}