import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/formatters/CurrencyInputFormatter.dart';
import 'package:fake_wallet/formatters/DateInputFormatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    int touchedIndex = 0;
    final database = AppDatabase();

    List<ExpenseData> lista = [];

    void listAllExpenses() async {
      lista = await database.select(database.expense).get();
    }

    void listAllCategories() async {
      await database.select(database.category).get();
    }

    void inserCategory() async {
      await database
          .into(database.category)
          .insert(CategoryCompanion.insert(description: '', icon: ''));
    }

    void insertExpense() async {
      await database.into(database.expense).insert(ExpenseCompanion.insert(
          title: 'todo: finish drift setup',
          name: 'We can now write queries and define our own tables.',
          value: 34.3,
          fixed: false,
          createdAt: DateTime.now(),
          expenseDate: DateTime.now().subtract(Duration(days: 1)),
          category: 1));
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

    return SingleChildScrollView(
        child: Column(
      children: [
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
        ),
        FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    title: Text('New Expense'),
                    content: Form(
                      child: Container(
                        width: 250,
                        height: 500,
                        // color: Colors.white,
                        child: Column(
                          children: [
                            TextFormField(
                              maxLength: 50,
                              decoration: const InputDecoration(
                                  labelText: 'Title'),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Name'),
                            ),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CurrencyInputFormatter()
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                  labelText: 'Value'),
                            ),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                DateInputFormatter()
                              ],
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                  labelText: 'Expense Date'),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          backgroundColor: Colors.amber,
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 25,
          ),
        )
      ],
    ));
  }
}
