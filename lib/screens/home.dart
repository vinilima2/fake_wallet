import 'package:drift/drift.dart' as drift;
import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:fake_wallet/widgets/chart.dart';
import 'package:fake_wallet/widgets/expensive_form.dart';
import 'package:fake_wallet/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fake_wallet/utils/date_utils.dart';

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
          }))
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
    for (int i = 1; i < 7; i++) {
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
      });
      return;
    }

    var total = expenses
        .map((expense) => expense.value)
        .reduce((current, preview) => (current) + (preview));

    setState(() {
      totalValueExpenses = double.parse(total.toStringAsFixed(2));
    });

    var list = categories.map((category) {
      var expensesPerCategory =
          expenses.where((expense) => expense.category == category.id).toList();

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
    }).toList();

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
        body: SingleChildScrollView(
            child: Column(
          children: [
            Header(callback: (p0) {
              listAllExpenses(p0);
            }),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 4,
              child: Chart(
                expenses: finalList,
              ),
            ),
            const Divider(height: 5),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 2,
              child: ListView.builder(
                  itemCount: expenses.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int indice) {
                    return Dismissible(
                      onResize: () {
                        widget.database
                            .delete(widget.database.expense)
                            .deleteReturning(expenses[indice]);
                      },
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                title: const Text('Attention!'),
                                content:
                                    Text('Do you wanna remove this expense?'),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('No'),
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
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      key: Key(expenses[indice].name),
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(248, 242, 252, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
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
                                        .format(expenses[indice].expenseDate),
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(Icons.chevron_right,
                                      size: 15, color: Colors.blue.shade900)
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${expenses[indice].name} - ${expenses[indice].name}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.simpleCurrency(locale: "pt_Br")
                                        .format(expenses[indice].value),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade900),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    );
                  }),
            ),
            Container(
              color: Colors.blue.shade900,
              height: 45,
              padding: EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(
                    NumberFormat.simpleCurrency(locale: 'pt-Br')
                        .format(totalValueExpenses),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          shape: const CircleBorder(),
          onPressed: () {
            showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    title: const Text('New Expense'),
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
            size: 25,
          ),
        ));
  }
}
