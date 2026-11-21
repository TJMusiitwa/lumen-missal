import 'package:flutter/material.dart';

import 'settings_service.dart';

class SettingsNotifier extends ChangeNotifier {
  final SettingsService settingsService;
  Settings _settings = Settings();

  SettingsNotifier({required this.settingsService});

  Settings get settings => _settings;
  ThemeMode get themeMode => _settings.themeMode;
  String get bibleTranslation => _settings.bibleTranslation;
  String get calendarType => _settings.calendarType;
  String get calendarId => _settings.calendarId;

  Future<void> loadSettings() async {
    _settings = await settingsService.loadSettings();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    if (themeMode == _settings.themeMode) return;
    _settings = _settings.copyWith(themeMode: themeMode);
    notifyListeners();
    await settingsService.saveSettings(_settings);
  }

  Future<void> updateBibleTranslation(String translation) async {
    if (translation == _settings.bibleTranslation) return;
    _settings = _settings.copyWith(bibleTranslation: translation);
    notifyListeners();
    await settingsService.saveSettings(_settings);
  }

  Future<void> updateCalendar(String type, String id) async {
    if (type == _settings.calendarType && id == _settings.calendarId) return;
    _settings = _settings.copyWith(calendarType: type, calendarId: id);
    notifyListeners();
    await settingsService.saveSettings(_settings);
  }
}
