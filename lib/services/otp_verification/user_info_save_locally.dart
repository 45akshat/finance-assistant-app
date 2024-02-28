import 'dart:convert';

import 'package:expense/services/otp_verification/validate_jwt_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void saveJwtToken(String token) async {
  final storage = FlutterSecureStorage();

  // Store the JWT token in the secure storage
  await storage.write(key: 'jwt_token', value: token);

  print('JWT token saved successfully');
}


Future<String?> getJwtToken() async {
  final storage = FlutterSecureStorage();

  // Retrieve the JWT token from the secure storage
  String? token = await storage.read(key: 'jwt_token');

  return token;
}


Future<void> deleteJwtToken() async {
  final storage = FlutterSecureStorage();

  // Retrieve the JWT token from the secure storage
  await storage.delete(key: 'jwt_token');

}

  Future<bool> checkToken() async {
    // deleteJwtToken();

    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    String? email = await storage.read(key: "email");
    var jwtokk = jsonDecode(await ValidateJwtApi(email!, token!));
    if(jwtokk['message'] == "Token is valid, and the email matches."){
      return true;
    }else{
      return false;
    }
  }


  void saveKeyLocally(String key, String token) async {
    final storage = FlutterSecureStorage();

    // Store the JWT token in the secure storage
    await storage.write(key: key, value: token);

  }