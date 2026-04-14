import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bible_models.dart';

class BibleApi {
  final http.Client client;

  BibleApi({http.Client? client}) : client = client ?? http.Client();

  Future<String> fetchPassage(String reference, {String translation = 'web'}) async {
    final encodedReference = Uri.encodeComponent(reference);
    final response = await client.get(Uri.parse('https://bible-api.com/$encodedReference?translation=$translation'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final biblePassage = BiblePassageResponse.fromJson(jsonResponse as Map<String, dynamic>);
      return biblePassage.text;
    } else {
      throw Exception('Failed to load Bible passage: $reference');
    }
  }
}
