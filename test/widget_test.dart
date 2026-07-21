import 'package:flutter_test/flutter_test.dart';

import 'package:inno_entry/main.dart';
import 'package:inno_entry/src/di/service_locator.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/auth_storage.dart';
import 'package:inno_entry/src/feature/entry/data/datasources/entry_storage.dart';

void main() {
  testWidgets('App starts with configured theme', (WidgetTester tester) async {
    await configureDependencies(
      authStorage: AuthStorage(),
      entryStorage: EntryStorage(databaseName: 'inno_entry_widget_test.db'),
      reset: true,
    );
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}
