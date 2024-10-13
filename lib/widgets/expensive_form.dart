import 'package:fake_wallet/formatters/CurrencyInputFormatter.dart';
import 'package:fake_wallet/formatters/DateInputFormatter.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpensiveForm extends StatefulWidget {
  final Function(Expensive) onSave;

  const ExpensiveForm({super.key, required this.onSave});

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
              DropdownMenu<String>(
                width: 250,
                initialSelection: '1',
                requestFocusOnTap: false,
                label: const Text('Category'),
                onSelected: (String? color) {
                  print(color);
                },
                dropdownMenuEntries:
                    ['1', '2'].map<DropdownMenuEntry<String>>((String color) {
                  return DropdownMenuEntry<String>(
                    value: color,
                    label: color,
                  );
                }).toList(),
              ),
              TextFormField(
                initialValue: expensive.title,
                onChanged: (text) => expensive.title = text,
                maxLength: 50,
                decoration:
                    const InputDecoration(counterText: '', labelText: 'Title'),
              ),
              TextFormField(
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
                  Text('Fixed')
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
