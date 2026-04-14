import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_missal/main.dart';
import 'package:lumen_missal/state/reading_notifier.dart';
import 'package:lumen_missal/settings/settings_notifier.dart';
import 'package:lumen_missal/database/database.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([AppDatabase, ReadingNotifier, SettingsNotifier])
void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    final mockNotifier = MockReadingNotifier();
    final mockSettingsNotifier = MockSettingsNotifier();

    when(mockNotifier.isLoading).thenReturn(true);
    when(mockNotifier.error).thenReturn(null);
    when(mockNotifier.data).thenReturn(null);
    when(mockSettingsNotifier.themeMode).thenReturn(ThemeMode.system);

    await tester.pumpWidget(MyApp(
      readingNotifier: mockNotifier,
      settingsNotifier: mockSettingsNotifier,
    ));

    expect(find.text('Daily Readings'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
