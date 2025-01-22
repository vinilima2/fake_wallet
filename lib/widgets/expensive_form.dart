import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/formatters/CurrencyInputFormatter.dart';
import 'package:fake_wallet/formatters/DateInputFormatter.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpensiveForm extends StatefulWidget {
  final Function(Expensive) onSave;
  final List<CategoryData> categories;

  const ExpensiveForm(
      {super.key, required this.onSave, required this.categories});

  @override
  State<StatefulWidget> createState() => _ExpensiveFormState();
}

class _ExpensiveFormState extends State<ExpensiveForm> {
  Expensive expensive = Expensive();
  static const iconMap = {
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

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Form(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 250,
          height: 500,
          // color: Colors.white,
          child: Column(
            children: [
              DropdownMenu<CategoryData>(
                width: 250,
                initialSelection: null,
                requestFocusOnTap: false,
                label: Text(AppLocalizations.of(context)!.category),
                onSelected: (CategoryData? category) {
                  expensive.category = category!.id;
                },
                dropdownMenuEntries: widget.categories
                    .map<DropdownMenuEntry<CategoryData>>(
                        (CategoryData category) {
                  return DropdownMenuEntry<CategoryData>(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(defaultColorScheme.surface)),
                      value: category,
                      label: category.description,
                      labelWidget: Row(
                        children: [
                          Icon(IconData(iconMap[category.icon]!,
                              fontFamily: 'MaterialIcons'), color: defaultColorScheme.onSurface,),
                          Text(category.description)
                        ],
                      ));
                }).toList(),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                initialValue: expensive.title,
                onChanged: (text) => expensive.title = text,
                maxLength: 50,
                decoration: InputDecoration(
                    counterText: '',
                    labelText: AppLocalizations.of(context)!.title),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                initialValue: expensive.name,
                onChanged: (text) => expensive.name = text,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description),
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                initialValue: expensive.value,
                onChanged: (text) => expensive.value = text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(context: context)
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.value),
              ),
              TextFormField(
                initialValue: expensive.expenseDate,
                onChanged: (text) => expensive.expenseDate = text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DateInputFormatter()
                ],
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.expenseDate),
              ),
              Row(
                children: [
                  Checkbox(
                      focusColor: defaultColorScheme.onSurface,
                      value: expensive.fixed,
                      onChanged: (value) {
                        setState(() {
                          expensive.fixed = value!;
                        });
                      }),
                  Text(AppLocalizations.of(context)!.fixed)
                ],
              ),
              expensive.fixed
                  ? TextFormField(
                      initialValue:
                          expensive.numberMonthsOfFixedExpense.toString(),
                      onChanged: (text) => expensive
                          .numberMonthsOfFixedExpense = int.parse(text),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.numberOfMonth),
                    )
                  : Container(),
              FilledButton(
                onPressed: () {
                  widget.onSave(expensive);
                },
                child: Text(AppLocalizations.of(context)!.save, style: TextStyle(color: defaultColorScheme.surface),),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(defaultColorScheme.onSurface),
                    fixedSize: MaterialStatePropertyAll(Size(1000, 50))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
