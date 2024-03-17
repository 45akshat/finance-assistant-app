import 'dart:convert';
import 'package:expense/pages/login_page.dart';
import 'package:expense/services/otp_verification/user_info_save_locally.dart';
import 'package:expense/services/otp_verification/validate_jwt_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String> checkToken() async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');
  String? email = await storage.read(key: "email");
  var jwtokk = jsonDecode(await ValidateJwtApi(email!, token!));
  if (jwtokk['message'] == "Token is valid, and the email matches.") {
    return email!;
  } else {
    return "";
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Page',
          style: TextStyle(color: Colors.white), // Set app bar title text color
        ),
        backgroundColor: Colors.black, // Set app bar background color
        iconTheme: IconThemeData(
            color: Color.fromARGB(255, 187, 187, 187)), // Set back icon color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: checkToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Text(
                      'Email: ${snapshot.data}',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Colors.white),
                    );
                  } else {
                    return Text(
                      'Email not available',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 219, 12, 50), // Set the background color
                onPrimary:
                    Color.fromARGB(255, 187, 187, 187), // Set the text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              onPressed: () async {
                // Call the function to delete the JWT token or perform any other logout actions
                await deleteJwtToken();

                // Navigate to the login screen and remove the current screen from the navigation stack
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 20),
            Text(
              'Help: We would love to help you, contact: contactme@gmail.com',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Set body background color
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: AccountPage(),
      theme: ThemeData.dark(), // Apply a dark theme to the entire app
    ),
  );
}
