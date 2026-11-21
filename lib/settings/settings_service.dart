import 'dart:convert';

import 'package:flutter/material.dart';

import 'storage_impl.dart' as impl;

class const Settings({
  final ThemeMode themeMode = ThemeMode.system,
  final String bibleTranslation = 'web',
  final String calendarType = 'general',
  final String calendarId = '',
}) {
  Settings copyWith({
    ThemeMode? themeMode,
    String? bibleTranslation,
    String? calendarType,
    String? calendarId,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      bibleTranslation: bibleTranslation ?? this.bibleTranslation,
      calendarType: calendarType ?? this.calendarType,
      calendarId: calendarId ?? this.calendarId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'bibleTranslation': bibleTranslation,
      'calendarType': calendarType,
      'calendarId': calendarId,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    final calendar = switch (json) {
      {'calendarType': final String type, 'calendarId': final String id}
          when (type == 'nation' || type == 'diocese') && id.isNotEmpty =>
        (type, id),
      _ => ('general', ''),
    };
    return Settings(
      themeMode: switch (json['themeMode']) {
        final int index when index >= 0 && index < ThemeMode.values.length =>
          ThemeMode.values[index],
        _ => ThemeMode.system,
      },
      bibleTranslation: switch (json['bibleTranslation']) {
        final String id when id.isNotEmpty => id,
        _ => 'web',
      },
      calendarType: calendar.$1,
      calendarId: calendar.$2,
    );
  }
}

class SettingsService {
  static const String _settingsKey = 'lumen_missal_settings';
  final Storage _storage;

  SettingsService({Storage? storage})
    : _storage = storage ?? impl.createStorage();

  Future<Settings> loadSettings() async {
    try {
      final storedString = await _storage.getString(_settingsKey);

      if (storedString != null) {
        final decodedMap = json.decode(storedString) as Map<String, dynamic>;
        return Settings.fromJson(decodedMap);
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
    return Settings();
  }

  Future<void> saveSettings(Settings settings) async {
    try {
      final jsonString = json.encode(settings.toJson());
      await _storage.setString(_settingsKey, jsonString);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}

abstract class Storage {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
}
