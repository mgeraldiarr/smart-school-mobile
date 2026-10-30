import 'package:flutter_test/flutter_test.dart';
import 'package:smart_school_mobile/main.dart';

void main() {
  testWidgets('Smart School app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartSchoolApp());

    // Verify that Smart School title is rendered.
    expect(find.text('Smart School'), findsOneWidget);
  });
}
