import 'dart:convert';
import 'package:http/http.dart' as http;

class LitCalApi {
  final http.Client client;

  LitCalApi({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchTodayData() async {
    final response = await client.get(Uri.parse('https://litcal.johnromanodorazio.com/api/v3/'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // LitCal API v3 returns a structure like:
      // {
      //   "litcal": {
      //     "2023-12-25": [
      //       {
      //         "name": "The Nativity of the Lord",
      //         "color": "white",
      //         ...
      //       }
      //     ]
      //   }
      // }
      // This is a simplified extraction since the actual structure might be more complex
      // and depends on specific LitCal version details.

      return jsonResponse;
    } else {
      throw Exception('Failed to load LitCal data');
    }
  }
}
