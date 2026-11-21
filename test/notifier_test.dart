import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_missal/api/bible_api.dart';
import 'package:lumen_missal/api/litcal_api.dart';
import 'package:lumen_missal/api/litcal_models.dart';
import 'package:lumen_missal/database/database.dart';
import 'package:lumen_missal/settings/settings_notifier.dart';
import 'package:lumen_missal/state/reading_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'notifier_test.mocks.dart';

@GenerateMocks([LitCalApi, BibleApi, SettingsNotifier])
void main() {
  late AppDatabase database;
  late MockLitCalApi mockLitCalApi;
  late MockBibleApi mockBibleApi;
  late MockSettingsNotifier mockSettingsNotifier;
  late ReadingNotifier notifier;
  final today = DateTime(2026, 1, 2);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    mockLitCalApi = MockLitCalApi();
    mockBibleApi = MockBibleApi();
    mockSettingsNotifier = MockSettingsNotifier();

    // Set up default mock values for settings
    when(mockSettingsNotifier.calendarType).thenReturn('general');
    when(mockSettingsNotifier.calendarId).thenReturn('');
    when(mockSettingsNotifier.bibleTranslation).thenReturn('web');

    notifier = ReadingNotifier(
      database: database,
      settingsNotifier: mockSettingsNotifier,
      litCalApi: mockLitCalApi,
      bibleApi: mockBibleApi,
      now: () => today,
    );
  });

  tearDown(() async {
    notifier.dispose();
    await database.close();
  });

  test(
    'loadTodayReading fetches data on cache miss and updates state correctly',
    () async {
      when(
        mockLitCalApi.fetchTodayData(
          type: anyNamed('type'),
          id: anyNamed('id'),
          year: anyNamed('year'),
          locale: anyNamed('locale'),
        ),
      ).thenAnswer((_) async {
        return LitCalResponse.fromJson({
          "litcal": {
            "2026-01-02": [
              {
                "name": "Test Day",
                "date": today.toIso8601String(),
                "color": ["green"],
                "readings": {"gospel": "John 3:16"},
              },
            ],
          },
        });
      });

      when(
        mockBibleApi.fetchPassage(
          'John 3:16',
          translation: anyNamed('translation'),
        ),
      ).thenAnswer((_) async => 'Test Passage');

      expect(notifier.isLoading, isFalse);
      expect(notifier.data, isNull);

      final future = notifier.loadTodayReading();

      expect(notifier.isLoading, isTrue);

      await future;

      expect(notifier.isLoading, isFalse);
      expect(notifier.data, isNotNull);
      expect(notifier.data!.title, 'Test Day');
      expect(notifier.data!.liturgicalColorName, 'green');
      expect(notifier.error, isNull);
    },
  );

  test('loadTodayReading handles errors correctly', () async {
    when(
      mockLitCalApi.fetchTodayData(
        type: anyNamed('type'),
        id: anyNamed('id'),
        year: anyNamed('year'),
        locale: anyNamed('locale'),
      ),
    ).thenThrow(Exception('API Error'));

    final future = notifier.loadTodayReading();
    await future;

    expect(notifier.isLoading, isFalse);
    expect(notifier.data, isNull);
    expect(notifier.error, isNotNull);
    expect(notifier.error, contains('API Error'));
  });
  test(
    'retains saved text after a failed refresh and serves it from cache',
    () async {
      var offline = false;
      when(
        mockLitCalApi.fetchTodayData(
          type: 'general',
          id: '',
          year: 2026,
          locale: 'en_US',
        ),
      ).thenAnswer((_) async {
        if (offline) throw Exception('Offline');
        return LitCalResponse.fromJson({
          'litcal': [
            {
              'name': 'Daytime celebration',
              'date': '2026-01-02T00:00:00+00:00',
              'readings': {'gospel': 'John 3:16'},
            },
          ],
        });
      });
      when(mockBibleApi.fetchPassage('John 3:16', translation: 'web'))
          .thenAnswer((_) async => 'Saved text');

      await notifier.loadTodayReading();
      offline = true;
      await notifier.loadTodayReading(forceRefresh: true);

      expect(notifier.error, contains('Offline'));
      expect(notifier.data?.passages.single.text, 'Saved text');

      await notifier.loadTodayReading();
      expect(notifier.error, isNull);
      expect(notifier.data?.passages.single.text, 'Saved text');
      verify(mockBibleApi.fetchPassage('John 3:16', translation: 'web'))
          .called(1);
    },
  );
}
