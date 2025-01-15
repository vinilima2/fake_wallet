import 'package:fake_wallet/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Database extends StatelessWidget {
  final AppDatabase database;
  const Database({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    final List<Map<IconData, String>> icons = [
      {Icons.theaters: "Theater"},
      {Icons.car_repair: "Car Repair"},
      {Icons.bolt: "Energy"},
      {Icons.water_drop_rounded: "Water"},
      {Icons.fastfood: "FastFood"},
      {Icons.bus_alert: "Bus"},
      {Icons.credit_card: "Credit Card"},
      {Icons.home: "Home"},
      {Icons.local_gas_station: "Fuel"},
      {Icons.gas_meter: "Gas"},
      {Icons.sim_card: "Phone"},
      {Icons.school: "School"},
      {Icons.coffee: "Coffee"},
      {Icons.help: "Another"},
      {Icons.health_and_safety: "Health"}
    ];

    const iconMap = {
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

    void insertCategory(String description, String icon) async {
      await database.into(database.category).insert(
          CategoryCompanion.insert(description: description, icon: icon));
      Navigator.of(context).pop();
    }

    String description = '';
    String icon = '';
    IconData? iconData;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title:  Text(AppLocalizations.of(context)!.newCategory),
                content: Form(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 250,
                      height: 250,
                      // color: Colors.white,
                      child: Column(
                        children: [
                          DropdownMenu<IconData>(
                            requestFocusOnTap: false,
                            enableSearch: false,
                            enableFilter: false,
                            width: 250,
                            initialSelection: iconData,
                            label: Text(AppLocalizations.of(context)!.icon),
                            onSelected: (IconData? iconData) {
                              icon = iconMap[iconData?.codePoint]!;
                              iconData = iconData;
                            },
                            dropdownMenuEntries: icons
                                .map<DropdownMenuEntry<IconData>>(
                                    (Map<IconData, String> color) {
                              return DropdownMenuEntry<IconData>(
                                value: color.keys.first,
                                label: iconMap[color.keys.first.codePoint]!,
                                labelWidget: Row(children: [
                                  Icon(color.keys.first),
                                  Text(color.values.first)
                                ]),

                                // style: MenuItemButton.styleFrom(
                                //   foregroundColor: Colors.red,
                                // ),
                              );
                            }).toList(),
                          ),
                          TextFormField(
                            onChanged: (text) => description = text,
                            maxLength: 50,
                            decoration:  InputDecoration(
                                counterText: '', labelText: AppLocalizations.of(context)!.description),
                          ),
                          Container(
                            height: 15,
                          ),
                          FilledButton(
                            onPressed: () {
                              insertCategory(description, icon);
                            },
                            child: Text(AppLocalizations.of(context)!.save),
                            style: ButtonStyle(
                                fixedSize:
                                    MaterialStatePropertyAll(Size(1000, 50))),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      // backgroundColor: Colors.redAccent,
      child: const Icon(
        Icons.add,
        color: Color.fromARGB(255, 255, 255, 255),
        size: 25,
      ),
    ));
  }
}
