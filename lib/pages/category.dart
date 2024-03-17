import 'dart:math' as math;
import 'package:expense/services/category/categorize.dart';
import 'package:flutter/material.dart';
import 'package:expense/models/expense_item.dart';
import 'package:expense/data/expense_data.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ExpenseData expenseData = ExpenseData();
  Map<String, int> industryCountMap = {};

  @override
  void initState() {
    super.initState();
    expenseData.prepareData();
    _fetchPredictedIndustries();
  }

  Future<void> _fetchPredictedIndustries() async {
    try {
      List<ExpenseItem> expenseList = expenseData.getAllExpenseList();

      for (ExpenseItem expense in expenseList) {
        String predictedIndustry = await predictIndustry(expense.name.toLowerCase());
        predictedIndustry = predictedIndustry.replaceAll(" ", "");
        print(expense.name+"=>"+predictedIndustry);
        industryCountMap[predictedIndustry] =
            (industryCountMap[predictedIndustry] ?? 0) + 1;
      }

      setState(() {}); // Trigger a rebuild to update the UI with the pie chart
    } catch (e) {
      print('Error fetching predicted industries: $e');
    }
  }
  List<PieChartSectionData> _generatePieChartSections() {
  List<PieChartSectionData> sections = [];

  industryCountMap.forEach((industry, count) {
    sections.add(
      PieChartSectionData(
        color: getRandomColor(), // You can define your own color logic
        value: count.toDouble(),
        title: '$industry\n$count', // Display industry and count as the title
        radius: 100,
        titleStyle: TextStyle(
          fontFamily: 'Poppins',

          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xffffffff),
        ),
      ),
    );
  });

  return sections;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Categories'),
      ),
      body: industryCountMap.isEmpty
          ? Center(
              child: Text('Loading data...'),
            )
          : _buildPieChart(),
    );
  }
Widget _buildPieChart() {
  return Column(
    children: [
      Expanded(
        child: PieChart(
          PieChartData(
            sections: _generatePieChartSections(),
            centerSpaceRadius: 40.0,
            sectionsSpace: 0,
            pieTouchData: PieTouchData(),
          ),
        ),
      ),
      SizedBox(height: 20), // Adjust the spacing based on your preference
      // _buildExpenseList(),
    ],
  );
}
// Widget _buildExpenseList() {
//   Map<String, int> mergedCategories = {};

//   industryCountMap.forEach((industry, count) {
//     List<ExpenseItem> expenseList = expenseData.getAllExpenseList();

//     // Filter expenses for the current industry
//     List<ExpenseItem> industryExpenses = expenseList.where((expense) {
      
//       industry = industry.replaceAll(" ", "");
      
//       return predictIndustry(expense.name) == industry;
//     }).toList();

//     // Merge expenses into a single category
//     String mergedCategory = industryExpenses.map((expense) => expense.name).join(', ');

//     // Update the merged categories map
//     mergedCategories[mergedCategory] = (mergedCategories[mergedCategory] ?? 0) + count;
//   });

// }


  Color getRandomColor() {
    // You can implement your own logic to generate random colors
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);

  }
}
