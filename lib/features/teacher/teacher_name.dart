// Nama guru dari backend menyertakan gelar, misal "Bambang Sutrisno, S.Pd"

String _nameWithoutTitle(String? fullName) =>
    (fullName ?? '').split(',').first.trim();

/// "Bambang Sutrisno, S.Pd" -> "Bambang"
String teacherFirstName(String? fullName) {
  final name = _nameWithoutTitle(fullName);
  return name.isEmpty ? 'Guru' : name.split(RegExp(r'\s+')).first;
}

/// "Bambang Sutrisno, S.Pd" -> "BS"
String teacherInitials(String? fullName) {
  final words = _nameWithoutTitle(fullName)
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .take(2);
  final initials = words.map((w) => w[0].toUpperCase()).join();
  return initials.isEmpty ? 'G' : initials;
}
