import 'dart:convert';
import 'package:http/http.dart' as http;

class LitCalApi {
  final http.Client client;

  LitCalApi({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchTodayData({String type = 'general', String id = ''}) async {
    String url = 'https://litcal.johnromanodorazio.com/api/v5/calendar';

    if (type == 'nation' && id.isNotEmpty) {
      url += '/nation/$id';
    } else if (type == 'diocese' && id.isNotEmpty) {
      url += '/diocese/$id';
    }

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Map v5 response structure to the expected map structure for our app
      // v5 response structure for /calendar endpoint looks like:
      // { "LitCal": { "2023-12-25": [{...}] } } or { "LitCal": [ { "date": "...", "name": "..."} ] } depending on JSON representation
      // Actually v5 returns an array of objects in "LitCal" if no specific date is used as key, or uses date as key if requested.
      // Based on OpenAPI specs, "LitCal" might be a list or an object. Let's make sure it's accessible via 'litcal' -> dateKey -> List

      // Since v5 usually returns "LitCal" (capitalised), we should handle it
      final litCalData = jsonResponse['LitCal'] ?? jsonResponse['litcal'];

      Map<String, dynamic> normalizedLitCal = {};

      if (litCalData is List) {
         // Some versions might return an array of events, each with a Date property
         for (var event in litCalData) {
            if (event is Map && event.containsKey('Date')) {
              String dateStr = event['Date'].toString().substring(0, 10); // Extract YYYY-MM-DD
              normalizedLitCal.putIfAbsent(dateStr, () => []);
              normalizedLitCal[dateStr].add(event);
            }
         }
      } else if (litCalData is Map) {
         normalizedLitCal = Map<String, dynamic>.from(litCalData);
      }

      return {'litcal': normalizedLitCal};
    } else {
      throw Exception('Failed to load LitCal data');
    }
  }
}
