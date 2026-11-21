import 'dart:convert';

import 'package:http/http.dart' as http;

class BibleApi {
  final http.Client client;

  BibleApi({http.Client? client}) : client = client ?? http.Client();

  Future<String> fetchPassage(
    String reference, {
    String translation = 'web',
  }) async {
    final citations = _lookupReferences(reference, translation);
    final texts = await Future.wait(
      citations.map((citation) => _fetch(citation, translation)),
    );
    return texts.join('\n\n');
  }

  Future<String> _fetch(String citation, String translation) async {
    final uri = Uri(
      scheme: 'https',
      host: 'bible-api.com',
      pathSegments: [citation],
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

  // Bible API works at verse granularity. Preserve LitCal's original
  // citation in the UI, including lettered subdivisions and “Cf.”.
  List<String> _lookupReferences(String reference, String translation) {
    if (reference.contains('|')) {
      throw const FormatException('LitCal supplies multiple reading options');
    }

    final sections = reference
        .trim()
        .replaceFirst(RegExp(r'^cf\.?\s+', caseSensitive: false), '')
        .replaceAll(RegExp('[–—−]'), '-')
        .split(';');
    var book = '';
    var chapter = '';
    return sections.map((section) {
      var citation = section
          .trim()
          .replaceFirstMapped(
            RegExp(r'^(Psalm\s+)(\d+)\s*\((\d+)\)', caseSensitive: false),
            (match) {
              final pair = [int.parse(match[2]!), int.parse(match[3]!)]..sort();
              final traditional =
                  translation == 'dra' || translation == 'clementine';
              return '${match[1]}${traditional ? pair.first : pair.last}';
            },
          )
          .replaceFirstMapped(
            RegExp(r'(^[^:]+?\s+\d+)\s*,\s*(?=\d)'),
            (match) => '${match[1]}:',
          );
      if (citation.isEmpty) {
        throw const FormatException('Empty citation section');
      }

      if (RegExp(r'^\d+\s*:').hasMatch(citation)) {
        if (book.isEmpty) throw const FormatException('Missing Bible book');
        citation = '$book $citation';
      } else if (RegExp(r'^\d+(?:[a-h]+)?(?:\s*[-.,]|$)').hasMatch(citation)) {
        if (chapter.isEmpty) {
          throw const FormatException('Missing Bible chapter');
        }
        citation = '$book $chapter:$citation';
      }

      final start = RegExp(r'^(.+?)\s+(\d+)\s*(?=:|$)').firstMatch(citation);
      if (start == null) {
        throw const FormatException('Unrecognized Bible citation');
      }
      book = start[1]!;
      chapter = start[2]!;

      final separator = citation.indexOf(':');
      if (separator == -1) return citation;
      final verses = citation
          .substring(separator + 1)
          .replaceAllMapped(RegExp(r'(\d)[a-h]+\b'), (match) => match[1]!)
          .replaceAll(RegExp(r'\.(?=\s*\d)'), ',')
          .replaceAll(RegExp(r'\s+'), '');
      return '$book $chapter:$verses';
    }).toList();
  }
}
