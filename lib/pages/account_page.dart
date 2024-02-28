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
        title: Text('Account Page'),
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
                      style: TextStyle(fontSize: 18),
                    );
                  } else {
                    return Text(
                      'Email not available',
                      style: TextStyle(fontSize: 18),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
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
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: AccountPage(),
    ),
  );
}
