import 'dart:convert';
import 'package:http/http.dart' as http;
import 'litcal_models.dart';

class LitCalApi {
  final http.Client client;

  LitCalApi({http.Client? client}) : client = client ?? http.Client();

  Future<LitCalResponse> fetchTodayData({String type = 'general', String id = ''}) async {
    String url = 'https://litcal.johnromanodorazio.com/api/v5/calendar';

    if (type == 'nation' && id.isNotEmpty) {
      url += '/nation/$id';
    } else if (type == 'diocese' && id.isNotEmpty) {
      url += '/diocese/$id';
    }

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return LitCalResponse.fromJson(jsonResponse as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load LitCal data');
    }
  }
}
