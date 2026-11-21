import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;

part 'database.g.dart';

class CachedReadings extends Table {
  TextColumn get dateKey => text()(); // YYYY-MM-DD
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
        if (from < 2) {
          // Add the new columns that were added in the latest update
          await m.addColumn(cachedReadings, cachedReadings.grade);
          await m.addColumn(cachedReadings, cachedReadings.season);
          await m.addColumn(cachedReadings, cachedReadings.psalterWeek);
          await m.addColumn(cachedReadings, cachedReadings.liturgicalYear);
        }
        if (from < 3) {
          await m.addColumn(cachedReadings, cachedReadings.date);
        }
      },
    );
  }
}
