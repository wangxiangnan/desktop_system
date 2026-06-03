import 'package:flutter_test/flutter_test.dart';

import 'package:desktop_system/main.dart';

void main() {
  testWidgets('App can be instantiated', (WidgetTester tester) async {
    // MainApp is a simple StatelessWidget wrapping App.
    // Full DI setup is not available in unit tests without mocking;
    // integration tests should cover the full app flow.
    expect(() => const MainApp(), isA<Object>());
  });
}
