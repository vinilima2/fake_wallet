import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/formatters/currency_input_formatter.dart';
import 'package:fake_wallet/formatters/date_input_formatter.dart';
import 'package:fake_wallet/models/expense_model.dart';
import 'package:fake_wallet/utils/database_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpenseForm extends StatefulWidget {
  final Function(ExpenseModel) onSave;
  final List<CategoryData> categories;

  const ExpenseForm(
      {super.key, required this.onSave, required this.categories});

  @override
  State<StatefulWidget> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  ExpenseModel expense = ExpenseModel();
  String? dropdownMessage;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: SingleChildScrollView(
        child: SizedBox(
          width: 250,
          height: 550,
          // color: Colors.white,
          child: Column(
            children: [
              DropdownMenu<CategoryData>(
                key: const Key('category'),
                errorText: dropdownMessage,
                width: 250,
                initialSelection: null,
                requestFocusOnTap: false,
                label: Text(AppLocalizations.of(context)!.category),
                onSelected: (CategoryData? category) {
                  expense.category = category!.id;
                  setState(() {
                    dropdownMessage = null;
                  });
                },
                dropdownMenuEntries: widget.categories
                    .map<DropdownMenuEntry<CategoryData>>(
                        (CategoryData category) {
                  return DropdownMenuEntry<CategoryData>(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              defaultColorScheme.surface)),
                      value: category,
                      label: category.description,
                      labelWidget: Row(
                        children: [
                          Icon(
                            IconData(
                                DatabaseUtils.invertedIconMap[category.icon]!,
                                fontFamily: 'MaterialIcons'),
                            color: defaultColorScheme.onSurface,
                          ),
                          Text(category.description)
                        ],
                      ));
                }).toList(),
              ),
              TextFormField(
                key: const Key('title'),
                textCapitalization: TextCapitalization.characters,
                initialValue: expense.title,
                onChanged: (text) => expense.title = text,
                maxLength: 50,
                decoration: InputDecoration(
                    counterText: '',
                    labelText: AppLocalizations.of(context)!.title),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.validateMessage;
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const Key('name'),
                textCapitalization: TextCapitalization.characters,
                initialValue: expense.name,
                onChanged: (text) => expense.name = text,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.validateMessage;
                  }
                  return null;
                },
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                key: const Key('value'),
                initialValue: expense.value,
                onChanged: (text) => expense.value = text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(context: context)
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.validateMessage;
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const Key('expenseDate'),
                initialValue: expense.expenseDate,
                onChanged: (text) => expense.expenseDate = text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DateInputFormatter()
                ],
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.expenseDate),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.validateMessage;
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Checkbox(
                      focusColor: defaultColorScheme.onSurface,
                      checkColor: defaultColorScheme.surface,
                      value: expense.fixed,
                      onChanged: (value) {
                        setState(() {
                          expense.fixed = value!;
                        });
                      }),
                  Text(AppLocalizations.of(context)!.fixed)
                ],
              ),
              expense.fixed
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        initialValue:
                            expense.numberMonthsOfFixedExpense.toString(),
                        onChanged: (text) => expense
                            .numberMonthsOfFixedExpense = int.parse(text),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                            counterText: '',
                            labelText:
                                AppLocalizations.of(context)!.numberOfMonth),
                      ),
                    )
                  : Container(),
              FilledButton(
                key: const Key('saveButton'),
                onPressed: () {
                  if (expense.category == 0) {
                    setState(() {
                      dropdownMessage =
                          AppLocalizations.of(context)!.validateMessage;
                    });
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(expense);
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(defaultColorScheme.onSurface),
                    fixedSize: const WidgetStatePropertyAll(Size(1000, 50))),
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: TextStyle(color: defaultColorScheme.surface),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
