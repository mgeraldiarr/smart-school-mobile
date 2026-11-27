import 'dart:math' as math;

/// Matematika pencocokan wajah. Murni Dart (tanpa plugin) supaya bisa dites.

/// Menyamakan panjang vektor menjadi 1. Setelah dinormalisasi, kemiripan
/// cosinus cukup dihitung dengan perkalian titik.
List<double> l2Normalize(List<double> vector) {
  var sumSquares = 0.0;
  for (final v in vector) {
    sumSquares += v * v;
  }
  final norm = math.sqrt(sumSquares);
  if (norm == 0) return List<double>.filled(vector.length, 0);
  return [for (final v in vector) v / norm];
}

/// Kemiripan cosinus: 1 = arah sama persis, 0 = tidak berhubungan.
double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length) {
    throw ArgumentError(
      'Panjang embedding berbeda (${a.length} vs ${b.length}). '
      'Kemungkinan dibuat dengan model yang berbeda.',
    );
  }
  var dot = 0.0, normA = 0.0, normB = 0.0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }
  if (normA == 0 || normB == 0) return 0;
  return dot / (math.sqrt(normA) * math.sqrt(normB));
}

/// Hasil pencocokan satu wajah terhadap satu orang terdaftar.
class FaceMatch {
  final String personId;

  /// Kemiripan tertinggi terhadap salah satu sampel wajah orang tersebut.
  final double similarity;

  const FaceMatch(this.personId, this.similarity);
}

/// Mencari orang terdaftar yang paling mirip dengan sebuah embedding.
class FaceMatcher {
  /// Batas minimal kemiripan untuk dianggap orang yang sama. Nilai final
  /// ditentukan dari hasil uji prototipe.
  final double threshold;

  const FaceMatcher({required this.threshold});

  /// Semua orang terdaftar, diurutkan dari yang paling mirip.
  List<FaceMatch> rank(
    List<double> probe,
    Map<String, List<List<double>>> gallery,
  ) {
    final matches = <FaceMatch>[
      for (final entry in gallery.entries)
        if (entry.value.isNotEmpty)
          FaceMatch(
            entry.key,
            entry.value
                .map((sample) => cosineSimilarity(probe, sample))
                .reduce(math.max),
          ),
    ]..sort((a, b) => b.similarity.compareTo(a.similarity));
    return matches;
  }

  /// Orang yang cocok, atau null bila tidak ada yang melewati batas.
  FaceMatch? bestMatch(
    List<double> probe,
    Map<String, List<List<double>>> gallery,
  ) {
    final ranked = rank(probe, gallery);
    if (ranked.isEmpty || ranked.first.similarity < threshold) return null;
    return ranked.first;
  }
}
