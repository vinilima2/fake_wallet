import 'package:fake_wallet/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
}
