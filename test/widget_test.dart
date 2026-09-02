import 'package:flutter_test/flutter_test.dart';

import 'package:inno_entry/main.dart';
import 'package:inno_entry/src/di/app_dependencies.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/auth_storage.dart';
import 'package:inno_entry/src/feature/entry/data/datasources/entry_storage.dart';

void main() {
  testWidgets('App starts with configured theme', (WidgetTester tester) async {
    final dependencies = await AppDependencies.create(
      authStorage: AuthStorage(),
      entryStorage: EntryStorage(databaseName: 'inno_entry_widget_test.db'),
    );
    addTearDown(dependencies.dispose);

    await tester.pumpWidget(MyApp(dependencies: dependencies));

    expect(find.byType(MyApp), findsOneWidget);
  });
}
