import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  const Chart({super.key, required this.expenses});

  @override
  State<StatefulWidget> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  static const iconMap = {
    'Theater': 0xe655,
    'Car Repair': 0xe13d,
    'Energy': 0xe0ee,
    'Water': 0xf03b4,
    'FastFood': 0xe25a,
    'Bus': 0xe11a,
    'Credit Card': 0xe19f,
    'Home': 0xe318,
    'Fuel': 0xe394,
    'Gas': 0xf07a4,
    'Phone': 0xe5b7,
    'School': 0xe559,
    'Coffee': 0xe178,
    'Another': 0xe309,
    'Health': 0xe305
  };


  static const List<MaterialColor> colors = [
    Colors.green,
    Colors.amber,
    Colors.red,
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.grey,
    Colors.cyan,
    Colors.indigo,
    Colors.purple,
    Colors.brown
  ];

  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
     final defaultColorScheme = Theme.of(context).colorScheme;
     
    return widget.expenses.map((i) {
      final isTouched = widget.expenses.indexOf(i) == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 110.0 : 90.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: isTouched ? Colors.black : colors[widget.expenses.indexOf(i)],
        value: i['percentage'],
        title: i['percentage'].toString() + '%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: defaultColorScheme.surface,
          shadows: shadows,
        ),
        badgeWidget: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: defaultColorScheme.onSurface,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Icon(
            IconData(iconMap[i['icon']]! as int, fontFamily: 'MaterialIcons'),
            color: defaultColorScheme.surface,
          ),
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.expenses.length > 0
        ? PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 5,
              sections: showingSections(),
            ),
            swapAnimationDuration: Duration(seconds: 3),
          )
        : Image.asset('assets/pork.gif');
  }
}
