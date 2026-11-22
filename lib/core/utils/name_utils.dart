// Utilitas nama orang yang dipakai di seluruh aplikasi.
// Nama dari backend bisa menyertakan gelar, misal "Bambang Sutrisno, S.Pd".

final _whitespace = RegExp(r'\s+');

/// Kata-kata nama tanpa gelar: "Bambang Sutrisno, S.Pd" -> [Bambang, Sutrisno].
List<String> _nameWords(String? fullName) => (fullName ?? '')
    .split(',')
    .first
    .trim()
    .split(_whitespace)
    .where((w) => w.isNotEmpty)
    .toList();

/// "Bambang Sutrisno, S.Pd" -> "BS". Dipakai untuk avatar tanpa foto.
String nameInitials(String? fullName, {String fallback = '?'}) {
  final initials = _nameWords(fullName)
      .take(2)
      .map((w) => w[0].toUpperCase())
      .join();
  return initials.isEmpty ? fallback : initials;
}

/// "Bambang Sutrisno, S.Pd" -> "Bambang". Dipakai untuk sapaan.
String firstName(String? fullName, {String fallback = ''}) {
  final words = _nameWords(fullName);
  return words.isEmpty ? fallback : words.first;
}
