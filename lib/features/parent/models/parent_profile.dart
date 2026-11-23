/// Data profil wali murid yang ditampilkan di tab Profil.
///
/// Semua parsing respons API dikumpulkan di sini agar UI cukup membaca field
/// yang sudah bersih. Bila struktur respons backend berubah, cukup ubah file ini.
class ParentProfile {
  final String fullName;
  final String email;

  /// URL foto profil. Null berarti UI menampilkan avatar inisial.
  final String? photoUrl;

  final LinkedStudent? student;

  /// Pengenal unik akun di perangkat ini (dipakai untuk kunci foto profil).
  final String accountKey;

  const ParentProfile({
    required this.accountKey,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.student,
  });

  /// Membaca `AuthProvider.userData`, baik dari respons login maupun `/auth/me`.
  ///
  /// Respons login menyimpan profil di `parent`, sedangkan `/auth/me` di
  /// `profile`. `profile` didahulukan karena selalu berasal dari server terbaru
  /// (data login bisa berasal dari cache saat aplikasi dibuka ulang).
  factory ParentProfile.fromUserData(Map<String, dynamic>? data) {
    final parent = _map(data?['profile']) ?? _map(data?['parent']);
    final user = _map(data?['user']) ?? _map(parent?['user']);
    final student = _pickStudent(
      loginStudent: _map(data?['student']) ?? _map(parent?['student']),
      linkedStudents: parent?['students'],
    );

    return ParentProfile(
      accountKey:
          _string(parent?['id']) ??
          _string(user?['id']) ??
          _string(student?['nis']) ??
          'default',
      fullName:
          _string(parent?['full_name']) ??
          _string(user?['name']) ??
          'Wali Murid',
      email:
          _string(user?['email']) ??
          _string(parent?['email']) ??
          _string(data?['email']) ??
          '-',
      photoUrl:
          _string(parent?['photo_url']) ??
          _string(parent?['avatar_url']) ??
          _string(user?['photo_url']),
      student: student == null ? null : LinkedStudent.fromJson(student),
    );
  }

  /// `/auth/me` mengirim semua anak (`students`), sedangkan login hanya anak
  /// yang NIS-nya dipakai masuk. Pilih anak yang sama, versi data terbarunya.
  static Map<String, dynamic>? _pickStudent({
    required Map<String, dynamic>? loginStudent,
    required dynamic linkedStudents,
  }) {
    final students = linkedStudents is List
        ? linkedStudents.whereType<Map<String, dynamic>>().toList()
        : const <Map<String, dynamic>>[];
    final loginNis = _string(loginStudent?['nis']);
    for (final s in students) {
      if (loginNis != null && _string(s['nis']) == loginNis) return s;
    }
    return loginStudent ?? (students.isEmpty ? null : students.first);
  }

  ParentProfile copyWith({String? fullName, String? email}) {
    return ParentProfile(
      accountKey: accountKey,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: photoUrl,
      student: student,
    );
  }
}

/// Anak (siswa) yang terhubung dengan akun wali murid.
class LinkedStudent {
  final String fullName;
  final String nis;
  final String className;

  const LinkedStudent({
    required this.fullName,
    required this.nis,
    required this.className,
  });

  factory LinkedStudent.fromJson(Map<String, dynamic> json) {
    // Kelas bisa dikirim sebagai string (`class_name`) atau objek (`class.name`)
    final classMap = _map(json['class']) ?? _map(json['school_class']);
    return LinkedStudent(
      fullName: _string(json['full_name']) ?? _string(json['name']) ?? '-',
      nis: _string(json['nis']) ?? '-',
      className:
          _string(json['class_name']) ??
          _string(classMap?['name']) ??
          _string(json['class']) ??
          '-',
    );
  }
}

Map<String, dynamic>? _map(dynamic value) =>
    value is Map<String, dynamic> ? value : null;

/// Mengembalikan null untuk nilai kosong agar fallback `??` berikutnya dipakai.
String? _string(dynamic value) {
  if (value == null || value is Map || value is List) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
