// Satu baris daftar kehadiran: status Hadir / Tidak Hadir / Belum Absen.

class AttendanceRecord {
  final int id;
  final String name;
  final String nis;
  String status; // 'Hadir', 'Tidak Hadir', 'Belum Absen'

  AttendanceRecord({
    required this.id,
    required this.name,
    required this.nis,
    required this.status,
  });
}
