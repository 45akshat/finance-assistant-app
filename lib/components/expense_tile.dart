import 'package:expense/services/category/categorize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  void Function(BuildContext)? deleteTapped;

  ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  Future<IconData> getCategoryIcon() async {
    try {
      String predictedIndustry = await predictIndustry(name);

      // Map the predicted industry to an icon
      if (predictedIndustry == 'food') {
        return Icons.fastfood; // Replace with the appropriate food icon
      } else if (predictedIndustry == 'shopping') {
        return Icons.shopping_cart; // Replace with the appropriate shopping icon
      } else if (predictedIndustry == 'transfer') {
        return Icons.swap_horiz; // Replace with the appropriate transfer icon
      } else {
        return Icons.category; // Default icon if industry is unknown
      }
    } catch (e) {
      print('Error predicting industry: $e');
      return Icons.category; // Default icon in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 47, 47, 47), // Adjust the color of the border as needed
            width: 0.8, // Adjust the width of the border as needed
          ),
        ),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteTapped,
              icon: Icons.delete,
              backgroundColor: Colors.red,
            )
          ],
        ),
        child: ListTile(
          leading: FutureBuilder<IconData>(
            future: getCategoryIcon(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Icon(
                  snapshot.data,
                  color: Color.fromARGB(255, 228, 228, 228),
                );
              } else {
                return Icon(
                  Icons.category,
                  color: Color.fromARGB(255, 228, 228, 228),
                );
              }
            },
          ),
          title: Text(
            name,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromARGB(255, 202, 202, 202),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '${dateTime.day} / ${dateTime.month} / ${dateTime.year}',
            style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 81, 81, 81)),
          ),
          trailing: Text(
            '₹ ' + amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromARGB(255, 159, 159, 159),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
