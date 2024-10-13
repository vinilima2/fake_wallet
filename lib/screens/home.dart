import 'dart:math';

import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:fake_wallet/widgets/expensive_form.dart';
import 'package:fake_wallet/widgets/header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int touchedIndex = 0;
  final database = AppDatabase();

  List<ExpenseData> lista = [];

  void listAllExpenses() async {
    var list  = await database.select(database.expense).get();
    setState(() {
      lista = list;
    });
  }

  void listAllCategories() async {
    await database.select(database.category).get();
  }

  void insertCategory() async {
    await database
        .into(database.category)
        .insert(CategoryCompanion.insert(description: '', icon: ''));
  }

  void insertExpense(Expensive expensive) async {
    await database.into(database.expense).insert(ExpenseCompanion.insert(
        title: expensive.title,
        name: expensive.name,
        value: double.parse(expensive.value.replaceAll(RegExp(r"[^\d.]+"),'')),
        fixed: expensive.fixed,
        createdAt: DateTime.now(),
        expenseDate: DateTime.now().subtract(Duration(days: 1)),
        category: 1));
  }


  @override
  void initState(){
    super.initState();
    listAllExpenses();
  }



  List<PieChartSectionData> showingSections() {
    return lista.map((i) {
      final isTouched = lista.indexOf(i) == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: isTouched ? Colors.deepPurple : Colors.deepOrange,
        value: isTouched ? 40 : 60,
        title: isTouched ? '40%' : '60%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: Container(
          padding: EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: const Icon(
            Icons.car_rental_sharp,
            color: Colors.white,
          ),
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
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
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      /* setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                    */
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: showingSections(),
                ),
                swapAnimationDuration: Duration(seconds: 5),
              ),
            ),
            Divider(height: 5),
            SizedBox(
              height: 250,
              child: ListView.builder(
                  itemCount: lista.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int indice) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.webhook_rounded),
                          Text(lista[indice].title),
                          Text(lista[indice].name),
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
                    content: ExpensiveForm(onSave: (ex) {
                      insertExpense(ex);
                    }),
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
