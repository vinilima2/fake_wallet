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
    if (expenses.isEmpty) {
      setState(() {
        finalList = [];
      });
      return;
    }

    var totalValueExpenses = expenses
        .map((expense) => expense.value)
        .reduce((current, preview) => (current) + (preview));

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
        'percentage': percentage
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
                    return Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(248, 242, 252, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ));
                  }),
            ),
            Container(
              color: Colors.blue.shade900,
              height: MediaQuery.sizeOf(context).height / 5,
              child: Row(
                children: [Text('Total:'), Text('Valor')],
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
