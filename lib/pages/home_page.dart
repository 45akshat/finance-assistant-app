import 'package:expense/components/expense_summary.dart';
import 'package:expense/components/expense_tile.dart';
import 'package:expense/data/expense_data.dart';
import 'package:expense/models/expense_item.dart';
import 'package:expense/pages/account_page.dart';
import 'package:expense/pages/budget_page.dart';
import 'package:expense/pages/category.dart';
import 'package:expense/pages/chat_page.dart';
import 'package:expense/pages/investments_page.dart';
import 'package:expense/pages/tax_calc.dart';
import 'package:expense/services/sms_model/connect_to_py.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  final Telephony telephony = Telephony.instance;

  final _formKey = GlobalKey<FormState>;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _valueSms = TextEditingController();

  _getSMS() async {
    List<SmsMessage> _messages = [];
    List<String> allowedAddresses = [
      "TMKOTAKB",
      "VMUNIONB",
      "SBI",
      "AXIS",
      "HDFC",
      "ICICI",
      "PNB",
      "BOI",
      "UBI",
      "IDBI",
      "Canara",
      "IOB",
      "KVB",
      "CBI",
      "IndusInd",
      "Yes Bank",
      "Federal Bank"
    ];
    for (String address in allowedAddresses) {
      List<SmsMessage> filteredMessages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE_SENT],
        filter: SmsFilter.where(SmsColumn.ADDRESS).like(address),
      );

      _messages.addAll(filteredMessages);
    }

    String text = "You've spent Rs.251.00 thru kotak bal 27000.00 Not you?";
    String spentAmount = "0";
    String location = 'Transfer';

    bool containsSpendingKeywords(String message) {
      // List of keywords to check for in the message
      List<String> spendingKeywords = ["debited", "debit", "spent", "sent"];

      // Convert the message to lowercase for case-insensitive matching
      String lowercaseMessage = message.toLowerCase();

      // Check if any of the keywords are present in the message
      return spendingKeywords
          .any((keyword) => lowercaseMessage.contains(keyword));
    }

    for (var msg in _messages) {
      print(msg.dateSent);

      // Replace 'http://192.168.100.117:5000/process' with your actual API endpoint
      final String apiUrl = 'http://192.168.100.117:5000/process';

      // Call sendRequest and handle the response
      final Map<String, dynamic> response =
          await sendRequest(apiUrl, msg.body!);

      if (response.containsKey('error')) {
        print('Error: ${response['error']}');
      } else {
        if (containsSpendingKeywords(msg.body!)) {
          // ... (Existing code for processing messages)

          for (var i = 0; i < 2; i++) {
            if (response['entities'][i]["label"] == "AMOUNT") {
              spentAmount = response["entities"][i]["text"];
            } else if (response['entities'][i]["label"] == "SENT_TO") {
              location = response["entities"][i]["text"];
            }
          }
        }
      }

      ExpenseItem newExpense = ExpenseItem(
        name: location,
        amount: spentAmount,
        dateTime: DateTime.now(),
      );

      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //prepare the data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  int extractAmount(String text) {
    RegExp amountRegExp = RegExp(r'Rs\.(\d+)');
    Match? amountMatch = amountRegExp.firstMatch(text);

    if (amountMatch != null && amountMatch.groupCount > 0) {
      String? amountString = amountMatch.group(1);
      return int.parse(amountString ?? '0');
    }

    // Return a default value or handle the case where no match is found
    return 0;
  }

  String extractLocation(String text) {
    RegExp locationRegExp = RegExp(r'at (\w+)');
    Match? locationMatch = locationRegExp.firstMatch(text);

    if (locationMatch != null && locationMatch.groupCount > 0) {
      String? locationString = locationMatch.group(1);
      return locationString ?? '';
    }

    // Return a default value or handle the case where no match is found
    return '';
  }

void addNewExpense() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        color: Color.fromARGB(255, 23, 25, 31),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'New Expense',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16), // Add space between title and text fields

            // Expense name

TextField(
  controller: newExpenseNameController,
  style: TextStyle(color: Colors.white), // Set text color to white
  decoration: const InputDecoration(
    hintText: 'Expense Name',
    hintStyle: TextStyle(color: Color.fromARGB(255, 137, 137, 137)),
  ),
),

