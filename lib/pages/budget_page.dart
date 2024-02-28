import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double _currentWeeklyBudget = 0.0;
  late Box _hiveBox;
  TextEditingController _newBudgetController = TextEditingController();

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
    // Load the weekly budget from Hive if it exists
    double? storedBudget = _hiveBox.get('weeklyBudget');
    if (storedBudget != null) {
      setState(() {
        _currentWeeklyBudget = storedBudget;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Weekly Budget: Rs ${_currentWeeklyBudget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newBudgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter New Weekly Budget',
                hintText: 'Enter amount in rupees',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _setWeeklyBudget();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 0, 150, 0), // Set the background color
                onPrimary: Colors.white, // Set the text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Set rounded corners
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Set padding
              ),
              child: Text(
                'Set Weekly Budget',
                style: TextStyle(fontSize: 16.0), // Set text style
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _setWeeklyBudget() {
    // Validate input before setting the weekly budget
    if (_newBudgetController.text.isEmpty) {
      // Show an error message or handle it appropriately
      return;
    }

    // Parse the amount as a double
    double newWeeklyBudget = double.tryParse(_newBudgetController.text) ?? 0.0;

    // Set the current weekly budget in the UI
    setState(() {
      _currentWeeklyBudget = newWeeklyBudget;
    });

    // Save the new weekly budget in Hive
    _hiveBox.put('weeklyBudget', newWeeklyBudget);

    // Optionally, you can clear the text field after setting the budget
    _newBudgetController.clear();
  }
}
