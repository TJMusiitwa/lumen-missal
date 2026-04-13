import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;

part 'database.g.dart';

class CachedReadings extends Table {
  TextColumn get dateKey => text()(); // YYYY-MM-DD
  TextColumn get title => text()();
  TextColumn get liturgicalColorName => text()();
  TextColumn get readingsJson => text()();

  @override
  Set<Column> get primaryKey => {dateKey};
}

@DriftDatabase(tables: [CachedReadings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? impl.connect());

  @override
  int get schemaVersion => 1;
}
