import 'package:flutter_test/flutter_test.dart';
import 'package:smart_school_mobile/features/teacher/models/student_grade.dart';

void main() {
  const grade = StudentGrade(
    id: 1,
    name: 'Ahmad Rizki',
    nis: '20260001',
    className: '8A',
    uts: 85,
    uas: 90,
  );

  test('rata-rata dan format angka Indonesia', () {
    expect(grade.average, 87.5);
    expect(formatScore(grade.average), '87,5');
    expect(formatScore(88), '88');
  });

  test('predikat mengikuti ambang batas', () {
    expect(GradePredicate.fromAverage(87.5), GradePredicate.a);
    expect(GradePredicate.fromAverage(85), GradePredicate.a);
    expect(GradePredicate.fromAverage(84.5), GradePredicate.b);
    expect(GradePredicate.fromAverage(65), GradePredicate.c);
    expect(GradePredicate.fromAverage(10), GradePredicate.d);
  });

  test('validasi nilai 0-100', () {
    expect(StudentGrade.isValidScore(0), isTrue);
    expect(StudentGrade.isValidScore(100), isTrue);
    expect(StudentGrade.isValidScore(101), isFalse);
    expect(StudentGrade.isValidScore(null), isFalse);
  });

  test('copyWith tidak mengubah objek asli', () {
    final updated = grade.copyWith(uts: 70);
    expect(updated.uts, 70);
    expect(updated.uas, 90);
    expect(grade.uts, 85);
  });

  test('fromJson toleran terhadap angka berbentuk string', () {
    final parsed = StudentGrade.fromJson({
      'student_id': '7',
      'full_name': 'Dinda Putri',
      'nis': 20260003,
      'class_name': '8A',
      'uts': '92',
      'uas': 95.0,
    });
    expect(parsed.id, 7);
    expect(parsed.nis, '20260003');
    expect(parsed.uts, 92);
    expect(parsed.uas, 95);
    expect(parsed.initials, 'DP');
  });
}
