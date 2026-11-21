// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CachedReadingsTable extends CachedReadings
    with TableInfo<$CachedReadingsTable, CachedReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _liturgicalColorNameMeta =
      const VerificationMeta('liturgicalColorName');
  @override
  late final GeneratedColumn<String> liturgicalColorName =
      GeneratedColumn<String>(
        'liturgical_color_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _readingsJsonMeta = const VerificationMeta(
    'readingsJson',
  );
  @override
  late final GeneratedColumn<String> readingsJson = GeneratedColumn<String>(
    'readings_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
    'grade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seasonMeta = const VerificationMeta('season');
  @override
  late final GeneratedColumn<String> season = GeneratedColumn<String>(
    'season',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _psalterWeekMeta = const VerificationMeta(
    'psalterWeek',
  );
  @override
  late final GeneratedColumn<int> psalterWeek = GeneratedColumn<int>(
    'psalter_week',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _liturgicalYearMeta = const VerificationMeta(
    'liturgicalYear',
  );
  @override
  late final GeneratedColumn<String> liturgicalYear = GeneratedColumn<String>(
    'liturgical_year',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateKey,
    title,
    liturgicalColorName,
    readingsJson,
    grade,
    season,
    psalterWeek,
    liturgicalYear,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('liturgical_color_name')) {
      context.handle(
        _liturgicalColorNameMeta,
        liturgicalColorName.isAcceptableOrUnknown(
          data['liturgical_color_name']!,
          _liturgicalColorNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_liturgicalColorNameMeta);
    }
    if (data.containsKey('readings_json')) {
      context.handle(
        _readingsJsonMeta,
        readingsJson.isAcceptableOrUnknown(
          data['readings_json']!,
          _readingsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_readingsJsonMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    }
    if (data.containsKey('season')) {
      context.handle(
        _seasonMeta,
        season.isAcceptableOrUnknown(data['season']!, _seasonMeta),
      );
    }
    if (data.containsKey('psalter_week')) {
      context.handle(
        _psalterWeekMeta,
        psalterWeek.isAcceptableOrUnknown(
          data['psalter_week']!,
          _psalterWeekMeta,
        ),
      );
    }
    if (data.containsKey('liturgical_year')) {
      context.handle(
        _liturgicalYearMeta,
        liturgicalYear.isAcceptableOrUnknown(
          data['liturgical_year']!,
          _liturgicalYearMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateKey};
  @override
  CachedReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedReading(
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      liturgicalColorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}liturgical_color_name'],
      )!,
      readingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}readings_json'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade'],
      ),
      season: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}season'],
      ),
      psalterWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}psalter_week'],
      ),
      liturgicalYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}liturgical_year'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $CachedReadingsTable createAlias(String alias) {
    return $CachedReadingsTable(attachedDatabase, alias);
  }
}

