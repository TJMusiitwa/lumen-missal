import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lumen_missal/api/litcal_api.dart';
import 'package:lumen_missal/api/bible_api.dart';
import 'package:lumen_missal/database/database.dart';
import 'package:lumen_missal/state/reading_notifier.dart';

import 'notifier_test.mocks.dart';

import 'package:drift/native.dart';
import 'package:lumen_missal/api/litcal_models.dart';

@GenerateMocks([LitCalApi, BibleApi])
void main() {
  late AppDatabase database;
  late MockLitCalApi mockLitCalApi;
  late MockBibleApi mockBibleApi;
  late ReadingNotifier notifier;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    mockLitCalApi = MockLitCalApi();
    mockBibleApi = MockBibleApi();
    notifier = ReadingNotifier(
      database: database,
      litCalApi: mockLitCalApi,
      bibleApi: mockBibleApi,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('loadTodayReading fetches data on cache miss and updates state correctly', () async {
    when(mockLitCalApi.fetchTodayData(type: anyNamed('type'), id: anyNamed('id'))).thenAnswer((_) async {
      return LitCalResponse.fromJson({
        "litcal": {
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}": [
            {
              "name": "Test Day",
              "color": ["green"],
              "readings": {
                 "gospel": "John 3:16"
              }
            }
          ]
        }
      });
    });

    when(mockBibleApi.fetchPassage('John 3:16', translation: anyNamed('translation'))).thenAnswer((_) async => 'Test Passage');

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
  });

  test('loadTodayReading handles errors correctly', () async {
    when(mockLitCalApi.fetchTodayData(type: anyNamed('type'), id: anyNamed('id'))).thenThrow(Exception('API Error'));

    final future = notifier.loadTodayReading();
    await future;

    expect(notifier.isLoading, isFalse);
    expect(notifier.data, isNull);
    expect(notifier.error, isNotNull);
    expect(notifier.error, contains('API Error'));
  });
}
