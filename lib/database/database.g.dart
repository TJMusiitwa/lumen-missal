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
  @override
  List<GeneratedColumn> get $columns => [
    dateKey,
    title,
    liturgicalColorName,
    readingsJson,
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
  const CachedReading({
    required this.dateKey,
    required this.title,
    required this.liturgicalColorName,
    required this.readingsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_key'] = Variable<String>(dateKey);
    map['title'] = Variable<String>(title);
    map['liturgical_color_name'] = Variable<String>(liturgicalColorName);
    map['readings_json'] = Variable<String>(readingsJson);
    return map;
  }

  CachedReadingsCompanion toCompanion(bool nullToAbsent) {
    return CachedReadingsCompanion(
      dateKey: Value(dateKey),
      title: Value(title),
      liturgicalColorName: Value(liturgicalColorName),
      readingsJson: Value(readingsJson),
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
    };
  }

  CachedReading copyWith({
    String? dateKey,
    String? title,
    String? liturgicalColorName,
    String? readingsJson,
  }) => CachedReading(
    dateKey: dateKey ?? this.dateKey,
    title: title ?? this.title,
    liturgicalColorName: liturgicalColorName ?? this.liturgicalColorName,
    readingsJson: readingsJson ?? this.readingsJson,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedReading(')
          ..write('dateKey: $dateKey, ')
          ..write('title: $title, ')
          ..write('liturgicalColorName: $liturgicalColorName, ')
          ..write('readingsJson: $readingsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dateKey, title, liturgicalColorName, readingsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedReading &&
          other.dateKey == this.dateKey &&
          other.title == this.title &&
          other.liturgicalColorName == this.liturgicalColorName &&
          other.readingsJson == this.readingsJson);
}

class CachedReadingsCompanion extends UpdateCompanion<CachedReading> {
  final Value<String> dateKey;
  final Value<String> title;
  final Value<String> liturgicalColorName;
  final Value<String> readingsJson;
  final Value<int> rowid;
  const CachedReadingsCompanion({
    this.dateKey = const Value.absent(),
    this.title = const Value.absent(),
    this.liturgicalColorName = const Value.absent(),
    this.readingsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedReadingsCompanion.insert({
    required String dateKey,
    required String title,
    required String liturgicalColorName,
    required String readingsJson,
    this.rowid = const Value.absent(),
  }) : dateKey = Value(dateKey),
       title = Value(title),
       liturgicalColorName = Value(liturgicalColorName),
       readingsJson = Value(readingsJson);
  static Insertable<CachedReading> custom({
    Expression<String>? dateKey,
    Expression<String>? title,
    Expression<String>? liturgicalColorName,
    Expression<String>? readingsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateKey != null) 'date_key': dateKey,
      if (title != null) 'title': title,
      if (liturgicalColorName != null)
        'liturgical_color_name': liturgicalColorName,
      if (readingsJson != null) 'readings_json': readingsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedReadingsCompanion copyWith({
    Value<String>? dateKey,
    Value<String>? title,
    Value<String>? liturgicalColorName,
    Value<String>? readingsJson,
    Value<int>? rowid,
  }) {
    return CachedReadingsCompanion(
      dateKey: dateKey ?? this.dateKey,
      title: title ?? this.title,
      liturgicalColorName: liturgicalColorName ?? this.liturgicalColorName,
      readingsJson: readingsJson ?? this.readingsJson,
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
      Value<int> rowid,
    });
typedef $$CachedReadingsTableUpdateCompanionBuilder =
    CachedReadingsCompanion Function({
      Value<String> dateKey,
      Value<String> title,
      Value<String> liturgicalColorName,
      Value<String> readingsJson,
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
                Value<int> rowid = const Value.absent(),
              }) => CachedReadingsCompanion(
                dateKey: dateKey,
                title: title,
                liturgicalColorName: liturgicalColorName,
                readingsJson: readingsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateKey,
                required String title,
                required String liturgicalColorName,
                required String readingsJson,
                Value<int> rowid = const Value.absent(),
              }) => CachedReadingsCompanion.insert(
                dateKey: dateKey,
                title: title,
                liturgicalColorName: liturgicalColorName,
                readingsJson: readingsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
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
