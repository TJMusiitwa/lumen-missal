import 'dart:convert';

import 'package:http/http.dart' as http;

class BibleApi {
  final http.Client client;

  BibleApi({http.Client? client}) : client = client ?? http.Client();

  Future<String> fetchPassage(
    String reference, {
    String translation = 'web',
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'bible-api.com',
      pathSegments: [_lookupReference(reference)],
      queryParameters: {'translation': translation},
    );
    final response = await client.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Bible API returned HTTP ${response.statusCode}',
        uri,
      );
    }

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final text = (data['text'] as String?)?.trim();
    if (text == null || text.isEmpty) {
      throw const FormatException('Missing Bible passage text');
    }
    return text;
  }

  // Bible API works at verse granularity. Keep LitCal's original citation
  // for display, including any lettered subdivisions and “Cf.” prefix.
  String _lookupReference(String reference) {
    var result = reference
        .trim()
        .replaceFirst(RegExp(r'^cf\.?\s+', caseSensitive: false), '')
        .replaceAll(RegExp('[–—−]'), '-')
        .replaceFirstMapped(RegExp(r'(\d),\s*(?=\d)'), (m) => '${m[1]}:');
    final separator = result.indexOf(':');
    if (separator != -1) {
      final verses = result
          .substring(separator + 1)
          .replaceAllMapped(RegExp(r'(\d)[a-h]+\b'), (m) => m[1]!)
          .replaceAll(RegExp(r'\.(?=\s*\d)'), ',')
          .replaceAll(RegExp(r'\s+'), '');
      result = '${result.substring(0, separator + 1)}$verses';
    }
    return result;
  }
}
