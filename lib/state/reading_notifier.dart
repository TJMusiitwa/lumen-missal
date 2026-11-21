import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../api/bible_api.dart';
import '../api/litcal_api.dart';
import '../api/litcal_models.dart';
import '../database/database.dart';
import '../settings/settings_notifier.dart';

typedef _ReadingPreferences = ({String type, String id, String translation});

class const ReadingPassage(
  final String label,
  final String reference,
  final String? text,
) {
  factory ReadingPassage.fromJson(Map<String, dynamic> json) => ReadingPassage(
    json['label'] as String,
    json['reference'] as String,
    json['text'] as String?,
  );

  Map<String, String?> toJson() => {
    'label': label,
    'reference': reference,
    'text': text,
  };
}

class ReadingData {
  ReadingData({
    required this.dateKey,
    required this.title,
    required this.liturgicalColorName,
    required Iterable<ReadingPassage> passages,
    this.grade,
    this.season,
    this.psalterWeek,
    this.liturgicalYear,
    required this.date,
  }) : passages = List.unmodifiable(passages);

  factory ReadingData.fromCache(CachedReading row) => ReadingData(
    dateKey: row.dateKey,
    title: row.title,
    liturgicalColorName: row.liturgicalColorName,
    passages: (jsonDecode(row.readingsJson) as List).map(
      (value) => ReadingPassage.fromJson(value as Map<String, dynamic>),
    ),
    grade: row.grade,
    season: row.season,
    psalterWeek: row.psalterWeek,
    liturgicalYear: row.liturgicalYear,
    date: row.date,
  );

  final String dateKey;
  final String title;
  final String liturgicalColorName;
  final List<ReadingPassage> passages;
  final String? grade;
  final String? season;
  final int? psalterWeek;
  final String? liturgicalYear;
  final DateTime date;

  bool get hasAllPassages =>
      passages.isNotEmpty && passages.every((passage) => passage.text != null);
}

class ReadingNotifier extends ChangeNotifier {
  final AppDatabase database;
  final LitCalApi litCalApi;
  final BibleApi bibleApi;
  final SettingsNotifier settingsNotifier;
  final DateTime Function() _now;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReadingData? _data;
  ReadingData? get data => _data;

  String? _error;
  String? get error => _error;

  late _ReadingPreferences _preferences;
  int _request = 0;
  String? _loadingKey;
  Future<void>? _loading;
  final _calendars = <(String, String, int), Future<LitCalResponse>>{};

  ReadingNotifier({
    required this.database,
    required this.settingsNotifier,
    LitCalApi? litCalApi,
    BibleApi? bibleApi,
    DateTime Function()? now,
  }) : litCalApi = litCalApi ?? LitCalApi(),
       bibleApi = bibleApi ?? BibleApi(),
       _now = now ?? DateTime.now {
    _preferences = _readPreferences();
    settingsNotifier.addListener(_onSettingsChanged);
  }

  _ReadingPreferences _readPreferences() => (
    type: settingsNotifier.calendarType,
    id: settingsNotifier.calendarId,
    translation: settingsNotifier.bibleTranslation,
  );

  void _onSettingsChanged() {
    final preferences = _readPreferences();
    if (preferences == _preferences) return;
    _preferences = preferences;
    loadTodayReading();
  }

  @override
  void dispose() {
    _request++;
    settingsNotifier.removeListener(_onSettingsChanged);
    super.dispose();
  }

  Future<void> loadTodayReading({bool forceRefresh = false}) {
    final today = _now();
    final preferences = _preferences;
    // Older cache entries have no reading labels and may contain fallback
    // verses or error text. Fetch a verified copy before showing them.
    final key =
        '${litCalDateKey(today)}_v2_${preferences.type}_'
        '${preferences.id}_${preferences.translation}';
    if (key == _loadingKey) return _loading ?? Future<void>.value();

    final request = ++_request;
    _loadingKey = key;
    _isLoading = true;
    _error = null;
    if (_data?.dateKey != key) _data = null;
    _loading = _load(request, today, key, preferences, forceRefresh);
    notifyListeners();
    return _loading!;
  }

