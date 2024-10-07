import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget2 extends StatelessWidget {
  const LineChartWidget2({
    super.key, required this.allSpots, required this.keys, required this.isDay,});
  final List<FlSpot> allSpots;
  final List<String> keys;
  final bool isDay ;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black,
          ),
        ),
        gridData: FlGridData(show: false),
        titlesData: titlesData1,
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom:
            BorderSide(color:Colors.blue.withOpacity(0.2), width: 4),
            left: const BorderSide(color: Colors.transparent),
            right: const BorderSide(color: Colors.transparent),
            top: const BorderSide(color: Colors.transparent),
          ),
        ),
         extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      color: Colors.black,
                      strokeWidth: 3,
                      dashArray: [20, 10],
                    ),
                  ],
                ),
        lineBarsData: [LineChartBarData(
            isCurved: true,
            color: Colors.green,
            barWidth: 8,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots:allSpots
        )],
        minX: 0,
        maxX: isDay?30:12,
        // maxY: 400,
      //  minY: 0,
      ) ,
      duration: const Duration(milliseconds: 250),
    );
  }




  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 10,
            child: Text(value.toInt().toString()),
          );
        },
      ),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        getTitlesWidget: (value, meta) {
          return Text(value.toInt().toString(), style:  TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black
          ), textAlign: TextAlign.center);
        },
        showTitles: true,
       // interval: 10000,
        reservedSize: 50,
      ),
    ),
  );

}
