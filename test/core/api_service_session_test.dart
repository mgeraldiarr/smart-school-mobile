import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_school_mobile/core/network/api_service.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('data akun tersimpan tanpa token dan bisa dibaca kembali', () async {
    final api = ApiService();
    await api.saveUserData({
      'token': 'rahasia',
      'user': {'email': 'budi@email.com'},
    });

    final cached = await api.getUserData();
    expect(cached?['user'], {'email': 'budi@email.com'});
    expect(cached?.containsKey('token'), isFalse);
  });

  test('logout menghapus token, peran, dan data akun', () async {
    final api = ApiService();
    await api.saveSession(token: 'abc', role: 'parent');
    await api.saveUserData({
      'user': {'id': 1},
    });

    await api.clearSession();

    expect(await api.getToken(), isNull);
    expect(await api.getUserRole(), isNull);
    expect(await api.getUserData(), isNull);
  });
}
