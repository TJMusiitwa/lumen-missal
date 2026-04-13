import 'package:drift/drift.dart';
import 'package:drift/native.dart';

DatabaseConnection connect() {
  return DatabaseConnection(NativeDatabase.memory());
}
