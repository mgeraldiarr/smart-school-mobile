import 'package:flutter_test/flutter_test.dart';
import 'package:smart_school_mobile/features/face_recognition/face_evaluation.dart';
import 'package:smart_school_mobile/features/face_recognition/face_math.dart';

void main() {
  final trials = [
    // Ahmad dipindai: dirinya 0.85, Dinda 0.30.
    const MatchTrial(
      actualPersonId: 'Ahmad',
      ranking: [FaceMatch('Ahmad', 0.85), FaceMatch('Dinda', 0.30)],
    ),
    // Dinda dipindai: dirinya 0.75, Ahmad 0.40.
    const MatchTrial(
      actualPersonId: 'Dinda',
      ranking: [FaceMatch('Dinda', 0.75), FaceMatch('Ahmad', 0.40)],
    ),
    // Orang tak terdaftar: tertinggi 0.45.
    const MatchTrial(
      actualPersonId: null,
      ranking: [FaceMatch('Ahmad', 0.45), FaceMatch('Dinda', 0.20)],
    ),
  ];

  test('memisahkan skor orang sama dan orang beda', () {
    final report = ThresholdReport.evaluate(trials, 0.6);
    expect(report.genuineScores, unorderedEquals([0.85, 0.75]));
    expect(report.impostorScores, unorderedEquals([0.30, 0.40, 0.45, 0.20]));
  });

  test('saran batas di tengah celah, dan semua benar pada batas itu', () {
    final report = ThresholdReport.evaluate(trials, 0.6);
    // Celah: impostor tertinggi 0.45, genuine terendah 0.75.
    expect(report.suggestedThreshold, closeTo(0.60, 1e-9));
    expect(report.correct, 3);
  });

  test('batas terlalu rendah membuat orang tak terdaftar dianggap cocok', () {
    final report = ThresholdReport.evaluate(trials, 0.40);
    expect(report.correct, 2);
  });

  test('tidak ada saran bila skor tumpang tindih', () {
    final report = ThresholdReport.evaluate([
      const MatchTrial(
        actualPersonId: 'Ahmad',
        ranking: [FaceMatch('Ahmad', 0.5)],
      ),
      const MatchTrial(
        actualPersonId: null,
        ranking: [FaceMatch('Ahmad', 0.6)],
      ),
    ], 0.55);
    expect(report.suggestedThreshold, isNull);
  });
}
