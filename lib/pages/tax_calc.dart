import 'package:flutter/material.dart';
// https://income-tax-calculator.in/



class TaxCalculatorScreen extends StatefulWidget {
  @override
  _TaxCalculatorScreenState createState() => _TaxCalculatorScreenState();
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  TextEditingController incomeController = TextEditingController();
  bool applyStandardDeduction = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      appBar: AppBar(
        title: Text(
              'Tax Calculator',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color:Colors.white ),
            ),
       backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 187, 187, 187)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: ListView(
          shrinkWrap: true,
          children: [
            
            SizedBox(height: 20),
            TextField(
              controller: incomeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Income:',
              ),
              style: TextStyle(color: Colors.white)
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Apply Standard Deduction (Salaried Only):', style: TextStyle(color: Colors.white),),
                Checkbox(
                  value: applyStandardDeduction,
                  onChanged: (value) {
                    setState(() {
                      applyStandardDeduction = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateTax();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 66, 47, 229), // Set the background color
                onPrimary: Color.fromARGB(255, 187, 187, 187), // Set the text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              child: Text('Calculate Tax', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            TaxResultsTable(
              oldTaxableIncome: oldTaxableIncome,
              oldCalculatedTax: oldCalculatedTax,
              oldCess: oldCess,
              oldTotalTax: oldTotalTax,
              newTaxableIncome: newTaxableIncome,
              newCalculatedTax: newCalculatedTax,
              newCess: newCess,
              newTotalTax: newTotalTax,
            ),
          ],
        ),
      ),
    );
  }
  double oldTaxableIncome = 0.0;
  double oldCalculatedTax = 0.0;
  double oldCess = 0.0;
  double oldTotalTax = 0.0;

  double newTaxableIncome = 0.0;
  double newCalculatedTax = 0.0;
  double newCess = 0.0;
  double newTotalTax = 0.0;

  void calculateTax() {
    // Get input values
    var income = double.tryParse(incomeController.text) ?? 0.0;

    // Apply standard deduction if checked
    var standardDeduction = applyStandardDeduction ? 50000 : 0;

    // Old Tax Regime Calculation
    oldTaxableIncome = income - standardDeduction;
    oldCalculatedTax = calculateOldTax(oldTaxableIncome);
    oldCess = 0.04 * oldCalculatedTax;
    oldTotalTax = oldCalculatedTax + oldCess;

    // New Tax Regime Calculation
    newTaxableIncome = income - standardDeduction;
    newCalculatedTax = calculateNewTax(newTaxableIncome);
    newCess = 0.04 * newCalculatedTax;
    newTotalTax = newCalculatedTax + newCess;

    // Update UI
    setState(() {});
  }

  double calculateOldTax(double income) {
    var oldTax = 0.0;
    if (income > 1000000) {
      oldTax += (income - 1000000) * 0.3;
      income = 1000000;
    }
    if (income > 500000) {
      oldTax += (income - 500000) * 0.2;
      income = 500000;
    }
    if (income > 250000) {
      oldTax += (income - 250000) * 0.05;
    }
    return oldTax;
  }

  double calculateNewTax(double income) {
    var newTax = 0.0;
    if (income > 900000) {
      newTax += (income - 900000) * 0.15;
      income = 900000;
    }
    if (income > 600000) {
      newTax += (income - 600000) * 0.1;
      income = 600000;
    }
    if (income > 300000) {
      newTax += (income - 300000) * 0.05;
    }
    return newTax;
  }
}

class TaxResultsTable extends StatelessWidget {
  final double oldTaxableIncome;
  final double oldCalculatedTax;
  final double oldCess;
  final double oldTotalTax;
  final double newTaxableIncome;
  final double newCalculatedTax;
  final double newCess;
  final double newTotalTax;

  TaxResultsTable({
    required this.oldTaxableIncome,
    required this.oldCalculatedTax,
    required this.oldCess,
    required this.oldTotalTax,
    required this.newTaxableIncome,
    required this.newCalculatedTax,
    required this.newCess,
    required this.newTotalTax,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Old Tax Regime Result:',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        DataTable(
          border: const TableBorder(
            horizontalInside: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 5, 5, 5),
            ),
                                      
          ),
          columns: [
            DataColumn(label: Text('Details', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Amount (₹)', style: TextStyle(color: Colors.white))),
          ],
          columnSpacing: 16, // Adjust as needed
          
          rows: [
            DataRow(cells: [
              DataCell(Text('Taxable Income', style: TextStyle(color: Colors.white))),
              DataCell(Text(oldTaxableIncome.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
            DataRow(cells: [
              DataCell(Text('Calculated Tax', style: TextStyle(color: Colors.white))),
              DataCell(Text(oldCalculatedTax.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
            DataRow(cells: [
              DataCell(Text('Health and Education Cess', style: TextStyle(color: Colors.white))),
              DataCell(Text(oldCess.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
            DataRow(cells: [
              DataCell(Text('Total Payable Tax (Old Regime)', style: TextStyle(color: Colors.white))),
              DataCell(Text(oldTotalTax.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'New Tax Regime Result:',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        DataTable(
          border: const TableBorder(
            horizontalInside: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 5, 5, 5),
            ),
                                      
          ),
          columns: [
            DataColumn(label: Text('Details', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Amount (₹)', style: TextStyle(color: Colors.white))),
          ],

          columnSpacing: 16, // Adjust as needed
          rows: [
            DataRow(cells: [
              DataCell(Text('Taxable Income', style: TextStyle(color: Colors.white))),
              DataCell(Text(newTaxableIncome.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
            DataRow(cells: [
              DataCell(Text('Calculated Tax', style: TextStyle(color: Colors.white))),
              DataCell(Text(newCalculatedTax.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
            DataRow(cells: [
              DataCell(Text('Health and Education Cess', style: TextStyle(color: Colors.white))),
              DataCell(Text(newCess.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
            DataRow(cells: [
              DataCell(Text('Total Payable Tax (New Regime)', style: TextStyle(color: Colors.white))),
              DataCell(Text(newTotalTax.toStringAsFixed(2), style: TextStyle(color: Colors.white))),
            ]),
          ],
        ),
      ],
    );
  }
}
