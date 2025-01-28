import 'package:fake_wallet/utils/database_utils.dart';
import 'package:fake_wallet/utils/theme_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  const Chart({super.key, required this.expenses});

  @override
  State<StatefulWidget> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return widget.expenses.map((i) {
      final isTouched = widget.expenses.indexOf(i) == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 110.0 : 90.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: isTouched
            ? Colors.black
            : ThemeUtils.chartColors[widget.expenses.indexOf(i)],
        value: i['percentage'],
        title: '${i['percentage']}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: defaultColorScheme.surface,
          shadows: shadows,
        ),
        badgeWidget: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: defaultColorScheme.onSurface,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Icon(
            IconData(DatabaseUtils.invertedIconMap[i['icon']]!,
                fontFamily: 'MaterialIcons'),
            color: defaultColorScheme.surface,
          ),
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.expenses.isNotEmpty
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
            swapAnimationDuration: const Duration(seconds: 3),
          )
        : Image.asset('assets/pork.gif');
  }
}
