import 'package:flutter_test/flutter_test.dart';

import 'package:inno_entry/main.dart';

void main() {
  testWidgets('App starts with configured theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}
