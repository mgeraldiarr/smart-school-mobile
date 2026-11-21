import 'package:intl/intl.dart';

/// Nilai UTS & UAS satu siswa untuk satu mata pelajaran.
///
/// Dibuat immutable: perubahan nilai menghasilkan objek baru lewat [copyWith],
/// sehingga halaman lain tidak bisa mengubah data ini diam-diam.
class StudentGrade {
  static const int minScore = 0;
  static const int maxScore = 100;

  final int id;
  final String name;
  final String nis;
  final String className;
  final int uts;
  final int uas;

  const StudentGrade({
    required this.id,
    required this.name,
    required this.nis,
    required this.className,
    required this.uts,
    required this.uas,
  });

  /// Parsing respons API. Nama field mengikuti konvensi backend (snake_case);
  /// sesuaikan bila struktur respons `/teacher/grades` berbeda.
  factory StudentGrade.fromJson(Map<String, dynamic> json) {
    return StudentGrade(
      id: _toInt(json['student_id'] ?? json['id']),
      name: (json['full_name'] ?? json['name'] ?? '-').toString(),
      nis: (json['nis'] ?? '-').toString(),
      className: (json['class_name'] ?? '-').toString(),
      uts: _toInt(json['uts']),
      uas: _toInt(json['uas']),
    );
  }

  /// Payload yang dikirim saat menyimpan nilai.
  Map<String, dynamic> toJson() => {'student_id': id, 'uts': uts, 'uas': uas};

  StudentGrade copyWith({int? uts, int? uas}) {
    return StudentGrade(
      id: id,
      name: name,
      nis: nis,
      className: className,
      uts: uts ?? this.uts,
      uas: uas ?? this.uas,
    );
  }

  double get average => (uts + uas) / 2;

  /// "AR" dari "Ahmad Rizki".
  String get initials {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final result = words.take(2).map((w) => w[0].toUpperCase()).join();
    return result.isEmpty ? '?' : result;
  }

  static bool isValidScore(int? score) =>
      score != null && score >= minScore && score <= maxScore;

  static int _toInt(dynamic value) {
    if (value is num) return value.round();
    return num.tryParse(value?.toString() ?? '')?.round() ?? 0;
  }
}

/// Predikat dari nilai rata-rata. Ambang batas di satu tempat agar mudah
/// disesuaikan dengan aturan sekolah.
enum GradePredicate {
  a('A', 'Sangat Baik', 85),
  b('B', 'Baik', 75),
  c('C', 'Cukup', 65),
  d('D', 'Perlu Bimbingan', 0);

  final String letter;
  final String description;
  final double minAverage;

  const GradePredicate(this.letter, this.description, this.minAverage);

  static GradePredicate fromAverage(double average) =>
      values.firstWhere((p) => average >= p.minAverage, orElse: () => d);
}

/// 87.5 -> "87,5", 88.0 -> "88" (format angka Indonesia).
String formatScore(double value) => NumberFormat('0.#', 'id_ID').format(value);
