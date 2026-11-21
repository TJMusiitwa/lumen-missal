import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;

part 'database.g.dart';

class CachedReadings extends Table {
  TextColumn get dateKey =>
      text()(); // Local civil date and reading preferences
  TextColumn get title => text()();
  TextColumn get liturgicalColorName => text()();
  TextColumn get readingsJson => text()();
  TextColumn get grade => text().nullable()();
  TextColumn get season => text().nullable()();
  IntColumn get psalterWeek => integer().nullable()();
  TextColumn get liturgicalYear => text().nullable()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {dateKey};
}

@DriftDatabase(tables: [CachedReadings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? impl.connect());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 3) {
          // Old rows can contain synthetic fallback readings and are disposable.
          await m.deleteTable(cachedReadings.actualTableName);
          await m.createTable(cachedReadings);
        }
      },
    );
  }
}
