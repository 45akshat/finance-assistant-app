import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:expense/bar%20graph/bar_graph.dart';
import 'package:expense/data/expense_data.dart';
import 'package:expense/datetime/date_time_helper.dart';

class ExpenseSummary extends StatefulWidget {
  final DateTime startOfWeek;

  ExpenseSummary({
    Key? key,
    required this.startOfWeek,
  }) : super(key: key);

  @override
  State<ExpenseSummary> createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  double _currentWeeklyBudget = 0.0;

  late Box _hiveBox;

    @override
  void initState() {
    super.initState();
    _openHiveBox();
  }

  void _openHiveBox() async {
    await Hive.openBox('budgetBox');
    _hiveBox = Hive.box('budgetBox');
    _loadWeeklyBudget();
  }

  void _loadWeeklyBudget() {
    double? storedBudget = _hiveBox.get('weeklyBudget');
    if (storedBudget != null) {
      setState(() {
        _currentWeeklyBudget = storedBudget;
      });
    }
  }



  //calculate the max amount
  int calculateMaxAmt(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ){
    int? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    values.sort();

    //get largest amount which is at the end of the sorted list
    max = (((values).last).toInt()*1.5).toInt();

    return max < 100? 100: max;
  }

  int calculateWeekTotal(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
    ){
      int total = 0;

      List<double> values = [
        value.calculateDailyExpenseSummary()[sunday] ?? 0,
        value.calculateDailyExpenseSummary()[monday] ?? 0,
        value.calculateDailyExpenseSummary()[tuesday] ?? 0,
        value.calculateDailyExpenseSummary()[wednesday] ?? 0,
        value.calculateDailyExpenseSummary()[thursday] ?? 0,
        value.calculateDailyExpenseSummary()[friday] ?? 0,
        value.calculateDailyExpenseSummary()[saturday] ?? 0,
      ];

      values.sort();

      //get largest amount which is at the end of the sorted list

      for (var i = 0; i < values.length; i++) {
        total += (values[i]).toInt();
      }
      return total;
  }

double calculateUtilizationPercentage(ExpenseData value, String sunday, String monday, String tuesday, String wednesday, String thursday, String friday, String saturday) {

  
  int weeklyBudget = 10000; // Replace with your actual weekly budget value
  int weekTotal = calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday);
  print(_currentWeeklyBudget);
  // Calculate the percentage
  double percentage = (weekTotal / _currentWeeklyBudget) * 100;

  return percentage;
}

Color getUtilizationColor(double utilization) {
  if (utilization >= 100) {
    return Colors.red; // Red for 100% or more utilization
  } else if (utilization >= 50 && utilization < 100) {
    return Color.fromARGB(255, 188, 141, 0); // Yellow for utilization between 80% and 99%
  } else {
    return Colors.green; // Default color for other cases
  }
}


  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(widget.startOfWeek.add(Duration(days: 0)));
    String monday = convertDateTimeToString(widget.startOfWeek.add(Duration(days: 1)));
    String tuesday = convertDateTimeToString(widget.startOfWeek.add(Duration(days: 2)));
    String wednesday = convertDateTimeToString(widget.startOfWeek.add(Duration(days: 3)));
    String thursday = convertDateTimeToString(widget.startOfWeek.add(Duration(days: 4)));
    String friday = convertDateTimeToString(widget.startOfWeek.add(Duration(days: 5)));
    String saturday = convertDateTimeToString(widget.startOfWeek.add(Duration(days: 6)));
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          //Week Total
          Padding(padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
          child: Row(
            children: [
              // Week Total
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
                child: Row(
                  children: [
                    Text("Week Total-  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("₹ " + calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday).toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                    // Utilization with margin, border radius, and background color
                    Container(
                      margin: EdgeInsets.only(left: 10), // Adjust the margin value as needed
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: getUtilizationColor(calculateUtilizationPercentage(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)),
                      ),
                      child: Text(
                         calculateUtilizationPercentage(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday).toStringAsFixed(2) + "% used",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ],

          ),),
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMaxAmt(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday).toDouble(), 
            sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0, 
            monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0, 
            tuesAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0, 
            wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0, 
            thursAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0, 
            friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0, 
            satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0),
          ),
        ],
      )
    );
  }
}