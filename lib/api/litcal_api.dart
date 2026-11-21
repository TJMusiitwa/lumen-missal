import 'dart:convert';

import 'package:http/http.dart' as http;

import 'litcal_models.dart';

class LitCalApi {
  static const _host = 'litcal.johnromanodorazio.com';
  static const _timeout = Duration(seconds: 10);

  final http.Client client;

  LitCalApi({http.Client? client}) : client = client ?? http.Client();

  Future<LitCalResponse> fetchTodayData({
    String type = 'general',
    String id = '',
    int? year,
    String? locale,
  }) async {
    final parameters = {
      if (year != null) 'year_type': 'CIVIL',
      if (locale != null) 'locale': locale,
    };
    final uri = Uri(
      scheme: 'https',
      host: _host,
      pathSegments: [
        'api',
        'v5',
        'calendar',
        if ((type == 'nation' || type == 'diocese') && id.isNotEmpty) ...[
          type,
          id,
        ],
        if (year != null) year.toString(),
      ],
      queryParameters: parameters.isEmpty ? null : parameters,
    );
    return LitCalResponse.fromJson(await _get(uri));
  }

  Future<Map<String, dynamic>> fetchCalendarMetadata() =>
      _get(Uri.https(_host, '/api/v5/calendars'));

  Future<List<dynamic>> fetchMissals() async {
    final data = await _get(Uri.https(_host, '/api/v5/missals'));
    return data['litcal_missals'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    final response = await client.get(uri).timeout(_timeout);
    if (response.statusCode != 200) {
      throw http.ClientException(
        'LitCal returned HTTP ${response.statusCode}',
        uri,
      );
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
