import 'package:flutter_test/flutter_test.dart';
import 'package:smart_school_mobile/features/parent/models/parent_profile.dart';

void main() {
  test('membaca respons login (key parent & student)', () {
    final profile = ParentProfile.fromUserData({
      'parent': {'full_name': 'Budi Pratama', 'photo_url': 'https://x/y.png'},
      'user': {'email': 'budi.pratama@email.com'},
      'student': {
        'full_name': 'Ahmad Rizki',
        'nis': '20260001',
        'class': {'name': '8A'},
      },
    });

    expect(profile.fullName, 'Budi Pratama');
    expect(profile.email, 'budi.pratama@email.com');
    expect(profile.photoUrl, 'https://x/y.png');
    expect(profile.student?.className, '8A');
    expect(nameInitials(profile.student!.fullName), 'AR');
  });

  test('membaca respons /auth/me (key profile)', () {
    final profile = ParentProfile.fromUserData({
      'profile': {'full_name': 'Siti Aminah', 'email': 'siti@email.com'},
    });
    expect(profile.fullName, 'Siti Aminah');
    expect(profile.email, 'siti@email.com');
    expect(profile.student, isNull);
  });

  test('data kosong memakai fallback netral', () {
    final profile = ParentProfile.fromUserData(null);
    expect(profile.fullName, 'Wali Murid');
    expect(profile.email, '-');
    expect(profile.photoUrl, isNull);
  });
}
