import 'face_math.dart';

/// Satu percobaan pencocokan beserta jawaban benarnya, untuk mengukur akurasi.
class MatchTrial {
  /// Orang yang sebenarnya dipindai, atau null bila orang itu tidak terdaftar.
  final String? actualPersonId;
  final List<FaceMatch> ranking;

  const MatchTrial({required this.actualPersonId, required this.ranking});
}

/// Ringkasan akurasi dari kumpulan percobaan.
class ThresholdReport {
  /// Kemiripan wajah dengan dirinya sendiri (seharusnya tinggi).
  final List<double> genuineScores;

  /// Kemiripan wajah dengan orang lain (seharusnya rendah).
  final List<double> impostorScores;

  /// Jumlah percobaan yang hasilnya benar pada batas yang diuji.
  final int correct;
  final int total;

  const ThresholdReport({
    required this.genuineScores,
    required this.impostorScores,
    required this.correct,
    required this.total,
  });

  /// Batas di tengah celah antara impostor tertinggi dan genuine terendah.
  /// Null bila kedua kelompok tumpang tindih (model tidak bisa memisahkan).
  double? get suggestedThreshold {
    if (genuineScores.isEmpty || impostorScores.isEmpty) return null;
    final lowestGenuine = genuineScores.reduce((a, b) => a < b ? a : b);
    final highestImpostor = impostorScores.reduce((a, b) => a > b ? a : b);
    if (lowestGenuine <= highestImpostor) return null;
    return (lowestGenuine + highestImpostor) / 2;
  }

  static ThresholdReport evaluate(List<MatchTrial> trials, double threshold) {
    final genuine = <double>[];
    final impostor = <double>[];
    var correct = 0;

    for (final trial in trials) {
      for (final match in trial.ranking) {
        (match.personId == trial.actualPersonId ? genuine : impostor).add(
          match.similarity,
        );
      }
      final best = trial.ranking.isEmpty ? null : trial.ranking.first;
      final predicted = best != null && best.similarity >= threshold
          ? best.personId
          : null;
      if (predicted == trial.actualPersonId) correct++;
    }

    return ThresholdReport(
      genuineScores: genuine,
      impostorScores: impostor,
      correct: correct,
      total: trials.length,
    );
  }
}
