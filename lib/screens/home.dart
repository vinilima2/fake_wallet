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

    Navigator.of(context).pop();
    listAllExpenses(null);
  }

  void calculateCharts() {
    if (expenses.length == 0) {
      setState(() {
        finalList = [];
      });
      return;
    }

    var list = categories.map((category) {
      var expensesPerCategory =
          expenses.where((expense) => expense.category == category.id).toList();
      var totalExpensesPerCategory = expensesPerCategory.length;
      var totalValueExpensesPerCategory = expensesPerCategory.isNotEmpty
          ? expensesPerCategory
              .map((expense) => expense.value)
              .reduce((current, preview) => (current ?? 0) + (preview ?? 0))
          : 0;
      var totalExpenses = expenses.length;

      return {
        'id': category.id,
        'description': category.description,
        'icon': category.icon,
        'total': totalExpensesPerCategory,
        'totalValue': totalValueExpensesPerCategory,
        'percentage': ((totalExpensesPerCategory * 100) /
                (totalExpenses == 0 ? 1 : totalExpenses))
            .truncateToDouble()
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
              height: 250,
              child: Chart(
                expenses: finalList,
              ),
            ),
            const Divider(height: 5),
            SizedBox(
              height: 750,
              child: ListView.builder(
                  itemCount: expenses.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int indice) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${expenses[indice].name} - ${expenses[indice].name} - ${DateFormat('dd/MM/yyyy').format(expenses[indice].expenseDate)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            NumberFormat.simpleCurrency(locale: "pt_Br")
                                .format(expenses[indice].value),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          shape: CircleBorder(),
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
