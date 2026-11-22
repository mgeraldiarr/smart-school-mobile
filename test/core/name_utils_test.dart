import 'package:flutter_test/flutter_test.dart';
import 'package:smart_school_mobile/core/utils/name_utils.dart';

void main() {
  test('inisial mengabaikan gelar dan spasi berlebih', () {
    expect(nameInitials('Bambang Sutrisno, S.Pd'), 'BS');
    expect(nameInitials('  ahmad   rizki fauzan '), 'AR');
    expect(nameInitials('Dinda'), 'D');
  });

  test('inisial memakai fallback bila nama kosong', () {
    expect(nameInitials(null, fallback: 'G'), 'G');
    expect(nameInitials('', fallback: 'W'), 'W');
    expect(nameInitials(', S.Pd'), '?');
  });

  test('nama depan tanpa gelar', () {
    expect(firstName('Bambang Sutrisno, S.Pd'), 'Bambang');
    expect(firstName(null, fallback: 'Guru'), 'Guru');
  });
}
