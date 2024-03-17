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
  ) {
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
    max = (((values).last).toInt() * 1.5).toInt();

    return max < 100 ? 100 : max;
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
  ) {
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

  double calculateUtilizationPercentage(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    int weeklyBudget = 10000; // Replace with your actual weekly budget value
    int weekTotal = calculateWeekTotal(
        value, sunday, monday, tuesday, wednesday, thursday, friday, saturday);
    print(_currentWeeklyBudget);
    // Calculate the percentage
    double percentage = (weekTotal / _currentWeeklyBudget) * 100;

    return percentage;
  }

  Color getUtilizationColor(double utilization) {
    if (utilization >= 100) {
      return Color.fromARGB(122, 242, 51, 38); // Red for 100% or more utilization
    } else if (utilization >= 50 && utilization < 100) {
      return Color.fromARGB(113, 251, 255, 3); // Yellow for utilization between 80% and 99%
    } else {
      return Color.fromARGB(88, 32, 198, 38); // Default color for other cases
    }
  }

  @override
  Widget build(BuildContext context) {
    String sunday =
        convertDateTimeToString(widget.startOfWeek.add(Duration(days: 0)));
    String monday =
        convertDateTimeToString(widget.startOfWeek.add(Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(widget.startOfWeek.add(Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(widget.startOfWeek.add(Duration(days: 3)));
    String thursday =
        convertDateTimeToString(widget.startOfWeek.add(Duration(days: 4)));
    String friday =
        convertDateTimeToString(widget.startOfWeek.add(Duration(days: 5)));
    String saturday =
        convertDateTimeToString(widget.startOfWeek.add(Duration(days: 6)));
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Column(
              children: [
                //Week Total
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(208, 18, 18, 23),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expense (Weekly)  ",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹ ${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                              height:
                                  10), // Add some space between the two rows
                          // Utilization with margin, border radius, and background color
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 20),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: getUtilizationColor(
                                calculateUtilizationPercentage(
                                  value,
                                  sunday,
                                  monday,
                                  tuesday,
                                  wednesday,
                                  thursday,
                                  friday,
                                  saturday,
                                ),
                              ),
                            ),
                            child: Text(
                              "${calculateUtilizationPercentage(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday).toStringAsFixed(2)}% used",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          width: 20), // Add some space between the two columns
                      // Circular progress indicator representing budget utilized percentage
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          value: calculateUtilizationPercentage(
                                value,
                                sunday,
                                monday,
                                tuesday,
                                wednesday,
                                thursday,
                                friday,
                                saturday,
                              ) /
                              100,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              const Color.fromARGB(255, 33, 93, 243)), // Change color as needed
                          backgroundColor: Colors
                              .grey[300], // Change background color as needed
                        ),
                      ),
                    ],
                  ),
                ),
                        
                SizedBox(
                  height: 200,
                  child: MyBarGraph(
                      maxY: calculateMaxAmt(value, sunday, monday, tuesday,
                              wednesday, thursday, friday, saturday)
                          .toDouble(),
                      sunAmount:
                          value.calculateDailyExpenseSummary()[sunday] ?? 0,
                      monAmount:
                          value.calculateDailyExpenseSummary()[monday] ?? 0,
                      tuesAmount:
                          value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                      wedAmount:
                          value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                      thursAmount:
                          value.calculateDailyExpenseSummary()[thursday] ?? 0,
                      friAmount:
                          value.calculateDailyExpenseSummary()[friday] ?? 0,
                      satAmount:
                          value.calculateDailyExpenseSummary()[saturday] ?? 0),
                ),
              ],
            ));
  }
}
