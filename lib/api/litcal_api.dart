import 'dart:convert';
import 'package:http/http.dart' as http;
import 'litcal_models.dart';

class LitCalApi {
  final http.Client client;

  LitCalApi({http.Client? client}) : client = client ?? http.Client();

  Future<LitCalResponse> fetchTodayData({
    String type = 'general',
    String id = '',
    int? year,
    String? locale,
  }) async {
    String url = 'https://litcal.johnromanodorazio.com/api/v5/calendar';

    if (type == 'nation' && id.isNotEmpty) {
      url += '/nation/$id';
    } else if (type == 'diocese' && id.isNotEmpty) {
      url += '/diocese/$id';
    }

    if (year != null) {
      url += '/$year';
    }

    final queryParams = <String, String>{};
    if (locale != null) {
      queryParams['locale'] = locale;
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return LitCalResponse.fromJson(jsonResponse as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load LitCal data');
    }
  }

  Future<Map<String, dynamic>> fetchCalendarMetadata() async {
    const url = 'https://litcal.johnromanodorazio.com/api/v5/calendars';
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load calendar metadata');
    }
  }

  Future<List<dynamic>> fetchMissals() async {
    const url = 'https://litcal.johnromanodorazio.com/api/v5/missals';
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['litcal_missals'] as List<dynamic>;
    } else {
      throw Exception('Failed to load missals');
    }
  }
}
