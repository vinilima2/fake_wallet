import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/formatters/CurrencyInputFormatter.dart';
import 'package:fake_wallet/formatters/DateInputFormatter.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Container(
          width: 250,
          height: 500,
          // color: Colors.white,
          child: Column(
            children: [
              DropdownMenu<CategoryData>(
                width: 250,
                initialSelection: null,
                requestFocusOnTap: false,
                label: const Text('Category'),
                onSelected: (CategoryData? category) {
                  expensive.category = category!.id;
                },
                dropdownMenuEntries: widget.categories
                    .map<DropdownMenuEntry<CategoryData>>(
                        (CategoryData category) {
                  return DropdownMenuEntry<CategoryData>(
                    value: category,
                    label: category.description,
                  );
                }).toList(),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                initialValue: expensive.title,
                onChanged: (text) => expensive.title = text,
                maxLength: 50,
                decoration:
                    const InputDecoration(counterText: '', labelText: 'Title'),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                initialValue: expensive.name,
                onChanged: (text) => expensive.name = text,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                initialValue: expensive.value,
                onChanged: (text) => expensive.value = text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter()
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Value'),
              ),
              TextFormField(
                initialValue: expensive.expenseDate,
                onChanged: (text) => expensive.expenseDate = text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DateInputFormatter()
                ],
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(labelText: 'Expense Date'),
              ),
              Row(
                children: [
                  Checkbox(
                      focusColor: Colors.blue,
                      value: expensive.fixed,
                      onChanged: (value) {
                        setState(() {
                          expensive.fixed = value!;
                        });
                      }),
                  const Text('Fixed')
                ],
              ),
              FilledButton(
                onPressed: () {
                  widget.onSave(expensive);
                },
                child: Text('Save'),
                style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size(1000, 50))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
