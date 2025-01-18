import 'package:drift/drift.dart' as drift;
import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:fake_wallet/screens/database.dart';
import 'package:fake_wallet/utils/export_utils.dart';
import 'package:fake_wallet/widgets/chart.dart';
import 'package:fake_wallet/widgets/expensive_form.dart';
import 'package:fake_wallet/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fake_wallet/utils/date_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      Database db = Database(database: widget.database);
      db.seedDatabaseWithCategories(context);
      listAllCategories();
    }
    setState(() {
      categories = list;
    });
  }

  void insertExpense(Expensive expensive) async {
    await widget.database.into(widget.database.expense).insert(
        ExpenseCompanion.insert(
            title: expensive.title,
            name: expensive.name,
            value: double.parse(expensive.value
                .replaceAll('.', '')
                .replaceFirst(',', '.')
                .replaceAll(RegExp(r"[^\d.]+"), '')),
            fixed: expensive.fixed,
            createdAt: DateTime.now(),
            expenseDate: DateFormat('dd/MM/yyyy').parse(expensive.expenseDate),
            category: expensive.category));

    if (expensive.fixed) {
      insertFixedExpense(expensive);
    }

    Navigator.of(context).pop();
    listAllExpenses(null);
  }

  void insertFixedExpense(Expensive expensive) async {
    DateTime actualDateTime =
        DateFormat('dd/MM/yyyy').parse(expensive.expenseDate);
    for (int i = 1; i <= expensive.numberMonthsOfFixedExpense; i++) {
      await widget.database.into(widget.database.expense).insert(
          ExpenseCompanion.insert(
              title: expensive.title,
              name: expensive.name,
              value: double.parse(expensive.value
                  .replaceAll('.', '')
                  .replaceFirst(',', '.')
                  .replaceAll(RegExp(r"[^\d.]+"), '')),
              fixed: expensive.fixed,
              createdAt: DateTime.now(),
              expenseDate: actualDateTime.copyWith(
                  day: 1, month: actualDateTime.month + i),
              category: expensive.category));
    }
  }

  void calculateCharts() {
    if (expenses.isEmpty) {
      setState(() {
        finalList = [];
        totalValueExpenses = 0;
      });
      return;
    }

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
  }

  @override
  void initState() {
    listAllCategories().then((c) => listAllExpenses(null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          'Fake Wallet',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.newExpense),
                      content: ExpensiveForm(
                          onSave: (ex) {
                            insertExpense(ex);
                          },
                          categories: categories),
                    );
                  });
            },
            // backgroundColor: Colors.redAccent,
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 30,
            ),
          ),
          totalValueExpenses > 0
              ? TextButton(
                  onPressed: () async {
                    await ExportUtils()
                        .exportToXLSX(context, monthAndYear, expenses);
                  },
                  child: const Icon(
                    Icons.share,
                    size: 22,
                    color: Color.fromARGB(255, 255, 255, 255),
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
          SizedBox(
            height: 500,
            child: ListView.builder(
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
                              title:
                                  Text(AppLocalizations.of(context)!.attention),
                              content: Text(
                                  AppLocalizations.of(context)!.removeQuestion),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text(AppLocalizations.of(context)!.no),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child:
                                      Text(AppLocalizations.of(context)!.yes),
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
                              ? Colors.grey.shade100
                              : Colors.white60,
                          border: Border(
                              left: BorderSide(
                                  color: expense.fixed
                                      ? Colors.grey.shade600
                                      : Colors.lightBlueAccent,
                                  width: 5)),
                        ),
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(expense.expenseDate),
                                  style: TextStyle(
                                      color: expense.fixed
                                          ? Colors.grey.shade600
                                          : Colors.lightBlueAccent,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.chevron_right,
                                    size: 15,
                                    color: expense.fixed
                                        ? Colors.grey.shade600
                                        : Colors.lightBlueAccent)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "${expense.title} - ${expense.name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: expense.fixed
                                            ? Colors.grey.shade600
                                            : Colors.lightBlueAccent,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(
                                          locale: Intl.systemLocale)
                                      .format(expense.value),
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: expense.fixed
                                          ? Colors.grey.shade600
                                          : Colors.lightBlueAccent),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                }),
          )
        ],
      )),
      bottomSheet: Container(
        color: Colors.blue.shade900,
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.total,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(
              NumberFormat.simpleCurrency(locale: Intl.systemLocale)
                  .format(totalValueExpenses),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