class CachedReading extends DataClass implements Insertable<CachedReading> {
  final String dateKey;
  final String title;
  final String liturgicalColorName;
  final String readingsJson;
  final String? grade;
  final String? season;
  final int? psalterWeek;
  final String? liturgicalYear;
  final DateTime date;
  const CachedReading({
    required this.dateKey,
    required this.title,
    required this.liturgicalColorName,
    required this.readingsJson,
    this.grade,
    this.season,
    this.psalterWeek,
    this.liturgicalYear,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_key'] = Variable<String>(dateKey);
    map['title'] = Variable<String>(title);
    map['liturgical_color_name'] = Variable<String>(liturgicalColorName);
    map['readings_json'] = Variable<String>(readingsJson);
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<String>(grade);
    }
    if (!nullToAbsent || season != null) {
      map['season'] = Variable<String>(season);
    }
    if (!nullToAbsent || psalterWeek != null) {
      map['psalter_week'] = Variable<int>(psalterWeek);
    }
    if (!nullToAbsent || liturgicalYear != null) {
      map['liturgical_year'] = Variable<String>(liturgicalYear);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  CachedReadingsCompanion toCompanion(bool nullToAbsent) {
    return CachedReadingsCompanion(
      dateKey: Value(dateKey),
      title: Value(title),
      liturgicalColorName: Value(liturgicalColorName),
      readingsJson: Value(readingsJson),
      grade: grade == null && nullToAbsent
          ? const Value.absent()
          : Value(grade),
      season: season == null && nullToAbsent
          ? const Value.absent()
          : Value(season),
      psalterWeek: psalterWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(psalterWeek),
      liturgicalYear: liturgicalYear == null && nullToAbsent
          ? const Value.absent()
          : Value(liturgicalYear),
      date: Value(date),
    );
  }

  factory CachedReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedReading(
      dateKey: serializer.fromJson<String>(json['dateKey']),
      title: serializer.fromJson<String>(json['title']),
      liturgicalColorName: serializer.fromJson<String>(
        json['liturgicalColorName'],
      ),
      readingsJson: serializer.fromJson<String>(json['readingsJson']),
      grade: serializer.fromJson<String?>(json['grade']),
      season: serializer.fromJson<String?>(json['season']),
      psalterWeek: serializer.fromJson<int?>(json['psalterWeek']),
      liturgicalYear: serializer.fromJson<String?>(json['liturgicalYear']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateKey': serializer.toJson<String>(dateKey),
      'title': serializer.toJson<String>(title),
      'liturgicalColorName': serializer.toJson<String>(liturgicalColorName),
      'readingsJson': serializer.toJson<String>(readingsJson),
      'grade': serializer.toJson<String?>(grade),
      'season': serializer.toJson<String?>(season),
      'psalterWeek': serializer.toJson<int?>(psalterWeek),
      'liturgicalYear': serializer.toJson<String?>(liturgicalYear),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  CachedReading copyWith({
    String? dateKey,
    String? title,
    String? liturgicalColorName,
    String? readingsJson,
    Value<String?> grade = const Value.absent(),
    Value<String?> season = const Value.absent(),
    Value<int?> psalterWeek = const Value.absent(),
    Value<String?> liturgicalYear = const Value.absent(),
    DateTime? date,
  }) => CachedReading(
    dateKey: dateKey ?? this.dateKey,
    title: title ?? this.title,
    liturgicalColorName: liturgicalColorName ?? this.liturgicalColorName,
    readingsJson: readingsJson ?? this.readingsJson,
    grade: grade.present ? grade.value : this.grade,
    season: season.present ? season.value : this.season,
    psalterWeek: psalterWeek.present ? psalterWeek.value : this.psalterWeek,
    liturgicalYear: liturgicalYear.present
        ? liturgicalYear.value
        : this.liturgicalYear,
    date: date ?? this.date,
  );
  CachedReading copyWithCompanion(CachedReadingsCompanion data) {
    return CachedReading(
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      title: data.title.present ? data.title.value : this.title,
      liturgicalColorName: data.liturgicalColorName.present
          ? data.liturgicalColorName.value
          : this.liturgicalColorName,
      readingsJson: data.readingsJson.present
          ? data.readingsJson.value
          : this.readingsJson,
      grade: data.grade.present ? data.grade.value : this.grade,
      season: data.season.present ? data.season.value : this.season,
      psalterWeek: data.psalterWeek.present
          ? data.psalterWeek.value
          : this.psalterWeek,
      liturgicalYear: data.liturgicalYear.present
          ? data.liturgicalYear.value
          : this.liturgicalYear,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedReading(')
          ..write('dateKey: $dateKey, ')
          ..write('title: $title, ')
          ..write('liturgicalColorName: $liturgicalColorName, ')
          ..write('readingsJson: $readingsJson, ')
          ..write('grade: $grade, ')
          ..write('season: $season, ')
          ..write('psalterWeek: $psalterWeek, ')
          ..write('liturgicalYear: $liturgicalYear, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dateKey,
    title,
    liturgicalColorName,
    readingsJson,
    grade,
    season,
    psalterWeek,
    liturgicalYear,
    date,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedReading &&
          other.dateKey == this.dateKey &&
          other.title == this.title &&
          other.liturgicalColorName == this.liturgicalColorName &&
          other.readingsJson == this.readingsJson &&
          other.grade == this.grade &&
          other.season == this.season &&
          other.psalterWeek == this.psalterWeek &&
          other.liturgicalYear == this.liturgicalYear &&
          other.date == this.date);
}

class CachedReadingsCompanion extends UpdateCompanion<CachedReading> {
  final Value<String> dateKey;
  final Value<String> title;
  final Value<String> liturgicalColorName;
  final Value<String> readingsJson;
  final Value<String?> grade;
  final Value<String?> season;
  final Value<int?> psalterWeek;
  final Value<String?> liturgicalYear;
  final Value<DateTime> date;
  final Value<int> rowid;
  const CachedReadingsCompanion({
    this.dateKey = const Value.absent(),
    this.title = const Value.absent(),
    this.liturgicalColorName = const Value.absent(),
    this.readingsJson = const Value.absent(),
    this.grade = const Value.absent(),
    this.season = const Value.absent(),
    this.psalterWeek = const Value.absent(),
    this.liturgicalYear = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedReadingsCompanion.insert({
    required String dateKey,
    required String title,
    required String liturgicalColorName,
    required String readingsJson,
    this.grade = const Value.absent(),
    this.season = const Value.absent(),
    this.psalterWeek = const Value.absent(),
    this.liturgicalYear = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  }) : dateKey = Value(dateKey),
       title = Value(title),
       liturgicalColorName = Value(liturgicalColorName),
       readingsJson = Value(readingsJson),
       date = Value(date);
  static Insertable<CachedReading> custom({
    Expression<String>? dateKey,
    Expression<String>? title,
    Expression<String>? liturgicalColorName,
    Expression<String>? readingsJson,
    Expression<String>? grade,
    Expression<String>? season,
    Expression<int>? psalterWeek,
    Expression<String>? liturgicalYear,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateKey != null) 'date_key': dateKey,
      if (title != null) 'title': title,
      if (liturgicalColorName != null)
        'liturgical_color_name': liturgicalColorName,
      if (readingsJson != null) 'readings_json': readingsJson,
      if (grade != null) 'grade': grade,
      if (season != null) 'season': season,
      if (psalterWeek != null) 'psalter_week': psalterWeek,
      if (liturgicalYear != null) 'liturgical_year': liturgicalYear,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedReadingsCompanion copyWith({
    Value<String>? dateKey,
    Value<String>? title,
    Value<String>? liturgicalColorName,
    Value<String>? readingsJson,
    Value<String?>? grade,
    Value<String?>? season,
    Value<int?>? psalterWeek,
    Value<String?>? liturgicalYear,
    Value<DateTime>? date,
    Value<int>? rowid,
  }) {
    return CachedReadingsCompanion(
      dateKey: dateKey ?? this.dateKey,
      title: title ?? this.title,
      liturgicalColorName: liturgicalColorName ?? this.liturgicalColorName,
      readingsJson: readingsJson ?? this.readingsJson,
      grade: grade ?? this.grade,
      season: season ?? this.season,
      psalterWeek: psalterWeek ?? this.psalterWeek,
      liturgicalYear: liturgicalYear ?? this.liturgicalYear,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (liturgicalColorName.present) {
      map['liturgical_color_name'] = Variable<String>(
        liturgicalColorName.value,
      );
    }
    if (readingsJson.present) {
      map['readings_json'] = Variable<String>(readingsJson.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (season.present) {
      map['season'] = Variable<String>(season.value);
    }
    if (psalterWeek.present) {
      map['psalter_week'] = Variable<int>(psalterWeek.value);
    }
    if (liturgicalYear.present) {
      map['liturgical_year'] = Variable<String>(liturgicalYear.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedReadingsCompanion(')
          ..write('dateKey: $dateKey, ')
          ..write('title: $title, ')
          ..write('liturgicalColorName: $liturgicalColorName, ')
          ..write('readingsJson: $readingsJson, ')
          ..write('grade: $grade, ')
          ..write('season: $season, ')
          ..write('psalterWeek: $psalterWeek, ')
          ..write('liturgicalYear: $liturgicalYear, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedReadingsTable cachedReadings = $CachedReadingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedReadings];
}

typedef $$CachedReadingsTableCreateCompanionBuilder =
    CachedReadingsCompanion Function({
      required String dateKey,
      required String title,
      required String liturgicalColorName,
      required String readingsJson,
      Value<String?> grade,
      Value<String?> season,
      Value<int?> psalterWeek,
      Value<String?> liturgicalYear,
      required DateTime date,
      Value<int> rowid,
    });
typedef $$CachedReadingsTableUpdateCompanionBuilder =
    CachedReadingsCompanion Function({
      Value<String> dateKey,
      Value<String> title,
      Value<String> liturgicalColorName,
      Value<String> readingsJson,
      Value<String?> grade,
      Value<String?> season,
      Value<int?> psalterWeek,
      Value<String?> liturgicalYear,
      Value<DateTime> date,
      Value<int> rowid,
    });

class $$CachedReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedReadingsTable> {
  $$CachedReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get liturgicalColorName => $composableBuilder(
    column: $table.liturgicalColorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingsJson => $composableBuilder(
    column: $table.readingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get season => $composableBuilder(
    column: $table.season,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get psalterWeek => $composableBuilder(
    column: $table.psalterWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get liturgicalYear => $composableBuilder(
    column: $table.liturgicalYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedReadingsTable> {
  $$CachedReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get liturgicalColorName => $composableBuilder(
    column: $table.liturgicalColorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingsJson => $composableBuilder(
    column: $table.readingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get season => $composableBuilder(
    column: $table.season,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get psalterWeek => $composableBuilder(
    column: $table.psalterWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get liturgicalYear => $composableBuilder(
    column: $table.liturgicalYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedReadingsTable> {
  $$CachedReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get liturgicalColorName => $composableBuilder(
    column: $table.liturgicalColorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readingsJson => $composableBuilder(
    column: $table.readingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get season =>
      $composableBuilder(column: $table.season, builder: (column) => column);

  GeneratedColumn<int> get psalterWeek => $composableBuilder(
    column: $table.psalterWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get liturgicalYear => $composableBuilder(
    column: $table.liturgicalYear,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$CachedReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedReadingsTable,
          CachedReading,
          $$CachedReadingsTableFilterComposer,
          $$CachedReadingsTableOrderingComposer,
          $$CachedReadingsTableAnnotationComposer,
          $$CachedReadingsTableCreateCompanionBuilder,
          $$CachedReadingsTableUpdateCompanionBuilder,
          (
            CachedReading,
            BaseReferences<_$AppDatabase, $CachedReadingsTable, CachedReading>,
          ),
          CachedReading,
          PrefetchHooks Function()
        > {
  $$CachedReadingsTableTableManager(
    _$AppDatabase db,
    $CachedReadingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dateKey = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> liturgicalColorName = const Value.absent(),
                Value<String> readingsJson = const Value.absent(),
                Value<String?> grade = const Value.absent(),
                Value<String?> season = const Value.absent(),
                Value<int?> psalterWeek = const Value.absent(),
                Value<String?> liturgicalYear = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedReadingsCompanion(
                dateKey: dateKey,
                title: title,
                liturgicalColorName: liturgicalColorName,
                readingsJson: readingsJson,
                grade: grade,
                season: season,
                psalterWeek: psalterWeek,
                liturgicalYear: liturgicalYear,
                date: date,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateKey,
                required String title,
                required String liturgicalColorName,
                required String readingsJson,
                Value<String?> grade = const Value.absent(),
                Value<String?> season = const Value.absent(),
                Value<int?> psalterWeek = const Value.absent(),
                Value<String?> liturgicalYear = const Value.absent(),
                required DateTime date,
                Value<int> rowid = const Value.absent(),
              }) => CachedReadingsCompanion.insert(
                dateKey: dateKey,
                title: title,
                liturgicalColorName: liturgicalColorName,
                readingsJson: readingsJson,
                grade: grade,
                season: season,
                psalterWeek: psalterWeek,
                liturgicalYear: liturgicalYear,
                date: date,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedReadingsTable, CachedReading>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedReadingsTable,
                    CachedReading
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedReadingsTable,
      CachedReading,
      $$CachedReadingsTableFilterComposer,
      $$CachedReadingsTableOrderingComposer,
      $$CachedReadingsTableAnnotationComposer,
      $$CachedReadingsTableCreateCompanionBuilder,
      $$CachedReadingsTableUpdateCompanionBuilder,
      (
        CachedReading,
        BaseReferences<_$AppDatabase, $CachedReadingsTable, CachedReading>,
      ),
      CachedReading,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedReadingsTableTableManager get cachedReadings =>
      $$CachedReadingsTableTableManager(_db, _db.cachedReadings);
}
