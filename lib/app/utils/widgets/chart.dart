// import 'package:al_khalil/domain/models/models.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class MyChart extends StatelessWidget {
//   final List? data;
//   const MyChart({super.key, this.data});
//   static const List<Color> gradientColors = [
//     Colors.cyan,
//     Colors.green,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8),
//       width: double.infinity,
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         color: Colors.black,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(
//           right: 18,
//           left: 12,
//           top: 24,
//           bottom: 12,
//         ),
//         child: LineChart(
//           mainData(),
//         ),
//       ),
//     );
//   }

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 14,
//         color: Colors.blue,
//         decorationThickness: 0);
//     Widget text = Text('${value.toInt() + 1}', style: style);
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: text,
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 12,
//         decorationThickness: 0,
//         color: Colors.blue);
//     String text = "${value.toInt()}";

//     return Text(text, style: style, textAlign: TextAlign.left);
//   }

//   LineChartData mainData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 5,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: Colors.blue,
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: Colors.blue,
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 5,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//           axisNameWidget: const Text(
//             "الجزء",
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 5,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 30,
//           ),
//           axisNameWidget: const Text(
//             "الصفحات",
//             style: TextStyle(fontSize: 12),
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: 29,
//       minY: 0,
//       maxY: 20,
//       lineBarsData: [
//         LineChartBarData(
//           spots: data == null
//               ? []
//               : data!
//                   .cast<Chart>()
//                   .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
//                   .toList(),
//           isCurved: true,
//           gradient: const LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
