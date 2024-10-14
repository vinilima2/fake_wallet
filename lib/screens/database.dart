import 'package:fake_wallet/database.dart';
import 'package:flutter/material.dart';

class Database extends StatelessWidget {
    final AppDatabase database;
  const Database({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.theaters,
      Icons.car_repair,
      Icons.bolt,
      Icons.water_drop_rounded,
      Icons.fastfood,
      Icons.bus_alert,
      Icons.credit_card,
      Icons.home,
      Icons.local_gas_station,
      Icons.gas_meter,
      Icons.sim_card,
      Icons.school,
      Icons.coffee,
      Icons.help,
      Icons.health_and_safety
    ];

    const iconMap = {
      0xe655: 'theaters',
      0xe13d: 'car_repair',
      0xe0ee: 'bolt',
      0xf03b4: 'water_drop_rounded',
      0xe25a: 'fastfood',
      0xe11a: 'bus_alert',
      0xe19f: 'credit_card',
      0xe318: 'home',
      0xe394: 'local_gas_station',
      0xf07a4: 'gas_meter',
      0xe5b7: 'sim_card',
      0xe559: 'school',
      0xe178: 'coffee',
      0xe309: 'help',
      0xe305: 'health_and_safety'
    };

  
    void insertCategory(String description, String icon) async {
      await database.into(database.category).insert(
          CategoryCompanion.insert(description: description, icon: icon));
      Navigator.of(context).pop();
    }

    String description = '';
    String icon = '';
    IconData? iconData = null;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title: Text('New Category'),
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
                            label: const Text('Icon'),
                            onSelected: (IconData? iconData) {
                              icon = iconMap[iconData?.codePoint]!;
                              iconData = iconData;
                            },
                            dropdownMenuEntries: icons
                                .map<DropdownMenuEntry<IconData>>(
                                    (IconData color) {
                              return DropdownMenuEntry<IconData>(
                                  value: color,
                                  label: iconMap[color.codePoint]!,
                                  labelWidget: Row(children: [
                                    Icon(color)
                                  ])
                                  // style: MenuItemButton.styleFrom(
                                  //   foregroundColor: Colors.red,
                                  // ),
                                  );
                            }).toList(),
                          ),
                          TextFormField(
                            onChanged: (text) => description = text,
                            maxLength: 50,
                            decoration: const InputDecoration(
                                counterText: '', labelText: 'Description'),
                          ),
                          Container(
                            height: 15,
                          ),
                          FilledButton(
                            onPressed: () {
                              insertCategory(description, icon);
                            },
                            child: Text('Save'),
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
