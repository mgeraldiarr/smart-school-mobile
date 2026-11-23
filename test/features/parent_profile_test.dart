import 'package:flutter_test/flutter_test.dart';
import 'package:smart_school_mobile/core/utils/name_utils.dart';
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

  test('auto-login: data /auth/me terbaru menimpa cache login', () {
    // Gabungan cache respons login + respons /auth/me (seperti tryAutoLogin).
    final profile = ParentProfile.fromUserData({
      'parent': {'id': 3, 'full_name': 'Nama Lama'},
      'student': {'nis': '20260002', 'full_name': 'Adik', 'class': '7-B'},
      'user': {'email': 'budi@email.com'},
      'profile': {
        'id': 3,
        'full_name': 'Budi Pratama',
        'students': [
          {
            'nis': '20260001',
            'full_name': 'Kakak',
            'school_class': {'name': '9-A'},
          },
          {
            'nis': '20260002',
            'full_name': 'Adik',
            'school_class': {'name': '8-A'},
          },
        ],
      },
    });

    expect(profile.fullName, 'Budi Pratama');
    // Anak yang sama dengan NIS saat login, dengan kelas terbaru.
    expect(profile.student?.fullName, 'Adik');
    expect(profile.student?.className, '8-A');
  });

  test('data kosong memakai fallback netral', () {
    final profile = ParentProfile.fromUserData(null);
    expect(profile.fullName, 'Wali Murid');
    expect(profile.email, '-');
    expect(profile.photoUrl, isNull);
  });
}
