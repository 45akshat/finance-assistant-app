import 'package:expense/data/expense_data.dart';
import 'package:expense/pages/home_page.dart';
import 'package:expense/pages/login_page.dart';
import 'package:expense/services/otp_verification/user_info_save_locally.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize hive
  // deleteJwtToken();

  await Hive.initFlutter();
  //open a hive box
  await Hive.openBox("expense_database");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> ExpenseData(),
      builder: (context, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
      future: checkToken(),
      builder: ((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data ==true){
            return HomePage();
          }else{
            return LoginPage();
          }
        }else{
          // Display a loading indicator or splash screen if needed
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      })),
    ),
    );
  }
}
