import 'package:flutter_test/flutter_test.dart';
import 'package:smart_school_mobile/features/auth/screens/splash_screen.dart';

void main() {
  test('belum login selalu ke halaman login', () {
    expect(
      startDestinationFor(isLoggedIn: false, role: 'teacher'),
      StartDestination.login,
    );
  });

  test('sesi tersimpan diarahkan sesuai peran', () {
    expect(
      startDestinationFor(isLoggedIn: true, role: 'teacher'),
      StartDestination.teacherHome,
    );
    expect(
      startDestinationFor(isLoggedIn: true, role: 'parent'),
      StartDestination.parentHome,
    );
  });

  test('peran tidak dikenal diminta login ulang', () {
    expect(
      startDestinationFor(isLoggedIn: true, role: 'admin'),
      StartDestination.login,
    );
    expect(
      startDestinationFor(isLoggedIn: true, role: null),
      StartDestination.login,
    );
  });
}