// Expense amount
TextField(
  controller: newExpenseAmountController,
  style: TextStyle(color: Colors.white), // Set text color to white
  decoration: const InputDecoration(
    hintText: 'Amount',
    hintStyle: TextStyle(color: Color.fromARGB(255, 137, 137, 137)),
  ),
),

            SizedBox(height: 16), // Add space between text fields and buttons

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Save button
                ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 66, 47, 229),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Cancel button
                OutlinedButton(
                  onPressed: cancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Color.fromARGB(255, 88, 71, 240)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );

    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

//clear controllers
  void clear() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  AppBar appBar() {
    return AppBar(
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
      children: [
        Icon(
          Icons.person, // Replace with your preferred icon
          color: Colors.white,
        ),
        SizedBox(width: 10), // Add space between icon and text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi Akshat 👋',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 240, 240, 240),
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Never Loose Track!', // Add your subtext
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey, // Adjust the color as needed
                fontSize: 12, // Adjust the font size as needed
              ),
            ),
          ],
        ),
      ],
    ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      elevation: 0,
      // centerTitle: true,
      actions: [
        ElevatedButton(
          onPressed: () {
            _getSMS();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent, // Set background color to transparent
            elevation: 0, // Remove button shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8.0), // Customize border radius if needed
              side: BorderSide(
                  color: const Color.fromARGB(
                      255, 0, 0, 0)), // Add border if needed
            ),
          ),
          child: Icon(Icons.refresh,
              color:
                  const Color.fromARGB(255, 255, 255, 255)), // Set icon color
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar(),
        body: RefreshIndicator(
          onRefresh: () async {
            // Call the reload function here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          child: Container(
            // padding: EdgeInsets.only(top: 20),
            child: ListView(
              children: [
                // Container(
                //   margin: EdgeInsets.only(
                //       left: 14, top: 15), // You can adjust the value as needed
                //   child: Text(
                //     'Spacing',
                //     style: TextStyle(
                //         fontFamily: 'Poppins',
                //         fontSize: 10,
                //         color: const Color.fromARGB(255, 0, 0, 0),
                //         fontWeight: FontWeight.bold),
                //   ),
                // ),

                //weekly summary graph
                ExpenseSummary(startOfWeek: value.startOfWeekDate()),

                Container(
                  margin: EdgeInsets.only(left: 14, top: 30, right: 14),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 18, 18, 23),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15, left: 20, right: 15),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 18, 18, 23),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Transactions',
                              style: TextStyle(
                                color: Color.fromARGB(255, 187, 187, 187),
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 110, 208, 5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                color: Colors.white,
                                onPressed: addNewExpense,

                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          height:
                              12), // Adjust the space between the text and the ListView
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 18, 18, 23),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.getAllExpenseList().length,
                          itemBuilder: (context, index) => ExpenseTile(
                            name: value.getAllExpenseList()[index].name,
                            amount: value.getAllExpenseList()[index].amount,
                            dateTime: value.getAllExpenseList()[index].dateTime,
                            deleteTapped: (p0) =>
                                deleteExpense(value.getAllExpenseList()[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Investments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gavel_outlined),
              label: 'Tax',
            ),
          ],
          backgroundColor: Colors.black,
          selectedItemColor:
              Colors.blue, // Set the color for the selected tab icon and label
          unselectedItemColor:
              Colors.grey, // Set the color for unselected tab icons and labels
          selectedLabelStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.blue,
              fontSize: 10), // Set the color for the selected tab label
          unselectedLabelStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromARGB(
                  255, 0, 0, 0)), // Set the color for unselected tab labels

          onTap: (int index) {
            // Handle tab navigation here
            switch (index) {
              case 0:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => HomePage(),
                //   ),
                // );
                break;

              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(),
                  ),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BudgetPage(),
                  ),
                );
                break;

              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvestmentsPage(),
                  ),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
                break;

              case 5:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaxCalculatorScreen(),
                  ),
                );
                break;
            }
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: addNewExpense,
        //   child:
        //       Icon(Icons.add, color: const Color.fromARGB(255, 255, 255, 255)),
        //   backgroundColor: Color.fromARGB(255, 34, 52, 157),
        // ),
      ),
    );
  }
}
