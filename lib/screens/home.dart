import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:fake_wallet/widgets/chart.dart';
import 'package:fake_wallet/widgets/expensive_form.dart';
import 'package:fake_wallet/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Future<void> listAllExpenses() async {
    var list = await widget.database.select(widget.database.expense).get();
    setState(() {
      expenses = list;
    });
  }

  Future<void> listAllCategories() async {
    var list = await widget.database.select(widget.database.category).get();
    setState(() {
      categories = list;
    });
  }

  void insertExpense(Expensive expensive) async {
    await widget.database.into(widget.database.expense).insert(ExpenseCompanion.insert(
        title: expensive.title,
        name: expensive.name,
        value: double.parse(expensive.value.replaceFirst(',', '.').replaceAll(RegExp(r"[^\d.]+"), '')),
        fixed: expensive.fixed,
        createdAt: DateTime.now(),
        expenseDate:  DateFormat('dd/MM/yyyy').parse(expensive.expenseDate),
        category: expensive.category));
  }

  void calculateCharts() {
    var list = categories.map((category) {
      var expensesPerCategory =
          expenses.where((expense) => expense.category == category.id).toList();
      var totalExpensesPerCategory = expensesPerCategory.length;
      var totalValueExpensesPerCategory = expensesPerCategory.length > 0 ? expensesPerCategory
          .map((expense) => expense.value)
          .reduce((current, preview) => (current ?? 0) + (preview ?? 0)) : 0;
      var totalExpenses = expenses.length;

      return {
        'id': category.id,
        'description': category.description,
        'icon': category.icon,
        'total': totalExpensesPerCategory,
        'totalValue': totalValueExpensesPerCategory,
        'percentage': (totalExpensesPerCategory * 100) / totalExpenses
      };
    }).toList();

    print(list);

    setState(() {
      finalList = list;
    });
  }

  @override
  void initState() {
    listAllCategories()
        .then((c) => listAllExpenses().then((c) => calculateCharts()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            const Header(),
            SizedBox(
              height: 250,
              child: Chart(
                expenses: finalList,
              ),
            ),
            const Divider(height: 5),
            SizedBox(
              height: 250,
              child: ListView.builder(
                  itemCount: expenses.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int indice) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(expenses[indice].value.toString()),
                          Text(expenses[indice].title),
                          Text(expenses[indice].expenseDate.toString()),
                        ],
                      ),
                    );
                  }),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
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
