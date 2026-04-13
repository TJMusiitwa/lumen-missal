import 'dart:convert';
import 'package:http/http.dart' as http;

class BibleApi {
  final http.Client client;

  BibleApi({http.Client? client}) : client = client ?? http.Client();

  Future<String> fetchPassage(String reference) async {
    final encodedReference = Uri.encodeComponent(reference);
    final response = await client.get(Uri.parse('https://bible-api.com/$encodedReference'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['text'] as String;
    } else {
      throw Exception('Failed to load Bible passage: $reference');
    }
  }
}
