class LitCalReadings {
  final String? firstReading;
  final String? responsorialPsalm;
  final String? secondReading;
  final String? gospelAcclamation;
  final String? gospel;

  LitCalReadings({
    this.firstReading,
    this.responsorialPsalm,
    this.secondReading,
    this.gospelAcclamation,
    this.gospel,
  });

  factory LitCalReadings.fromJson(Map<String, dynamic> json) {
    return LitCalReadings(
      firstReading: json['first_reading'] as String?,
      responsorialPsalm: json['responsorial_psalm'] as String?,
      secondReading: json['second_reading'] as String?,
      gospelAcclamation: json['gospel_acclamation'] as String?,
      gospel: json['gospel'] as String?,
    );
  }
}

class LitCalEvent {
  final String name;
  final List<String> color;
  final LitCalReadings? readings;

  LitCalEvent({
    required this.name,
    required this.color,
    this.readings,
  });

  factory LitCalEvent.fromJson(Map<String, dynamic> json) {
    // Handle 'name' or 'Name'
    String eventName = json['name'] as String? ?? json['Name'] as String? ?? 'Today\'s Reading';

    // Handle 'color' or 'Color'
    List<String> eventColor = ['green'];
    if (json.containsKey('color')) {
      if (json['color'] is List && (json['color'] as List).isNotEmpty) {
        eventColor = (json['color'] as List).map((c) => c.toString()).toList();
      } else if (json['color'] is String) {
        eventColor = [json['color'] as String];
      }
    } else if (json.containsKey('Color') && json['Color'] is Map) {
      final colorMap = json['Color'] as Map;
      if (colorMap.containsKey('option')) {
        eventColor = [colorMap['option'] as String];
      }
    }

    // Handle 'readings'
    LitCalReadings? eventReadings;
    if (json.containsKey('readings') && json['readings'] is Map) {
      eventReadings = LitCalReadings.fromJson(json['readings'] as Map<String, dynamic>);
    }

    return LitCalEvent(
      name: eventName,
      color: eventColor,
      readings: eventReadings,
    );
  }
}

class LitCalResponse {
  final Map<String, List<LitCalEvent>> litcal;

  LitCalResponse({required this.litcal});

  factory LitCalResponse.fromJson(Map<String, dynamic> json) {
    final litCalData = json['LitCal'] ?? json['litcal'];

    Map<String, List<LitCalEvent>> normalizedLitCal = {};

    if (litCalData is List) {
      for (var event in litCalData) {
        if (event is Map && event.containsKey('Date')) {
          String dateStr = event['Date'].toString().substring(0, 10);
          normalizedLitCal.putIfAbsent(dateStr, () => []);
          normalizedLitCal[dateStr]!.add(LitCalEvent.fromJson(event as Map<String, dynamic>));
        }
      }
    } else if (litCalData is Map) {
      litCalData.forEach((key, value) {
        if (value is List) {
          normalizedLitCal[key] = value.map((e) => LitCalEvent.fromJson(e as Map<String, dynamic>)).toList();
        } else if (value is Map) {
          // If the values are objects with date properties, though usually in Map case, it's date -> array
          // Fallback if needed, but standard seems to be date -> array
          normalizedLitCal[key] = [LitCalEvent.fromJson(value as Map<String, dynamic>)];
        }
      });
    }

    return LitCalResponse(litcal: normalizedLitCal);
  }
}
