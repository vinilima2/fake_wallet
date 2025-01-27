import 'package:drift/drift.dart' as drift;
import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expense_model.dart';
import 'package:fake_wallet/utils/database_utils.dart';
import 'package:fake_wallet/utils/export_utils.dart';
import 'package:fake_wallet/widgets/chart.dart';
import 'package:fake_wallet/widgets/expense_form.dart';
import 'package:fake_wallet/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fake_wallet/utils/date_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Home extends StatefulWidget {
  final AppDatabase database;

  const Home({super.key, required this.database});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int touchedIndex = 0;

  List<ExpenseData> expenses = [];
  List<CategoryData> categories = [];
  List<Map<String, dynamic>> finalList = [];
  String monthAndYear = DateUtil.now();
  double totalValueExpenses = 0;

  Future<void> listAllExpenses(String? date) async {
    List<String> splitDate = (date ?? monthAndYear).split('/');
    (widget.database.select(widget.database.expense)
          ..where((tbl) {
            return tbl.expenseDate.month.equals(int.parse(splitDate[0])) &
                tbl.expenseDate.year.equals(int.parse(splitDate[1]));
          })
          ..orderBy([
            (table) => drift.OrderingTerm.asc(table.fixed),
            (table) => drift.OrderingTerm.desc(table.expenseDate)
          ]))
        .watch()
        .listen((list) {
      setState(() {
        expenses = list;
      });
      calculateCharts();
    }, onDone: () {
      reassemble();
    });
  }

  Future<void> listAllCategories() async {
    var list = await widget.database.select(widget.database.category).get();
    if (list.isEmpty) {
      DatabaseUtils db = DatabaseUtils(database: widget.database);
      db.seedDatabaseWithCategories(context);
      listAllCategories();
    }
    setState(() {
      categories = list;
    });
  }

  void insertExpense(ExpenseModel expenseModel) async {
    context.loaderOverlay.show();
    await widget.database.into(widget.database.expense).insert(
        ExpenseCompanion.insert(
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
    Navigator.of(context).pop();
    context.loaderOverlay.hide();
    listAllExpenses(null);
  }

  Future<void> insertFixedExpense(ExpenseModel expenseModel) async {
    DateTime actualDateTime =
        DateFormat('dd/MM/yyyy').parse(expenseModel.expenseDate);
    for (int i = 1; i <= expenseModel.numberMonthsOfFixedExpense; i++) {
      await widget.database.into(widget.database.expense).insert(
          ExpenseCompanion.insert(
              title: expenseModel.title,
              name: expenseModel.name,
              value: double.parse(expenseModel.value
                  .replaceAll('.', '')
                  .replaceFirst(',', '.')
                  .replaceAll(RegExp(r"[^\d.]+"), '')),
              fixed: expenseModel.fixed,
              createdAt: DateTime.now(),
              expenseDate: actualDateTime.copyWith(
                  day: 1, month: actualDateTime.month + i),
              category: expenseModel.category));
    }
  }

  Future<void> calculateCharts() async {
    if (expenses.isEmpty) {
      setState(() {
        finalList = [];
        totalValueExpenses = 0;
      });
      return;
    }

    context.loaderOverlay.show();

    var total = expenses
        .map((expense) => expense.value)
        .reduce((current, preview) => (current) + (preview));

    setState(() {
      totalValueExpenses = double.parse(total.toStringAsFixed(2));
    });

    var list = categories
        .map((category) {
          var expensesPerCategory = expenses
              .where((expense) => expense.category == category.id)
              .toList();

          var totalValueExpensesPerCategory = expensesPerCategory.isNotEmpty
              ? expensesPerCategory
                  .map((expense) => expense.value)
                  .reduce((current, preview) => (current) + (preview))
              : 0;

          var percentage =
              (totalValueExpensesPerCategory * 100) / (totalValueExpenses);

          return {
            'id': category.id,
            'description': category.description,
            'icon': category.icon,
            'percentage': double.parse(percentage.toStringAsFixed(2))
          };
        })
        .where((item) => (item['percentage']! as double) > 0)
        .toList();

    setState(() {
      finalList = list;
    });
    context.loaderOverlay.hide();
  }

  @override
  void initState() {
    listAllCategories().then((c) => listAllExpenses(null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final Locale locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColorScheme.onSurface,
        title: Text(
          'Fake Wallet',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: defaultColorScheme.surface),
        ),
        actions: [
          TextButton(
            key: const Key('call_add_expense'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.newExpense),
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: defaultColorScheme.onSurface,
                          fontSize: 20),
                      content: ExpenseForm(
                          key: const Key('expense_form'),
                          onSave: (ex) {
                            insertExpense(ex);
                          },
                          categories: categories),
                    );
                  });
            },
            child: Icon(
              Icons.add,
              color: defaultColorScheme.surface,
              size: 30,
            ),
          ),
          totalValueExpenses > 0
              ? TextButton(
                  onPressed: () async {
                    context.loaderOverlay.show();
                    await ExportUtils()
                        .exportToXLSX(context, monthAndYear, expenses);
                    context.loaderOverlay.hide();
                  },
                  child: Icon(
                    Icons.share,
                    size: 22,
                    color: defaultColorScheme.surface,
                  ))
              : Container()
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Header(callback: (date) {
            listAllExpenses(date);
          }),
          SizedBox(
            height: 250,
            child: Chart(
              expenses: finalList,
            ),
          ),
          const Divider(height: 5),
          Container(
              padding: EdgeInsets.all(5),
              height: 500,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.expense,
                    style: TextStyle(
                        color: defaultColorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  ListView.builder(
                      itemCount: expenses.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int indice) {
                        var expense = expenses[indice];

                        return Dismissible(
                          onResize: () {
                            widget.database
                                .delete(widget.database.expense)
                                .deleteReturning(expense);
                          },
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .attention),
                                    content: Text(AppLocalizations.of(context)!
                                        .removeQuestion),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!.no),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!.yes),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          key: Key(expense.name),
                          child: Container(
                              decoration: BoxDecoration(
                                color: expense.fixed
                                    ? defaultColorScheme.onTertiary
                                    : defaultColorScheme.onSecondary,
                                border: Border(
                                    left: BorderSide(
                                        color: expense.fixed
                                            ? defaultColorScheme.tertiary
                                            : defaultColorScheme.secondary,
                                        width: 5)),
                              ),
                              padding: const EdgeInsets.all(7),
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(expense.expenseDate),
                                        style: TextStyle(
                                            color: expense.fixed
                                                ? defaultColorScheme.tertiary
                                                : defaultColorScheme.secondary,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(Icons.chevron_right,
                                          size: 15,
                                          color: expense.fixed
                                              ? defaultColorScheme.tertiary
                                              : defaultColorScheme.secondary)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "${expense.title} - ${expense.name}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: expense.fixed
                                                  ? defaultColorScheme.tertiary
                                                  : defaultColorScheme
                                                      .secondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Text(
                                        NumberFormat.simpleCurrency(
                                                locale: locale.languageCode)
                                            .format(expense.value),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: expense.fixed
                                                ? defaultColorScheme.tertiary
                                                : defaultColorScheme.secondary),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      }),
                ],
              ))
        ],
      )),
      bottomSheet: Container(
        color: defaultColorScheme.onSurface,
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.total,
                style: TextStyle(
                    color: defaultColorScheme.surface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(
              NumberFormat.simpleCurrency(locale: locale.languageCode)
                  .format(totalValueExpenses),
              style: TextStyle(
                  color: defaultColorScheme.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
