import 'package:flutter_test/flutter_test.dart';

import 'package:desktop_system/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
  });
}
