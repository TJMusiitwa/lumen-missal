import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lumen_missal/settings/settings_notifier.dart';
import 'package:lumen_missal/settings/settings_service.dart';

import 'settings_notifier_test.mocks.dart';

@GenerateMocks([SettingsService])
void main() {
  late MockSettingsService mockSettingsService;
  late SettingsNotifier notifier;

  setUp(() {
    mockSettingsService = MockSettingsService();

    // Default mock response for loadSettings
    when(mockSettingsService.loadSettings()).thenAnswer((_) async => Settings());

    notifier = SettingsNotifier(settingsService: mockSettingsService);
  });

  group('SettingsNotifier Tests', () {
    test('loadSettings updates settings correctly', () async {
      final customSettings = Settings(bibleTranslation: 'kjv', themeMode: ThemeMode.dark);
      when(mockSettingsService.loadSettings()).thenAnswer((_) async => customSettings);

      await notifier.loadSettings();

      expect(notifier.bibleTranslation, 'kjv');
      expect(notifier.themeMode, ThemeMode.dark);
      verify(mockSettingsService.loadSettings()).called(1);
    });

    test('updateThemeMode updates state and saves to service', () async {
      await notifier.updateThemeMode(ThemeMode.light);

      expect(notifier.themeMode, ThemeMode.light);
      verify(mockSettingsService.saveSettings(any)).called(1);
    });

    test('updateBibleTranslation updates state and saves to service', () async {
      await notifier.updateBibleTranslation('drb');

      expect(notifier.bibleTranslation, 'drb');
      verify(mockSettingsService.saveSettings(any)).called(1);
    });

    test('updateCalendar updates state and saves to service', () async {
      await notifier.updateCalendar('nation', 'IT');

      expect(notifier.calendarType, 'nation');
      expect(notifier.calendarId, 'IT');
      verify(mockSettingsService.saveSettings(any)).called(1);
    });
  });
}
