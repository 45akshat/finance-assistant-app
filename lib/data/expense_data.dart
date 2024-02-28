import 'package:expense/data/hive_database.dart';
import 'package:expense/datetime/date_time_helper.dart';
import 'package:expense/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier{
  // list  of all the expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //prepare data to display

  final db = HiveDataBase();
  void prepareData(){
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense){
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }
  // delete and expense
  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);

  }


  // get weekday( mon, tues, etc) from a dateTime object
  String getDayName(DateTime dateTime){
    switch (dateTime.weekday){
      case 1:
        return 'Mon';
      case 2:
        return 'Tues';
      case 3:
        return 'Wed';
      case 4:
        return 'Thurs';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week (sunday)
  DateTime startOfWeekDate(){
    DateTime? startOfWeek;

    //get todays date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (var i = 0; i < 7; i++) {
      if(getDayName(today.subtract(Duration(days: i))) == 'Sun'){
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }
  /*
 
  convert overall list of exxpenses into a daily expense summary

  eg.  

  overallExpenseList = 

  [

    [food, 20230130, $10 ],
    
  ]

  */

  Map<String, double> calculateDailyExpenseSummary(){
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);

      double amount  = double.parse(expense.amount);

      if(dailyExpenseSummary.containsKey(date)){
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }else{
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }

  Map<String, double> calculateWeeklyExpenseTotal() {
    Map<String, double> weeklyExpenseTotal = {};

    for (var expense in overallExpenseList) {
      String weekStart = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (weeklyExpenseTotal.containsKey(weekStart)) {
        double currentAmount = weeklyExpenseTotal[weekStart]!;
        currentAmount += amount;
        weeklyExpenseTotal[weekStart] = currentAmount;
      } else {
        weeklyExpenseTotal.addAll({weekStart: amount});
      }
    }

    return weeklyExpenseTotal;
  }
}



