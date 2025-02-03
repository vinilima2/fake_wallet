import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Expense extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(max: 50)();
  TextColumn get name => text().named('name')();
  RealColumn get value => real()();
  IntColumn get category => integer().references(Category, #id)();
  BoolColumn get fixed => boolean()();
  DateTimeColumn get expenseDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

class Category extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get icon => text()();
  TextColumn get description => text()();
  IntColumn get color => integer()();
}

@DriftDatabase(tables: [Expense, Category])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'fake_wallet_db');
  }
}
