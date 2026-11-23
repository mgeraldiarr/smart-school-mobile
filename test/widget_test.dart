import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_school_mobile/main.dart';

void main() {
  testWidgets('tanpa sesi tersimpan, splash diteruskan ke halaman login', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SmartSchoolApp());
    // Splash hanya menampilkan logo.
    expect(find.text('Smart School'), findsNothing);

    // Lewati durasi minimum splash dan animasi fade ke login.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Smart School'), findsOneWidget);
  });
}
