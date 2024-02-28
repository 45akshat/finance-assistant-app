import 'package:expense/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  // reference our box
  final _myBox = Hive.box("expense_database");
  //write data
  void saveData(List<ExpenseItem> allExpense){
    // hive can only save strings and dateTime and not custom objects like ExpenseItem.
    List<List<dynamic>> allExpensesFormatted = [];

    for(var expense in allExpense){
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    // finally lets store it in our database!
    _myBox.put('ALL_EXPENSES', allExpensesFormatted);
  }
  
  
  //read data
  List<ExpenseItem> readData(){
    // convert it back to object from str

    List savedExpenses = _myBox.get('ALL_EXPENSES') ?? [];
    List<ExpenseItem> allExpenses = [];

    for (var i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem expense = ExpenseItem(
        name: name, 
        amount: amount, 
        dateTime: dateTime
      );
      allExpenses.add(expense);
    }
    return allExpenses;
  }


}