import 'package:drift/drift.dart' as drift;
import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expense_model.dart';
import 'package:fake_wallet/utils/date_utils.dart' as myDateUtils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DatabaseUtils {
  final AppDatabase database;

  DatabaseUtils({required this.database});

  static const iconMap = {
    0xe655: 'Theater',
    0xe13d: 'Car Repair',
    0xe0ee: 'Energy',
    0xf03b4: 'Water',
    0xe25a: 'FastFood',
    0xe11a: 'Bus',
    0xe19f: 'Credit Card',
    0xe318: 'Home',
    0xe394: 'Fuel',
    0xf07a4: 'Gas',
    0xe5b7: 'Phone',
    0xe559: 'School',
    0xe178: 'Coffee',
    0xe309: 'Another',
    0xe305: 'Health'
  };

static const Map<String, int> invertedIconMap = {
  'Theater': 0xe655,
  'Car Repair': 0xe13d,
  'Energy': 0xe0ee,
  'Water': 0xf03b4,
  'FastFood': 0xe25a,
  'Bus': 0xe11a,
  'Credit Card': 0xe19f,
  'Home': 0xe318,
  'Fuel': 0xe394,
  'Gas': 0xf07a4,
  'Phone': 0xe5b7,
  'School': 0xe559,
  'Coffee': 0xe178,
  'Another': 0xe309,
  'Health': 0xe305
};




  static Future<DatabaseUtils> init(AppDatabase database) async {
    return await DatabaseUtils(database: database);
  }

  void seedDatabaseWithCategories(BuildContext context) {
    final List<Map<String, IconData>> categories = [
      {AppLocalizations.of(context)!.theater: Icons.theaters},
      {AppLocalizations.of(context)!.carRepair: Icons.car_repair},
      {AppLocalizations.of(context)!.energy: Icons.bolt},
      {AppLocalizations.of(context)!.water: Icons.water_drop_rounded},
      {AppLocalizations.of(context)!.fastFood: Icons.fastfood},
      {AppLocalizations.of(context)!.bus: Icons.bus_alert},
      {AppLocalizations.of(context)!.creditCard: Icons.credit_card},
      {AppLocalizations.of(context)!.home: Icons.home},
      {AppLocalizations.of(context)!.fuel: Icons.local_gas_station},
      {AppLocalizations.of(context)!.gas: Icons.gas_meter},
      {AppLocalizations.of(context)!.phone: Icons.sim_card},
      {AppLocalizations.of(context)!.school: Icons.school},
      {AppLocalizations.of(context)!.coffee: Icons.coffee},
      {AppLocalizations.of(context)!.another: Icons.help},
      {AppLocalizations.of(context)!.health: Icons.health_and_safety}
    ];
    for (var category in categories) {
      var description = category.keys.first;
      var icon = iconMap[category.values.first.codePoint]!;
      insertCategory(description, icon);
    }
  }

  void insertCategory(String description, String icon) async {
    await database
        .into(database.category)
        .insert(CategoryCompanion.insert(description: description, icon: icon));
  }

  Future<List<CategoryData>> listAllCategories(BuildContext context) async {
    var list = await database.select(database.category).get();
    if (list.isEmpty) {
      seedDatabaseWithCategories(context);
      await listAllCategories(context);
    }
    return list;
  }

  Future<void> insertExpense(ExpenseModel expenseModel) async {
    await database.into(database.expense).insert(ExpenseCompanion.insert(
        title: expenseModel.title,
        name: expenseModel.name,
        value: double.parse(expenseModel.value
            .replaceAll('.', '')
            .replaceFirst(',', '.')
            .replaceAll(RegExp(r"[^\d.]+"), '')),
        fixed: expenseModel.fixed,
        createdAt: DateTime.now(),
        expenseDate: DateFormat('dd/MM/yyyy').parse(expenseModel.expenseDate),
        category: expenseModel.category));

    if (expenseModel.fixed) {
      await insertFixedExpense(expenseModel);
    }
  }

  Future<void> insertFixedExpense(ExpenseModel expenseModel) async {
    DateTime actualDateTime =
        DateFormat('dd/MM/yyyy').parse(expenseModel.expenseDate);
    for (int i = 1; i <= expenseModel.numberMonthsOfFixedExpense; i++) {
      await database.into(database.expense).insert(ExpenseCompanion.insert(
          title: expenseModel.title,
          name: expenseModel.name,
          value: double.parse(expenseModel.value
              .replaceAll('.', '')
              .replaceFirst(',', '.')
              .replaceAll(RegExp(r"[^\d.]+"), '')),
          fixed: expenseModel.fixed,
          createdAt: DateTime.now(),
          expenseDate:
              actualDateTime.copyWith(day: 1, month: actualDateTime.month + i),
          category: expenseModel.category));
    }
  }

  Future<List<ExpenseData>> listAllExpenses(String? date) async {
    List<String> splitDate = (date ?? myDateUtils.DateUtils.now()).split('/');
    return (database.select(database.expense)
          ..where((tbl) {
            return tbl.expenseDate.month.equals(int.parse(splitDate[0])) &
                tbl.expenseDate.year.equals(int.parse(splitDate[1]));
          })
          ..orderBy([
            (table) => drift.OrderingTerm.asc(table.fixed),
            (table) => drift.OrderingTerm.desc(table.expenseDate)
          ]))
        .get();
  }
}
