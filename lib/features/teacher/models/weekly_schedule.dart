// Jadwal pelajaran mingguan guru (data tampilan halaman Jadwal).

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
class DaySchedule {
  final String dayName;
  final String dateNum;
  final List<Lesson> lessons;

  DaySchedule({
    required this.dayName,
    required this.dateNum,
    required this.lessons,
  });
}