  Future<void> _load(
    int request,
    DateTime today,
    String key,
    _ReadingPreferences preferences,
    bool forceRefresh,
  ) async {
    try {
      final cached = await _readCache(key);
      if (request != _request) return;
      if (cached != null) {
        _data = cached;
        if (!forceRefresh && cached.hasAllPassages) return;
        notifyListeners();
      }

      final calendar = await _calendar(today.year, preferences, forceRefresh);
      if (request != _request) return;
      final event = calendar.daytimeEvent(today);
      if (event == null) {
        throw const FormatException(
          'LitCal has no daytime event for this date',
        );
      }
      final references = event.readings?.references ?? const <String, String>{};
      // Keep the last good passages if the upstream data temporarily turns blank.
      final previous = _data;
      if (references.isEmpty &&
          previous != null &&
          previous.passages.isNotEmpty) {
        _error = 'LitCal did not return updated reading references.';
        return;
      }

      final savedText = {
        for (final passage in previous?.passages ?? const <ReadingPassage>[])
          if (passage.text case final String text) passage.reference: text,
      };
      final lookups = <String, Future<String?>>{};
      final passages = await Future.wait(
        references.entries.map((entry) async {
          final text =
              savedText[entry.value] ??
              await lookups.putIfAbsent(
                entry.value,
                () => _fetchPassage(entry.value, preferences.translation),
              );
          return ReadingPassage(entry.key, entry.value, text);
        }),
      );
      if (request != _request) return;

      final reading = ReadingData(
        dateKey: key,
        title: event.name,
        liturgicalColorName: event.color.firstOrNull ?? '',
        passages: passages,
        grade: event.gradeLcl,
        season: event.liturgicalSeasonLcl,
        psalterWeek: event.psalterWeek,
        liturgicalYear: event.liturgicalYear,
        date: DateTime.utc(today.year, today.month, today.day),
      );

      _data = reading;
      await _writeCache(reading);
    } catch (error) {
      if (request == _request) _error = error.toString();
    } finally {
      if (request == _request) {
        _loadingKey = null;
        _loading = null;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<LitCalResponse> _calendar(
    int year,
    _ReadingPreferences preferences,
    bool forceRefresh,
  ) async {
    final key = (preferences.type, preferences.id, year);
    if (forceRefresh) _calendars.remove(key);
    if (_calendars.length >= 4 && !_calendars.containsKey(key)) {
      _calendars.remove(_calendars.keys.first);
    }
    final future = _calendars.putIfAbsent(
      key,
      () => litCalApi.fetchTodayData(
        type: preferences.type,
        id: preferences.id,
        year: year,
        locale: 'en_US',
      ),
    );
    try {
      return await future;
    } catch (_) {
      if (_calendars[key] == future) _calendars.remove(key);
      rethrow;
    }
  }

  Future<String?> _fetchPassage(String reference, String translation) async {
    try {
      return await bibleApi.fetchPassage(reference, translation: translation);
    } catch (error) {
      debugPrint('Could not load Bible passage $reference: $error');
      return null;
    }
  }

  Future<ReadingData?> _readCache(String key) async {
    try {
      final row = await (database.select(
        database.cachedReadings,
      )..where((table) => table.dateKey.equals(key))).getSingleOrNull();
      return row == null ? null : ReadingData.fromCache(row);
    } catch (error) {
      debugPrint('Could not read the daily reading cache: $error');
      return null;
    }
  }

  Future<void> _writeCache(ReadingData reading) async {
    try {
      await database
          .into(database.cachedReadings)
          .insertOnConflictUpdate(
            CachedReadingsCompanion.insert(
              dateKey: reading.dateKey,
              title: reading.title,
              liturgicalColorName: reading.liturgicalColorName,
              readingsJson: jsonEncode(
                reading.passages.map((p) => p.toJson()).toList(),
              ),
              grade: Value(reading.grade),
              season: Value(reading.season),
              psalterWeek: Value(reading.psalterWeek),
              liturgicalYear: Value(reading.liturgicalYear),
              date: reading.date,
            ),
          );
    } catch (error) {
      debugPrint('Could not write the daily reading cache: $error');
    }
  }
}
