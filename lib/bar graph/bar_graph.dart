import 'package:expense/bar%20graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tuesAmount;
  final double wedAmount;
  final double thursAmount;
  final double friAmount;
  final double satAmount;
  
  const MyBarGraph({
    super.key,
    required this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tuesAmount,
    required this.wedAmount,
    required this.thursAmount,
    required this.friAmount,
    required this.satAmount,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: sunAmount, 
    monAmount: monAmount, 
    tuesAmount: tuesAmount, 
    wedAmount: wedAmount, 
    thursAmount: thursAmount, 
    friAmount: friAmount, 
    satAmount: satAmount
    );
    myBarData.initializeBarData();


    return BarChart(BarChartData(
      // maxY: 2000,
      minY: 0,
      titlesData: FlTitlesData(show: true,
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: getBottomTitles,
        )
      )),
      
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: myBarData.barData.map((e) => BarChartGroupData(x: e.x,
      barRods: [
        BarChartRodData(
          toY: e.y,
          color: Color.fromARGB(255, 69, 63, 255),
          width: 25,
          borderRadius: BorderRadius.circular(8),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: Color.fromARGB(255, 32, 34, 57)
          )
          )
      ])).toList(),
    ));
  }
}


Widget getBottomTitles(double value, TitleMeta meta){
  const style = TextStyle(
    fontFamily: 'Poppins',

    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14
  );
  Widget text;
  switch (value.toInt()){
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('T', style: style,);
      break;
    case 5:
      text = const Text('F', style: style,);
      break;
    case 6:
      text = const Text('S', style: style,);
      break;

    default:
      text = const Text('', style: style,);
      break;
  }

  return SideTitleWidget(
    child: text,
    axisSide: meta.axisSide,

  );
}