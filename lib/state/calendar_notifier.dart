import 'package:flutter/foundation.dart';

import '../api/litcal_api.dart';

class CalendarMetadata {
  final Map<String, String> nations;
  final Map<String, List<Map<String, String>>> dioceses;

  CalendarMetadata({required this.nations, required this.dioceses});
}

class CalendarNotifier extends ChangeNotifier {
  final LitCalApi _api;

  CalendarNotifier({LitCalApi? api}) : _api = api ?? LitCalApi();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  CalendarMetadata? _metadata;
  CalendarMetadata? get metadata => _metadata;

  Future<void> loadMetadata() async {
    if (_metadata != null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.fetchCalendarMetadata();
      final litcalMetadata = data['litcal_metadata'] as Map<String, dynamic>;

      final nationalCalendars =
          litcalMetadata['national_calendars'] as List<dynamic>;
      final Map<String, String> nations = {};
      for (final n in nationalCalendars) {
        final id = n['calendar_id'] as String;
        // Use a simple mapping for common IDs, or just the ID itself
        nations[id] = _getNationName(id);
      }

      final diocesanCalendars =
          litcalMetadata['diocesan_calendars'] as List<dynamic>;
      final Map<String, List<Map<String, String>>> dioceses = {};

      for (final d in diocesanCalendars) {
        final id = d['calendar_id'] as String;
        final nation = d['nation'] as String;
        final name = d['diocese'] as String;

        dioceses.putIfAbsent(nation, () => []);
        dioceses[nation]!.add({'id': id, 'name': name});
      }

      _metadata = CalendarMetadata(nations: nations, dioceses: dioceses);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getNationName(String id) {
    const names = {
      'VA': 'Vatican City',
      'IT': 'Italy',
      'US': 'United States',
      'CA': 'Canada',
      'GB': 'United Kingdom',
      'FR': 'France',
      'ES': 'Spain',
      'DE': 'Germany',
      'NL': 'Netherlands',
      'BE': 'Belgium',
      'IE': 'Ireland',
      'AU': 'Australia',
      'NZ': 'New Zealand',
      'IN': 'India',
      'PH': 'Philippines',
      'MX': 'Mexico',
      'BR': 'Brazil',
      'AR': 'Argentina',
      'PL': 'Poland',
      'HU': 'Hungary',
      'HR': 'Croatia',
      'SI': 'Slovenia',
      'SK': 'Slovakia',
      'CZ': 'Czech Republic',
      'PT': 'Portugal',
      'CH': 'Switzerland',
      'AT': 'Austria',
      'LU': 'Luxembourg',
      'NG': 'Nigeria',
      'ZA': 'South Africa',
      'VN': 'Vietnam',
    };
    return names[id] ?? id;
  }
}
