class const LitCalReadings({
  final String? firstReading,
  final String? responsorialPsalm,
  final String? secondReading,
  final String? gospelAcclamation,
  final String? gospel,
}) {
  Map<String, String> get references => {
    for (final entry in {
      'First reading': firstReading,
      'Responsorial psalm': responsorialPsalm,
      'Second reading': secondReading,
      'Gospel acclamation': gospelAcclamation,
      'Gospel': gospel,
    }.entries)
      if (entry.value case final String reference
          when reference.trim().isNotEmpty)
        entry.key: reference.trim(),
  };

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

class const LitCalEvent({
  required final String name,
  required final List<String> color,
  final LitCalReadings? readings,
  final String? gradeLcl,
  final String? gradeAbbr,
  final String? liturgicalYear,
  final String? liturgicalSeasonLcl,
  final int? psalterWeek,
  final bool isVigilMass = false,
  final int grade = 0,
  final String? commonLcl,
  required final DateTime date,
}) {
  factory LitCalEvent.fromJson(Map<String, dynamic> json) {
    final eventDate = switch (json['date'] ?? json['Date']) {
      final int seconds => DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000,
        isUtc: true,
      ),
      final String date => DateTime.tryParse(date),
      _ => null,
    };
    if (eventDate == null) {
      throw const FormatException('Invalid LitCal event date');
    }

    final eventColor = switch (json['color'] ?? json['Color']) {
      final List colors => colors.cast<String>(),
      final String color => [color],
      {'option': final String color} => [color],
      _ => <String>[],
    };
    final eventReadings = json['readings'];

    return LitCalEvent(
      name:
          (json['name'] ?? json['Name']) as String? ?? 'Liturgical celebration',
      color: eventColor,
      readings: eventReadings is Map<String, dynamic>
          ? LitCalReadings.fromJson(eventReadings)
          : null,
      gradeLcl: (json['grade_display'] ?? json['grade_lcl']) as String?,
      grade: json['grade'] as int? ?? 0,
      gradeAbbr: json['grade_abbr'] as String?,
      liturgicalYear: json['liturgical_year'] as String?,
      liturgicalSeasonLcl: json['liturgical_season_lcl'] as String?,
      psalterWeek: json['psalter_week'] as int?,
      isVigilMass: json['is_vigil_mass'] as bool? ?? false,
      commonLcl: json['common_lcl'] as String?,
      date: eventDate,
    );
  }
}

class LitCalResponse({required final Map<String, List<LitCalEvent>> litcal}) {
  factory LitCalResponse.fromJson(Map<String, dynamic> json) {
    final litCalData = json['LitCal'] ?? json['litcal'];

    final eventsByDate = <String, List<LitCalEvent>>{};

    void addEvent(Object? value) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Invalid LitCal event');
      }
      final event = LitCalEvent.fromJson(value);
      (eventsByDate[litCalDateKey(event.date)] ??= []).add(event);
    }

    if (litCalData is List) {
      litCalData.forEach(addEvent);
    } else if (litCalData is Map) {
      for (final value in litCalData.values) {
        if (value is List) {
          value.forEach(addEvent);
        } else {
          addEvent(value);
        }
      }
    } else {
      throw const FormatException('Missing LitCal events');
    }

    return LitCalResponse(litcal: eventsByDate);
  }

  LitCalEvent? daytimeEvent(DateTime date) {
    LitCalEvent? selected;
    for (final event in litcal[litCalDateKey(date)] ?? <LitCalEvent>[]) {
      // Optional memorials do not replace a weekday by default.
      if (event.isVigilMass) continue;
      if (selected == null || _precedence(event) > _precedence(selected)) {
        selected = event;
      }
    }
    return selected;
  }

  int _precedence(LitCalEvent event) => switch (event.grade) {
    1 || 2 => -1,
    _ => event.grade,
  };
}

String litCalDateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
