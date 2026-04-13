import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lumen_missal/api/litcal_api.dart';
import 'package:lumen_missal/api/bible_api.dart';

import 'api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('LitCalApi Tests', () {
    test('fetchTodayData returns data on success', () async {
      final client = MockClient();
      final api = LitCalApi(client: client);

      when(client.get(Uri.parse('https://litcal.johnromanodorazio.com/api/v3/')))
          .thenAnswer((_) async => http.Response('{"litcal": {"2024-01-01": [{"name": "Mary, Mother of God", "color": "white"}]}}', 200));

      final data = await api.fetchTodayData();

      expect(data, isA<Map<String, dynamic>>());
      expect(data['litcal']['2024-01-01'][0]['name'], 'Mary, Mother of God');
      expect(data['litcal']['2024-01-01'][0]['color'], 'white');
    });

    test('fetchTodayData throws exception on failure', () async {
      final client = MockClient();
      final api = LitCalApi(client: client);

      when(client.get(Uri.parse('https://litcal.johnromanodorazio.com/api/v3/')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => api.fetchTodayData(), throwsException);
    });
  });

  group('BibleApi Tests', () {
    test('fetchPassage returns text on success', () async {
      final client = MockClient();
      final api = BibleApi(client: client);

      final ref = 'John 3:16';
      final encodedRef = Uri.encodeComponent(ref);

      when(client.get(Uri.parse('https://bible-api.com/$encodedRef')))
          .thenAnswer((_) async => http.Response('{"reference": "John 3:16", "text": "For God so loved the world..."}', 200));

      final text = await api.fetchPassage(ref);

      expect(text, 'For God so loved the world...');
    });

    test('fetchPassage throws exception on failure', () async {
      final client = MockClient();
      final api = BibleApi(client: client);

      final ref = 'Invalid 1:1';
      final encodedRef = Uri.encodeComponent(ref);

      when(client.get(Uri.parse('https://bible-api.com/$encodedRef')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => api.fetchPassage(ref), throwsException);
    });
  });
}
