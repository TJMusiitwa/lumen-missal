import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lumen_missal/api/litcal_api.dart';
import 'package:lumen_missal/api/litcal_models.dart';
import 'package:lumen_missal/api/bible_api.dart';

import 'api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('LitCalApi Tests', () {
    test('fetchTodayData returns data on success', () async {
      final client = MockClient();
      final api = LitCalApi(client: client);

      when(
        client.get(
          Uri.parse('https://litcal.johnromanodorazio.com/api/v5/calendar'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          '{"LitCal": {"2024-01-01": [{"name": "Mary, Mother of God", "color": "white", "date": "2024-01-01"}]}}',
          200,
        ),
      );

      final data = await api.fetchTodayData();

      expect(data.litcal.containsKey('2024-01-01'), true);
      expect(data.litcal['2024-01-01']!.first.name, 'Mary, Mother of God');
      expect(data.litcal['2024-01-01']!.first.color.first, 'white');
    });

    test(
      'indexes the live event array and excludes vigils and optional memorials',
      () {
        const date = '2026-01-02T00:00:00+00:00';
        final data = LitCalResponse.fromJson({
          'litcal': [
            {'date': date, 'name': 'Vigil', 'grade': 6, 'is_vigil_mass': true},
            {'date': date, 'name': 'Optional memorial', 'grade': 2},
            {'date': date, 'name': 'Weekday', 'grade': 0},
          ],
        });
        expect(data.daytimeEvent(DateTime(2026, 1, 2))?.name, 'Weekday');
        expect(data.daytimeEvent(DateTime(2026, 1, 3)), isNull);
      },
    );

    test('fetchTodayData throws exception on failure', () async {
      final client = MockClient();
      final api = LitCalApi(client: client);

      when(
        client.get(
          Uri.parse('https://litcal.johnromanodorazio.com/api/v5/calendar'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => api.fetchTodayData(), throwsException);
    });
  });

  group('BibleApi Tests', () {
    test('fetchPassage returns text on success', () async {
      final client = MockClient();
      final api = BibleApi(client: client);

      final ref = 'John 3:16';
      final uri = Uri(
        scheme: 'https',
        host: 'bible-api.com',
        pathSegments: [ref],
        queryParameters: {'translation': 'web'},
      );

      when(client.get(uri)).thenAnswer(
        (_) async => http.Response(
          '{"reference": "John 3:16", "text": "For God so loved the world..."}',
          200,
        ),
      );

      final text = await api.fetchPassage(ref);

      expect(text, 'For God so loved the world...');
    });

    test(
      'normalizes LitCal cross-chapter and dual-numbered Psalm citations',
      () async {
        final client = MockClient();
        final api = BibleApi(client: client);
        Uri lookup(String citation) => Uri(
          scheme: 'https',
          host: 'bible-api.com',
          pathSegments: [citation],
          queryParameters: {'translation': 'web'},
        );
        when(client.get(lookup('Psalm 103:1-2,4'))).thenAnswer(
          (_) async => http.Response('{"text":"First section"}', 200),
        );
        when(client.get(lookup('Psalm 104:5'))).thenAnswer(
          (_) async => http.Response('{"text":"Second section"}', 200),
        );

        expect(
          await api.fetchPassage('Cf. Psalm 103 (102): 1–2a.4; 104:5b'),
          'First section\n\nSecond section',
        );
      },
    );

    test('fetchPassage throws exception on failure', () async {
      final client = MockClient();
      final api = BibleApi(client: client);

      final ref = 'Invalid 1:1';
      final uri = Uri(
        scheme: 'https',
        host: 'bible-api.com',
        pathSegments: [ref],
        queryParameters: {'translation': 'web'},
      );

      when(client.get(uri))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => api.fetchPassage(ref), throwsException);
    });
  });
}
