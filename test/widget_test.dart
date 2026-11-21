import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_missal/main.dart';
import 'package:lumen_missal/state/calendar_notifier.dart';
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
    when(mockSettingsNotifier.calendarType).thenReturn('general');
    when(mockSettingsNotifier.bibleTranslation).thenReturn('web');

    await tester.pumpWidget(
      MyApp(
        readingNotifier: mockNotifier,
        settingsNotifier: mockSettingsNotifier,
        calendarNotifier: CalendarNotifier(),
      ),
    );

    expect(find.text('Daily Readings'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
  testWidgets('opens and closes a passage while its transition is running', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final notifier = MockReadingNotifier();
    final settings = MockSettingsNotifier();
    when(notifier.isLoading).thenReturn(false);
    when(notifier.error).thenReturn(null);
    when(notifier.data).thenReturn(
      ReadingData(
        dateKey: '2026-01-02',
        title: 'A liturgical celebration',
        liturgicalColorName: 'white',
        passages: const [ReadingPassage('Gospel', 'John 3:16', 'Passage text')],
        date: DateTime.utc(2026, 1, 2),
      ),
    );
    when(settings.themeMode).thenReturn(ThemeMode.light);
    when(settings.calendarType).thenReturn('general');
    when(settings.bibleTranslation).thenReturn('web');

    await tester.pumpWidget(
      MyApp(
        readingNotifier: notifier,
        settingsNotifier: settings,
        calendarNotifier: CalendarNotifier(),
      ),
    );
    await tester.tap(find.text('John 3:16'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    await tester.tap(find.text('All readings'));
    await tester.pumpAndSettle();

    expect(find.text('Reading order'), findsOneWidget);
    await tester.tap(find.text('John 3:16'));
    await tester.pumpAndSettle();
    expect(find.text('Passage text'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    final row = tester.widget<InkWell>(
      find.ancestor(of: find.text('John 3:16'), matching: find.byType(InkWell)),
    );
    expect(row.focusNode?.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });
}
