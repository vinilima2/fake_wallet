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
    'theaters': 0xe655,
    'car_repair': 0xe13d,
    'bolt': 0xe0ee,
    'water_drop_rounded': 0xf03b4,
    'fastfood': 0xe25a,
    'bus_alert': 0xe11a,
    'credit_card': 0xe19f,
    'home': 0xe318,
    'local_gas_station': 0xe394,
    'gas_meter': 0xf07a4,
    'sim_card': 0xe5b7,
    'school': 0xe559,
    'coffee': 0xe178,
    'help': 0xe309,
    'health_and_safety': 0xe305
  };

  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    return widget.expenses.map((i) {
      final isTouched = widget.expenses.indexOf(i) == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: isTouched ? Colors.deepPurple : Colors.deepOrange,
        value: i['percentage'],
        title: i['percentage'].toString() + '%',
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
          child: Icon(
            IconData(iconMap[i['icon']]! as int),
            color: Colors.white,
          ),
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
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
    );
  }
}
