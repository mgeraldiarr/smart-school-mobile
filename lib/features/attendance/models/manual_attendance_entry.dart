// Satu baris presensi manual: status Hadir / Sakit / Izin / Alpha.

class ManualAttendanceEntry {
  final int id;
  final String name;
  final String nis;
  String? status; // 'Hadir', 'Sakit', 'Izin', 'Alpha', atau null

  ManualAttendanceEntry({
    required this.id,
    required this.name,
    required this.nis,
    this.status,
  });
}
