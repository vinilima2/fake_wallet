import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    int touchedIndex = 0;

    List<Map> lista = [
      {
        "dataDespesa": "10/02/2024",
        "titulo": "GASTO COMBUSTIVEL",
        "categoria": "VEICULO",
        "estabelecimento": "Posto Elefantinho"
      },
      {
        "dataDespesa": "10/02/2024",
        "titulo": "GASTO COMBUSTIVEL",
        "categoria": "VEICULO",
        "estabelecimento": "Posto Elefantinho"
      }
    ];

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.webhook_rounded),
                        Text(lista[indice]['titulo']),
                        Text(lista[indice]['dataDespesa']),
                      ],
                    );
                  }),
            )
          ],
        )),
      ),
    );
  }
}
