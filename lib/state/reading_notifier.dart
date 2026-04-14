import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../api/litcal_api.dart';
import '../api/bible_api.dart';
import '../database/database.dart';
import '../settings/settings_notifier.dart';

class ReadingData {
  final String dateKey;
  final String title;
  final String liturgicalColorName;
  final String readingsJson;

  ReadingData({
    required this.dateKey,
    required this.title,
    required this.liturgicalColorName,
    required this.readingsJson,
  });
}

class ReadingNotifier extends ChangeNotifier {
  final AppDatabase database;
  final LitCalApi litCalApi;
  final BibleApi bibleApi;
  final SettingsNotifier settingsNotifier;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReadingData? _data;
  ReadingData? get data => _data;

  String? _error;
  String? get error => _error;

  ReadingNotifier({
    required this.database,
    required this.settingsNotifier,
    LitCalApi? litCalApi,
    BibleApi? bibleApi,
  })  : litCalApi = litCalApi ?? LitCalApi(),
        bibleApi = bibleApi ?? BibleApi() {
    // Reload when settings change so the reading updates
    settingsNotifier.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    // Clear cache for today if settings changed so we fetch fresh
    loadTodayReading(forceRefresh: true);
  }

  @override
  void dispose() {
    settingsNotifier.removeListener(_onSettingsChanged);
    super.dispose();
  }

  Future<void> loadTodayReading({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final today = DateTime.now();
    // Include calendar and translation in the dateKey to separate caches
    final String calType = settingsNotifier.calendarType;
    final String calId = settingsNotifier.calendarId;
    final String translation = settingsNotifier.bibleTranslation;
    final String settingsHash = '${calType}_${calId}_$translation';
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}_$settingsHash';

    try {
      // 1. Check Cache
      final cached = await (database.select(database.cachedReadings)
            ..where((t) => t.dateKey.equals(dateKey)))
          .getSingleOrNull();

      if (cached != null && !forceRefresh) {
        // Cache Hit
        _data = ReadingData(
          dateKey: cached.dateKey,
          title: cached.title,
          liturgicalColorName: cached.liturgicalColorName,
          readingsJson: cached.readingsJson,
        );
      } else {
        // Cache Miss or Force Refresh
        if (forceRefresh && cached != null) {
          await (database.delete(database.cachedReadings)..where((t) => t.dateKey.equals(dateKey))).go();
        }

        // Fetch LitCal data
        final litCalResponse = await litCalApi.fetchTodayData(type: calType, id: calId);

        String title = 'Today\'s Reading';
        String color = 'green';
        List<String> readingReferences = [];

        final baseDateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

        if (litCalResponse.litcal.containsKey(baseDateKey)) {
          final dayDataList = litCalResponse.litcal[baseDateKey]!;
          if (dayDataList.isNotEmpty) {
            final dayData = dayDataList.first;
            title = dayData.name;

            if (dayData.color.isNotEmpty) {
              color = dayData.color.first;
            }

            if (dayData.readings != null) {
              final readingsMap = {
                'firstReading': dayData.readings!.firstReading,
                'responsorialPsalm': dayData.readings!.responsorialPsalm,
                'secondReading': dayData.readings!.secondReading,
                'gospelAcclamation': dayData.readings!.gospelAcclamation,
                'gospel': dayData.readings!.gospel,
              };
              readingReferences = readingsMap.values
                  .where((v) => v != null && v.isNotEmpty)
                  .cast<String>()
                  .toList();
            }

            if (readingReferences.isEmpty) {
              readingReferences = ['1 Cor 13:1-13']; // Realistic fallback per the instructions
            }
          }
        } else {
           readingReferences = ['1 Cor 13:1-13']; // Realistic fallback per the instructions
        }

        // Fetch Bible data
        final Map<String, String> compiledReadings = {};
        for (final ref in readingReferences) {
          try {
            final text = await bibleApi.fetchPassage(ref, translation: translation);
            compiledReadings[ref] = text;
          } catch (e) {
            compiledReadings[ref] = 'Passage not found in this translation.';
          }
        }

        final readingsJsonString = json.encode(compiledReadings);

        // Save to Cache
        await database.into(database.cachedReadings).insert(
          CachedReadingsCompanion.insert(
            dateKey: dateKey,
            title: title,
            liturgicalColorName: color,
            readingsJson: readingsJsonString,
          ),
        );

        _data = ReadingData(
          dateKey: dateKey,
          title: title,
          liturgicalColorName: color,
          readingsJson: readingsJsonString,
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
