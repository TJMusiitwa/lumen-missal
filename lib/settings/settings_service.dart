import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class Settings {
  final ThemeMode themeMode;
  final String bibleTranslation;
  final String calendarType; // 'general', 'nation', 'diocese'
  final String calendarId; // e.g., 'US', 'boston_us'

  Settings({
    this.themeMode = ThemeMode.system,
    this.bibleTranslation = 'web',
    this.calendarType = 'general',
    this.calendarId = '',
  });

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
    return Settings(
      themeMode: ThemeMode.values[json['themeMode'] ?? ThemeMode.system.index],
      bibleTranslation: json['bibleTranslation'] ?? 'web',
      calendarType: json['calendarType'] ?? 'general',
      calendarId: json['calendarId'] ?? '',
    );
  }
}

class SettingsService {
  static const String _settingsKey = 'lumen_missal_settings';

  Future<Settings> loadSettings() async {
    try {
      final storage = web.window.localStorage;
      final storedString = storage.getItem(_settingsKey);

      if (storedString != null) {
        final decodedMap = json.decode(storedString) as Map<String, dynamic>;
        return Settings.fromJson(decodedMap);
      }
    } catch (e) {
      debugPrint('Error loading settings from local storage: $e');
    }
    return Settings();
  }

  Future<void> saveSettings(Settings settings) async {
    try {
      final storage = web.window.localStorage;
      final jsonString = json.encode(settings.toJson());
      storage.setItem(_settingsKey, jsonString);
    } catch (e) {
      debugPrint('Error saving settings to local storage: $e');
    }
  }
}
