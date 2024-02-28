import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> sendRequest(String apiUrl, String userInput) async {
  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_input': userInput}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return {'processed_text': data['processed_text'], 'entities': data['entities']};
    } else {
      throw Exception('HTTP error! Status: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
    return {'error': error.toString()};
  }
}
