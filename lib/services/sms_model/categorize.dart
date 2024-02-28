import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> generateResponse(String apiUrl, String userMessage) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userMessage": userMessage}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final generatedResponse = data["generatedResponse"];
      return generatedResponse;
    } else {
      throw Exception("Failed to fetch response. Status code: ${response.statusCode}");
    }
  } catch (error) {
    throw Exception("Error: $error");
  }
}